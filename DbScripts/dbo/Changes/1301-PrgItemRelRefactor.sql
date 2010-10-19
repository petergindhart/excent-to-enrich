/*
	Add Trigger and outcome fields to PrgItemRelDef
*/

CREATE TABLE dbo.PrgTrigger
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgTrigger ADD CONSTRAINT
	PK_PrgTrigger PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.PrgItemRelDef ADD
	TriggerID uniqueidentifier NULL,
	OutcomeID uniqueidentifier NULL
GO
ALTER TABLE dbo.PrgItemRelDef ADD CONSTRAINT
	FK_PrgItemRelDef#Trigger# FOREIGN KEY
	(
	TriggerID
	) REFERENCES dbo.PrgTrigger
	(
	ID
	)	
GO
ALTER TABLE dbo.PrgItemRelDef ADD CONSTRAINT
	FK_PrgItemRelDef#Outcome#ResultingItemDefs FOREIGN KEY
	(
	OutcomeID
	) REFERENCES dbo.PrgItemOutcome
	(
	ID
	)
GO



INSERT dbo.PrgTrigger VALUES('E91110EC-78E2-4E42-90B5-5206D3AA735D', 'Create')
INSERT dbo.PrgTrigger VALUES('3EAAE600-86AB-4CF8-8866-E7D70BCB0497', 'End')

UPDATE dbo.PrgItemRelDef
SET TriggerID = 'E91110EC-78E2-4E42-90B5-5206D3AA735D' -- CREATE
GO

ALTER TABLE dbo.PrgItemRelDef
ALTER COLUMN TriggerID uniqueidentifier NOT NULL
GO


-- Create PrgItemRelDef records based on existing outcomes
INSERT PrgItemRelDef
SELECT
	ID = newid(),
	InitiatingItemDefID = CurrentDefID,
	ResultingItemDefID = NextDefID,
	Name = NULL,
	DeletedDate = NULL,
	TriggerID = '3EAAE600-86AB-4CF8-8866-E7D70BCB0497', -- END
	OutcomeID = ID
FROM PrgItemOutcome
WHERE NextDefID IS NOT NULL
GO

-- #############################################################################
-- create PrgItemOutcome selections to PrgItemRel records

INSERT PrgItemRel
SELECT
	ID = NEWID(),
	PrgItemRelDefID = rd.ID,
	InitiatingItemID = i.ID,
	ResultingItemID = NULL
FROM 
	PrgItem i join
	PrgItemOutcome o on i.ItemOutcomeID = o.ID join
	PrgItemRelDef rd on 
		rd.OutcomeID = o.ID AND
		rd.TriggerID = '3EAAE600-86AB-4CF8-8866-E7D70BCB0497' -- END
WHERE
	NOT EXISTS ( --not already added
		SELECT *
		FROM PrgItemRel
		WHERE
			InitiatingItemID = i.ID AND
			PrgItemRelDefID = rd.ID
	)
GO

-- #############################################################################
-- attempt to automatically satisfy these items where possible

DECLARE @pendingRels table (
	RelID uniqueidentifier NOT NULL,
	InitiatingItemID uniqueidentifier NOT NULL,	
	ResultingItemDefID uniqueidentifier NOT NULL,
	IsCrossProgram bit NOT NULL
)

-- assume everything is triggered on PrgTrigger.End
INSERT @pendingRels
SELECT
	r.ID,
	r.InitiatingItemID,
	rd.ResultingItemDefID,
	IsCrossProgram = CASE WHEN resDef.ProgramID = iniDef.ProgramID THEN 0 ELSE 1 END
FROM
	PrgItemRel r JOIN
	PrgItemRelDef rd ON r.PrgItemRelDefID = rd.ID JOIN
	PrgItemDef iniDef ON rd.InitiatingItemDefID = iniDef.ID JOIN
	PrgItemDef resDef ON rd.ResultingItemDefID = resDef.ID
WHERE
	rd.TriggerID = '3EAAE600-86AB-4CF8-8866-E7D70BCB0497' AND -- End	
	r.ResultingItemID IS NULL -- not satisfied


DECLARE @candidates table (
	RelID uniqueidentifier NOT NULL,
	ResultingItemID uniqueidentifier NOT NULL,
	Sequence bigint NOT NULL
)

INSERT @candidates
SELECT
	p.RelID,
	other.ID,
	Sequence = CASE -- items created after in asc order; followed by items occuring before in desc order
		WHEN other.StartDate >= i.EndDate THEN DATEDIFF(MINUTE, i.EndDate, other.StartDate)
		ELSE ABS(DATEDIFF(MINUTE, i.EndDate, DATEADD(YEAR, -10, other.StartDate))) END
FROM
	@pendingRels p JOIN
	PrgItem i ON p.InitiatingItemID = i.ID JOIN
	PrgItem other ON
		i.ID <> other.ID AND
		other.DefID = p.ResultingItemDefID AND
		i.StudentID = other.StudentID AND		
		(	-- same involvement if not cross program
			p.IsCrossProgram = 1 OR
			i.InvolvementID = other.InvolvementID
		) AND
		(
			-- occurred after, or before if still open
			other.StartDate >= i.EndDate OR 
			other.EndDate IS NULL
		)
		
UPDATE r
SET ResultingItemID = (SELECT TOP 1 ResultingItemID FROM @candidates WHERE RelID = r.ID ORDER BY Sequence)
FROM
	PrgItemRel r 
WHERE
	r.ID in (select RelID from @candidates)	
	
-- #############################################################################

-- drop no longer used stored procedures
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItem_GetUnsatisfied]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgItem_GetUnsatisfied]

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItem_GetUnsatisfiedByStudent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgItem_GetUnsatisfiedByStudent]

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItem_GetUnsatisfiedByInvolvement]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgItem_GetUnsatisfiedByInvolvement]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItemOutcome_GetRecordsByNextDef]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgItemOutcome_GetRecordsByNextDef]
GO


-- drop no longer used column
ALTER TABLE dbo.PrgItemOutcome
	DROP CONSTRAINT FK_PrgItemOutcome#NextDef#
GO
ALTER TABLE dbo.PrgItemOutcome
	DROP COLUMN NextDefID
GO

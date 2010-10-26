IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GetInterventionsByActivityDueDate]') AND xtype IN (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[GetInterventionsByActivityDueDate]
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgIntervention_SearchActive]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgIntervention_SearchActive]
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItem_SearchActive]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgItem_SearchActive]
GO

/*
<summary>
Gets records from the PrgItem table for active
items matching the specified criteria
</summary>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgItem_SearchActive]
	@programId UNIQUEIDENTIFIER,
	@schoolId UNIQUEIDENTIFIER,
	@rosterYearId UNIQUEIDENTIFIER,
	@itemDefId UNIQUEIDENTIFIER,
	@statusId UNIQUEIDENTIFIER,
	@variantId UNIQUEIDENTIFIER,
	@gradeLevelId UNIQUEIDENTIFIER,
	@startMin DATETIME,
	@startMax DATETIME,
	@plannedEndDateUsed INT, --Any = 2,	Yes = 1, No = 0
	@plannedEndMin DATETIME,
	@plannedEndMax DATETIME,
	@progressMonitoringActive INT, --Any = 2, Yes = 1, No = 0
	@progressDueMin DATETIME,
	@progressDueMax DATETIME,	
	@includeActions BIT,
	@teamMemberId UNIQUEIDENTIFIER,
	@teamMemberRole INT --Any = 2, Primary = 1, Secondary = 0
AS

DECLARE @noneOption UNIQUEIDENTIFIER
SET @noneOption = 'ffffffff-ffff-ffff-ffff-ffffffffffff'

-- find items ids matching criteria (except activity due dates)
DECLARE @filter TABLE( ItemId UNIQUEIDENTIFIER PRIMARY KEY)
INSERT INTO @filter
SELECT DISTINCT
	item.Id
FROM
	PrgItem item JOIN 
	PrgItemDef def ON def.ID = item.DefID JOIN 
	PrgInvolvement inv ON inv.Id = item.InvolvementID JOIN 
	Student s ON item.StudentID = s.Id JOIN
	RosterYear y ON dbo.DateInRange(item.StartDate, y.StartDate, y.EndDate) = 1 LEFT OUTER JOIN
	PrgItemTeamMember pm ON (pm.ItemID = item.ID AND pm.IsPrimary = 1) LEFT JOIN
	PrgItemTeamMember sm ON (sm.ItemID = item.ID AND sm.IsPrimary = 0) LEFT JOIN
	IntvGoalView g ON item.ID = g.InterventionID
WHERE 
	( @programId IS NULL OR inv.ProgramId = @programId) AND 
	( @schoolId IS NULL OR item.SchoolId = @schoolId ) AND
	( @rosterYearId IS NULL OR y.Id = @rosterYearId ) AND
	( @statusId IS NULL OR item.StartStatusID = @statusId ) AND
	( @itemDefId IS NULL OR item.DefId = @itemDefId ) AND
	( @variantId IS NULL OR inv.VariantID = @variantID ) AND
	item.ItemOutcomeID IS NULL AND
	dbo.DateInRangeAdvanced(item.StartDate,@startMin,@startMax,1) = 1 AND 
	(
		@plannedEndDateUsed = 2 OR
		(@plannedEndDateUsed = 0 AND item.PlannedEndDate IS NULL) OR
		(@plannedEndDateUsed = 1 AND item.PlannedEndDate IS NOT NULL AND dbo.DateInRangeAdvanced(item.PlannedEndDate,@plannedEndMin,@plannedEndMax,1) = 1)
	) 
	AND 
	( @gradeLevelId IS NULL OR item.GradeLevelId = @gradeLevelId ) AND
	(
		(@teamMemberRole = 1 AND -- Primary
			(pm.PersonID = @teamMemberId OR
			(@teamMemberId IS NULL AND pm.ID IS NOT NULL) OR --any scenario
			(@teamMemberId = @noneOption AND pm.ID IS NULL))) OR
		(@teamMemberRole = 0 AND -- Secondary
			((sm.PersonID = @teamMemberId) OR
			(@teamMemberId IS NULL AND sm.ID IS NOT NULL) OR --any scenario
			(@teamMemberId = @noneOption AND sm.ID IS NULL))) OR
		(@teamMemberRole = 2 AND -- Any
			(@teamMemberId IS NULL OR 
			@teamMemberId = pm.PersonID OR 
			@teamMemberId = Sm.PersonID OR
			(@teamMemberId = @noneOption AND pm.ID IS NULL AND sm.ID IS NULL)))
	) 
	AND 
	(
		@includeActions = 1 OR def.TypeID IN 
			('D7B183D8-5BBD-4471-8829-3C8D82A92478', -- Custom Plan
			'03670605-58B2-40B2-99D5-4A1A70156C73', -- Intervention
			'A5990B5E-AFAD-4EF0-9CCA-DC3685296870') -- IEP
	)
	AND 
	(	
		@progressMonitoringActive = 2 OR
		(@progressMonitoringActive = 0 AND (g.ID IS NULL OR g.ProbeDueDate IS NULL)) OR
		(@progressMonitoringActive = 1 AND g.ProbeDueDate IS NOT NULL AND dbo.DateInRangeAdvanced(g.ProbeDueDate,@progressDueMin,@progressDueMax,1) = 1)
	)

--Delete items that have any active progress monitoring is set to the not active filter
DELETE f
FROM @filter f JOIN
IntvGoalView v ON (f.ItemId = v.InterventionID AND v.ProbeDueDate IS NOT NULL)
WHERE @progressMonitoringActive = 0

SELECT
	ItemTypeId = def.TypeID,
	item.*
FROM
	PrgItem item INNER JOIN 
	PrgItemDef def ON def.ID = item.DefID INNER JOIN 
	@filter f ON item.Id = f.ItemId

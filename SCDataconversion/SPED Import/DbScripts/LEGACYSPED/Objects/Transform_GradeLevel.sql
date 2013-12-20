-- use in all states, all districts.
-- #############################################################################
-- GradeLevel
IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_GradeLevelID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_GradeLevelID
	(
	GradeLevelCode nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 

ALTER TABLE LEGACYSPED.MAP_GradeLevelID ADD CONSTRAINT
	PK_MAP_GradeLevelID PRIMARY KEY CLUSTERED
	(
	GradeLevelCode
	)
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_GradeLevel') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_GradeLevel
GO

CREATE VIEW LEGACYSPED.Transform_GradeLevel 
AS
/*
	This view depends on GradeLevel.StateCode (the state reporting code) being populated in the target table.  
		The code to populate GradeLevel.StateCode should be contained in file 0001a-ETLPrep_State_StateAbbr.sql
		The fact that we are returning rows where a StateCode match exists between SelectLists and Target ensures that we don't duplicate these values in Target.
	Table Aliases:  k for SelectLists, s for StateCode, m for Map, t for Target
	
*/

SELECT
		GradeLevelCode = k.LegacySpedCode,
		DestID = coalesce(i.ID, n.ID, t.ID, m.DestID), 
		Name = coalesce(i.Name, n.Name, t.Name, left(k.EnrichLabel, 10)),
		StateCode = coalesce(i.StateCode, n.StateCode, t.StateCode,k.StateCode),
		Bitmask = coalesce(i.Bitmask, n.Bitmask, t.Bitmask),
		Sequence = coalesce(i.Sequence,n.Sequence, t.Sequence, 99),
		Active  = case when k.EnrichID is not null then 1 when coalesce(i.ID, n.ID, t.ID) is null then 0 else coalesce(i.Active, n.Active, t.Active) end
	FROM
		LEGACYSPED.SelectLists k LEFT JOIN
		GradeLevel i on k.EnrichID = i.ID LEFT JOIN 
		GradeLevel n on k.EnrichLabel = n.Name LEFT JOIN 
		LEGACYSPED.MAP_GradeLevelID m on k.LegacySpedCode = m.GradeLevelCode LEFT JOIN
		GradeLevel t on m.DestID = t.ID
	WHERE
		k.Type = 'Grade' and 
		k.LegacySpedCode is not null
GO

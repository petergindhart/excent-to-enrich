
-- Not currently in VC3ETL.LoadTable.  We are populating MAP_GoalAreaDefID in the state specific ETL Prep file.
---- #############################################################################
----		Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgGoalAreaDefID 
(
	GoalAreaCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgGoalAreaDefID ADD CONSTRAINT
PK_MAP_PrgGoalAreaDefID PRIMARY KEY CLUSTERED
(
	GoalAreaCode
)
END
GO

-- ############################################################################# 
-- Transform
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgGoalAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgGoalAreaDef
GO

CREATE VIEW LEGACYSPED.Transform_PrgGoalAreaDef  --- select * from PrgGoalAreaDef order by sequence, deleteddate  -- select * from LEGACYSPED.Transform_PrgGoalAreaDef -- delete PrgGoalAreaDef where deleteddate is not null
AS
/*
	This view should work for both CO and FL, though FL's map table is populated in the Prep_State file
	
	Note:  Test FL Map table setup.  mapping table should be pre-populated, so this query should not affect mapping table for FL.

*/
SELECT
	GoalAreaCode = isnull(k.LegacySpedCode, left(k.EnrichLabel, 150)),
	ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', --SpecialEducation
	k.SubType,
	DestID = coalesce(i.ID, n.ID, t.ID,  m.DestID, k.EnrichID),
	Sequence = coalesce(i.Sequence, n.Sequence, t.Sequence, 99),
	Name = coalesce(i.Name, n.Name, t.Name, cast(k.EnrichLabel as varchar(50))),
	AllowCustomProbes = cast(0 as bit),
	StateCode = coalesce(i.StateCode, n.StateCode, t.StateCode),
	DeletedDate = case when t.ID is null then getdate() else NULL end,
	RequireGoal = cast(1 as bit)
  FROM
	LEGACYSPED.SelectLists k LEFT JOIN
	dbo.PrgGoalAreaDef i on k.EnrichID = i.ID left join
	dbo.PrgGoalAreaDef n on k.EnrichLabel = n.Name and n.DeletedDate is null left join -- only match on the name if not soft-deleted?
	LEGACYSPED.MAP_PrgGoalAreaDefID m on k.LegacySpedCode = m.GoalAreaCode LEFT JOIN 
	dbo.PrgGoalAreaDef t on m.DestID = t.ID 
WHERE k.Type = 'GoalArea'
GO


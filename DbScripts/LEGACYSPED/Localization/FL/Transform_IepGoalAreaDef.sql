
-- This transform is not currently in LoadTable.  We are populating MAP_GoalAreaDefID in the state specific ETL Prep file.


---- #############################################################################
----		Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepGoalAreaDefID 
(
	GoalAreaCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepGoalAreaDefID ADD CONSTRAINT
PK_MAP_IepGoalAreaDefID PRIMARY KEY CLUSTERED
(
	GoalAreaCode
)

END
GO

-- #############################################################################
---- Transform
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoalAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepGoalAreaDef
GO

CREATE VIEW LEGACYSPED.Transform_IepGoalAreaDef  --- select * from IepGoalAreaDef order by sequence, deleteddate  -- select * from LEGACYSPED.Transform_IepGoalAreaDef -- delete IepGoalAreaDef where deleteddate is not null
AS
/*
	This view should work for both CO and FL, though FL's map table is populated in the Prep_State file
	
	Note:  Florida's LoadTable record for IepGoalAreaDef should set UpdateTrans = NULL

*/
SELECT
	GoalAreaCode = k.LegacySpedCode,
	DestID = coalesce(i.ID, n.ID, t.ID,  m.DestID),
	Sequence = coalesce(i.Sequence, n.Sequence, t.Sequence, 99),
	Name = coalesce(i.Name, n.Name, t.Name, cast(k.EnrichLabel as varchar(50))),
	AllowCustomProbes = cast(0 as bit),
	StateCode = coalesce(i.StateCode, n.StateCode, t.StateCode),
	-- note that some districts in FL have soft-deleted 3 of 4 goal areas and we don't want to un-soft-delete them.  turn off UPDATE flag in the load table record.
	DeletedDate = case when k.EnrichID is not null then NULL when coalesce(i.ID, n.ID, t.ID) is null then getdate() else coalesce(i.DeletedDate, n.DeletedDate, t.DeletedDate) end,
	RequireGoal = cast(1 as bit)
  FROM
	LEGACYSPED.SelectLists k LEFT JOIN
	dbo.IepGoalAreaDef i on k.EnrichID = i.ID left join
	dbo.IepGoalAreaDef n on k.EnrichLabel = n.Name and n.DeletedDate is null left join -- only match on the name if not soft-deleted?
	LEGACYSPED.MAP_IepGoalAreaDefID m on k.LegacySpedCode = m.GoalAreaCode LEFT JOIN 
	dbo.IepGoalAreaDef t on m.DestID = t.ID 
WHERE k.Type = 'GoalArea'
GO




--insert IepGoalAreaDef values ('DA0ECBD3-9E20-4031-8F8F-631D3FB4118C', 1, 'Curriculum and Learning/Writing', 0, NULL, '2011-09-29 00:00:00.000')
--insert IepGoalAreaDef values ('F6C49490-FA7B-4188-A24A-D98797484D38', 2, 'Curriculum and Learning/Math', 0, NULL, '2011-09-29 00:00:00.000')
--insert IepGoalAreaDef values ('489C84EA-BD0D-4F56-9C79-89FB089E2511', 3, 'Curriculum and Learning/Other', 0, NULL, '2011-09-29 00:00:00.000')


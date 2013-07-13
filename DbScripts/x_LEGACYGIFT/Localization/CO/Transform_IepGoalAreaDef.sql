
---- Not currently in VC3ETL.LoadTable.  We are populating MAP_GoalAreaDefID in the state specific ETL Prep file.
------ #############################################################################
------		Goal Area MAP
--IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_IepGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
--BEGIN
--CREATE TABLE x_LEGACYGIFT.MAP_IepGoalAreaDefID 
--(
--	GoalAreaCode	varchar(150) NOT NULL,
--	DestID uniqueidentifier NOT NULL
--)

--ALTER TABLE x_LEGACYGIFT.MAP_IepGoalAreaDefID ADD CONSTRAINT
--PK_MAP_IepGoalAreaDefID PRIMARY KEY CLUSTERED
--(
--	GoalAreaCode
--)
--END
--GO

---- ############################################################################# 
---- Transform
--IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_IepGoalAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
--DROP VIEW x_LEGACYGIFT.Transform_IepGoalAreaDef
--GO

--CREATE VIEW x_LEGACYGIFT.Transform_IepGoalAreaDef  --- select * from IepGoalAreaDef order by sequence, deleteddate  -- select * from x_LEGACYGIFT.Transform_IepGoalAreaDef -- delete IepGoalAreaDef where deleteddate is not null
--AS
--/*
--	This view should work for both CO and FL, though FL's map table is populated in the Prep_State file
	
--	Note:  Test FL Map table setup.  mapping table should be pre-populated, so this query should not affect mapping table for FL.

--*/
--SELECT
--	GoalAreaCode = isnull(k.x_LEGACYGIFTCode, left(k.EnrichLabel, 150)),
--	DestID = coalesce(i.ID, n.ID, t.ID,  m.DestID, k.EnrichID),
--	Sequence = coalesce(i.Sequence, n.Sequence, t.Sequence, 99),
--	Name = coalesce(i.Name, n.Name, t.Name, cast(k.EnrichLabel as varchar(50))),
--	AllowCustomProbes = cast(0 as bit),
--	StateCode = coalesce(i.StateCode, n.StateCode, t.StateCode),
--	DeletedDate = case when k.EnrichID is not null then NULL  else coalesce(i.DeletedDate, n.DeletedDate, t.DeletedDate) end,
--	RequireGoal = cast(1 as bit)
--  FROM
--	x_LEGACYGIFT.SelectLists k LEFT JOIN
--	dbo.IepGoalAreaDef i on k.EnrichID = i.ID left join
--	dbo.IepGoalAreaDef n on k.EnrichLabel = n.Name and n.DeletedDate is null left join -- only match on the name if not soft-deleted?
--	x_LEGACYGIFT.MAP_IepGoalAreaDefID m on k.x_LEGACYGIFTCode = m.GoalAreaCode LEFT JOIN 
--	dbo.IepGoalAreaDef t on m.DestID = t.ID 
--WHERE k.Type = 'GoalArea'
--GO



-- FLORIDA SPECIFIC

-- LEGACYSPED.MAP_GoalAreaDefID is created and inserted in LEGACYSPED\Objects\0001a-ETLPrep_State_FL.sql
-- #############################################################################
--		Iep Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepGoalArea') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepGoalArea
(
	InstanceID	uniqueidentifier not null,
	GoalAreaDefID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepGoalArea ADD CONSTRAINT 
PK_MAP_IepGoalArea PRIMARY KEY CLUSTERED
(
	InstanceID, GoalAreaDefID
)
END
GO

-- #############################################################################

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.GoalAreaPivotView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.GoalAreaPivotView
GO

create view LEGACYSPED.GoalAreaPivotView
as
	select IepRefID, GoalRefID, 'GAReading' GoalAreaCode, CAST(0 as int) GoalIndex
	from LEGACYSPED.Goal
	where GAReading = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAWriting' GoalAreaCode, CAST(1 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GAWriting = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAMath' GoalAreaCode, CAST(2 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GAMath = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAOther' GoalAreaCode, CAST(3 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GAOther = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAEmotional' GoalAreaCode, CAST(4 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GAEmotional = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAIndependent' GoalAreaCode, CAST(5 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GAIndependent = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAHealth' GoalAreaCode, CAST(6 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GAHealth = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GACommunication' GoalAreaCode, CAST(7 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GACommunication = 'Y'
go


-- #############################################################################

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.GoalAreasPerGoalView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.GoalAreasPerGoalView
GO

create view LEGACYSPED.GoalAreasPerGoalView 
as
/*

	Currently Enrich does not support more than 1 goal area per goal, so we need to arbitrarily but consistently pick one goal for now.
	In LEGACYSPED.GoalAreaPivotView we devised an Index that will allow us to select the minimum GoalAreaIndex per Goal, which this view provides.
	The output of this view will be the one GoalArea selected for each Goal.
	This filter will no longer be necessary after support for multiple areas (domains) per goal is added to Enrich.

*/
-- The output of this view will be the one GoalArea selected for each Goal.
select
	g.IepRefID,
	InstanceID = pgs.DestID,
	DefID = m.DestID,
	ga.GoalAreaCode, 
	g.GoalRefID,
	GoalIndex = cast(0 as int)
from LEGACYSPED.Goal g JOIN
	LEGACYSPED.Transform_PrgGoals pgs on g.IepRefID = pgs.IepRefID join 
	LEGACYSPED.GoalAreaPivotView ga on g.GoalRefID = ga.GoalRefID join
	LEGACYSPED.Transform_IepGoalAreaDef m on ga.GoalAreaCode = m.GoalAreaCode  
where ga.GoalIndex = (
	select top 1 minga.GoalIndex
	from  LEGACYSPED.GoalAreaPivotView minga
	where g.GoalRefID = minga.GoalRefID
	order by ga.GoalIndex)
GO


-- #############################################################################


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoalArea') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepGoalArea
GO

create view LEGACYSPED.Transform_IepGoalArea 
as
select distinct
	gapg.IepRefID,
	gapg.GoalAreaCode,
	mga.DestID,
	gapg.InstanceID,
	gapg.DefID,
	FormInstanceID = CAST(NULL as uniqueidentifier)
from 
	LEGACYSPED.GoalAreasPerGoalView gapg left join
	LEGACYSPED.MAP_IepGoalArea mga on gapg.InstanceID = mga.InstanceID and gapg.DefID = mga.GoalAreaDefID left join
	dbo.IepGoalArea tgt on mga.DestID = tgt.ID 
go

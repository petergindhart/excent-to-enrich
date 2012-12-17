
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.PrimaryGoalAreaPerGoal') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.PrimaryGoalAreaPerGoal
GO

create view LEGACYSPED.PrimaryGoalAreaPerGoal 
as
select GoalRefID, PrimaryGoalAreaDefIndex = min(GoalAreaDefIndex)
from LEGACYSPED.MAP_GoalAreaPivot
group by GoalRefID
go

-- no map table needed
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoalSecondaryGoalAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepGoalSecondaryGoalAreaDef
go

create view LEGACYSPED.Transform_IepGoalSecondaryGoalAreaDef -- no map necessary.  just delete and insert
as
-- The secondary goal areas are all those other than the goal area with the lowest GoalAreaDefIndex
select
	tg.GoalRefID,
	ga.GoalAreaCode,
	GoalID = tg.DestID,
 	DefID = m.DestID
from 
	LEGACYSPED.Transform_PrgGoal tg join -- select * from LEGACYSPED.Transform_PrgGoal 
	LEGACYSPED.MAP_GoalAreaPivot ga on tg.GoalRefID = ga.GoalRefID join -- select * from LEGACYSPED.GoalAreaPivotView
	LEGACYSPED.MAP_IepGoalAreaDefID m on ga.GoalAreaCode = m.GoalAreaCode  -- select * from LEGACYSPED.MAP_IepGoalAreaDefID
where ga.GoalAreaDefIndex > (
	select ming.PrimaryGoalAreaDefIndex
	from LEGACYSPED.PrimaryGoalAreaPerGoal ming
	where tg.GoalRefID = ming.GoalRefID
	)
go


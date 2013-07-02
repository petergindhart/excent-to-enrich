
-- no map table needed
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_IepGoalSecondaryGoalAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_IepGoalSecondaryGoalAreaDef
go

create view x_LEGACYGIFT.Transform_IepGoalSecondaryGoalAreaDef -- no map necessary.  just delete and insert
as
-- The secondary goal areas are all those other than the goal area with the lowest GoalAreaDefIndex (per goal)
select
	tg.GoalRefID,
	ga.GoalAreaCode,
	GoalID = tg.DestID,
 	DefID = m.DestID
from 
	x_LEGACYGIFT.Transform_PrgGoal tg join -- select * from x_LEGACYGIFT.Transform_PrgGoal 
	x_LEGACYGIFT.MAP_GoalAreaPivot ga on tg.GoalRefID = ga.GoalRefID join -- select * from x_LEGACYGIFT.GoalAreaPivotView
	x_LEGACYGIFT.MAP_IepGoalAreaDefID m on ga.GoalAreaCode = m.GoalAreaCode  -- select * from x_LEGACYGIFT.MAP_IepGoalAreaDefID
where ga.GoalAreaDefIndex > (
	select ming.PrimaryGoalAreaDefIndex
	from x_LEGACYGIFT.PrimaryGoalAreaPerGoal ming
	where tg.GoalRefID = ming.GoalRefID
	)
go

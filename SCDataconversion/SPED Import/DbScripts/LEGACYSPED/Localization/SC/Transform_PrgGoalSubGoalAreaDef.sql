--- NEW VIEW 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.SubGoalAreaPivotView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.SubGoalAreaPivotView
GO

create view LEGACYSPED.SubGoalAreaPivotView
as
	select IepRefID, GoalRefID,GoalAreaCode, CAST(0 as int) SubGoalDefIndex
	from LEGACYSPED.Goal
	where SCInstructional = 'Y'  --'Instructional/Special Education' 
	UNION ALL
	select IepRefID, GoalRefID, GoalAreaCode, CAST(1 as int) SubGoalDefIndex
	from LEGACYSPED.Goal
	where  SCTransition = 'Y'--'Transition' 
	UNION ALL
	select IepRefID, GoalRefID, GoalAreaCode, CAST(2 as int) SubGoalDefIndex
	from LEGACYSPED.Goal
	where  SCRelatedService = 'Y' --'Related Service'
	--order by GoalRefID, GoalIndex
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgGoalSubGoalAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgGoalSubGoalAreaDef
GO

create view LEGACYSPED.Transform_PrgGoalSubGoalAreaDef
as
select 
	ga.GoalRefID,
	GoalID = pg.DestID,
	DefID = m.DestID 
--select ga.*
from LEGACYSPED.Transform_PrgGoalarea_goals ga join 
LEGACYSPED.Transform_PrgGoal pg on ga.GoalRefID = pg.GoalRefID join 
LEGACYSPED.SubGoalAreaPivotView sg on ga.GoalRefID = sg.GoalRefID left join 
	(
	select isnull(sub.ID,msub.DestID) DestID, isnull(sub.sequence,msub.sequence) sequence,isnull(gadef.StateCode,msub.SubGoalAreaCode) SubGoalAreaCode
	from PrgSubGoalAreaDef sub
	join PrgGoalAreaDef gadef ON gadef.ID = sub.parentID
	left join LEGACYSPED.MAP_PrgSubGoalAreaDefID msub on msub.DestID = sub.ID 
	) m on sg.GoalAreaCode = m.SubGoalAreaCode and sg.SubGoalDefIndex = m.sequence
left join PrgGoalSubGoalAreaDef sgad on ga.DestID = sgad.GoalID and m.DestID = sgad.DefID
--where ga.GoalAreaCode = 'GACurriculum' -- assuming only one parent for now
go

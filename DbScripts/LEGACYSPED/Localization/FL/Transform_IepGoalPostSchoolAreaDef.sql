-- #############################################################################
--		Goal Area Pivot 

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.PostSchoolAreaPivotView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.PostSchoolAreaPivotView
GO

create view LEGACYSPED.PostSchoolAreaPivotView
as
	select IepRefID, GoalRefID, 'PSAdult' PostSchoolAreaCode
	from LEGACYSPED.Goal
	where PSAdult = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'PSCommunity' PostSchoolAreaCode
	from LEGACYSPED.Goal
	where  PSCommunity = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'PSInstruction' PostSchoolAreaCode
	from LEGACYSPED.Goal
	where  PSInstruction = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'PSEmployment' PostSchoolAreaCode
	from LEGACYSPED.Goal
	where  PSEmployment = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'PSDailyLiving' PostSchoolAreaCode
	from LEGACYSPED.Goal
	where  PSDailyLiving = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'PSRelated' PostSchoolAreaCode
	from LEGACYSPED.Goal
	where  PSRelated = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'PSVocational' PostSchoolAreaCode
	from LEGACYSPED.Goal
	where  PSVocational = 'Y'
GO


-- #############################################################################


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoalPostSchoolAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepGoalPostSchoolAreaDef
GO

create view LEGACYSPED.Transform_IepGoalPostSchoolAreaDef -- select * from LEGACYSPED.Transform_PrgGoals
as
	select 
		ps.IEPRefID,
		ps.GoalRefID,
		ps.PostSchoolAreaCode,
		GoalID = pg.DestID,
		--DestID = NEWID(),
		PostSchoolAreaDefID = m.DestID,
		Sequence = (select COUNT(*) from LEGACYSPED.PostSchoolAreaPivotView where GoalRefID = ps.GoalRefID and PostSchoolAreaCode < ps.PostSchoolAreaCode)
	from LEGACYSPED.PostSchoolAreaPivotView ps JOIN 
	LEGACYSPED.Transform_PrgGoal pg on ps.GoalRefID = pg.GoalRefID join 
	LEGACYSPED.MAP_PostSchoolAreaDefID m on ps.PostSchoolAreaCode = m.PostSchoolAreaCode left join
	dbo.IepGoalPostSchoolAreaDef tgt on pg.DestID = tgt.GoalID and m.DestID = tgt.PostSchoolAreaDefID
	where 
		tgt.GoalID is null
-- order by ps.GoalRefID, Sequence
go






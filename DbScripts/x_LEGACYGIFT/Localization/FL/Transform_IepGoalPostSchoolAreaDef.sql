-- #############################################################################
--		Goal Area Pivot 

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.PostSchoolAreaPivotView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.PostSchoolAreaPivotView
GO

create view x_LEGACYGIFT.PostSchoolAreaPivotView
as
	select EPRefID, GoalRefID, 'PSAdult' PostSchoolAreaCode
	from x_LEGACYGIFT.GiftedGoal
	where PSAdult = 'Y'
	UNION ALL
	select EPRefID, GoalRefID, 'PSCommunity' PostSchoolAreaCode
	from x_LEGACYGIFT.GiftedGoal
	where  PSCommunity = 'Y'
	UNION ALL
	select EPRefID, GoalRefID, 'PSInstruction' PostSchoolAreaCode
	from x_LEGACYGIFT.GiftedGoal
	where  PSInstruction = 'Y'
	UNION ALL
	select EPRefID, GoalRefID, 'PSEmployment' PostSchoolAreaCode
	from x_LEGACYGIFT.GiftedGoal
	where  PSEmployment = 'Y'
	UNION ALL
	select EPRefID, GoalRefID, 'PSDailyLiving' PostSchoolAreaCode
	from x_LEGACYGIFT.GiftedGoal
	where  PSDailyLiving = 'Y'
	UNION ALL
	select EPRefID, GoalRefID, 'PSRelated' PostSchoolAreaCode
	from x_LEGACYGIFT.GiftedGoal
	where  PSRelated = 'Y'
	UNION ALL
	select EPRefID, GoalRefID, 'PSVocational' PostSchoolAreaCode
	from x_LEGACYGIFT.GiftedGoal
	where  PSVocational = 'Y'
GO


-- #############################################################################


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_IepGoalPostSchoolAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_IepGoalPostSchoolAreaDef
GO

create view x_LEGACYGIFT.Transform_IepGoalPostSchoolAreaDef
as
	select 
		ps.EPRefID,
		ps.GoalRefID,
		ps.PostSchoolAreaCode,
		GoalID = pg.DestID,
		PostSchoolAreaDefID = m.DestID,
		Sequence = (select COUNT(*) from x_LEGACYGIFT.PostSchoolAreaPivotView where GoalRefID = ps.GoalRefID and PostSchoolAreaCode < ps.PostSchoolAreaCode)
	from x_LEGACYGIFT.PostSchoolAreaPivotView ps JOIN 
	x_LEGACYGIFT.MAP_PrgGoalID pg on ps.GoalRefID = pg.GoalRefID join 
	x_LEGACYGIFT.MAP_PostSchoolAreaDefID m on ps.PostSchoolAreaCode = m.PostSchoolAreaCode left join
	dbo.IepGoalPostSchoolAreaDef t on 
		pg.DestID = t.GoalID and 
		m.DestID = t.PostSchoolAreaDefID
	where 
		t.GoalID is null
go

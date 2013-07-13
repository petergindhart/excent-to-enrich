-- #############################################################################
--		Goal Area Pivot 

-- COLORADO SPECIFIC

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.PostSchoolAreaPivotView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.PostSchoolAreaPivotView
GO

create view x_LEGACYGIFT.PostSchoolAreaPivotView -- select GoalRefID, count(*) tot from x_LEGACYGIFT.PostSchoolAreaPivotView group by GoalRefID having count(*) > 1
as
	select EpRefID, GoalRefID, '01' PostSchoolAreaCode
	from x_LEGACYGIFT.GiftedGoal
	where PSEducation = 'Y'
	UNION ALL
	select EpRefID, GoalRefID, '02' PostSchoolAreaCode
	from x_LEGACYGIFT.GiftedGoal
	where  PSEmployment = 'Y'
	UNION ALL
	select EpRefID, GoalRefID, '03' PostSchoolAreaCode
	from x_LEGACYGIFT.GiftedGoal
	where  PSIndependent = 'Y'
GO


-- #############################################################################


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_IepGoalPostSchoolAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_IepGoalPostSchoolAreaDef
GO

create view x_LEGACYGIFT.Transform_IepGoalPostSchoolAreaDef -- select * from x_LEGACYGIFT.Transform_PrgGoals
as
	select 
		ps.EpRefID,
		ps.GoalRefID,
		ps.PostSchoolAreaCode,
		GoalID = pg.DestID,
		--DestID = NEWID(),
		PostSchoolAreaDefID = m.DestID,
		Sequence = (select COUNT(*) from x_LEGACYGIFT.PostSchoolAreaPivotView where GoalRefID = ps.GoalRefID and PostSchoolAreaCode < ps.PostSchoolAreaCode)
	from x_LEGACYGIFT.PostSchoolAreaPivotView ps JOIN 
	x_LEGACYGIFT.Transform_PrgGoal pg on ps.GoalRefID = pg.GoalRefID join 
	x_LEGACYGIFT.MAP_PostSchoolAreaDefID m on ps.PostSchoolAreaCode = m.PostSchoolAreaCode left join
	dbo.IepGoalPostSchoolAreaDef tgt on pg.DestID = tgt.GoalID and m.DestID = tgt.PostSchoolAreaDefID
	where 
		tgt.GoalID is null
-- order by ps.GoalRefID, Sequence
go






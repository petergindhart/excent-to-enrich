-- #############################################################################
--		Goal Area Pivot 

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[PostSchoolAreaPivotView]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].PostSchoolAreaPivotView
GO

create view AURORAX.PostSchoolAreaPivotView
as
	select IepRefID, GoalRefID, 'PSAdult' PostSchoolAreaCode
	from AURORAX.Goal
	where PSAdult = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'PSCommunity' PostSchoolAreaCode
	from AURORAX.Goal
	where  PSCommunity = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'PSInstruction' PostSchoolAreaCode
	from AURORAX.Goal
	where  PSInstruction = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'PSEmployment' PostSchoolAreaCode
	from AURORAX.Goal
	where  PSEmployment = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'PSDailyLiving' PostSchoolAreaCode
	from AURORAX.Goal
	where  PSDailyLiving = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'PSRelated' PostSchoolAreaCode
	from AURORAX.Goal
	where  PSRelated = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'PSVocational' PostSchoolAreaCode
	from AURORAX.Goal
	where  PSVocational = 'Y'
GO


-- #############################################################################
--		Transform

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_IepGoalPostSchoolAreaDef]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].Transform_IepGoalPostSchoolAreaDef
GO

create view AURORAX.Transform_IepGoalPostSchoolAreaDef -- select * from AURORAX.Transform_PrgGoals
as
	select 
		ps.IEPRefID,
		ps.GoalRefID,
		ps.PostSchoolAreaCode,
		GoalID = pg.DestID,
		--DestID = NEWID(),
		PostSchoolAreaDefID = m.DestID,
		Sequence = (select COUNT(*) from AURORAX.PostSchoolAreaPivotView where GoalRefID = ps.GoalRefID and PostSchoolAreaCode < ps.PostSchoolAreaCode)
	from AURORAX.PostSchoolAreaPivotView ps JOIN 
	AURORAX.Transform_PrgGoal pg on ps.GoalRefID = pg.GoalRefID join 
	AURORAX.MAP_PostSchoolAreaDefID m on ps.PostSchoolAreaCode = m.PostSchoolAreaCode left join
	dbo.IepGoalPostSchoolAreaDef tgt on pg.DestID = tgt.GoalID and m.DestID = tgt.PostSchoolAreaDefID
	where 
		tgt.GoalID is null
-- order by ps.GoalRefID, Sequence
go






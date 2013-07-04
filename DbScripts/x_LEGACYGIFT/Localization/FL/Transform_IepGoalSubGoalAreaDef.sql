
---- Not currently in LoadTable.  We are populating MAP_IepSubGoalAreaDefID in the state specific ETL Prep file.
--IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_IepSubGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
--BEGIN
--CREATE TABLE x_LEGACYGIFT.MAP_IepSubGoalAreaDefID 
--(
--	SubGoalAreaCode	varchar(150) NOT NULL,
--	DestID uniqueidentifier NOT NULL
--)

--ALTER TABLE x_LEGACYGIFT.MAP_IepSubGoalAreaDefID ADD CONSTRAINT
--PK_MAP_IepSubGoalAreaDefID PRIMARY KEY CLUSTERED
--(
--	SubGoalAreaCode
--)

--END
--GO

--- NEW VIEW 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.SubGoalAreaPivotView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.SubGoalAreaPivotView
GO

create view x_LEGACYGIFT.SubGoalAreaPivotView
as
	select EPRefID, GoalRefID, 'GAReading' GoalAreaCode, CAST(0 as int) SubGoalDefIndex
	from x_LEGACYGIFT.GiftedGoal
	where GAReading = 'Y'
	UNION ALL
	select EPRefID, GoalRefID, 'GAWriting' GoalAreaCode, CAST(1 as int) SubGoalDefIndex
	from x_LEGACYGIFT.GiftedGoal
	where  GAWriting = 'Y'
	UNION ALL
	select EPRefID, GoalRefID, 'GAMath' GoalAreaCode, CAST(2 as int) SubGoalDefIndex
	from x_LEGACYGIFT.GiftedGoal
	where  GAMath = 'Y'
	UNION ALL
	select EPRefID, GoalRefID, 'GAOther' GoalAreaCode, CAST(3 as int) SubGoalDefIndex
	from x_LEGACYGIFT.GiftedGoal
	where  GAOther = 'Y'
go

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_IepGoalSubGoalAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_IepGoalSubGoalAreaDef
GO

create view x_LEGACYGIFT.Transform_IepGoalSubGoalAreaDef
as
select 
	ga.GoalRefID,
	GoalID = pg.DestID,
	DefID = m.DestID 
from x_LEGACYGIFT.Transform_IepGoalArea_goals ga join 
x_LEGACYGIFT.Transform_PrgGoal pg on ga.GoalRefID = pg.GoalRefID join 
x_LEGACYGIFT.SubGoalAreaPivotView sg on ga.GoalRefID = sg.GoalRefID left join 
LEGACYSPED.MAP_IepSubGoalAreaDefID m on sg.GoalAreaCode = m.SubGoalAreaCode left join 
IepGoalSubGoalAreaDef sgad on ga.DestID = sgad.GoalID and m.DestID = sgad.DefID
where ga.GoalAreaCode = 'GACurriculum' -- assuming only one parent for now
go


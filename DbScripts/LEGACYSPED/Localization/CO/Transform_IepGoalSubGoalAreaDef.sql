
-- Not currently in LoadTable.  We are populating MAP_IepSubGoalAreaDefID in the state specific ETL Prep file.
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepSubGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepSubGoalAreaDefID 
(
	SubGoalAreaCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepSubGoalAreaDefID ADD CONSTRAINT
PK_MAP_IepSubGoalAreaDefID PRIMARY KEY CLUSTERED
(
	SubGoalAreaCode
)

END
GO

--- NEW VIEW 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.SubGoalAreaPivotView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.SubGoalAreaPivotView
GO

create view LEGACYSPED.SubGoalAreaPivotView
as
/*	FLORIDA CODE AS FOLLOWS:

	select IepRefID, GoalRefID, 'GAReading' GoalAreaCode, CAST(0 as int) SubGoalDefIndex
	from LEGACYSPED.Goal
	where GAReading = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAWriting' GoalAreaCode, CAST(1 as int) SubGoalDefIndex
	from LEGACYSPED.Goal
	where  GAWriting = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAMath' GoalAreaCode, CAST(2 as int) SubGoalDefIndex
	from LEGACYSPED.Goal
	where  GAMath = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAOther' GoalAreaCode, CAST(3 as int) SubGoalDefIndex
	from LEGACYSPED.Goal
	where  GAOther = 'Y'
	--order by GoalRefID, GoalIndex
	
	CREATE A DUMMY VIEW FOR STATES THAT DO NOT USE SUBGOALAREAS SO THAT WE CAN RE-USE THE REST OF THE CODE. */
select top 1 IepRefID, GoalRefID, 'do not need this view in CO' GoalAreaCode, CAST(0 as int) SubGoalDefIndex
from LEGACYSPED.Goal
where 0 = 1
go

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoalSubGoalAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepGoalSubGoalAreaDef
GO

create view LEGACYSPED.Transform_IepGoalSubGoalAreaDef
as
select 
	ga.GoalRefID,
	GoalID = pg.DestID,
	DefID = m.DestID 
from LEGACYSPED.Transform_IepGoalArea_goals ga join 
LEGACYSPED.Transform_PrgGoal pg on ga.GoalRefID = pg.GoalRefID join 
LEGACYSPED.SubGoalAreaPivotView sg on ga.GoalRefID = sg.GoalRefID left join 
LEGACYSPED.MAP_IepSubGoalAreaDefID m on sg.GoalAreaCode = m.SubGoalAreaCode left join 
IepGoalSubGoalAreaDef sgad on ga.DestID = sgad.GoalID and m.DestID = sgad.DefID
where ga.GoalAreaCode = 'GACurriculum' -- assuming only one parent for now
go

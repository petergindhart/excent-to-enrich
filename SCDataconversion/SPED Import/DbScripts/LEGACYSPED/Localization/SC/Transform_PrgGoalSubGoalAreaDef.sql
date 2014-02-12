
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
	
	CREATE A DUMMY VIEW FOR STATES THAT DO NOT USE SUBGOALAREAS SO THAT WE CAN RE-USE THE REST OF THE CODE. 
*/
	select IepRefID, GoalRefID, 'SCInstructional' GoalAreaCode, CAST(0 as int) SubGoalDefIndex
	from LEGACYSPED.Goal
	where SCInstructional = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'SCTransition' GoalAreaCode, CAST(1 as int) SubGoalDefIndex
	from LEGACYSPED.Goal
	where  SCTransition = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'SCRelatedService' GoalAreaCode, CAST(2 as int) SubGoalDefIndex
	from LEGACYSPED.Goal
	where  SCRelatedService = 'Y'
go

/*

manufacture some data for testing (currently all columns are N

set nocount on;
declare @t table (RowNum int not null identity(0,1), SCInstructional char(1), SCTransition char(1), SCRelatedService char(1))
insert @t (SCInstructional, SCTransition, SCRelatedService) values ('Y', 'N', 'N')
insert @t (SCInstructional, SCTransition, SCRelatedService) values ('Y', 'Y', 'N')
insert @t (SCInstructional, SCTransition, SCRelatedService) values ('Y', 'Y', 'Y')
insert @t (SCInstructional, SCTransition, SCRelatedService) values ('Y', 'N', 'Y')
insert @t (SCInstructional, SCTransition, SCRelatedService) values ('N', 'Y', 'N')
insert @t (SCInstructional, SCTransition, SCRelatedService) values ('N', 'Y', 'Y')
insert @t (SCInstructional, SCTransition, SCRelatedService) values ('N', 'N', 'Y')
insert @t (SCInstructional, SCTransition, SCRelatedService) values ('N', 'N', 'N')

update g set SCInstructional = t.SCInstructional, SCTransition = t.SCTransition, SCRelatedService = t.SCRelatedService
-- select * 
from LEGACYSPED.Goal_LOCAL g
join @t t on g.GoalRefID % 7 = RowNum

select * from LEGACYSPED.Goal


*/





IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgGoalSubGoalAreaDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgGoalSubGoalAreaDef
GO

create view LEGACYSPED.Transform_PrgGoalSubGoalAreaDef
as
select 
	ga.GoalRefID,
	GoalID = pg.DestID,
	DefID = m.DestID 
from LEGACYSPED.Transform_PrgGoalarea_goals ga join 
LEGACYSPED.Transform_PrgGoal pg on ga.GoalRefID = pg.GoalRefID join 
LEGACYSPED.SubGoalAreaPivotView sg on ga.GoalRefID = sg.GoalRefID left join 
LEGACYSPED.MAP_IepSubGoalAreaDefID m on sg.GoalAreaCode = m.SubGoalAreaCode 
--left join PrgGoalSubGoalAreaDef sgad on ga.DestID = sgad.GoalID and m.DestID = sgad.DefID
--where ga.GoalAreaCode = 'GACurriculum' -- assuming only one parent for now
go

select * from LEGACYSPED.MAP_IepSubGoalAreaDefID m

select * from IepGoalPostSchoolAreaDef


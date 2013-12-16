
-- this MAP table will speed up the GoalArea queries considerably
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_GoalAreaPivot') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
create table LEGACYSPED.MAP_GoalAreaPivot 
(
	GoalRefID	varchar(150) not null,
	GoalAreaCode varchar(150) not null,
	GoalAreaDefIndex int not null
)

ALTER TABLE LEGACYSPED.MAP_GoalAreaPivot ADD CONSTRAINT 
PK_MAP_GoalAreaPivot PRIMARY KEY CLUSTERED
(
	GoalRefID, GoalAreaDefIndex
)
END
GO

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_MAP_GoalAreaPivot_GoalRefID_GoalAreaCode')
create index IX_LEGACYSPED_MAP_GoalAreaPivot_GoalRefID_GoalAreaCode on LEGACYSPED.MAP_GoalAreaPivot (GoalRefID, GoalAreaCode)
go

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.PrimaryGoalAreaPerGoal') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.PrimaryGoalAreaPerGoal
GO

create view LEGACYSPED.PrimaryGoalAreaPerGoal 
as
select GoalRefID, PrimaryGoalAreaDefIndex = min(GoalAreaDefIndex)
from LEGACYSPED.MAP_GoalAreaPivot
group by GoalRefID
go

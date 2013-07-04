
-- this MAP table will speed up the GoalArea queries considerably
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_GoalAreaPivot') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
create table x_LEGACYGIFT.MAP_GoalAreaPivot 
(
	GoalRefID	varchar(150) not null,
	GoalAreaCode varchar(150) not null,
	GoalAreaDefIndex int not null
)

ALTER TABLE x_LEGACYGIFT.MAP_GoalAreaPivot ADD CONSTRAINT 
PK_MAP_GoalAreaPivot PRIMARY KEY CLUSTERED
(
	GoalRefID, GoalAreaDefIndex
)
END
GO

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_MAP_GoalAreaPivot_GoalRefID_GoalAreaCode')
create index IX_x_LEGACYGIFT_MAP_GoalAreaPivot_GoalRefID_GoalAreaCode on x_LEGACYGIFT.MAP_GoalAreaPivot (GoalRefID, GoalAreaCode)
go

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.PrimaryGoalAreaPerGoal') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.PrimaryGoalAreaPerGoal
GO

create view x_LEGACYGIFT.PrimaryGoalAreaPerGoal 
as
select GoalRefID, PrimaryGoalAreaDefIndex = min(GoalAreaDefIndex)
from x_LEGACYGIFT.MAP_GoalAreaPivot
group by GoalRefID
go

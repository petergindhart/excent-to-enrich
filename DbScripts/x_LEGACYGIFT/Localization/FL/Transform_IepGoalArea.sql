
-- FLORIDA SPECIFIC

-- x_LEGACYGIFT.MAP_GoalAreaDefID is created and inserted in x_LEGACYGIFT\Objects\0001a-ETLPrep_State_FL.sql -- drop table x_LEGACYGIFT.MAP_IepGoalAreaID
-- #############################################################################
--		Iep Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_IepGoalAreaID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_IepGoalAreaID
(
	GoalRefID	varchar(150) not null,
	DefID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE x_LEGACYGIFT.MAP_IepGoalAreaID ADD CONSTRAINT 
PK_MAP_IepGoalAreaID PRIMARY KEY CLUSTERED
(
	DefID, GoalRefID
)
END
GO

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

IF exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.name = 'GoalAreaPivotView' and o.type = 'U')
DROP TABLE x_LEGACYGIFT.GoalAreaPivotView
GO
-- #############################################################################
IF exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.name = 'GoalAreaPivotView' and o.type = 'V')
DROP VIEW x_LEGACYGIFT.GoalAreaPivotView
GO

create view x_LEGACYGIFT.GoalAreaPivotView
as
	select EPRefID, GoalRefID, 'GACurriculum' GoalAreaCode, cast(0 as int) GoalAreaDefIndex
	from x_LEGACYGIFT.GiftedGoal 
	where not (GAReading is null and GAWriting is null and GAMath is null and GAOther is null) 
	UNION ALL
	select EPRefID, GoalRefID, 'GAEmotional' GoalAreaCode, CAST(4 as int) GoalAreaDefIndex
	from x_LEGACYGIFT.GiftedGoal
	where  GAEmotional = 'Y'
	UNION ALL
	select EPRefID, GoalRefID, 'GAIndependent' GoalAreaCode, CAST(5 as int) GoalAreaDefIndex
	from x_LEGACYGIFT.GiftedGoal
	where  GAIndependent = 'Y'
	UNION ALL
	select EPRefID, GoalRefID, 'GAHealth' GoalAreaCode, CAST(6 as int) GoalAreaDefIndex
	from x_LEGACYGIFT.GiftedGoal
	where  GAHealth = 'Y'
	UNION ALL
	select EPRefID, GoalRefID, 'GACommunication' GoalAreaCode, CAST(7 as int) GoalAreaDefIndex
	from x_LEGACYGIFT.GiftedGoal
	where  GACommunication = 'Y'
--order by GoalRefID
go



-- #############################################################################
-- Transform_IepGoalArea (PRIMARY)
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_IepGoalArea') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_IepGoalArea
go

create view x_LEGACYGIFT.Transform_IepGoalArea
as
-- we are separating out the primary goal areas from the secondary goal areas.  We will use the lowest GoalAreaDefIndex for the primary goal. 
-- Curriculum and Learning goals are derived from the presence any of Reading, Writing, Math or Other
select 
	g.EPRefID, 
	g.GoalRefID, 
	p.GoalAreaCode, 
	mga.DestID,
	GoalID = g.DestID,
	DefID = md.DestID, -- GoalAreaDefID
	g.InstanceID, 
	FormInstanceID = cast(NULL as uniqueidentifier),
	g.EsyID -- select *
from x_LEGACYGIFT.Transform_PrgGoal g join 
x_LEGACYGIFT.MAP_GoalAreaPivot p on g.GoalRefID = p.GoalRefID join -- in the where clause we will limit this to the primary goal area.  Another transform will insert subgoals, and yet another will insert secondary goals
x_LEGACYGIFT.MAP_IepGoalAreaDefID md on p.GoalAreaCode = md.GoalAreaCode left join
x_LEGACYGIFT.MAP_IepGoalAreaID mga on g.GoalRefID = mga.GoalRefID and md.DestID = mga.DefID left join 
IepGoalArea ga on mga.DestID = ga.ID
where p.GoalAreaDefIndex = (
	select min(pmin.GoalAreaDefIndex)
	from x_LEGACYGIFT.MAP_GoalAreaPivot pmin 
	where p.GoalRefID = pmin.GoalRefID)
go


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_IepGoalArea_Distinct') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_IepGoalArea_Distinct
go

create view x_LEGACYGIFT.Transform_IepGoalArea_Distinct
as
select EPRefID, GoalAreaCode, DefID, InstanceID, FormInstanceID
from x_LEGACYGIFT.Transform_IepGoalArea ga 
group by EPRefID, GoalAreaCode, DefID, InstanceID, FormInstanceID
go


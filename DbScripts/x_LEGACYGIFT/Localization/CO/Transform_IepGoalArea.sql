-- COLORADO VERSION

-- x_LEGACYGIFT.MAP_GoalAreaDefID is created and inserted in x_LEGACYGIFT\Objects\0001a-ETLPrep_State_CO.sql -- drop table x_LEGACYGIFT.MAP_IepGoalAreaID
-- #############################################################################
--		Iep Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_IepGoalAreaID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_IepGoalAreaID
(
	EPRefID	varchar(150) not null,
	DefID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE x_LEGACYGIFT.MAP_IepGoalAreaID ADD CONSTRAINT 
PK_MAP_IepGoalAreaID PRIMARY KEY CLUSTERED
(
	DefID, EPRefID
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
select g.EpRefID, g.GoalRefID, g.GoalAreaCode, GoalAreaDefIndex = k.Sequence
from x_LEGACYGIFT.GiftedGoal g join (
	select k.Type, k.LegacySpedCode, k.EnrichLabel, Sequence = (
		select count(*) 
		from LEGACYSPED.SelectLists ki 
		where ki.Type = 'GoalArea' 
		and ki.EnrichLabel < k.EnrichLabel
		) 
	from LEGACYSPED.SelectLists k 
	where k.Type = 'GoalArea'
	) k on g.GoalAreaCode = k.LegacySpedCode 
GO


IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_PrgGoalID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_PrgGoalID
	(
	GoalRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL,
	CrossVersionGoalID uniqueidentifier NOT NULL
	)

ALTER TABLE x_LEGACYGIFT.MAP_PrgGoalID ADD CONSTRAINT
	PK_MAP_PrgGoalID PRIMARY KEY CLUSTERED
	(
	GoalRefID
	)
CREATE INDEX IX_x_LEGACYGIFT_MAP_PrgGoalID_DestID on x_LEGACYGIFT.MAP_PrgGoalID (DestID)
END

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_GiftedGoal_LOCAL_EPRefID')
CREATE NONCLUSTERED INDEX  IX_x_LEGACYGIFT_GiftedGoal_LOCAL_EPRefID ON x_LEGACYGIFT.GiftedGoal_LOCAL ([EpRefID]) INCLUDE ([GoalRefID])
GO

-- #############################################################################
-- Transform_IepGoalArea (PRIMARY) (this view was copied from FL)
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_IepGoalArea_goals') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_IepGoalArea_goals
go

create view x_LEGACYGIFT.Transform_IepGoalArea_goals
as
-- we are separating out the primary goal areas from the secondary goal areas.  We will use the lowest GoalAreaDefIndex for the primary goal. 
-- Curriculum and Learning goals are derived from the presence any of Reading, Writing, Math or Other
select 
	g.EpRefID, 
	g.GoalRefID, 
	p.GoalAreaCode, 
	mga.DestID,
	GoalID = mg.DestID,
	DefID = md.DestID, -- GoalAreaDefID
	InstanceID = gs.DestID, 
	FormInstanceID = cast(NULL as uniqueidentifier),
	EsyID = case when g.IsEsy = 'Y' then 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' else 'F7E20A86-2709-4170-9810-15B601C61B79' end
from x_LEGACYGIFT.MAP_EPStudentRefID mes join 
x_LEGACYGIFT.GiftedGoal g on mes.EPRefID = g.EpRefID join 
x_LEGACYGIFT.MAP_GoalAreaPivot p on g.GoalRefID = p.GoalRefID join -- in the where clause we will limit this to the primary goal area.  Another transform will insert subgoals, and yet another will insert secondary goals
LEGACYSPED.MAP_IepGoalAreaDefID md on p.GoalAreaCode = md.GoalAreaCode left join
x_LEGACYGIFT.MAP_PrgGoalID mg on g.GoalRefID = mg.GoalRefID left join
x_LEGACYGIFT.Transform_PrgGoals gs on g.EpRefID = gs.EpRefId left join
x_LEGACYGIFT.MAP_IepGoalAreaID mga on g.EPRefID = mga.EPRefID and md.DestID = mga.DefID left join 
IepGoalArea ga on mga.DestID = ga.ID
where p.GoalAreaDefIndex = (
	select min(pmin.GoalAreaDefIndex)
	from x_LEGACYGIFT.MAP_GoalAreaPivot pmin 
	where p.GoalRefID = pmin.GoalRefID)
go


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_IepGoalArea') AND OBJECTPROPERTY(id, N'IsView') = 1) ------- this is new to make distinct goal areas per IEP
DROP VIEW x_LEGACYGIFT.Transform_IepGoalArea
go

create view x_LEGACYGIFT.Transform_IepGoalArea
as
select gap.EpRefID, gap.GoalAreaCode, DestID = isnull(ga.ID, mga.DestID), DefID = gad.DestID, InstanceID = gs.DestID, FormInstanceID = cast(NULL as uniqueidentifier)
from x_LEGACYGIFT.MAP_EPStudentRefID mes
join x_LEGACYGIFT.GoalAreaPivotView gap on mes.EPRefID = gap.EpRefID 
join x_LEGACYGIFT.PrimaryGoalAreaPerGoal pg on gap.GoalRefID = pg.GoalRefID and gap.GoalAreaDefIndex = pg.PrimaryGoalAreaDefIndex
join LEGACYSPED.MAP_IepGoalAreaDefID gad on gap.GoalAreaCode = gad.GoalAreaCode
join x_LEGACYGIFT.Transform_PrgGoals gs on gap.EpRefID = gs.EpRefId
left join x_LEGACYGIFT.MAP_IepGoalAreaID mga on gap.EpRefID = mga.EpRefID and gad.DestID = mga.DefID
left join dbo.IepGoalArea ga on mga.DestID = ga.ID
group by gap.EpRefID, gap.GoalAreaCode, gad.DestID, gs.DestID, isnull(ga.ID, mga.DestID)
go

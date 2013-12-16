
-- FLORIDA SPECIFIC

-- LEGACYSPED.MAP_GoalAreaDefID is created and inserted in LEGACYSPED\Objects\0001a-ETLPrep_State_FL.sql -- drop table LEGACYSPED.MAP_IepGoalAreaID
-- #############################################################################
--		Iep Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepGoalAreaID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepGoalAreaID
(
	IEPRefID	varchar(150) not null,
	DefID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepGoalAreaID ADD CONSTRAINT 
PK_MAP_IepGoalAreaID PRIMARY KEY CLUSTERED
(
	DefID, IEPRefID
)
END
GO

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

IF exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'GoalAreaPivotView' and o.type = 'U')
DROP TABLE LEGACYSPED.GoalAreaPivotView
GO
-- #############################################################################
IF exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'GoalAreaPivotView' and o.type = 'V')
DROP VIEW LEGACYSPED.GoalAreaPivotView
GO

create view LEGACYSPED.GoalAreaPivotView
as
	select IepRefID, GoalRefID, 'GACurriculum' GoalAreaCode, cast(0 as int) GoalAreaDefIndex
	from LEGACYSPED.Goal 
	where not (GAReading is null and GAWriting is null and GAMath is null and GAOther is null) 
	UNION ALL
	select IepRefID, GoalRefID, 'GAEmotional' GoalAreaCode, CAST(4 as int) GoalAreaDefIndex
	from LEGACYSPED.Goal
	where  GAEmotional = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAIndependent' GoalAreaCode, CAST(5 as int) GoalAreaDefIndex
	from LEGACYSPED.Goal
	where  GAIndependent = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAHealth' GoalAreaCode, CAST(6 as int) GoalAreaDefIndex
	from LEGACYSPED.Goal
	where  GAHealth = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GACommunication' GoalAreaCode, CAST(7 as int) GoalAreaDefIndex
	from LEGACYSPED.Goal
	where  GACommunication = 'Y'
--order by GoalRefID
go


IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgGoalID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgGoalID
	(
	GoalRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL,
	CrossVersionGoalID uniqueidentifier NOT NULL
	)

ALTER TABLE LEGACYSPED.MAP_PrgGoalID ADD CONSTRAINT
	PK_MAP_PrgGoalID PRIMARY KEY CLUSTERED
	(
	GoalRefID
	)
CREATE INDEX IX_LEGACYSPED_MAP_PrgGoalID_DestID on LEGACYSPED.MAP_PrgGoalID (DestID)
END

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_Goal_LOCAL_IEPRefID')
CREATE NONCLUSTERED INDEX  IX_LEGACYSPED_Goal_LOCAL_IEPRefID ON [LEGACYSPED].[Goal_LOCAL] ([IepRefID]) INCLUDE ([GoalRefID])
GO

-- #############################################################################
-- Transform_IepGoalArea_goals (PRIMARY)
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoalArea_goals') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepGoalArea_goals
go

create view LEGACYSPED.Transform_IepGoalArea_goals
as
-- we are separating out the primary goal areas from the secondary goal areas.  We will use the lowest GoalAreaDefIndex for the primary goal. 
-- Curriculum and Learning goals are derived from the presence any of Reading, Writing, Math or Other
select 
	g.IepRefID, 
	g.GoalRefID, 
	p.GoalAreaCode, 
	mga.DestID,
	GoalID = mg.DestID,
	DefID = md.DestID, -- GoalAreaDefID
	InstanceID = gs.DestID, 
	FormInstanceID = cast(NULL as uniqueidentifier),
	EsyID = case when g.IsEsy = 'Y' then 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' else 'F7E20A86-2709-4170-9810-15B601C61B79' end
from LEGACYSPED.Goal g join 
LEGACYSPED.MAP_GoalAreaPivot p on g.GoalRefID = p.GoalRefID join -- in the where clause we will limit this to the primary goal area.  Another transform will insert subgoals, and yet another will insert secondary goals
LEGACYSPED.MAP_IepGoalAreaDefID md on p.GoalAreaCode = md.GoalAreaCode left join
LEGACYSPED.MAP_PrgGoalID mg on g.GoalRefID = mg.GoalRefID left join
LEGACYSPED.Transform_PrgGoals gs on g.IepRefID = gs.IepRefId left join
LEGACYSPED.MAP_IepGoalAreaID mga on g.IEPRefID = mga.IEPRefID and md.DestID = mga.DefID left join --------------- used to join on goalrefid.  can't now
IepGoalArea ga on mga.DestID = ga.ID
where p.GoalAreaDefIndex = (
	select min(pmin.GoalAreaDefIndex)
	from LEGACYSPED.MAP_GoalAreaPivot pmin 
	where p.GoalRefID = pmin.GoalRefID)
go


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoalArea') AND OBJECTPROPERTY(id, N'IsView') = 1) ------- this is new to make distinct goal areas per IEP
DROP VIEW LEGACYSPED.Transform_IepGoalArea
go

create view LEGACYSPED.Transform_IepGoalArea
as
select gap.IepRefID, gap.GoalAreaCode, DestID = isnull(ga.ID, mga.DestID), DefID = gad.DestID, InstanceID = gs.DestID, FormInstanceID = cast(NULL as uniqueidentifier)
from LEGACYSPED.GoalAreaPivotView gap
join LEGACYSPED.PrimaryGoalAreaPerGoal pg on gap.GoalRefID = pg.GoalRefID and gap.GoalAreaDefIndex = pg.PrimaryGoalAreaDefIndex
join LEGACYSPED.MAP_IepGoalAreaDefID gad on gap.GoalAreaCode = gad.GoalAreaCode
join LEGACYSPED.Transform_PrgGoals gs on gap.IepRefID = gs.IepRefId
left join LEGACYSPED.MAP_IepGoalAreaID mga on gap.IepRefID = mga.IEPRefID and gad.DestID = mga.DefID
left join dbo.IepGoalArea ga on mga.DestID = ga.ID
group by gap.IepRefID, gap.GoalAreaCode, gad.DestID, gs.DestID, isnull(ga.ID, mga.DestID)
go

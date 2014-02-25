-- MICHIGAN VERSION

-- LEGACYSPED.MAP_GoalAreaDefID is created and inserted in LEGACYSPED\Objects\0001a-ETLPrep_State_CO.sql -- drop table LEGACYSPED.MAP_IepGoalAreaID
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

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_MAP_GoalAreaPivot_GaolRefID_GoalAreaCode')
create index IX_LEGACYSPED_MAP_GoalAreaPivot_GaolRefID_GoalAreaCode on LEGACYSPED.MAP_GoalAreaPivot (GoalRefID, GoalAreaCode)
go


IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgGoalID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN -- drop TABLE LEGACYSPED.MAP_PrgGoalID
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

declare @tableorview char(10) 
-- #############################################################################
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.GoalAreaPivotView') AND OBJECTPROPERTY(id, N'IsView') = 1)
set @tableorview = 'VIEW'

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.GoalAreaPivotView') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
set @tableorview = 'TABLE'

if @tableorview = 'TABLE' 
drop table LEGACYSPED.GoalAreaPivotView

if @tableorview = 'VIEW'
drop view LEGACYSPED.GoalAreaPivotView
go

create view LEGACYSPED.GoalAreaPivotView
as
select g.IepRefID, g.GoalRefID, g.GoalAreaCode, GoalAreaDefIndex = k.Sequence
from LEGACYSPED.Goal g join (
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

--create table LEGACYSPED.GoalAreaPivotTable (
--IepRefID varchar(150) not null,
--GoalRefID varchar(150) not null,
--GoalAreaCode varchar(20) not null,
--GoalIndex int not null
--)

--alter table LEGACYSPED.GoalAreaPivotTable 
--	add constraint PK_LEGACYSPED_GoalAreaPivotTable primary key (IepRefID, GoalRefID, GoalAreaCode)
--go

--alter table LEGACYSPED.GoalAreaPivotTable 
--	drop constraint PK_LEGACYSPED_GoalAreaPivotTable 
--go


--insert LEGACYSPED.GoalAreaPivotTable
--select * from LEGACYSPED.GoalAreaPivotView

-- #############################################################################

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.GoalAreasPerGoalView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.GoalAreasPerGoalView
GO

-- this view is different between FL and CO because of the way Goal Areas are handled in the 2 states
create view LEGACYSPED.GoalAreasPerGoalView -- select * from LEGACYSPED.GoalAreasPerGoalView 
as
/*

	Currently Enrich does not support more than 1 goal area per goal, so we need to arbitrarily but consistently pick one goal for now.
	In LEGACYSPED.GoalAreaPivotView we devised an Index that will allow us to select the minimum GoalAreaIndex per Goal, which this view provides.
	The output of this view will be the one GoalArea selected for each Goal.
	This filter will no longer be necessary after support for multiple areas (domains) per goal is added to Enrich.

*/

-- The output of this view will be the one GoalArea selected for each Goal.
	select
		g.IepRefID,
		InstanceID = pgs.DestID,
		DefID = m.DestID,
		GoalAreaCode = isnull(g.GoalAreaCode, 'ZZZ'),
		g.GoalRefID,
		GoalIndex = cast(0 as int) -- select g.*
	from LEGACYSPED.Goal g JOIN
		LEGACYSPED.Transform_PrgGoals pgs on g.IepRefID = pgs.IepRefID join -- on left join some records do not have an instanceid  -- 4E367F51-09E0-41A6-9CA1-88F0230A05D1 
		LEGACYSPED.Transform_IepGoalAreaDef m on isnull(g.GoalAreaCode,'ZZZ') = m.GoalAreaCode -- select * from LEGACYSPED.MAP_GoalAreaDefID -- select * from IepGoalAreaDef order by deleteddate, sequence, Name -- select * from LEGACYSPED.MAP_GoalAreaDefID
	--where ga.GoalIndex = (				
	--	select top 1 minga.GoalIndex
	--	from  LEGACYSPED.GoalAreaPivotView minga
	--	where ga.GoalRefID = minga.GoalRefID
	--	order by ga.GoalIndex)
GO
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


-- #############################################################################
-- Transform_IepGoalArea (PRIMARY) (this view was copied from FL)
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoalArea') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepGoalArea
go

-- we are separating out the primary goal areas from the secondary goal areas.  We will use the lowest GoalAreaDefIndex for the primary goal. 
-- Curriculum and Learning goals are derived from the presence any of Reading, Writing, Math or Other
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
go

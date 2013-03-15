-- SOUTH CAROLINA VERSION

-- #############################################################################
--		Iep Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepGoalAreaID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepGoalAreaID
(
	GoalRefID	varchar(150) not null,
	DefID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepGoalAreaID ADD CONSTRAINT 
PK_MAP_IepGoalAreaID PRIMARY KEY CLUSTERED
(
	DefID, GoalRefID
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


-- #############################################################################
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.GoalAreaPivotView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.GoalAreaPivotView
GO

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


-- #############################################################################
-- Transform_IepGoalArea (PRIMARY) (this view was copied from FL)
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoalArea') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepGoalArea
go

create view LEGACYSPED.Transform_IepGoalArea
as
-- we are separating out the primary goal areas from the secondary goal areas.  We will use the lowest GoalAreaDefIndex for the primary goal. 
-- Curriculum and Learning goals are derived from the presence any of Reading, Writing, Math or Other
select 
	g.IepRefID, 
	g.GoalRefID, 
	p.GoalAreaCode, 
	mga.DestID,
	GoalID = g.DestID,
	DefID = md.DestID, -- GoalAreaDefID
	g.InstanceID, 
	FormInstanceID = cast(NULL as uniqueidentifier),
	g.EsyID
from LEGACYSPED.Transform_PrgGoal g join 
LEGACYSPED.MAP_GoalAreaPivot p on g.GoalRefID = p.GoalRefID join -- in the where clause we will limit this to the primary goal area.  Another transform will insert subgoals, and yet another will insert secondary goals
LEGACYSPED.MAP_IepGoalAreaDefID md on p.GoalAreaCode = md.GoalAreaCode left join
LEGACYSPED.MAP_IepGoalAreaID mga on g.GoalRefID = mga.GoalRefID and md.DestID = mga.DefID left join 
IepGoalArea ga on mga.DestID = ga.ID
where p.GoalAreaDefIndex = (
	select min(pmin.GoalAreaDefIndex)
	from LEGACYSPED.MAP_GoalAreaPivot pmin 
	where p.GoalRefID = pmin.GoalRefID)
go

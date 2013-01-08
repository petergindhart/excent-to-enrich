-- COLORADO VERSION

-- LEGACYSPED.MAP_GoalAreaDefID is created and inserted in LEGACYSPED\Objects\0001a-ETLPrep_State_FL.sql
-- #############################################################################
--		Iep Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepGoalArea') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepGoalArea
(
	GoalRefID	varchar(150) not null,
	DefID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepGoalArea ADD CONSTRAINT 
PK_MAP_IepGoalArea PRIMARY KEY CLUSTERED
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


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoalArea') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepGoalArea
GO

create view LEGACYSPED.Transform_IepGoalArea 
as
	select distinct
		gapg.IepRefID,
		g.GoalRefID,
		gapg.GoalAreaCode,
		mga.DestID,
		GoalID = g.DestID,
		gapg.InstanceID,
		gapg.DefID,
		FormInstanceID = CAST(NULL as uniqueidentifier),
		g.EsyID
	from Legacysped.Transform_PrgGoal g join 
		--select distinct -- if support is later added for multiple domains per goal this portion of the query may work
		--	ga.IepRefID,
		--	InstanceID = pgs.DestID,
		--	DefID = m.DestID,
		--	ga.GoalAreaCode
		--from LEGACYSPED.GoalAreaPivotView ga JOIN 
		--LEGACYSPED.Transform_PrgGoals pgs on ga.IepRefID = pgs.IepRefID join -- on left join some records do not have an instanceid  -- 4E367F51-09E0-41A6-9CA1-88F0230A05D1 
		--LEGACYSPED.MAP_GoalAreaDefID m on ga.GoalAreaCode = m.GoalAreaCode
		LEGACYSPED.GoalAreasPerGoalView gapg on g.GoalRefID = gapg.GoalRefID and g.IepRefID = gapg.IepRefID left join
		--) distga left join -- 32608
		LEGACYSPED.MAP_IepGoalArea mga on gapg.GoalRefID = mga.GoalRefID and gapg.DefID = mga.DefID left join
		dbo.IepGoalArea tgt on mga.DestID = tgt.ID
go

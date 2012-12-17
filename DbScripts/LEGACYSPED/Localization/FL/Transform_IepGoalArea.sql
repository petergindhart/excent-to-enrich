
-- FLORIDA SPECIFIC

-- LEGACYSPED.MAP_GoalAreaDefID is created and inserted in LEGACYSPED\Objects\0001a-ETLPrep_State_FL.sql -- drop table LEGACYSPED.MAP_IepGoalArea
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


-- #############################################################################

--IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.GoalAreasPerGoalView') AND OBJECTPROPERTY(id, N'IsView') = 1)
--DROP VIEW LEGACYSPED.GoalAreasPerGoalView
--GO

--create view LEGACYSPED.GoalAreasPerGoalView ---------------------------- change name to minimum goal area per goal -- or -- goal area per goal view (not plural).  one primary area, possible multiple secondary areas.
--as
--/*

--	--Currently Enrich does not support more than 1 goal area per goal, so we need to arbitrarily but consistently pick one goal for now.
--	--In LEGACYSPED.GoalAreaPivotView we devised an Index that will allow us to select the minimum GoalAreaIndex per Goal, which this view provides.
--	--The output of this view will be the one GoalArea selected for each Goal.
--	--This filter will no longer be necessary after support for multiple areas (domains) per goal is added to Enrich.
---- The output of this view will be the one GoalArea selected for each Goal.

--	NOTE:  The above comment does not apply now that we can have more than one goal area per goal.  GG 20121213

--	Now the view should only return one goal area per goal, because the sub-goals are being split out.	

--*/
--select
--	tg.GoalRefID,
--	tg.IepRefID,
--	tg.InstanceID,
--	DefID = m.DestID,
--	ga.GoalAreaCode, 
--	GoalIndex = cast(0 as int) -- select ga.* 
--from 
--	LEGACYSPED.Transform_PrgGoal tg join -- select * from LEGACYSPED.Transform_PrgGoal 
--	LEGACYSPED.GoalAreaPivotView ga on tg.GoalRefID = ga.GoalRefID join -- select * from LEGACYSPED.GoalAreaPivotView
--	LEGACYSPED.MAP_IepGoalAreaDefID m on ga.GoalAreaCode = m.GoalAreaCode  -- select * from LEGACYSPED.MAP_IepGoalAreaDefID
--where ga.GoalAreaDefIndex = (
--	select min(minga.GoalAreaDefIndex)
--	from  LEGACYSPED.GoalAreaPivotView minga
--	where tg.GoalRefID = minga.GoalRefID
--	)
--GO


-- #############################################################################
-- Transform_IepGoalArea (PRIMARY)
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
LEGACYSPED.MAP_IepGoalArea mga on g.GoalRefID = mga.GoalRefID and md.DestID = mga.GoalAreaDefID left join 
IepGoalArea ga on mga.DestID = ga.ID
where p.GoalAreaDefIndex = (
	select min(pmin.GoalAreaDefIndex)
	from LEGACYSPED.MAP_GoalAreaPivot pmin 
	where p.GoalRefID = pmin.GoalRefID)
go



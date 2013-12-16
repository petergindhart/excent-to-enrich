-- ILLINOIS VERSION

-- #############################################################################
--		Iep Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepGoalAreaID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepGoalAreaID
(
	InstanceID	uniqueidentifier not null,
	GoalAreaDefID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepGoalAreaID ADD CONSTRAINT 
PK_MAP_IepGoalAreaID PRIMARY KEY CLUSTERED
(
	InstanceID, GoalAreaDefID
)
END
GO

-- #############################################################################
/*
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.GoalAreaPivotView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.GoalAreaPivotView
--GO

create view LEGACYSPED.GoalAreaPivotView
as
	select IepRefID, GoalRefID, 'GAReading' GoalAreaCode, CAST(0 as int) GoalIndex
	from LEGACYSPED.Goal
	where GAReading = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAWriting' GoalAreaCode, CAST(1 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GAWriting = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAMath' GoalAreaCode, CAST(2 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GAMath = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAOther' GoalAreaCode, CAST(3 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GAOther = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAEmotional' GoalAreaCode, CAST(4 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GAEmotional = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAIndependent' GoalAreaCode, CAST(5 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GAIndependent = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GAHealth' GoalAreaCode, CAST(6 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GAHealth = 'Y'
	UNION ALL
	select IepRefID, GoalRefID, 'GACommunication' GoalAreaCode, CAST(7 as int) GoalIndex
	from LEGACYSPED.Goal
	where  GACommunication = 'Y'
--GO
*/

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
		gapg.GoalAreaCode,
		mga.DestID,
		gapg.InstanceID,
		gapg.DefID,
		FormInstanceID = CAST(NULL as uniqueidentifier)
	from 
		--select distinct -- if support is later added for multiple domains per goal this portion of the query may work
		--	ga.IepRefID,
		--	InstanceID = pgs.DestID,
		--	DefID = m.DestID,
		--	ga.GoalAreaCode
		--from LEGACYSPED.GoalAreaPivotView ga JOIN 
		--LEGACYSPED.Transform_PrgGoals pgs on ga.IepRefID = pgs.IepRefID join -- on left join some records do not have an instanceid  -- 4E367F51-09E0-41A6-9CA1-88F0230A05D1 
		--LEGACYSPED.MAP_GoalAreaDefID m on ga.GoalAreaCode = m.GoalAreaCode
		LEGACYSPED.GoalAreasPerGoalView gapg left join
		--) distga left join -- 32608
		LEGACYSPED.MAP_IepGoalAreaID mga on gapg.InstanceID = mga.InstanceID and gapg.DefID = mga.GoalAreaDefID left join
		dbo.IepGoalArea tgt on mga.DestID = tgt.ID --- select * from IepGoalArea
		--where gapg.GoalIndex = 
		--	(select MIN(gaIn.GoalIndex) -- Enrich does not currently support multiple domains per Goal
		--	from LEGACYSPED.GoalAreaPivotView gaIn
		--	where gaIn.GoalRefID = gapg.GoalRefID) 
go

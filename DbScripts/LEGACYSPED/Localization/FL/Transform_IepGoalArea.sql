
-- FLORIDA SPECIFIC

-- LEGACYSPED.MAP_GoalAreaDefID is created and inserted in LEGACYSPED\Objects\0001a-ETLPrep_State_FL.sql -- drop table LEGACYSPED.MAP_IepGoalArea
-- #############################################################################
--		Iep Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepGoalArea') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepGoalArea
(
	GoalRefID	varchar(150) not null,
	GoalAreaDefID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepGoalArea ADD CONSTRAINT 
PK_MAP_IepGoalArea PRIMARY KEY CLUSTERED
(
	GoalAreaDefID, GoalRefID
)
END
GO

-- #############################################################################

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.GoalAreaPivotView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.GoalAreaPivotView
GO

create view LEGACYSPED.GoalAreaPivotView
as
	select IepRefID, GoalRefID, 'GACurriculum' GoalAreaCode, cast(0 as int) GoalIndex
	from LEGACYSPED.Goal 
	where not (GAReading is null and GAWriting is null and GAMath is null and GAOther is null) 
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
go

select * from LEGACYSPED.Goal




-- #############################################################################

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.GoalAreasPerGoalView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.GoalAreasPerGoalView
GO

create view LEGACYSPED.GoalAreasPerGoalView 
as
/*

	--Currently Enrich does not support more than 1 goal area per goal, so we need to arbitrarily but consistently pick one goal for now.
	--In LEGACYSPED.GoalAreaPivotView we devised an Index that will allow us to select the minimum GoalAreaIndex per Goal, which this view provides.
	--The output of this view will be the one GoalArea selected for each Goal.
	--This filter will no longer be necessary after support for multiple areas (domains) per goal is added to Enrich.
-- The output of this view will be the one GoalArea selected for each Goal.

	NOTE:  The above comment does not apply now that we can have more than one goal area per goal.  GG 20121213

	Now the view should only return one goal area per goal, because the sub-goals are being split out.	

*/
select
	g.GoalRefID,
	g.IepRefID,
	InstanceID = pgs.DestID,
	DefID = m.DestID,
	ga.GoalAreaCode, 
	GoalIndex = cast(0 as int) -- select ga.* 
from LEGACYSPED.Goal g JOIN
	LEGACYSPED.Transform_PrgGoals pgs on g.IepRefID = pgs.IepRefID join -- select * from LEGACYSPED.Transform_PrgGoals pgs
	LEGACYSPED.GoalAreaPivotView ga on g.GoalRefID = ga.GoalRefID join -- select * from LEGACYSPED.GoalAreaPivotView
	LEGACYSPED.MAP_IepGoalAreaDefID m on ga.GoalAreaCode = m.GoalAreaCode  -- select * from LEGACYSPED.MAP_IepGoalAreaDefID
--where ga.GoalIndex = (
--	select top 1 minga.GoalIndex
--	from  LEGACYSPED.GoalAreaPivotView minga
--	where g.GoalRefID = minga.GoalRefID
--	order by ga.GoalIndex
--	)
GO


-- #############################################################################


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoalArea') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepGoalArea
GO

create view LEGACYSPED.Transform_IepGoalArea 
as
select distinct
	gapg.IepRefID,
	gapg.GoalRefID,
	gapg.GoalAreaCode,
	GoalAreaDefID = mgad.DestID,
	mga.DestID,
	gapg.InstanceID,
	gapg.DefID,
	FormInstanceID = CAST(NULL as uniqueidentifier)
from 
	LEGACYSPED.GoalAreasPerGoalView gapg join
	LEGACYSPED.MAP_IepGoalAreaDefID mgad on gapg.GoalAreaCode = mgad.GoalAreaCode left join -- select * from LEGACYSPED.MAP_IepGoalAreaDefID
	LEGACYSPED.MAP_IepGoalArea mga on gapg.GoalRefID = mga.GoalRefID and gapg.DefID = mga.GoalAreaDefID left join -- select * from LEGACYSPED.MAP_IepGoalArea where GoalAreaDefID = '35B32108-174B-4F7F-9B5A-B5AF106F06BC'
	dbo.IepGoalArea tgt on mga.DestID = tgt.ID 
go

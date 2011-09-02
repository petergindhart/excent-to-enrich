--#include Transform_PrgGoal.sql
--#include Transform_IepGoalArea.sql
--#include Transform_IepGoalPostSchoolArea.sql
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_IepGoal]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].Transform_IepGoal
GO

create view AURORAX.Transform_IepGoal
as
select 
  DestID = pg.DestID,
  GoalAreaID = ga.DestID,
   PostSchoolAreaDefID = psa.PostSchoolAreaDefID,
   pg.EsyID -- ,
FROM 
	AURORAX.Transform_PrgGoal pg JOIN
	AURORAX.Transform_IepGoalArea ga on pg.InstanceID = ga.InstanceID LEFT JOIN 
	AURORAX.Transform_IepGoalPostSchoolAreaDef psa on pg.GoalRefID = psa.GoalRefID and psa.Sequence = 0 LEFT JOIN 
	dbo.IepGoalArea tgt on ga.InstanceID = tgt.InstanceID and psa.PostSchoolAreaDefID = tgt.DefID 
go





/*

select g.goalrefid, 
	GoalAreaID = ga.ID,
	-- psa.PostSchoolAreaDefID,
	--pg.EsyId
	0 as bogus
from AURORAX.Goal g join -- 34737
	AURORAX.MAP_PrgGoalID pg on g.GoalRefID = pg.GoalRefID join -- 33685
	AURORAX.GoalAreasPerGoalView gapg on g.GoalRefID = gapg.GoalRefID and
		 gapg.GoalIndex = 
		(select MIN(gaIn.GoalIndex) -- Enrich does not currently support multiple domains per Goal
		from AURORAX.GoalAreaPivotView gaIn
		where gaIn.GoalRefID = g.GoalRefID) join  -- 39555
		-- 32679
	dbo.IepGoalArea ga on gapg.InstanceID = ga.instanceID and gapg.DefID = ga.DefID 
	left join
	AURORAX.Transform_IepGoalPostSchoolAreaDef psa on g.GoalRefID = psa.GoalRefID and psa.Sequence = 0


-- select * from AURORAX.MAP_PrgGoalID

--go

-- select * from IepGoal
-- select * from AURORAX.Transform_IepGoalPostSchoolArea psa 
-- select * from AURORAX.Transform_PrgGoal
-- select * from AURORAX.Transform_IepGoalArea
-- select * from dbo.IepGoalArea
-- select count(*) from AURORAX.Transform_PrgGoal -- 33685
-- select InstanceID, count(*) tot from dbo.PrgGoal group by InstanceID -- 10731

select * from AURORAX.Transform_PrgGoals -- 10721
select COUNT(*) from AURORAX.Map_IepRefID -- 10721
select distinct i.DestID
from AURORAX.Map_IepRefID i left join
	AURORAX.Goal g on i.IepRefID = g.IepRefID
where g.IepRefID is not null -- 6 ieps do not have goals
-- 10715 with goals


select distinct InstanceID
from AURORAX.Transform_PrgGoal -- 10715 -- this is good

select COUNT(*) from AURORAX.Transform_PrgGoal -- 33685 -- there should be this many IepGoal records

select * from IepGoalArea -- 39572
select * from AURORAX.Transform_IepGoalArea -- 27549



select ga.* 
from IepGoalArea ga left join-- 39572
	AURORAX.Transform_PrgGoals pgs on ga.InstanceID = pgs.DestID -- 39572
where pgs.DestID is null -- 17

select top 1 *
from AURORAX.Transform_PrgGoal -- destid = iepgoal.id, instanceid = prggoals.id		(the batch of goals for this iep)

select top 1 *
from AURORAX.Transform_IepGoalArea -- instanceid from prggoals.id		(one record per instance and distinct goal area)


select top 1 * 
from AURORAX.Transform_IepGoal -- destid = prggoal.id, goalareaid = iepgoalarea.id  



select pg.* 
from (select top 1 * from AURORAX.Transform_PrgGoal) pg -- 1 row for every goal
join AURORAX.Transform_IepGoalArea ga on pg.InstanceID = ga.InstanceID and pg.TypeID = ga.DestID 


select ga.*
from (select top 1 * from AURORAX.Transform_PrgGoals) pgs -- 1 row for every goal
join AURORAX.Transform_IepGoalArea ga on pgs.DestID = ga.InstanceID -- select * from AURORAX.Transform_IepGoalArea ga -- 36496 (should have at least 10k if all students have at least 1 goal)

-- iep goal area is not selecting distinct instance/defid







select GoalRefID
from AURORAX.Transform_PrgGoal  -- 33685






select distinct p.IepRefID, p.GoalAreaCode
from AURORAX.GoalAreaPivotView p -- 33648 distinct goal areas per iep (instance)

select * from AURORAX.MAP_IepGoalArea -- this is what we're trying to get to.  need the join tables

select * from AURORAX.MAP_PrgGoalID -- 33685


-- that goal has those defs
select p.GoalRefID, p.GoalAreaCode
from AURORAX.GoalAreaPivotView p -- 40785


-- that goal has those defs
select distinct p.GoalRefID, p.GoalAreaCode
from AURORAX.GoalAreaPivotView p -- 40785 

select p.GoalRefID, COUNT(*) tot
from AURORAX.GoalAreaPivotView p -- 40785 
group by p.GoalRefID -- 32704



select * 
from IepGoalArea -- 32625


-- select * from AURORAX.MAP_IepGoalArea

select count(*) from AURORAX.Goal -- 34737

-- select * from AURORAX.Transform_PrgGoals

declare @instanceid uniqueidentifier ; select @instanceid = 'AE197730-D508-4762-B06B-9A6FF525C68A'
select * from PrgGoals where ID = @instanceid
-- select * from PrgGoal where InstanceID = @instanceid order by Sequence
select * from AURORAX.Transform_PrgGoal where InstanceID = @instanceid order by Sequence
select d.Name, ga.* from aurorax.Transform_IepGoalArea ga join IepGoalAreaDef d on ga.DefID = d.ID where InstanceID = @instanceid order by DefID
-- show me a 
select p.* from AURORAX.Transform_PrgGoal g join AURORAX.GoalAreaPivotView p on g.GoalRefID = p.GoalRefID where g.InstanceID = @instanceid order by g.GoalRefID, p.GoalAreaCode


select * from AURORAX.GoalAreaPivotView



select InstanceID, COUNT(*) tot
from AURORAX.Transform_IepGoalArea
group by InstanceID
order by tot desc

select GoalRefID, COUNT(*) tot
from AURORAX.GoalAreaPivotView
group by GoalRefID
order by tot desc


select ga.InstanceID, COUNT(*) tot
from AURORAX.Transform_IepGoalArea ga
group by ga.InstanceID
order by tot desc

-- same instance, multi recs same def


select ga.InstanceID, ga.DefID, COUNT(*) tot 
from AURORAX.Transform_IepGoalArea ga -- not this table, dummmy, these are distinct
group by ga.InstanceID, ga.DefID
order by tot desc


select ga.IepRefID, ga.GoalAreaCode, COUNT(*) tot
from AURORAX.GoalAreaPivotView ga
group by ga.IepRefID, ga.GoalAreaCode
order by tot desc


select * 
from AURORAX.Transform_PrgGoals where IepRefId = '1994468F-96FB-46A3-B730-A9EE575F4BC8'



*/















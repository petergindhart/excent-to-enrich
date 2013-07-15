
--select * from vc3etl.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' order by Sequence
--select 'delete '+isnull(DestTable,'')+' where ID in (select DestID from '+isnull(maptable, SourceTable)+')' from vc3etl.LoadTable where ExtractDatabase = '35612529-9F3D-4971-A3DD-90E795E39080' order by Sequence desc

--declare @t table (ID uniqueidentifier)  ; insert @t

begin tran
delete x from PrgGoalProgress x where ID in (select ID from x_LEGACYGIFT.Transform_PrgGoalProgress_Objective)
delete PrgGoalProgress where ID in (select ID from x_LEGACYGIFT.Transform_PrgGoalProgress)
delete PrgGoal where ID in (select DestID from x_LEGACYGIFT.MAP_PrgGoalObjectiveID) 
	delete x_LEGACYGIFT.MAP_PrgGoalObjectiveID
delete x from IepGoalSubGoalAreaDef x where x.GoalID in (select GoalID from x_LEGACYGIFT.Transform_IepGoalSubGoalAreaDef) 
delete x from IepGoalSecondaryGoalAreaDef x where GoalID in (select GoalID from x_LEGACYGIFT.Transform_IepGoalSecondaryGoalAreaDef) 
delete IepGoal where ID in (select DestID from x_LEGACYGIFT.Transform_IepGoal)
delete PrgGoal where ID in (select DestID from x_LEGACYGIFT.MAP_PrgGoalID)
delete PrgCrossVersionGoal where ID in (select CrossVersionGoalID from x_LEGACYGIFT.MAP_PrgGoalID)
	delete x_LEGACYGIFT.MAP_PrgGoalID 
delete IepGoalArea where ID in (select DestID from x_LEGACYGIFT.MAP_IepGoalAreaID)
	delete x_LEGACYGIFT.MAP_IepGoalAreaID
	delete x_LEGACYGIFT.MAP_GoalAreaPivot -- this was created for query performance reasons
delete PrgGoals where ID in (select DestID from x_LEGACYGIFT.Transform_PrgGoals)

drop table x_LEGACYGIFT.MAP_IepGoalAreaID
drop table x_LEGACYGIFT.MAP_GoalAreaPivot

--drop table x_LEGACYGIFT.MAP_PrgGoalObjectiveID -- select * from x_LEGACYGIFT.MAP_PrgGoalObjectiveID
--drop table x_LEGACYGIFT.MAP_PrgGoalID -- select * from x_LEGACYGIFT.MAP_PrgGoalID 

rollback

-- commit

-- save a history of the records that we are changing
select g.*
into x_DATATEAM.GiftedGoal_LOCAL_GoalsNoArea
from x_LEGACYGIFT.GiftedGoal_LOCAL g
where isnull(g.GACommunication,'')+isnull(g.GAEmotional,'')+isnull(g.GAHealth,'')+isnull(g.GAIndependent,'')+isnull(g.GAMath,'')+isnull(g.GAOther,'')+isnull(g.GAReading,'')+isnull(g.GAWriting,'') not like '%Y%'
order by EpRefID, GoalRefID

-- add a goal area of OTHER for the 412 records that are missing a goal area
update g set GAOther = 'Y'
-- select g.*
from x_LEGACYGIFT.GiftedGoal_LOCAL g
where isnull(g.GACommunication,'')+isnull(g.GAEmotional,'')+isnull(g.GAHealth,'')+isnull(g.GAIndependent,'')+isnull(g.GAMath,'')+isnull(g.GAOther,'')+isnull(g.GAReading,'')+isnull(g.GAWriting,'') not like '%Y%'

select g.*
from x_LEGACYGIFT.GiftedGoal_LOCAL g
where isnull(g.GACommunication,'')+isnull(g.GAEmotional,'')+isnull(g.GAHealth,'')+isnull(g.GAIndependent,'')+isnull(g.GAMath,'')+isnull(g.GAOther,'')+isnull(g.GAReading,'')+isnull(g.GAWriting,'') like '%Y%'


update lt set enabled = 0 from VC3ETL.LoadTable lt where ExtractDatabase = '35612529-9F3D-4971-A3DD-90E795E39080' 
update lt set enabled = 1 from VC3ETL.LoadTable lt where ExtractDatabase = '35612529-9F3D-4971-A3DD-90E795E39080' and Sequence between 50 and 99

--select * from x_LEGACYGIFT.MAP_GoalAreaPivot


select Enabled, SourceTable, DestTable, Sequence seq, * 
from VC3ETL.LoadTable lt where ExtractDatabase = '35612529-9F3D-4971-A3DD-90E795E39080' and Sequence > 49 -- and Sequence between 50 and 55 -- 
order by Sequence





vc3etl.loadtable_run '46A3FF82-52D9-45A0-976F-1D458FC38608', '', 1, 0


begin tran
UPDATE PrgGoal SET CrossVersionGoalID=s.CrossVersionGoalID, TargetDate=s.TargetDate, InstanceID=s.InstanceID, NumericTarget=s.NumericTarget, GoalStatement=s.GoalStatement, IsProbeGoal=s.IsProbeGoal, BaselineScoreID=s.BaselineScoreID, ProbeTypeID=s.ProbeTypeID, Sequence=s.Sequence, ProbeScheduleID=s.ProbeScheduleID, IndDefID=s.IndDefID, TypeID=s.TypeID, RatioOutOfTarget=s.RatioOutOfTarget, RatioPartTarget=s.RatioPartTarget, StartDate=s.StartDate, RubricTargetID=s.RubricTargetID, IndTarget=s.IndTarget
-- select s.*
FROM  PrgGoal d JOIN 
	x_LEGACYGIFT.Transform_PrgGoal  s ON s.DestID=d.ID
where d.Sequence <> s.Sequence



UPDATE STATISTICS PrgGoal


INSERT PrgGoal (ID, CrossVersionGoalID, TargetDate, InstanceID, NumericTarget, GoalStatement, IsProbeGoal, BaselineScoreID, ProbeTypeID, Sequence, ProbeScheduleID, IndDefID, TypeID, RatioOutOfTarget, RatioPartTarget, StartDate, RubricTargetID, IndTarget)
SELECT s.DestID, s.CrossVersionGoalID, s.TargetDate, s.InstanceID, s.NumericTarget, s.GoalStatement, s.IsProbeGoal, s.BaselineScoreID, s.ProbeTypeID, s.Sequence, s.ProbeScheduleID, s.IndDefID, s.TypeID, s.RatioOutOfTarget, s.RatioPartTarget, s.StartDate, s.RubricTargetID, s.IndTarget
FROM x_LEGACYGIFT.Transform_PrgGoal s
WHERE NOT EXISTS (SELECT * FROM PrgGoal d WHERE s.DestID=d.ID)

UPDATE STATISTICS PrgGoal



rollback

commit


select * from x_LEGACYGIFT.Transform_PrgGoal -- 9038
select * from x_LEGACYGIFT.GiftedGoal -- 9127

-- Transform_PrgGoal
select ga.*
 FROM
  x_LEGACYGIFT.GiftedStudent stu join 
  x_LEGACYGIFT.GiftedGoal g on stu.EPRefID = g.EPRefID JOIN
  x_LEGACYGIFT.GoalAreaExists e on g.GoalRefID = e.GoalRefID left join
  x_LEGACYGIFT.Transform_IepGoalArea_goals ga on g.GoalRefID = ga.GoalRefID left join ----------------- May be able to use MAP table for speed
	(
	select g.EPRefID, ga.DefID, gad.GoalAreaCode 
	from x_LEGACYGIFT.GiftedGoal g join
	x_LEGACYGIFT.Transform_IepGoalArea_goals ga on g.GoalRefID = ga.GoalRefID join ----------------- May be able to use MAP table for speed
	LEGACYSPED.MAP_IepGoalAreaDefID gad on ga.DefID = gad.DestID
	group by g.EPRefID, ga.DefID, gad.GoalAreaCode
	) ga1 on g.EPRefID = ga1.EPRefID and ga.DefID = ga1.DefID LEFT JOIN 
  x_LEGACYGIFT.MAP_PrgGoalID m on g.GoalRefID = m.GoalRefID LEFT JOIN 
  x_LEGACYGIFT.Transform_PrgGoals i on g.EPRefID = i.EPRefID LEFT JOIN -- getting a null instance id for students that have been deleted, but goal records are imported.  bad data, but handle it here anyway.
  dbo.PrgGoal pg on m.DestID = pg.ID 
 WHERE
  i.DestID is not null 
GO



--- Transform_IepGoalArea_goals
select 
	g.EPRefID, 
	g.GoalRefID, 
	p.GoalAreaCode, 
	mga.DestID,
	GoalID = mg.DestID,
	DefID = md.DestID, -- GoalAreaDefID
	InstanceID = gs.DestID, 
	FormInstanceID = cast(NULL as uniqueidentifier),
	EsyID = case when g.IsEsy = 'Y' then 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' else 'F7E20A86-2709-4170-9810-15B601C61B79' end
--- select * 
from x_LEGACYGIFT.Transform_PrgGoals gs join -- 4492
x_LEGACYGIFT.GiftedGoal g on g.EpRefID = gs.EpRefId join -- 9038?
x_LEGACYGIFT.MAP_GoalAreaPivot p on g.GoalRefID = p.GoalRefID join -- in the where clause we will limit this to the primary goal area.  Another transform will insert subgoals, and yet another will insert secondary goals
LEGACYSPED.MAP_IepGoalAreaDefID md on p.GoalAreaCode = md.GoalAreaCode left join
x_LEGACYGIFT.MAP_PrgGoalID mg on g.GoalRefID = mg.GoalRefID left join
--x_LEGACYGIFT.Transform_PrgGoals gs on g.EpRefID = gs.EpRefId left join
x_LEGACYGIFT.MAP_IepGoalAreaID mga on g.EPRefID = mga.EPRefID and md.DestID = mga.DefID left join 
IepGoalArea ga on mga.DestID = ga.ID
where p.GoalAreaDefIndex = (
	select min(pmin.GoalAreaDefIndex)
	from x_LEGACYGIFT.MAP_GoalAreaPivot pmin 
	where p.GoalRefID = pmin.GoalRefID)
go


select * from x_LEGACYGIFT.GiftedGoal where EpRefID not in (select EpRefID from x_LEGACYGIFT.Transform_PrgGoals)


select * from x_LEGACYGIFT.MAP_PrgGoalID -- 9038




select * from x_LEGACYGIFT.MAP_PrgGoalID -- 9038





select * from LEGACYSPED.MAP_IepGoalAreaDefID 



-- x_LEGACYGIFT.MAP_GoalAreaPivot is populated from GoalAreaPivotView
select * from x_LEGACYGIFT.MAP_GoalAreaPivot -- 9203

select * from x_LEGACYGIFT.GoalAreaPivotView -- 9203

select * from x_LEGACYGIFT.MAP_IepGoalAreaID


select * from x_LEGACYGIFT.GiftedGoal where GoalRefID not in (select goalrefid from x_LEGACYGIFT.MAP_GoalAreaPivot ) -- 0 


select * from x_LEGACYGIFT.Transform_IepGoalArea_goals

select * from x_LEGACYGIFT.Transform_PrgGoals -- 4492


select EPRefID from x_LEGACYGIFT.GiftedStudent -- 4543 ------------------------------- will this be the same after an import of new data????????????????



select * from x_LEGACYGIFT.GiftedStudent where EPRefID not in (select EPRefID from x_LEGACYGIFT.Transform_PrgGoals ) -- 51 students without a prggoals record



select gs.* 
from x_LEGACYGIFT.GiftedStudent gs left join
x_LEGACYGIFT.Transform_Student s on gs.StudentRefID = s.StudentRefID
where s.DestID is null


select * from x_LEGACYGIFT.Transform_PrgItem -- 4492




--x_LEGACYGIFT.Transform_IepGoalArea
--as
select gap.EpRefID, gap.GoalAreaCode, DestID = isnull(ga.ID, mga.DestID), DefID = gad.DestID, InstanceID = gs.DestID, FormInstanceID = cast(NULL as uniqueidentifier)
from x_LEGACYGIFT.GoalAreaPivotView gap
join x_LEGACYGIFT.PrimaryGoalAreaPerGoal pg on gap.GoalRefID = pg.GoalRefID and gap.GoalAreaDefIndex = pg.PrimaryGoalAreaDefIndex
join LEGACYSPED.MAP_IepGoalAreaDefID gad on gap.GoalAreaCode = gad.GoalAreaCode
join x_LEGACYGIFT.Transform_PrgGoals gs on gap.EpRefID = gs.EpRefId
left join x_LEGACYGIFT.MAP_IepGoalAreaID mga on gap.EpRefID = mga.EpRefID and gad.DestID = mga.DefID
left join dbo.IepGoalArea ga on mga.DestID = ga.ID
group by gap.EpRefID, gap.GoalAreaCode, gad.DestID, gs.DestID, isnull(ga.ID, mga.DestID)




select * FROM x_LEGACYGIFT.Transform_IepGoalArea



--(0 row(s) affected)

--(0 row(s) affected)

--(17317 row(s) affected)

--(17317 row(s) affected)

--(8986 row(s) affected)

--(70 row(s) affected)

--(8629 row(s) affected)

--(8629 row(s) affected)

--(8629 row(s) affected)

--(8629 row(s) affected)

--(8629 row(s) affected)

--(8629 row(s) affected)

--(8791 row(s) affected)

--(4492 row(s) affected)


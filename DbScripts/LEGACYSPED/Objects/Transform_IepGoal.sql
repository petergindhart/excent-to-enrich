----#include Transform_PrgGoal.sql
----#include Transform_IepGoalArea.sql
----#include Transform_IepGoalPostSchoolArea.sql

--/*

--	This expensive query was taking over 12 minutes to run, so the logic was moved to stored procedure IepGoal_InsertAllRecordsFromLegacySped for the time being.
	

--*/

--IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoal') AND OBJECTPROPERTY(id, N'IsView') = 1)
--DROP VIEW LEGACYSPED.Transform_IepGoal
--GO

--create view LEGACYSPED.Transform_IepGoal
--as
--select 
--	DestID = pg.DestID,
--	GoalAreaID = ga.DestID,
--	PostSchoolAreaDefID = psa.PostSchoolAreaDefID,
--	pg.EsyID
--FROM 
--	LEGACYSPED.Transform_PrgGoal pg JOIN
--	LEGACYSPED.GoalAreasPerGoalView pgga ON pg.GoalRefID = pgga.GoalRefID JOIN
--	LEGACYSPED.Transform_IepGoalArea ga on pg.InstanceID = ga.InstanceID AND pgga.GoalAreaCode = ga.GoalAreaCode LEFT JOIN 
--	LEGACYSPED.Transform_IepGoalPostSchoolAreaDef psa on pg.GoalRefID = psa.GoalRefID and psa.Sequence = 0 LEFT JOIN 
--	dbo.IepGoalArea tgt on ga.InstanceID = tgt.InstanceID and psa.PostSchoolAreaDefID = tgt.DefID 
--go


--/*


--LEGACYSPED.IepGoal_InsertAllRecordsFromLegacySped

--update vc3etl.loadtable set enabled = 0, sequence = 777 where id = '7629F1BE-F9D4-4D99-9302-3009027FD50E'
--insert vc3etl.loadtable values (newid(), '29D14961-928D-4BEE-9025-238496D144C6', 30, 'LEGACYSPED.IepGoal_InsertAllRecordsFromLegacySped', NULL, 0, NULL, NULL, NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, 0, NULL, NULL)

--select * from vc3etl.loadtable where ID = '86A1D977-790C-4852-B574-1D305B814A17'


--GEO.ShowLoadTables

--update vc3etl.loadtable set enabled = 0 where ID = 'DCAA0626-5046-4B9C-93D9-F448F77DE1BD'


--select c.name, t.name+
--	case when t.name like '%char%' then '('+convert(varchar, c.prec)+')' else '' end+
--	case when c.isnullable = 0 then '	NOT NULL,' else ',' end
--from sysobjects o
--left join syscolumns c on o.id = c.id 
--left join systypes t on c.xusertype = t.xusertype
--where o.name = 'Transform_IepGoal' -- and c.name = 'sourcetbl'
--order by c.colorder


--select * from IepGoal




--Declare @Transform_PrgGoal table (
--IepRefID	varchar(150),
--GoalRefID	varchar(150) NOT NULL,
--DestID	uniqueidentifier,
--TypeID	uniqueidentifier,
--InstanceID	uniqueidentifier,
--Sequence	int,
--IsProbeGoal	bit,
--TargetDate	datetime,
--GoalStatement	text,
--ProbeTypeID	uniqueidentifier,
--NumericTarget	float,
--RubricTargetID	uniqueidentifier,
--RatioPartTarget	float,
--RatioOutOfTarget	float,
--BaselineScoreID	uniqueidentifier,
--IndDefID	uniqueidentifier,
--IndTarget	float,
--ProbeScheduleID	uniqueidentifier,
--ParentID	uniqueidentifier,
--FormInstanceID	uniqueidentifier,
--EsyID	varchar(36) NOT NULL
--)

--insert @Transform_PrgGoal
--select * from LEGACYSPED.Transform_PrgGoal


--declare @GoalAreasPerGoalView table (
--IepRefID	varchar(150),
--InstanceID	uniqueidentifier NOT NULL,
--DefID	uniqueidentifier NOT NULL,
--GoalAreaCode	varchar(15) NOT NULL,
--GoalRefID	varchar(150) NOT NULL,
--GoalIndex	int
--)

--insert @GoalAreasPerGoalView
--select * from LEGACYSPED.GoalAreasPerGoalView


--declare @Transform_IepGoalArea table (
--IepRefID	varchar(150),
--GoalAreaCode	varchar(15) NOT NULL,
--DestID	uniqueidentifier,
--InstanceID	uniqueidentifier NOT NULL,
--DefID	uniqueidentifier NOT NULL,
--FormInstanceID	uniqueidentifier
--)

--insert @Transform_IepGoalArea 
--select * from LEGACYSPED.Transform_IepGoalArea 

--declare @Transform_IepGoalPostSchoolAreaDef table (
--IEPRefID	varchar(150),
--GoalRefID	varchar(150),
--PostSchoolAreaCode	varchar(13) NOT NULL,
--GoalID	uniqueidentifier,
--PostSchoolAreaDefID	uniqueidentifier NOT NULL,
--Sequence	int
--)

--insert @Transform_IepGoalPostSchoolAreaDef
--select * from LEGACYSPED.Transform_IepGoalPostSchoolAreaDef


--declare @Transform_IepGoal table (
--DestID	uniqueidentifier,
--GoalAreaID	uniqueidentifier,
--PostSchoolAreaDefID	uniqueidentifier,
--EsyID	varchar(36) NOT NULL
--)

--insert @Transform_IepGoal 
--select 
--  DestID = pg.DestID,
--  GoalAreaID = ga.DestID,
--   PostSchoolAreaDefID = psa.PostSchoolAreaDefID,
--   pg.EsyID 
--FROM 
--	@Transform_PrgGoal pg JOIN
--	@GoalAreasPerGoalView pgga ON pg.GoalRefID = pgga.GoalRefID JOIN
--	@Transform_IepGoalArea ga on pg.InstanceID = ga.InstanceID AND pgga.GoalAreaCode = ga.GoalAreaCode LEFT JOIN 
--	@Transform_IepGoalPostSchoolAreaDef psa on pg.GoalRefID = psa.GoalRefID and psa.Sequence = 0 LEFT JOIN 
--	dbo.IepGoalArea tgt on ga.InstanceID = tgt.InstanceID and psa.PostSchoolAreaDefID = tgt.DefID 

---- INSERT IepGoal (ID, PostSchoolAreaDefID, EsyID, GoalAreaID)
--SELECT s.DestID, s.PostSchoolAreaDefID, s.EsyID, s.GoalAreaID
--FROM @Transform_IepGoal s
--WHERE NOT EXISTS (SELECT * FROM IepGoal d WHERE s.DestID=d.ID)

--and 




--select *
--from
--	PrgItemDef d join
--	PrgItem i on i.DefID = d.ID join
--	PrgVersion v on v.ItemID = i.ID JOIN
--	PrgSection s on s.VersionID = v.ID join
--	PrgGoal pg on pg.InstanceID = s.ID left join
--	IepGoal ig on ig.ID = pg.ID
--where 
--	pg.TypeID = 'AB74929E-B03F-4A51-82CA-659CA90E291A'
--	--pg.ID = 'd918e3a6-d84d-43bb-8811-7cc5fad28eb0'
--	and ig.ID IS NULL




--select * from PrgGoal
--where ID = 'd918e3a6-d84d-43bb-8811-7cc5fad28eb0'


--select * from IepGoal
--where ID = 'd918e3a6-d84d-43bb-8811-7cc5fad28eb0'






--INSERT IepGoal (ID, PostSchoolAreaDefID, EsyID, GoalAreaID)
--SELECT s.DestID, s.PostSchoolAreaDefID, s.EsyID, s.GoalAreaID
--FROM LEGACYSPED.Transform_IepGoal s
--WHERE NOT EXISTS (SELECT * FROM IepGoal d WHERE s.DestID=d.ID)







































--select top 1 * from LEGACYSPED.Transform_PrgGoal







--select count(*) tot from LEGACYSPED.GoalAreasPerGoalView
--33688 -- 3 sec

--select count(*) from LEGACYSPED.Transform_IepGoalArea
--29898 -- 3 seconds

--select count(*) from LEGACYSPED.Goal
--34737


--GEO.ShowLoadTables IepGoal


--set nocount on;
--declare @n varchar(100) ; select @n = 'IepGoal'
--declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
--update t set Enabled = 1
--	, HasMapTable = 0
--	, MapTable = NULL
--	, KeyField = NULL
--	, DeleteKey = NULL
--	, DeleteTrans = 0
--	, UpdateTrans = 1
--	, DestTableFilter = NULL
--from VC3ETL.LoadTable t where t.ID = @t
--exec VC3ETL.LoadTable_Run @t, '', 1, 0
--print '

--select * from '+@n





--select d.*
---- UPDATE IepGoal SET PostSchoolAreaDefID=s.PostSchoolAreaDefID, EsyID=s.EsyID, GoalAreaID=s.GoalAreaID
--FROM  IepGoal d JOIN 
--	LEGACYSPED.Transform_IepGoal  s ON s.DestID=d.ID


---- INSERT IepGoal (ID, PostSchoolAreaDefID, EsyID, GoalAreaID)
--SELECT s.DestID, s.PostSchoolAreaDefID, s.EsyID, s.GoalAreaID
--FROM LEGACYSPED.Transform_IepGoal s
--WHERE NOT EXISTS (SELECT * FROM IepGoal d WHERE s.DestID=d.ID)


--	Msg 2627, Level 14, State 1, Line 1
--	Violation of PRIMARY KEY constraint 'PK_IepGoal'. Cannot insert duplicate key in object 'dbo.IepGoal'.
--	The statement has been terminated.





--select * from IepGoal





--select g.goalrefid, 
--	GoalAreaID = ga.ID,
--	-- psa.PostSchoolAreaDefID,
--	--pg.EsyId
--	0 as bogus
--from LEGACYSPED.Goal g join -- 34737
--	LEGACYSPED.MAP_PrgGoalID pg on g.GoalRefID = pg.GoalRefID join -- 33685
--	LEGACYSPED.GoalAreasPerGoalView gapg on g.GoalRefID = gapg.GoalRefID and
--		 gapg.GoalIndex = 
--		(select MIN(gaIn.GoalIndex) -- Enrich does not currently support multiple domains per Goal
--		from LEGACYSPED.GoalAreaPivotView gaIn
--		where gaIn.GoalRefID = g.GoalRefID) join  -- 39555
--		-- 32679
--	dbo.IepGoalArea ga on gapg.InstanceID = ga.instanceID and gapg.DefID = ga.DefID 
--	left join
--	LEGACYSPED.Transform_IepGoalPostSchoolAreaDef psa on g.GoalRefID = psa.GoalRefID and psa.Sequence = 0


---- select * from LEGACYSPED.MAP_PrgGoalID

----go

---- select * from IepGoal
---- select * from LEGACYSPED.Transform_IepGoalPostSchoolArea psa 
---- select * from LEGACYSPED.Transform_PrgGoal
---- select * from LEGACYSPED.Transform_IepGoalArea
---- select * from dbo.IepGoalArea
---- select count(*) from LEGACYSPED.Transform_PrgGoal -- 33685
---- select InstanceID, count(*) tot from dbo.PrgGoal group by InstanceID -- 10731

--select * from LEGACYSPED.Transform_PrgGoals -- 10721
--select COUNT(*) from LEGACYSPED.Map_IepRefID -- 10721
--select distinct i.DestID
--from LEGACYSPED.Map_IepRefID i left join
--	LEGACYSPED.Goal g on i.IepRefID = g.IepRefID
--where g.IepRefID is not null -- 6 ieps do not have goals
---- 10715 with goals


--select distinct InstanceID
--from LEGACYSPED.Transform_PrgGoal -- 10715 -- this is good

--select COUNT(*) from LEGACYSPED.Transform_PrgGoal -- 33685 -- there should be this many IepGoal records

--select * from IepGoalArea -- 39572
--select * from LEGACYSPED.Transform_IepGoalArea -- 27549



--select ga.* 
--from IepGoalArea ga left join-- 39572
--	LEGACYSPED.Transform_PrgGoals pgs on ga.InstanceID = pgs.DestID -- 39572
--where pgs.DestID is null -- 17

--select top 1 *
--from LEGACYSPED.Transform_PrgGoal -- destid = iepgoal.id, instanceid = prggoals.id		(the batch of goals for this iep)

--select top 1 *
--from LEGACYSPED.Transform_IepGoalArea -- instanceid from prggoals.id		(one record per instance and distinct goal area)


--select top 1 * 
--from LEGACYSPED.Transform_IepGoal -- destid = prggoal.id, goalareaid = iepgoalarea.id  



--select pg.* 
--from (select top 1 * from LEGACYSPED.Transform_PrgGoal) pg -- 1 row for every goal
--join LEGACYSPED.Transform_IepGoalArea ga on pg.InstanceID = ga.InstanceID and pg.TypeID = ga.DestID 


--select ga.*
--from (select top 1 * from LEGACYSPED.Transform_PrgGoals) pgs -- 1 row for every goal
--join LEGACYSPED.Transform_IepGoalArea ga on pgs.DestID = ga.InstanceID -- select * from LEGACYSPED.Transform_IepGoalArea ga -- 36496 (should have at least 10k if all students have at least 1 goal)

---- iep goal area is not selecting distinct instance/defid







--select GoalRefID
--from LEGACYSPED.Transform_PrgGoal  -- 33685






--select distinct p.IepRefID, p.GoalAreaCode
--from LEGACYSPED.GoalAreaPivotView p -- 33648 distinct goal areas per iep (instance)

--select * from LEGACYSPED.MAP_IepGoalArea -- this is what we're trying to get to.  need the join tables

--select * from LEGACYSPED.MAP_PrgGoalID -- 33685


---- that goal has those defs
--select p.GoalRefID, p.GoalAreaCode
--from LEGACYSPED.GoalAreaPivotView p -- 40785


---- that goal has those defs
--select distinct p.GoalRefID, p.GoalAreaCode
--from LEGACYSPED.GoalAreaPivotView p -- 40785 

--select p.GoalRefID, COUNT(*) tot
--from LEGACYSPED.GoalAreaPivotView p -- 40785 
--group by p.GoalRefID -- 32704



--select * 
--from IepGoalArea -- 32625


---- select * from LEGACYSPED.MAP_IepGoalArea

--select count(*) from LEGACYSPED.Goal -- 34737

---- select * from LEGACYSPED.Transform_PrgGoals

--declare @instanceid uniqueidentifier ; select @instanceid = 'AE197730-D508-4762-B06B-9A6FF525C68A'
--select * from PrgGoals where ID = @instanceid
---- select * from PrgGoal where InstanceID = @instanceid order by Sequence
--select * from LEGACYSPED.Transform_PrgGoal where InstanceID = @instanceid order by Sequence
--select d.Name, ga.* from LEGACYSPED.Transform_IepGoalArea ga join IepGoalAreaDef d on ga.DefID = d.ID where InstanceID = @instanceid order by DefID
---- show me a 
--select p.* from LEGACYSPED.Transform_PrgGoal g join LEGACYSPED.GoalAreaPivotView p on g.GoalRefID = p.GoalRefID where g.InstanceID = @instanceid order by g.GoalRefID, p.GoalAreaCode


--select * from LEGACYSPED.GoalAreaPivotView



--select InstanceID, COUNT(*) tot
--from LEGACYSPED.Transform_IepGoalArea
--group by InstanceID
--order by tot desc

--select GoalRefID, COUNT(*) tot
--from LEGACYSPED.GoalAreaPivotView
--group by GoalRefID
--order by tot desc


--select ga.InstanceID, COUNT(*) tot
--from LEGACYSPED.Transform_IepGoalArea ga
--group by ga.InstanceID
--order by tot desc

---- same instance, multi recs same def


--select ga.InstanceID, ga.DefID, COUNT(*) tot 
--from LEGACYSPED.Transform_IepGoalArea ga -- not this table, dummmy, these are distinct
--group by ga.InstanceID, ga.DefID
--order by tot desc


--select ga.IepRefID, ga.GoalAreaCode, COUNT(*) tot
--from LEGACYSPED.GoalAreaPivotView ga
--group by ga.IepRefID, ga.GoalAreaCode
--order by tot desc


--select * 
--from LEGACYSPED.Transform_PrgGoals where IepRefId = '1994468F-96FB-46A3-B730-A9EE575F4BC8'



--*/















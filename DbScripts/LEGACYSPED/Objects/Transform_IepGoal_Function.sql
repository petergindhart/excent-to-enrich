--if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name  = 'Transform_IepGoal_Function')
--drop FUNCTION LEGACYSPED.Transform_IepGoal_Function
--go

---- table valued function for IepGoal

--create FUNCTION LEGACYSPED.Transform_IepGoal_Function ()  
--RETURNS @Transform_IepGoal table(
--GoalRefID varchar(150),
--DestID	uniqueidentifier,
--GoalAreaID	uniqueidentifier,
--PostSchoolAreaDefID	uniqueidentifier,
--EsyID	varchar(36) NOT NULL,
--	primary key (DestID)
--) AS  
--BEGIN 

---- test
--declare @Transform_IepGoal table(
--GoalRefID varchar(150),
--DestID	uniqueidentifier,
--GoalAreaID	uniqueidentifier,
--PostSchoolAreaDefID	uniqueidentifier,
--EsyID	varchar(36) NOT NULL,
--	primary key (DestID)
--) 

------ test



---- #1
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
--StartDate datetime,
--EsyID	varchar(36) NOT NULL,
--DoNotTouch int not null,
--CrossVersionGoalID uniqueidentifier,
--	primary key (IepRefID, GoalRefID)
--)

---- #2
--declare @GoalAreasPerGoalView table (
--GoalRefID	varchar(150) not null,
--IepRefID	varchar(150) not null,
--InstanceID	uniqueidentifier NOT NULL,
--DefID	uniqueidentifier NOT NULL,
--GoalAreaCode	varchar(150) NOT NULL,
--GoalIndex	int,
--	primary key (IepRefID, GoalRefID, GoalAreaCode)
--)

---- #3
--declare @Transform_PrgGoalArea table (
--IepRefID	varchar(150),
--GoalRefID	varchar(150),
--GoalAreaCode	varchar(150) NOT NULL,
--GoalAreaDefID uniqueidentifier not null,
--DestID	uniqueidentifier,
--InstanceID	uniqueidentifier NOT NULL,
--DefID	uniqueidentifier NOT NULL,
--FormInstanceID	uniqueidentifier,
--	primary key (GoalRefID, GoalAreaCode) -- how to accommodate multiple areas per goal?
--)

---- #4
--declare @Transform_IepGoalPostSchoolAreaDef table (
--IEPRefID	varchar(150),
--GoalRefID	varchar(150),
--PostSchoolAreaCode	varchar(13) NOT NULL,
--GoalID	uniqueidentifier,
--PostSchoolAreaDefID	uniqueidentifier NOT NULL,
--Sequence	int,
--	primary key (IepRefID, GoalRefID, PostSchoolAreaCode)
--)

---- #5
----declare @Transform_IepGoal table (
----DestID	uniqueidentifier,
----GoalAreaID	uniqueidentifier,
----PostSchoolAreaDefID	uniqueidentifier,
----EsyID	varchar(36) NOT NULL,
----	primary key (DestID)
----)

---- insert table variables
---- #1
----print 'insert @Transform_PrgGoal '+convert(varchar(50), getdate(), 108)
--insert @Transform_PrgGoal
--select * from LEGACYSPED.Transform_PrgGoal
----print '		complete	'+convert(varchar(50), getdate(), 108)

---- #2
----print 'insert @GoalAreasPerGoalView '+convert(varchar(50), getdate(), 108)
--insert @GoalAreasPerGoalView
--select * from LEGACYSPED.GoalAreasPerGoalView
----print '		complete	'+convert(varchar(50), getdate(), 108)

---- #3
----print 'insert @Transform_PrgGoalArea '+convert(varchar(50), getdate(), 108)
--insert @Transform_PrgGoalArea 
--select * from LEGACYSPED.Transform_PrgGoalArea 
----print '		complete	'+convert(varchar(50), getdate(), 108)

---- #4
----print 'insert @Transform_IepGoalPostSchoolAreaDef '+convert(varchar(50), getdate(), 108)
--insert @Transform_IepGoalPostSchoolAreaDef
--select * from LEGACYSPED.Transform_IepGoalPostSchoolAreaDef
----print '		complete	'+convert(varchar(50), getdate(), 108)


--select * from @Transform_PrgGoal
--select * from @GoalAreasPerGoalView
--select * from @Transform_PrgGoalArea
--select * from @Transform_IepGoalPostSchoolAreaDef
--select * from PrgGoalAreaDef order by Sequence


---- #5
----print 'insert @Transform_IepGoal '+convert(varchar(50), getdate(), 108)
--insert @Transform_IepGoal 
--select 
--  pg.GoalRefID,
--  DestID = pg.DestID,
--  GoalAreaID = ga.DestID,
--  PostSchoolAreaDefID = psa.PostSchoolAreaDefID,
--  pg.EsyID 
--FROM 
--	@Transform_PrgGoal pg JOIN
--	@GoalAreasPerGoalView pgga ON pg.GoalRefID = pgga.GoalRefID JOIN
--	@Transform_PrgGoalArea ga on pg.InstanceID = ga.InstanceID AND pgga.GoalAreaCode = ga.GoalAreaCode and pgga.GoalRefID = ga.GoalRefID LEFT JOIN 
--	@Transform_IepGoalPostSchoolAreaDef psa on pg.GoalRefID = psa.GoalRefID and psa.Sequence = 0 LEFT JOIN 
--	dbo.PrgGoalArea tgt on ga.InstanceID = tgt.InstanceID and psa.PostSchoolAreaDefID = tgt.DefID 
----print '		complete	'+convert(varchar(50), getdate(), 108)

----Msg 2627, Level 14, State 1, Line 116
----Violation of PRIMARY KEY constraint 'PK__#606C28F__EF9784F162547169'. Cannot insert duplicate key in object 'dbo.@Transform_IepGoal'. The duplicate key value is (5c0c010c-cf22-4225-9ed2-e27aad5e6073).
----The statement has been terminated.


--return 
--END


--if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'IepGoal_InsertAllRecordsFromLegacySped')
--drop proc LEGACYSPED.IepGoal_InsertAllRecordsFromLegacySped
--go


--create PROC LEGACYSPED.IepGoal_InsertAllRecordsFromLegacySped
--as

--/*
--	For expediency we are using this stored procedure to insert IepGoal in view of the expensive query plan selecting straight from the views.
--	gg.
--*/

--set nocount on;
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
--IepRefID	varchar(150),
--InstanceID	uniqueidentifier NOT NULL,
--DefID	uniqueidentifier NOT NULL,
--GoalAreaCode	varchar(150) NOT NULL,
--GoalRefID	varchar(150) NOT NULL,
--GoalIndex	int,
--	primary key (IepRefID, GoalRefID, GoalAreaCode)
--)

---- #3
--declare @Transform_IepGoalArea table (
--IepRefID	varchar(150),
--GoalAreaCode	varchar(150) NOT NULL,
--DestID	uniqueidentifier,
--InstanceID	uniqueidentifier NOT NULL,
--DefID	uniqueidentifier NOT NULL,
--FormInstanceID	uniqueidentifier,
--	primary key (IepRefID, GoalAreaCode)
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
--declare @Transform_IepGoal table (
--DestID	uniqueidentifier,
--GoalAreaID	uniqueidentifier,
--PostSchoolAreaDefID	uniqueidentifier,
--EsyID	varchar(36) NOT NULL,
--	primary key (DestID)
--)

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
----print 'insert @Transform_IepGoalArea '+convert(varchar(50), getdate(), 108)
--insert @Transform_IepGoalArea 
--select * from LEGACYSPED.Transform_IepGoalArea 
----print '		complete	'+convert(varchar(50), getdate(), 108)

---- #4
----print 'insert @Transform_IepGoalPostSchoolAreaDef '+convert(varchar(50), getdate(), 108)
--insert @Transform_IepGoalPostSchoolAreaDef
--select * from LEGACYSPED.Transform_IepGoalPostSchoolAreaDef
----print '		complete	'+convert(varchar(50), getdate(), 108)

---- #5
----print 'insert @Transform_IepGoal '+convert(varchar(50), getdate(), 108)
--insert @Transform_IepGoal 
--select 
--  DestID = pg.DestID,
--  GoalAreaID = ga.DestID,
--  PostSchoolAreaDefID = psa.PostSchoolAreaDefID,
--  pg.EsyID 
--FROM 
--	@Transform_PrgGoal pg JOIN
--	@GoalAreasPerGoalView pgga ON pg.GoalRefID = pgga.GoalRefID JOIN
--	@Transform_IepGoalArea ga on pg.InstanceID = ga.InstanceID AND pgga.GoalAreaCode = ga.GoalAreaCode LEFT JOIN 
--	@Transform_IepGoalPostSchoolAreaDef psa on pg.GoalRefID = psa.GoalRefID and psa.Sequence = 0 LEFT JOIN 
--	dbo.IepGoalArea tgt on ga.InstanceID = tgt.InstanceID and psa.PostSchoolAreaDefID = tgt.DefID 
----print '		complete	'+convert(varchar(50), getdate(), 108)

--set nocount off;
---- hard code the logic for this insert
----print 'insert IepGoal '+convert(varchar(50), getdate(), 108)
--INSERT IepGoal (ID, PostSchoolAreaDefID, EsyID, GoalAreaID)
--SELECT s.DestID, s.PostSchoolAreaDefID, s.EsyID, s.GoalAreaID
--FROM @Transform_IepGoal s
--WHERE NOT EXISTS (SELECT * FROM IepGoal d WHERE s.DestID=d.ID)
----print '		complete	'+convert(varchar(50), getdate(), 108)

--go


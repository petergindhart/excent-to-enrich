
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Setup_ScheduleFinalizerTask' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.Setup_ScheduleFinalizerTask
GO

/*
<summary>
Called by the TestView installer to schedule to schedule
a task to finalize the installation.
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Void" 
        />
*/
CREATE PROCEDURE dbo.Setup_ScheduleFinalizerTask
	@parameters text
AS

-- Add a pending "finalize installation" task that will be picked up by the service
insert into VC3TaskScheduler.ScheduledTask (ID, TaskTypeID, Parameters, StatusID)
values (
	newid(), 
	'4955FEBD-B332-4191-9D8B-0B33469C31EA', 
	@parameters, 
	'P'
)

GO

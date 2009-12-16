-- cancel any pending or 'running' tasks
update VC3TaskScheduler.ScheduledTask set StatusID = 'C' where StatusID in ('P', 'R')
-- ensure no scheduled tasks will initiate
update VC3TaskScheduler.ScheduledTaskSchedule set LastRunTime = DATEADD(YEAR, 1, GETDATE()) where IsEnabled = 1
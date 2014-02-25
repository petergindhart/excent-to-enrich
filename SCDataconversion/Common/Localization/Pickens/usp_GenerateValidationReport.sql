IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'usp_GenerateValidationReport')
DROP PROC x_DATAVALIDATION.usp_GenerateValidationReport
GO

CREATE PROC x_DATAVALIDATION.usp_GenerateValidationReport
AS
DECLARE @jobID uniqueidentifier, @cmd varchar(1000) ,@startdate int, @starttime int,@job_name varchar(50)

SET @startdate = CONVERT(INT,REPLACE(CONVERT(VARCHAR(10),GETDATE(),102),'.',''));
SET @starttime = CONVERT(INT,REPLACE(CONVERT(VARCHAR(8),DATEADD(mi,2,GETDATE()),108),':',''));
--print @starttime
--print @startdate
SET @cmd = 'E:\GIT\excent-to-enrich\SCDataconversion\ValidationScripts\Localization\Pickens\validationreport.bat'


IF EXISTS (SELECT name FROM msdb.dbo.sysjobs WHERE name = '_runValidationReport')
BEGIN
     EXEC msdb.dbo.sp_delete_job @job_name = '_runValidationReport'
END


EXEC msdb.dbo.sp_add_job @job_name = '_runValidationReport', @enabled  = 1, @start_step_id = 1, @owner_login_name='sa', @job_id = @jobID OUTPUT 

EXEC msdb.dbo.sp_add_jobstep @job_id = @jobID, @step_name = 'Run validation step', @step_id = 1, @subsystem = 'CMDEXEC', @command = @cmd

EXEC msdb.dbo.sp_add_jobserver @job_id = @jobID
SET @job_name = '_runValidationReport'

EXEC msdb.dbo.sp_add_jobschedule @job_name = @job_name,
@name = 'ValidationReportSchedule',
@freq_type=1,
@active_start_date = @startdate,
@active_start_time = @starttime

GO

/*
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'usp_GenerateValidationReport')
DROP PROC x_DATAVALIDATION.usp_GenerateValidationReport
GO

CREATE PROC x_DATAVALIDATION.usp_GenerateValidationReport
AS

EXEC master..xp_CMDShell 'C:\ValidationReport_SSIS\ValidationReport_Upload_FTP\validationreport.bat'

GO



exec msdb.dbo.sp_help_job '_runValidationReport'


EXEC msdb.dbo.sp_start_job @job_id = @jobID, @output_flag = 0 

WAITFOR DELAY '000:02:00' -- Give the job a chance to complete
*/
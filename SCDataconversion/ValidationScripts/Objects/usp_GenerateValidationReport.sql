IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'usp_GenerateValidationReport')
DROP PROC x_DATAVALIDATION.usp_GenerateValidationReport
GO

CREATE PROC x_DATAVALIDATION.usp_GenerateValidationReport
AS

EXEC master..xp_CMDShell 'C:\ValidationReport_SSIS\ValidationReport_Upload_FTP\validationreport.bat'
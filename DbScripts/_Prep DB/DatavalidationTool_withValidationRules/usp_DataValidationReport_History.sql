IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'DataValidationReport_History')
DROP PROC Datavalidation.DataValidationReport_History
GO

CREATE PROC Datavalidation.DataValidationReport_History 
AS
BEGIN

DECLARE @iterationno INT
--DECLARE @dt DATETIME
DECLARE @sql nVARCHAR(MAX)

--SET @dt = GETDATE()
--SELECT @iterationno = CASE IterationNo WHEN MAX(IterationNo) IS NULL THEN 1 ELSE MAX(IterationNo)+1 END  from SelectLists_ValidationReport_History

--SET @sql = 'SELECT @iterationno= MAX(IterationNo) FROM '+@tablename+'_ValidationReport_History'
--EXEC (@sql)

SELECT @iterationno= MAX(IterationNumber) FROM Datavalidation.ValidationReportHistory
--print @iterationno
IF (@iterationno IS NULL)

BEGIN
SET @sql = 'INSERT Datavalidation.ValidationReportHistory (IterationNumber,ValidatedDate,TableName,ErrorMessage,LineNumber,Line)
SELECT 1,GETDATE(),TableName,ErrorMessage,LineNumber,Line FROM Datavalidation.ValidationReport'
EXEC sp_executesql @stmt=@sql
END

ELSE

BEGIN
SET @sql = 'INSERT Datavalidation.ValidationReportHistory (IterationNumber,ValidatedDate,TableName,ErrorMessage,LineNumber,Line)
SELECT (select max(IterationNumber)+1 from Datavalidation.ValidationReportHistory),GETDATE(),TableName,ErrorMessage,LineNumber,Line FROM Datavalidation.ValidationReport'
EXEC sp_executesql @stmt=@sql
END

SET @sql  = 'DELETE Datavalidation.ValidationReport'
EXEC sp_executesql @stmt=@sql

SET @sql  = 'DELETE vh FROM Datavalidation.ValidationReportHistory vh WHERE ValidatedDate < (DATEADD(DD,-60,ValidatedDate))'
EXEC sp_executesql @stmt=@sql

SET @sql = 'DELETE Datavalidation.ValidationSummaryReport'
EXEC sp_executesql @stmt = @sql

END


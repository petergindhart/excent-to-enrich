IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'DataValidationReport_History')
DROP PROC dbo.DataValidationReport_History
GO

CREATE PROC dbo.DataValidationReport_History 
(
@tablename VARCHAR(50)
)
AS
BEGIN

DECLARE @iterationno INT
--DECLARE @dt DATETIME
DECLARE @sql nVARCHAR(MAX)

--SET @dt = GETDATE()
--SELECT @iterationno = CASE IterationNo WHEN MAX(IterationNo) IS NULL THEN 1 ELSE MAX(IterationNo)+1 END  from SelectLists_ValidationReport_History

--SET @sql = 'SELECT @iterationno= MAX(IterationNo) FROM '+@tablename+'_ValidationReport_History'
--EXEC (@sql)
IF (@tablename = 'SelectLists')
SELECT @iterationno= MAX(IterationNo) FROM SelectLists_ValidationReport_History

IF (@tablename = 'District')
SELECT @iterationno= MAX(IterationNo) FROM District_ValidationReport_History

IF (@tablename = 'School')
SELECT @iterationno= MAX(IterationNo) FROM School_ValidationReport_History

IF (@tablename = 'Student')
SELECT @iterationno= MAX(IterationNo) FROM Student_ValidationReport_History

IF (@tablename = 'IEP')
SELECT @iterationno= MAX(IterationNo) FROM IEP_ValidationReport_History

IF (@tablename = 'SpedStaffMember')
SELECT @iterationno= MAX(IterationNo) FROM SpedStaffMember_ValidationReport_History

IF (@tablename = 'Service')
SELECT @iterationno= MAX(IterationNo) FROM Service_ValidationReport_History

IF (@tablename = 'Goal')
SELECT @iterationno= MAX(IterationNo) FROM Goal_ValidationReport_History

IF (@tablename = 'Objective')
SELECT @iterationno= MAX(IterationNo) FROM Objective_ValidationReport_History

IF (@tablename = 'TeamMember')
SELECT @iterationno= MAX(IterationNo) FROM TeamMember_ValidationReport_History

IF (@tablename = 'StaffSchool')
SELECT @iterationno= MAX(IterationNo) FROM StaffSchool_ValidationReport_History


IF (@iterationno IS NULL)

BEGIN
SET @sql = 'INSERT  ' +@tablename+'_ValidationReport_History (IterationNo,ValidatedDate,LineNumber,Result)
SELECT 1,GETDATE(),ID,Result FROM '+@tablename+'_ValidationReport'
EXEC sp_executesql @stmt=@sql
END

ELSE

BEGIN
SET @sql = 'INSERT  ' +@tablename+'_ValidationReport_History (IterationNo,ValidatedDate,LineNumber,Result)
SELECT (select max(IterationNo)+1 from  '+@tablename+'_ValidationReport_History),GETDATE(),ID,Result FROM '+@tablename+'_ValidationReport'
EXEC sp_executesql @stmt=@sql
END

SET @sql  = 'DELETE '+@tablename+'_ValidationReport'
EXEC sp_executesql @stmt=@sql

SET @sql  = 'DELETE vh FROM '+@tablename+'_ValidationReport_History vh WHERE ValidatedDate < (DATEADD(DD,-60,ValidatedDate))'
EXEC sp_executesql @stmt=@sql

END


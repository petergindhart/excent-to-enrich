IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'ReportFile_Preparation')
DROP PROC x_DATAVALIDATION.ReportFile_Preparation
GO
CREATE PROC x_DATAVALIDATION.ReportFile_Preparation
( 
@dbname varchar(100)
,@reportpath varchar(500)
)
AS
BEGIN
DECLARE @sql nvarchar(max)
--DECLARE @dbname varchar(100)
--DECLARE @reportpath varchar(500)
--SET @dbname= 'Enrich_DCB8_SC_Chesterfield'
--SET @reportpath ='C:\ValidationSummaryReport'
SET @sql = 'EXEC Xp_cmdShell ''bcp "select ''''""''''+tablename+''''""'''',''''""''''+errormessage +''''""'''',''''""''''+ convert(varchar(10),NumberOfRecords)+''''""'''' from '+@dbname+'.x_DATAVALIDATION.vw_ValidationSummaryreport order by sequence,tablename,errormessage " queryout "'+@reportpath+'\ValidationSummaryReport.csv"  -T -c -t,''' 
--print @sql
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "SELECT ''''""''''+CONVERT(VARCHAR(10),LineNumber)+''''""'''',''''""''''+errormessage+''''""'''',''''""''''+Line+''''""'''' FROM '+@dbname+'.x_DATAVALIDATION.Validationreport WHERE TableName= ''''SelectLists'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_SelectLists.csv"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "SELECT ''''""''''+CONVERT(VARCHAR(10),LineNumber)+''''""'''',''''""''''+errormessage+''''""'''',''''""''''+Line+''''""'''' FROM '+@dbname+'.x_DATAVALIDATION.Validationreport WHERE TableName= ''''District'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_District.csv"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "SELECT ''''""''''+CONVERT(VARCHAR(10),LineNumber)+''''""'''',''''""''''+errormessage+''''""'''',''''""''''+Line+''''""'''' FROM '+@dbname+'.x_DATAVALIDATION.Validationreport WHERE TableName= ''''School'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_School.csv"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "SELECT ''''""''''+CONVERT(VARCHAR(10),LineNumber)+''''""'''',''''""''''+errormessage+''''""'''',''''""''''+Line+''''""'''' FROM '+@dbname+'.x_DATAVALIDATION.Validationreport WHERE TableName= ''''Student'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_Student.csv"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "SELECT ''''""''''+CONVERT(VARCHAR(10),LineNumber)+''''""'''',''''""''''+errormessage+''''""'''',''''""''''+Line+''''""'''' FROM '+@dbname+'.x_DATAVALIDATION.Validationreport WHERE TableName= ''''IEP'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_IEP.csv"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "SELECT ''''""''''+CONVERT(VARCHAR(10),LineNumber)+''''""'''',''''""''''+errormessage+''''""'''',''''""''''+Line+''''""'''' FROM '+@dbname+'.x_DATAVALIDATION.Validationreport WHERE TableName= ''''SpedStaffMember'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_SpedStaffMember.csv"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "SELECT ''''""''''+CONVERT(VARCHAR(10),LineNumber)+''''""'''',''''""''''+errormessage+''''""'''',''''""''''+Line+''''""'''' FROM '+@dbname+'.x_DATAVALIDATION.Validationreport WHERE TableName= ''''Service'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_Service.csv"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "SELECT ''''""''''+CONVERT(VARCHAR(10),LineNumber)+''''""'''',''''""''''+errormessage+''''""'''',''''""''''+Line+''''""'''' FROM '+@dbname+'.x_DATAVALIDATION.Validationreport WHERE TableName= ''''Goal'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_Goal.csv"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "SELECT ''''""''''+CONVERT(VARCHAR(10),LineNumber)+''''""'''',''''""''''+errormessage+''''""'''',''''""''''+Line+''''""'''' FROM '+@dbname+'.x_DATAVALIDATION.Validationreport WHERE TableName= ''''Objective'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_Objective.csv"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "SELECT ''''""''''+CONVERT(VARCHAR(10),LineNumber)+''''""'''',''''""''''+errormessage+''''""'''',''''""''''+Line+''''""'''' FROM '+@dbname+'.x_DATAVALIDATION.Validationreport WHERE TableName= ''''TeamMember'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_TeamMember.csv"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "SELECT ''''""''''+CONVERT(VARCHAR(10),LineNumber)+''''""'''',''''""''''+errormessage+''''""'''',''''""''''+Line+''''""'''' FROM '+@dbname+'.x_DATAVALIDATION.Validationreport WHERE TableName= ''''StaffSchool'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_StaffSchool.csv"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
END


IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'ReportFile_Preparation')
DROP PROC Datavalidation.ReportFile_Preparation
GO
CREATE PROC Datavalidation.ReportFile_Preparation
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
SET @sql = 'EXEC Xp_cmdShell ''bcp "select tablename+''''-''''+errormessage +''''=''''+ convert(varchar(10),NumberOfRecords) from '+@dbname+'.Datavalidation.vw_ValidationSummaryreport order by sequence,tablename,errormessage " queryout "'+@reportpath+'\ValidationSummaryReport.txt"  -T -c -t,''' 
--print @sql
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "select tablename+'''' - ''''+errormessage +'''' - ''''+ convert(varchar(10),LineNumber)+''''- "''''+Line+''''" '''' from '+@dbname+'.Datavalidation.Validationreport WHERE TableName= ''''SelectLists'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_SelectLists.txt"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "select tablename+'''' - ''''+errormessage +'''' - ''''+ convert(varchar(10),LineNumber)+''''- "''''+Line+''''" '''' from '+@dbname+'.Datavalidation.Validationreport WHERE TableName= ''''District'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_District.txt"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "select tablename+'''' - ''''+errormessage +'''' - ''''+ convert(varchar(10),LineNumber)+''''- "''''+Line+''''" '''' from '+@dbname+'.Datavalidation.Validationreport WHERE TableName= ''''School'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_School.txt"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "select tablename+'''' - ''''+errormessage +'''' - ''''+ convert(varchar(10),LineNumber)+''''- "''''+Line+''''" '''' from '+@dbname+'.Datavalidation.Validationreport WHERE TableName= ''''Student'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_Student.txt"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "select tablename+'''' - ''''+errormessage +'''' - ''''+ convert(varchar(10),LineNumber)+''''- "''''+Line+''''" '''' from '+@dbname+'.Datavalidation.Validationreport WHERE TableName= ''''IEP'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_IEP.txt"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "select tablename+'''' - ''''+errormessage +'''' - ''''+ convert(varchar(10),LineNumber)+''''- "''''+Line+''''" '''' from '+@dbname+'.Datavalidation.Validationreport WHERE TableName= ''''SpedStaffMember'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_SpedStaffMember.txt"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "select tablename+'''' - ''''+errormessage +'''' - ''''+ convert(varchar(10),LineNumber)+''''- "''''+Line+''''" '''' from '+@dbname+'.Datavalidation.Validationreport WHERE TableName= ''''Service'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_Service.txt"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "select tablename+'''' - ''''+errormessage +'''' - ''''+ convert(varchar(10),LineNumber)+''''- "''''+Line+''''" '''' from '+@dbname+'.Datavalidation.Validationreport WHERE TableName= ''''Goal'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_Goal.txt"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "select tablename+'''' - ''''+errormessage +'''' - ''''+ convert(varchar(10),LineNumber)+''''- "''''+Line+''''" '''' from '+@dbname+'.Datavalidation.Validationreport WHERE TableName= ''''Objective'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_Objective.txt"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "select tablename+'''' - ''''+errormessage +'''' - ''''+ convert(varchar(10),LineNumber)+''''- "''''+Line+''''" '''' from '+@dbname+'.Datavalidation.Validationreport WHERE TableName= ''''TeamMember'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_TeamMember.txt"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
SET @sql = 'EXEC Xp_cmdShell ''bcp "select tablename+'''' - ''''+errormessage +'''' - ''''+ convert(varchar(10),LineNumber)+''''- "''''+Line+''''" '''' from '+@dbname+'.Datavalidation.Validationreport WHERE TableName= ''''StaffSchool'''' order by CONVERT(int,LineNumber)" queryout "'+@reportpath+'\ValidationReport_StaffSchool.txt"  -T -c -t,''' 
EXEC sp_executesql @stmt=@sql
END


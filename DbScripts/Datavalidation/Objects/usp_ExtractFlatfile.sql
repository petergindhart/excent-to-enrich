IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'ExtractData_FlatFile')
DROP PROC Datavalidation.ExtractData_FlatFile
GO

CREATE PROC Datavalidation.ExtractData_FlatFile
--(
--@datafilelocationpath VARCHAR(100)
--,@dbname VARCHAR(150)
--,@reportfilelocationpath VARCHAR(150)
--) 
AS
BEGIN
--declare @datafilelocationpath VARCHAR(100)
DECLARE @sql NVARCHAR(MAX)
DECLARE @datafilelocationpath VARCHAR(100)
SELECT @datafilelocationpath = LocalCopyPath FROM VC3ETL.FlatFileExtractDatabase WHERE ID = 'FCDC15CE-526B-46FD-83DE-AE86B3BC7F50'
print @datafilelocationpath
--set @datafilelocationpath ='E:\SC\Test'
--print @sql
EXEC sp_executesql @stmt=@sql
BEGIN TRY 
EXEC Datavalidation.Cleanup_Flatfile
SET @sql='EXEC Datavalidation.ExtractData_From_Csv '''+ @datafilelocationpath +'\SelectLists.csv'',''SelectLists'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC Datavalidation.ExtractData_From_Csv '''+ @datafilelocationpath +'\District.csv'',''District'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC Datavalidation.ExtractData_From_Csv '''+ @datafilelocationpath +'\School.csv'',''School'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC Datavalidation.ExtractData_From_Csv '''+ @datafilelocationpath +'\Student.csv'',''Student'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC Datavalidation.ExtractData_From_Csv '''+ @datafilelocationpath +'\IEP.csv'',''IEP'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC Datavalidation.ExtractData_From_Csv '''+ @datafilelocationpath +'\SpedStaffMember.csv'',''SpedStaffMember'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC Datavalidation.ExtractData_From_Csv '''+ @datafilelocationpath +'\Service.csv'',''Service'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC Datavalidation.ExtractData_From_Csv '''+ @datafilelocationpath +'\Goal.csv'',''Goal'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC Datavalidation.ExtractData_From_Csv '''+ @datafilelocationpath +'\Objective.csv'',''Objective'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC Datavalidation.ExtractData_From_Csv '''+ @datafilelocationpath +'\TeamMember.csv'',''TeamMember'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC Datavalidation.ExtractData_From_Csv '''+ @datafilelocationpath +'\StaffSchool.csv'',''StaffSchool'''
EXEC sp_executesql @stmt=@sql
--EXEC Datavalidation.Summaryreport
DELETE Datavalidation.ValidationSummaryReport WHERE NumberOfRecords = 0 AND ErrorMessage NOT IN ('SuccessfulRecords','TotalRecords')
EXEC Datavalidation.DataValidationReport_History
--EXEC Datavalidation.ReportFile_Preparation @dbname,@reportfilelocationpath
END TRY

BEGIN CATCH
DECLARE @ErrorMessage NVARCHAR(4000);
select @ErrorMessage = ERROR_MESSAGE()
print @ErrorMessage
END CATCH

END


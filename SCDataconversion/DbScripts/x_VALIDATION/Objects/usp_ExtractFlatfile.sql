IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'ExtractData_FlatFile')
DROP PROC x_DATAVALIDATION.ExtractData_FlatFile
GO

CREATE PROC x_DATAVALIDATION.ExtractData_FlatFile
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
EXEC x_DATAVALIDATION.Cleanup_Flatfile
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\SelectLists.csv'',''SelectLists'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\District.csv'',''District'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\School.csv'',''School'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\Student.csv'',''Student'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\IEP.csv'',''IEP'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\SpedStaffMember.csv'',''SpedStaffMember'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\Service.csv'',''Service'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\Goal.csv'',''Goal'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\Objective.csv'',''Objective'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\TeamMember.csv'',''TeamMember'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\StaffSchool.csv'',''StaffSchool'''
EXEC sp_executesql @stmt=@sql
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\SchoolProgressFrequency.csv'',''SchoolProgressFrequency'''
EXEC sp_executesql @stmt=@sql

IF((SELECT ParamValue FROM x_datavalidation.ParamValues WHERE ParamName ='Check_AccomMod')='1')
BEGIN
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\AccomMod.csv'',''AccomMod'''
EXEC sp_executesql @stmt=@sql
END

IF((SELECT ParamValue FROM x_datavalidation.ParamValues WHERE ParamName ='Check_AccomMod')='1')
BEGIN
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\ClassroomAccommMod.csv'',''ClassroomAccommMod'''
EXEC sp_executesql @stmt=@sql
END

IF((SELECT ParamValue FROM x_datavalidation.ParamValues WHERE ParamName ='Check_PresentLevel')='1')
BEGIN
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\PresentLevel.csv'',''PresentLevel'''
EXEC sp_executesql @stmt=@sql
END

IF((SELECT ParamValue FROM x_datavalidation.ParamValues WHERE ParamName ='Check_PostSchoolConsider')='1')
BEGIN
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\PostSchoolConsider.csv'',''PostSchoolConsider'''
EXEC sp_executesql @stmt=@sql
END

IF((SELECT ParamValue FROM x_datavalidation.ParamValues WHERE ParamName ='Check_PostSchoolStatement')='1')
BEGIN
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\PostSchoolStatement.csv'',''PostSchoolStatement'''
EXEC sp_executesql @stmt=@sql
END

IF((SELECT ParamValue FROM x_datavalidation.ParamValues WHERE ParamName ='Check_SpecialFactors')='1')
BEGIN
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\SpecialFactors.csv'',''SpecialFactors'''
EXEC sp_executesql @stmt=@sql
END

IF((SELECT ParamValue FROM x_datavalidation.ParamValues WHERE ParamName ='Check_AssessAccomm')='1')
BEGIN
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\AssessAccomm.csv'',''AssessAccomm'''
EXEC sp_executesql @stmt=@sql
END

IF((SELECT ParamValue FROM x_datavalidation.ParamValues WHERE ParamName ='Check_PriorWrittenNotice')='1')
BEGIN
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\PriorWrittenNotice.csv'',''PriorWrittenNotice'''
EXEC sp_executesql @stmt=@sql
END

IF((SELECT ParamValue FROM x_datavalidation.ParamValues WHERE ParamName ='Check_Evaluation')='1')
BEGIN
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\Evaluation.csv'',''Evaluation'''
EXEC sp_executesql @stmt=@sql
END

IF((SELECT ParamValue FROM x_datavalidation.ParamValues WHERE ParamName ='Check_EvaluationAssess')='1')
BEGIN
SET @sql='EXEC x_DATAVALIDATION.ExtractData_From_Csv '''+ @datafilelocationpath +'\EvaluationAssess.csv'',''EvaluationAssess'''
EXEC sp_executesql @stmt=@sql
END

--EXEC x_DATAVALIDATION.Summaryreport
DELETE x_DATAVALIDATION.ValidationSummaryReport WHERE NumberOfRecords = 0 AND ErrorMessage NOT IN ('SuccessfulRecords','TotalRecords')
EXEC x_DATAVALIDATION.DataValidationReport_History
--EXEC x_DATAVALIDATION.ReportFile_Preparation @dbname,@reportfilelocationpath
END TRY

BEGIN CATCH
DECLARE @ErrorMessage NVARCHAR(4000);
select @ErrorMessage = ERROR_MESSAGE()
print @ErrorMessage
END CATCH

END


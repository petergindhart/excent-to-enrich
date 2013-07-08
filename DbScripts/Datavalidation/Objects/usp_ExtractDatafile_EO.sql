IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'ExtractDataFile_EO')
DROP PROC x_DATAVALIDATION.ExtractDataFile_EO
GO

CREATE PROC x_DATAVALIDATION.ExtractDataFile_EO 
(
@dbname VARCHAR(150)
,@reportfilelocationpath VARCHAR(150)
)
AS
BEGIN

BEGIN TRY 
EXEC x_DATAVALIDATION.Cleanup_EO
/*
EXEC x_DATAVALIDATION.Extract_SelectLists
EXEC x_DATAVALIDATION.Extract_District
EXEC x_DATAVALIDATION.Extract_School
EXEC x_DATAVALIDATION.Extract_Student
EXEC x_DATAVALIDATION.Extract_IEP
EXEC x_DATAVALIDATION.Extract_SpedStaffMember
EXEC x_DATAVALIDATION.Extract_Service
EXEC x_DATAVALIDATION.Extract_Goal
EXEC x_DATAVALIDATION.Extract_Objective
EXEC x_DATAVALIDATION.Extract_TeamMember
EXEC x_DATAVALIDATION.Extract_StaffSchool
*/
--Check specfications
INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','TotalRecords',COUNT(*)
FROM x_DATAVALIDATION.SelectLists_LOCAL

INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'District','TotalRecords',COUNT(*)
FROM x_DATAVALIDATION.District_LOCAL

INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'School','TotalRecords',COUNT(*)
FROM x_DATAVALIDATION.School_LOCAL

INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'Student','TotalRecords',COUNT(*)
FROM x_DATAVALIDATION.Student_Local

INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'IEP','TotalRecords',COUNT(*)
FROM x_DATAVALIDATION.IEP_Local

INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'SpedStaffMember','TotalRecords',COUNT(*)
FROM x_DATAVALIDATION.SpedStaffMember_Local

INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'Service','TotalRecords',COUNT(*)
FROM x_DATAVALIDATION.Service_Local

INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'Goal','TotalRecords',COUNT(*)
FROM x_DATAVALIDATION.Goal_Local

INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'Objective','TotalRecords',COUNT(*)
FROM x_DATAVALIDATION.Objective_Local

INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'TeamMember','TotalRecords',COUNT(*)
FROM x_DATAVALIDATION.TeamMember_Local

INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'StaffSchool','TotalRecords',COUNT(*)
FROM x_DATAVALIDATION.StaffSchool_Local

EXEC x_DATAVALIDATION.Check_SelectLists_Specifications
EXEC x_DATAVALIDATION.Check_District_Specifications
EXEC x_DATAVALIDATION.Check_School_Specifications
EXEC x_DATAVALIDATION.Check_Student_Specifications
EXEC x_DATAVALIDATION.Check_IEP_Specifications
EXEC x_DATAVALIDATION.Check_SpedStaffMember_Specifications
EXEC x_DATAVALIDATION.Check_Service_Specifications
EXEC x_DATAVALIDATION.Check_Goal_Specifications
EXEC x_DATAVALIDATION.Check_Objective_Specifications
EXEC x_DATAVALIDATION.Check_TeamMember_Specifications
EXEC x_DATAVALIDATION.Check_StaffSchool_Specifications
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


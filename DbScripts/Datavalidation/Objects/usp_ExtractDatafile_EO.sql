IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'ExtractDataFile_EO')
DROP PROC Datavalidation.ExtractDataFile_EO
GO

CREATE PROC Datavalidation.ExtractDataFile_EO 
(
@dbname VARCHAR(150)
,@reportfilelocationpath VARCHAR(150)
)
AS
BEGIN

BEGIN TRY 
EXEC Datavalidation.Cleanup_EO
/*
EXEC Datavalidation.Extract_SelectLists
EXEC Datavalidation.Extract_District
EXEC Datavalidation.Extract_School
EXEC Datavalidation.Extract_Student
EXEC Datavalidation.Extract_IEP
EXEC Datavalidation.Extract_SpedStaffMember
EXEC Datavalidation.Extract_Service
EXEC Datavalidation.Extract_Goal
EXEC Datavalidation.Extract_Objective
EXEC Datavalidation.Extract_TeamMember
EXEC Datavalidation.Extract_StaffSchool
*/
--Check specfications
INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','TotalRecords',COUNT(*)
FROM Datavalidation.SelectLists_LOCAL

INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'District','TotalRecords',COUNT(*)
FROM Datavalidation.District_LOCAL

INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'School','TotalRecords',COUNT(*)
FROM Datavalidation.School_LOCAL

INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'Student','TotalRecords',COUNT(*)
FROM Datavalidation.Student_Local

INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'IEP','TotalRecords',COUNT(*)
FROM Datavalidation.IEP_Local

INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'SpedStaffMember','TotalRecords',COUNT(*)
FROM Datavalidation.SpedStaffMember_Local

INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'Service','TotalRecords',COUNT(*)
FROM Datavalidation.Service_Local

INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'Goal','TotalRecords',COUNT(*)
FROM Datavalidation.Goal_Local

INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'Objective','TotalRecords',COUNT(*)
FROM Datavalidation.Objective_Local

INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'TeamMember','TotalRecords',COUNT(*)
FROM Datavalidation.TeamMember_Local

INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'StaffSchool','TotalRecords',COUNT(*)
FROM Datavalidation.StaffSchool_Local

EXEC Datavalidation.Check_SelectLists_Specifications
EXEC Datavalidation.Check_District_Specifications
EXEC Datavalidation.Check_School_Specifications
EXEC Datavalidation.Check_Student_Specifications
EXEC Datavalidation.Check_IEP_Specifications
EXEC Datavalidation.Check_SpedStaffMember_Specifications
EXEC Datavalidation.Check_Service_Specifications
EXEC Datavalidation.Check_Goal_Specifications
EXEC Datavalidation.Check_Objective_Specifications
EXEC Datavalidation.Check_TeamMember_Specifications
EXEC Datavalidation.Check_StaffSchool_Specifications
--EXEC Datavalidation.Summaryreport
DELETE Datavalidation.ValidationSummaryReport WHERE NumberOfRecords = 0 AND ErrorMessage NOT IN ('SuccessfulRecords','TotalRecords')
EXEC Datavalidation.DataValidationReport_History
EXEC Datavalidation.ReportFile_Preparation @dbname,@reportfilelocationpath
END TRY

BEGIN CATCH
DECLARE @ErrorMessage NVARCHAR(4000);
select @ErrorMessage = ERROR_MESSAGE()
print @ErrorMessage
END CATCH

END


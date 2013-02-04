IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'ExtractDataFile')
DROP PROC dbo.ExtractDataFile
GO

CREATE PROC dbo.ExtractDataFile 
AS
BEGIN

BEGIN TRY 
EXEC dbo.DataValidationReport_History 'SelectLists'
EXEC dbo.DataValidationReport_History 'District'
EXEC dbo.DataValidationReport_History 'School'
EXEC dbo.DataValidationReport_History 'Student'
EXEC dbo.DataValidationReport_History 'IEP'
EXEC dbo.DataValidationReport_History 'SpedStaffMember'
EXEC dbo.DataValidationReport_History 'Service'
EXEC dbo.DataValidationReport_History 'Goal'
EXEC dbo.DataValidationReport_History 'Objective'
EXEC dbo.DataValidationReport_History 'TeamMember'
EXEC dbo.DataValidationReport_History 'StaffSchool'
EXEC dbo.ExtractData_From_Csv 'C:\Test\SelectLists.csv','SelectLists'
EXEC dbo.ExtractData_From_Csv 'C:\Test\District.csv','District'
EXEC dbo.ExtractData_From_Csv 'C:\Test\School.csv','School'
EXEC dbo.ExtractData_From_Csv 'C:\Test\Student.csv','Student'
EXEC dbo.ExtractData_From_Csv 'C:\Test\IEP.csv','IEP'
EXEC dbo.ExtractData_From_Csv 'C:\Test\SpedStaffMember.csv','SpedStaffMember'
EXEC dbo.ExtractData_From_Csv 'C:\Test\Service.csv','Service'
EXEC dbo.ExtractData_From_Csv 'C:\Test\Goal.csv','Goal'
EXEC dbo.ExtractData_From_Csv 'C:\Test\Objective.csv','Objective'
EXEC dbo.ExtractData_From_Csv 'C:\Test\TeamMember.csv','TeamMember'
EXEC dbo.ExtractData_From_Csv 'C:\Test\StaffSchool.csv','StaffSchool'
END TRY

BEGIN CATCH
DECLARE @ErrorMessage NVARCHAR(4000);
select @ErrorMessage = ERROR_MESSAGE()
print @ErrorMessage
END CATCH

END


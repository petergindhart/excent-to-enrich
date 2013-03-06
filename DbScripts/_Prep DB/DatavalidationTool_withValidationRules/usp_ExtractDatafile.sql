IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'ExtractDataFile')
DROP PROC Datavalidation.ExtractDataFile
GO

CREATE PROC Datavalidation.ExtractDataFile 
AS
BEGIN

BEGIN TRY 
EXEC Datavalidation.DataValidationReport_History
EXEC Datavalidation.Cleanup
EXEC Datavalidation.ExtractData_From_Csv 'C:\Test\SelectLists.csv','SelectLists'
EXEC Datavalidation.ExtractData_From_Csv 'C:\Test\District.csv','District'
EXEC Datavalidation.ExtractData_From_Csv 'C:\Test\School.csv','School'
EXEC Datavalidation.ExtractData_From_Csv 'C:\Test\Student.csv','Student'
EXEC Datavalidation.ExtractData_From_Csv 'C:\Test\IEP.csv','IEP'
EXEC Datavalidation.ExtractData_From_Csv 'C:\Test\SpedStaffMember.csv','SpedStaffMember'
EXEC Datavalidation.ExtractData_From_Csv 'C:\Test\Service.csv','Service'
EXEC Datavalidation.ExtractData_From_Csv 'C:\Test\Goal.csv','Goal'
EXEC Datavalidation.ExtractData_From_Csv 'C:\Test\Objective.csv','Objective'
EXEC Datavalidation.ExtractData_From_Csv 'C:\Test\TeamMember.csv','TeamMember'
EXEC Datavalidation.ExtractData_From_Csv 'C:\Test\StaffSchool.csv','StaffSchool'
EXEC Datavalidation.Summaryreport
END TRY

BEGIN CATCH
DECLARE @ErrorMessage NVARCHAR(4000);
select @ErrorMessage = ERROR_MESSAGE()
print @ErrorMessage
END CATCH

END


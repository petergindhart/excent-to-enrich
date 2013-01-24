IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'ExtractDataFile')
DROP PROC dbo.ExtractDataFile
GO

CREATE PROC dbo.ExtractDataFile 
AS
BEGIN

BEGIN TRY 
EXEC dbo.ImportDatafileToStaging 'C:\Test\SelectLists.csv','SelectLists_LOCAL'
EXEC dbo.ImportDatafileToStaging 'C:\Test\District.csv','District_LOCAL'
EXEC dbo.ImportDatafileToStaging 'C:\Test\Student.csv','Student_LOCAL'
EXEC dbo.ImportDatafileToStaging 'C:\Test\IEP.csv','IEP_LOCAL'
EXEC dbo.ImportDatafileToStaging 'C:\Test\SpedStaffMember.csv','SpedStaffMember_LOCAL'
EXEC dbo.ImportDatafileToStaging 'C:\Test\Service.csv','Service_LOCAL'
EXEC dbo.ImportDatafileToStaging 'C:\Test\Goal.csv','Goal_LOCAL'
EXEC dbo.ImportDatafileToStaging 'C:\Test\Objective.csv','Objective_LOCAL'
EXEC dbo.ImportDatafileToStaging 'C:\Test\TeamMember.csv','TeamMember_LOCAL'
EXEC dbo.ImportDatafileToStaging 'C:\Test\StaffSchool.csv','StaffSchool_LOCAL'
END TRY

BEGIN CATCH
DECLARE @ErrorMessage NVARCHAR(4000);
select @ErrorMessage = ERROR_MESSAGE()
print @ErrorMessage
END CATCH

END


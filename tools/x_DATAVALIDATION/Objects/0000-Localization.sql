--#include {SpedObjectsInclude}\0000-Localization.sql
--#include Check_SelectLists_Specifications.sql
--#include Check_District_Specifications.sql
--#include Check_School_Specifications.sql
--#include Check_Student_Specifications.sql
--#include Check_IEP_Specifications.sql
--#include Check_SpedStaffMember_Specifications.sql
--#include Check_Service_Specifications.sql
--#include Check_Goal_Specifications.sql
--#include Check_Objective_Specifications.sql
--#include Check_TeamMember_Specifications.sql
--#include Check_StaffSchool_Specifications.sql
--#include usp_DatavalidatoinCleanUp_Flatfile.sql
--#include usp_DatavalidatoinCleanUp_EO.sql
--#include usp_ImportDataFileStaging.sql
--#include usp_CheckColumnNameAndOrder.sql
--#include usp_ExtractDatafile_From_Csv.sql
--#include usp_ReportFilePreaprtion.sql
--#include usp_DataValidationReport_History.sql
--#include usp_ExtractDatafile_EO.sql
--#include usp_ExtractFlatfile.sql

-- let's reset the counts for imported data so we know this script ran when we run dc from the ui
--update et set LastSuccessfulCount = 0, CurrentCount = 0 from VC3ETL.ExtractTable et where ExtractDatabase = '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16' 
--go

-- :r < filename >
-- < filename > is read relative to the startup directory in which sqlcmd was run.


:r ..\..\..\EnrichDB\ValidationScripts\Changes\0000-CreateSchema.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\usp_GetParam.sql
GO
:r ..\..\..\Common\Localization\Demo\0001-Prep_District.sql
Go
:r ..\..\..\Common\Create_LinkedServer.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Changes\Check_IsInteger.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Changes\CreateEnrichDVObjects.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Changes\vw_Validationsummaryreport.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Populate_TableOrder.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Script_ValidationRules_Populate.sql
GO
:r ..\..\..\Common\Populate_SpeedObjects.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\usp_ImportLegacyToEnrich.sql
GO
/*
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Populate_DataConvSpedStudentsAndIEPs.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Populate_SelectLists.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Populate_District.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Populate_School.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Populate_Student.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Populate_IEP.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Populate_SpedStaffMember.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Populate_Service.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Populate_Goal.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Populate_Objective.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Populate_TeamMember.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Populate_StaffSchool.sql
Go
*/
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Check_SelectLists_Specifications.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Check_District_Specifications.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Check_School_Specifications.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Check_Student_Specifications.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Check_IEP_Specifications.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Check_SpedStaffMember_Specifications.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Check_Service_Specifications.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Check_Goal_Specifications.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Check_Objective_Specifications.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Check_TeamMember_Specifications.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Check_StaffSchool_Specifications.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Check_AccomMod_Specifications.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\Check_SchoolProgressFrequency_Specifications.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\usp_DatavalidatoinCleanUp_Flatfile.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\usp_DatavalidatoinCleanUp_EO.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\usp_ImportDataFileStaging.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\usp_CheckColumnNameAndOrder.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\usp_ExtractDatafile_From_Csv.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\usp_ReportFilePreaprtion.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\usp_DataValidationReport_History.sql
Go
:r ..\..\..\EnrichDB\ValidationScripts\Objects\usp_ExtractDatafile_EO.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\usp_ExtractFlatfile.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\Objects\setupETL_EO.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\SourceScripts_enrich\Source_District.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\SourceScripts_enrich\Source_Goal.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\SourceScripts_enrich\Source_IEP.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\SourceScripts_enrich\Source_Objective.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\SourceScripts_enrich\Source_School.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\SourceScripts_enrich\Source_SelectLists.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\SourceScripts_enrich\Source_SpedStaffMember.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\SourceScripts_enrich\Source_Service.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\SourceScripts_enrich\Source_StaffSchool.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\SourceScripts_enrich\Source_Student.sql
GO
:r ..\..\..\EnrichDB\ValidationScripts\SourceScripts_enrich\Source_TeamMemeber.sql
GO
:r ..\..\..\Common\usp_GenerateValidationReport.sql
GO


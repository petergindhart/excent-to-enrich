-- :r < filename >
-- < filename > is read relative to the startup directory in which sqlcmd was run.
--!!!Change the District Name in this file!!!!

:r ..\DbScripts\x_VALIDATION\Changes\0000-CreateSchema.sql
Go
:r ..\DbScripts\x_VALIDATION\Objects\usp_GetParam.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Check_IsInteger.sql
Go
:r ..\DbScripts\x_VALIDATION\Changes\CreateEnrichDVObjects.sql
GO
:r ..\DbScripts\x_VALIDATION\Localization\Enrich\SC\DistrictName\0001-Prep_District.sql
Go
:r ..\DbScripts\x_VALIDATION\Localization\Enrich\SC\DistrictName\Create_CmdShellUser.sql
Go
:r ..\DbScripts\x_VALIDATION\Localization\Enrich\SC\Create_LinkedServer.sql
GO
:r ..\DbScripts\x_VALIDATION\Localization\Enrich\SC\create_Goal_DV.sql
GO
:r ..\DbScripts\x_VALIDATION\Localization\Enrich\SC\create_Objective_DV.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\vw_Validationsummaryreport.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Populate_TableOrder.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Script_ValidationRules_Populate.sql
GO
:r ..\DbScripts\x_VALIDATION\Localization\Enrich\SC\Script_ValidationRules_Populate_Localization.sql
GO
:r ..\DbScripts\x_VALIDATION\Localization\EO\SC\Populate_SpeedObjects.sql
Go
:r ..\DbScripts\x_VALIDATION\Objects\usp_ImportLegacyToEnrich.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Check_SelectLists_Specifications.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Check_District_Specifications.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Check_School_Specifications.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Check_Student_Specifications.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Check_IEP_Specifications.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Check_SpedStaffMember_Specifications.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Check_Service_Specifications.sql
GO
:r ..\DbScripts\x_VALIDATION\Localization\Enrich\SC\Check_Goal_Specifications.sql
GO
:r ..\DbScripts\x_VALIDATION\Localization\Enrich\SC\Check_Objective_Specifications.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Check_TeamMember_Specifications.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Check_StaffSchool_Specifications.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Check_AccomMod_Specifications.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\Check_SchoolProgressFrequency_Specifications.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\usp_DatavalidatoinCleanUp_Flatfile.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\usp_DatavalidatoinCleanUp_EO.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\usp_ImportDataFileStaging.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\usp_CheckColumnNameAndOrder.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\usp_ExtractDatafile_From_Csv.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\usp_ReportFilePreaprtion.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\usp_DataValidationReport_History.sql
Go
:r ..\DbScripts\x_VALIDATION\Objects\usp_ExtractDatafile_EO.sql
GO
:r ..\DbScripts\x_VALIDATION\Objects\usp_ExtractFlatfile.sql
GO
:r ..\DbScripts\x_VALIDATION\Localization\Enrich\SC\setupETL_EO.sql
GO
:r ..\DbScripts\x_VALIDATION\SourceScripts_enrich\Source_District.sql
GO
:r ..\DbScripts\x_VALIDATION\SourceScripts_enrich\Source_Goal.sql
GO
:r ..\DbScripts\x_VALIDATION\SourceScripts_enrich\Source_IEP.sql
GO
:r ..\DbScripts\x_VALIDATION\SourceScripts_enrich\Source_Objective.sql
GO
:r ..\DbScripts\x_VALIDATION\SourceScripts_enrich\Source_School.sql
GO
:r ..\DbScripts\x_VALIDATION\SourceScripts_enrich\Source_SelectLists.sql
GO
:r ..\DbScripts\x_VALIDATION\SourceScripts_enrich\Source_SpedStaffMember.sql
GO
:r ..\DbScripts\x_VALIDATION\SourceScripts_enrich\Source_Service.sql
GO
:r ..\DbScripts\x_VALIDATION\SourceScripts_enrich\Source_StaffSchool.sql
GO
:r ..\DbScripts\x_VALIDATION\SourceScripts_enrich\Source_Student.sql
GO
:r ..\DbScripts\x_VALIDATION\SourceScripts_enrich\Source_TeamMemeber.sql
GO
:r ..\DbScripts\x_VALIDATION\Localization\Enrich\SC\usp_GenerateValidationReport.sql
GO


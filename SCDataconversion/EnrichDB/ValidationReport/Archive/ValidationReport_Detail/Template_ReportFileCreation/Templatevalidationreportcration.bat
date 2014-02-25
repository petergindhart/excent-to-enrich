@ECHO OFF

SET DTEXC_PATH="C:\Program Files (x86)\Microsoft SQL Server\100\DTS\Binn"
SET Package_PATH="E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReport_Detail\Template_ReportFileCreation\ValidationReport_TemplateFileCreatoin.dtsx"
SET Config_PATH="E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReport_Detail\Template_ReportFileCreation\ValidationReportTemplate.dtsConfig"


cd %DTEXC_PATH%
"C:\Program Files (x86)\Microsoft SQL Server\100\DTS\Binn\DTExec.exe" /f %Package_PATH% /conf %Config_PATH% > E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReport_Detail\Template_ReportFileCreation\log_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt
EXIT
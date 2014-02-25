@ECHO OFF

rem      get the following from local database
rem SET DTEXC_PATH="C:\Program Files (x86)\Microsoft SQL Server\100\DTS\Binn"
rem SET Package_PATH="E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReport_Detail\Template_ReportFileCreation\ValidationReport_TemplateFileCreatoin.dtsx"
rem SET Config_PATH="E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReport_Detail\Template_ReportFileCreation\ValidationReportTemplate.dtsConfig"
rem set logpath also

cd %DTEXC_PATH%
"C:\Program Files (x86)\Microsoft SQL Server\100\DTS\Binn\DTExec.exe" /f %Package_PATH% /conf %Config_PATH% > E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReport_Detail\Template_ReportFileCreation\log_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt
EXIT
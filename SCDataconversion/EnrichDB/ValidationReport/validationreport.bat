@ECHO OFF
rem from ValidationReport folder
rem rasdial "ViaWest Data Conversion" /DISCONNECT

SET DTEXC_PATH="C:\Program Files (x86)\Microsoft SQL Server\100\DTS\Binn"
SET Package_PATH="E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReportGeneration.dtsx"
SET Config_PATH="E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\validationreport.dtsConfig"


cd %DTEXC_PATH%
DTExec.exe /f %Package_PATH% /conf %Config_PATH% > E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReport_log_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt
EXIT
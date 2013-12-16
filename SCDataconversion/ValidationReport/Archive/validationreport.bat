@ECHO OFF

SET DTEXC_PATH="C:\Program Files (x86)\Microsoft SQL Server\100\DTS\Binn"
SET Package_PATH="C:\ValidationReport_SSIS\Package.dtsx"
SET Config_PATH="C:\ValidationReport_SSIS\validationreport_test.dtsConfig"


cd %DTEXC_PATH%
DTExec.exe /f %Package_PATH% /conf %Config_PATH% > C:\ValidationReport_SSIS\log_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt
EXIT
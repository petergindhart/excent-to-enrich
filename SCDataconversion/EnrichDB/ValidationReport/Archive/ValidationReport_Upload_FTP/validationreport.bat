@ECHO OFF

SET DTEXC_PATH="C:\Program Files (x86)\Microsoft SQL Server\100\DTS\Binn"
SET Package_PATH="E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReport_Upload_FTP\ValidationReport_Generation_UploadFTP.dtsx"
SET Config_PATH="E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReport_Upload_FTP\UploadValidationReportToFTP.dtsConfig"


cd %DTEXC_PATH%
"C:\Program Files (x86)\Microsoft SQL Server\100\DTS\Binn\DTExec.exe" /f %Package_PATH% /conf %Config_PATH% > E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReport_Upload_FTP\log_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt
EXIT
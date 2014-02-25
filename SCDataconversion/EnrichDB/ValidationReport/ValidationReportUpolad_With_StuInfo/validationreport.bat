@ECHO OFF

rasdial "ViaWest Data Conversion" /DISCONNECT

SET DTEXC_PATH="C:\Program Files (x86)\Microsoft SQL Server\100\DTS\Binn"
SET Package_PATH="E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReportUpolad_With_StuInfo\ValidationReport_UploadFTP_IEPwStuInfo.dtsx"
SET Config_PATH="E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReportUpolad_With_StuInfo\ValidationReport_UploadFTP_IEPwStuInfo.dtsConfig"

cd %DTEXC_PATH%
"C:\Program Files (x86)\Microsoft SQL Server\100\DTS\Binn\DTExec.exe" /f %Package_PATH% /conf %Config_PATH% > E:\GIT\excent-to-enrich\SCDataconversion\ValidationReport\ValidationReportUpolad_With_StuInfo\log_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt
EXIT
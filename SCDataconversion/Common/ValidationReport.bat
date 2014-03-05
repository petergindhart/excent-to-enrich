@ECHO OFF
rem get Enrich connection string from txt file here.
REM set speddistrict=%1
REM echo %speddistrict%
REM set locFolder=E:\GIT\excent-to-enrich\SCDataconversion\Common\Localization\%speddistrict%
set locFolder=%1
set /P connStr=<%locFolder%\0000-connStr.txt

FOR /F "usebackq tokens=1 delims=~" %%i IN (`SQLCMD %connStr% -W -h-1 -Q"exec x_DATAVALIDATION.usp_GetParam 'DTEXC_PATH'"`) DO set DTEXC_PATH=%%i
FOR /F "usebackq tokens=1 delims=~" %%i IN (`SQLCMD %connStr% -W -h-1 -Q"exec x_DATAVALIDATION.usp_GetParam 'Package_PATH'"`) DO set Package_PATH=%%i
FOR /F "usebackq tokens=1 delims=~" %%i IN (`SQLCMD %connStr% -W -h-1 -Q"exec x_DATAVALIDATION.usp_GetParam 'Config_PATH'"`) DO set Config_PATH=%%i
rem FOR /F "usebackq tokens=1 delims=~" %%i IN (`SQLCMD %connStr% -W -h-1 -Q"exec x_DATAVALIDATION.usp_GetParam 'locFolder'"`) DO set locFolder=%%i
rem FOR /F "usebackq tokens=1 delims=~" %%i IN (`SQLCMD %connStr%  -W -h-1 -Q"exec x_DATAVALIDATION.usp_GetParam + '~' + 'remoteConnStr'"`) DO set remoteConnStr=%%i

echo "%DTEXC_PATH%"
echo %Package_PATH%
echo %Config_PATH%
echo %locFolder%


cd %DTEXC_PATH%
"%DTEXC_PATH%"\DTExec.exe /f %Package_PATH% /conf %Config_PATH% > %locFolder%\log_Validation_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt
REM EXIT

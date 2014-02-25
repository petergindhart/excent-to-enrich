@echo off
rem renamed from PopulateDataConversionSpeedObjects.bat
rem get Enrich connection string from txt file here.
set speddistrict=%1
REM echo %speddistrict%
set locFolder=E:\GIT\excent-to-enrich\SCDataconversion\Common\Localization\%speddistrict%
set /P connStr=<%locFolder%\0000-connStr.txt

REM  echo %CD%
REM echo %locFolder%
REM echo %connStr%
REM echo %etlRoot%

FOR /F "usebackq tokens=1 delims=~" %%i IN (`SQLCMD %connStr% -W -h-1 -Q"exec x_DATAVALIDATION.usp_GetParam 'etlRoot'"`) DO set etlRoot=%%i
REM FOR /F "usebackq delims=" %%i IN (`SQLCMD %connStr% "exec x_DATAVALIDATION.usp_GetParam 'remoteConnStr'" -Q -W -h-1`) DO set remoteConnStr=%%i

SQLCMD %connStr% -i%etlRoot%\SCDataconversion\Common\PopulateRemoteSpeedObjects.sql -olog_dcp.txt
rem SQLCMD -S10.0.1.30 -Usa -Pvc3go!! -dEnrich_DCB7_SC_Dillon4 -i E:\GIT\excent-to-enrich\SCDataconversion\RemoteDB\PopulateRemoteSpeedObjects.sql


Pause
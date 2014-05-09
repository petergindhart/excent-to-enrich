@echo off

REM set speddistrict=%1
REM set locFolder=E:\GIT\excent-to-enrich\SCDataconversion\Common\Localization\%speddistrict%
set locFolder=%1
set /P connStr=<%locFolder%\0000-connStr.txt

FOR /F "usebackq tokens=1 delims=~" %%i IN (`SQLCMD %connStr% -W -h-1 -Q"exec x_DATAVALIDATION.usp_GetParam 'etlRoot'"`) DO set etlRoot=%%i
REM Place the storeprocedure here instead of file (future)..
REM Consider running x_DATAVALIDATION.usp_ImportLegacyToEnrich directly, rather than calling PopulateRemoteSpeedObjects.sql
SQLCMD %connStr%  -W -h-1 -Q"exec x_DATAVALIDATION.usp_ImportLegacyToEnrich" -o%locFolder%\log_ImportLegacyToEnrich.txt 

Pause
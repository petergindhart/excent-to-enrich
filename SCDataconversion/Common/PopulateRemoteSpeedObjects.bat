@echo off
rem REMOVE LOCFOLDER HARD CODE.  IF NOT THIS WILL HAVE TO BE EDITED IN ALL 100 ENVIRONMENTS IN SC

REM set speddistrict=%1
REM set locFolder=E:\GIT\excent-to-enrich\SCDataconversion\Common\Localization\%speddistrict%
set locFolder=%1
set /P connStr=<%locFolder%\0000-connStr.txt

FOR /F "usebackq tokens=1 delims=~" %%i IN (`SQLCMD %connStr% -W -h-1 -Q"exec x_DATAVALIDATION.usp_GetParam 'etlRoot'"`) DO set etlRoot=%%i
REM Place the storeprocedure here instead of file (future)..
REM Consider running x_DATAVALIDATION.usp_ImportLegacyToEnrich directly, rather than calling PopulateRemoteSpeedObjects.sql
SQLCMD %connStr% -i%etlRoot%\SCDataconversion\Common\PopulateRemoteSpeedObjects.sql -olog_dcp.txt

Pause
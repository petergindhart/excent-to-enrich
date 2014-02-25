@echo off


rem set etlRoot=%cd%
rem set etlRoot=%etlRoot:\SCDataconversion\Batch=%
FOR /F "usebackq tokens=1 delims=~" %%i IN (`SQLCMD %connStr% -W -h-1 -Q"exec x_DATAVALIDATION.ParamValues + '~' + 'etlRoot'"`) DO set etlRoot=%%i
FOR /F "usebackq tokens=1 delims=~" %%i IN (`SQLCMD %connStr% -W -h-1 -Q"exec x_DATAVALIDATION.ParamValues + '~' + 'remoteConnStr'"`) DO set remoteConnStr=%%i
FOR /F "usebackq tokens=1 delims=~" %%i IN (`SQLCMD %connStr% -W -h-1 -Q"exec x_DATAVALIDATION.ParamValues + '~' + 'locFolder'"`) DO set locFolder=%%i

SQLCMD %remoteConnStr% -i%etlRoot%\SCDataconversion\ExtractScripts_For_EO\Support\Executesqlscript.sql -o%locFolder%Executesqlscript_log.txt
PAUSE

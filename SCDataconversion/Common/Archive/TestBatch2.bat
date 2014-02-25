@echo off

set etlRoot=%cd%
set etlRoot=%etlRoot:\SCDataconversion\Batch=%

set /P connStr=<%etlRoot%\SCDataconversion\Localization\Demo\0000-connStr.txt

rem SQLCMD -Q "exec x_DATATEAM.TestProc" -W -h-1 %connStr% -o%etlRoot%\SCDataconversion\Batch\testworked.txt
FOR /F "usebackq delims=" %%i IN (`SQLCMD -Q "exec x_DATATEAM.TestProc" -W -h-1 %connStr%`) DO set GG=%%i

echo %GG%

PAUSE






@echo off


set distFolder=%cd%

set /P connStr=<%distFolder%\0000-connStr.txt

SQLCMD %connStr% -i %distFolder%\UpgradeEnrichDVObjects.sql -olog.txt
PAUSE

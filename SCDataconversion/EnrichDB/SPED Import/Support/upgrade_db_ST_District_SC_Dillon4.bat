@echo off
REM set state=SC
REM set speddistrict=Dillon4
set state=%1
set speddistrict=%2

echo DB Upgrade %state% %speddistrict%
set connection=server=10.0.1.30;uid=sa;pwd=vc3go!!;database=Enrich_DCB7_SC_Dillon4

set locFolder=..\..\..\Common\Localization\%speddistrict%
set /P remoteConnStr=<%locFolder%\0000-remoteConnStr.txt
set /P connStr=<%locFolder%\0000-connStr.txt
echo %locFolder% %connStr% %remoteConnStr%

rem The rasphone path may need to be customized - don't know yet.  The VPN connection should always be named "SC ExcentOnline".  Ensure that the connection is in the indicated PBK.
rem Was not able to call this command from a batch file.  We can call rasdial /Disconnect from a batch file.
rasphone -d "SC ExcentOnline" -f C:\ProgramData\Microsoft\Network\Connections\Pbk\rasphone.pbk 

SQLCMD %remoteConnStr% -i ..\..\..\RemoteDB\ExtractScripts_For_EO\SQL2005\UpgradeRemoteDB.sql -o%locFolder%\log_UpgradeRemoteDB.txt
SQLCMD %connStr% -i %locFolder%\_UpgradeEnrichDVObjects.sql -o%locFolder%\log_UpgradeEnrichDVObjects.txt
ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

SQLCMD %connStr% -i %locFolder%\..\..\Create_FTPdtsConfig.sql -h-1 -o%locFolder%\ValidationReport_UploadFTP_IEPwStuInfo.dtsConfig

SQLCMD %connStr% -i %locFolder%\..\..\Create_Upload_FTP_txt.sql -h-1 -o%locFolder%\ValidationReport_Upload_FTP.txt

VPNDisconnect.bat

echo Tasks completed

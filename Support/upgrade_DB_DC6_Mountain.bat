set state=CO
set speddistrict=Mountain
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC6_CO_Mountain

echo DB Upgrade %state% %speddistrict%
ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

rem net stop "VC3 TestView Scheduled Tasks (DevDC6)"
rem net start "VC3 TestView Scheduled Tasks (DevDC6)"



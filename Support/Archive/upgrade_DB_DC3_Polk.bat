set state=FL
set speddistrict=Polk
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC3_FL_Polk

echo DB Upgrade %state% %speddistrict%
ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

rem net stop "VC3 TestView Scheduled Tasks (DevDC3)"
rem net start "VC3 TestView Scheduled Tasks (DevDC3)"

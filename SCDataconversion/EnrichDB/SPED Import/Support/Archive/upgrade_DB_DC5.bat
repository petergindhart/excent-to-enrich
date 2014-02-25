set state=CO
set speddistrict=FtLuptonK
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC5_CO_FtLuptonK;Application Name=DC5upg

echo DB Upgrade %state% %speddistrict%
ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

net stop "VC3 TestView Scheduled Tasks (DevDC5)"
net start "VC3 TestView Scheduled Tasks (DevDC5)"

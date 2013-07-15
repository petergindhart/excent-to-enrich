set state=FL
set speddistrict=Flagler
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC2_FL_Flagler

echo DB Upgrade %state% %speddistrict%
ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

net stop "VC3 TestView Scheduled Tasks (DevDC2)"
net start "VC3 TestView Scheduled Tasks (DevDC2)"

set state=CO
set speddistrict=Boulder
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC6_CO_Boulder

echo DB Upgrade %state% %speddistrict%
ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

net stop "VC3 TestView Scheduled Tasks (DevDC6)"
net start "VC3 TestView Scheduled Tasks (DevDC6)"



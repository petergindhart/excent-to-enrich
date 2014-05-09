set state=MI
set speddistrict=Jackson
set connection=server=.\SQL2005;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC1_MI_Jackson_2005

echo DB Upgrade %state% %speddistrict%
ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

net stop "VC3 TestView Scheduled Tasks (DevDC1)"
net start "VC3 TestView Scheduled Tasks (DevDC1)"

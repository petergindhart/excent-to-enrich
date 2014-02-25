set state=FL
set speddistrict=Collier
set connection=server=.\sql2012;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC4_FL_Collier_SQL2012

echo DB Upgrade %state% %speddistrict%
ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

net stop "VC3 TestView Scheduled Tasks (DevDC4)"
net start "VC3 TestView Scheduled Tasks (DevDC4)"

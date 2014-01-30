set state=FL
set speddistrict=Brevard
set connection=server=.;uid=sa;pwd=vc3go!!;database=Enrich_DCB6_FL_Brevard

echo DB Upgrade %state% %speddistrict%
ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

net stop "VC3 TestView Scheduled Tasks (DCB6)"
net start "VC3 TestView Scheduled Tasks (DCB6)"

set state=CO
set speddistrict=NEBOCES
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC4_CO_NEBOCES

echo DB Upgrade %state% %speddistrict%
PsEexec \\192.168.119.141  E:\GIT\Support\ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

net stop "VC3 TestView Scheduled Tasks (DevDC4)"
net start "VC3 TestView Scheduled Tasks (DevDC4)"

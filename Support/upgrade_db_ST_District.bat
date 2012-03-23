set state=CO
set speddistrict=Aurora

echo DB Upgrade %state% %speddistrict%

set connection=''

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

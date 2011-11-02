set state=YourState
set speddistrict=YourDistrict

echo DB Upgrade %state% %speddistrict%

set connection=YourConnectionString

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

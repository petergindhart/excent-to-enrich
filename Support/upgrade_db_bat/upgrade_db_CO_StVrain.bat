set state=CO

set speddistrict=StVrain

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.30;uid=DCB3_DB_User;pwd=vc3go!!;database=Enrich_DCB3

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

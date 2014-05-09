set state=ID

set speddistrict=Boise

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.30;uid=DCB5_DB_User;pwd=vc3go!!;database=Enrich_DCB5_ID_Boise

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

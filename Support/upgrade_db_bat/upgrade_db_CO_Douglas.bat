set state=CO

set speddistrict=Douglas

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.30;uid=DCB8_SQL_Login;pwd=vc3go!!;database=Enrich_DCB8_CO_Douglas

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

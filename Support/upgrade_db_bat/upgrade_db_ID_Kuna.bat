set state=ID

set speddistrict=Kuna

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.30;uid=DCB8_SQL_Login;pwd=vc3go!!;database=Enrich_DCB8_ID_Kuna

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

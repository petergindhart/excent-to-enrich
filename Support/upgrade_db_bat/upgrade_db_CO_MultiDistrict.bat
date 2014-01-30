set state=ID

set speddistrict=MultiDistrict

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.30;uid=DCB3_DB_User;pwd=vc3go!!;database=Enrich_DCB3_ID_MultiDistrict

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

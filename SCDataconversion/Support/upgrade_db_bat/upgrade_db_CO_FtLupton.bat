set state=CO

set speddistrict=Ft.LuptonKeensBurg

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.30;uid=DCB7_DB;pwd=vc3go!!;database=Enrich_DCB7

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

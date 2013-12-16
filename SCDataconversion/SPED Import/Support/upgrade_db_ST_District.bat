set state=IL

set speddistrict=Waukegan

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.30;uid=DCB4;pwd=vc3go!!;database=Enrich_DCB4

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

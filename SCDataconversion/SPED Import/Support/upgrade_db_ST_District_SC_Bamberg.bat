set state=SC

set speddistrict=Bamberg

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.30;uid=sa;pwd=vc3go!!;database=Enrich_DCB8_SC_Bamberg1

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

set state=SC

set speddistrict=Dorchester2

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.30;uid=sa;pwd=vc3go!!;database=Enrich_DCB4_SC_Pickens

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

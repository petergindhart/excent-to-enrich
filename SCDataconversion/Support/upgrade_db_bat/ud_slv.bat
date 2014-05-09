set state=CO

set speddistrict=SLV

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.30;uid=DCB4_CO_SLV;pwd=vc3go!!;database=Enrich_DCB4_CO_SLV

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

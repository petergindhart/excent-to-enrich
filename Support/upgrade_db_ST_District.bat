set state=CO
set speddistrict=CDE

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.23\SQL2008r2;uid=enrich_db_user_dc8;pwd=dsdar@2011;database=EnrichDCB3 

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

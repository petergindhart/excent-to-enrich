set state=CO

set speddistrict=UtePassBOCES

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.31;uid=enrich_db_user;pwd=dsdar@2012;database=Enrich_COUPB

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

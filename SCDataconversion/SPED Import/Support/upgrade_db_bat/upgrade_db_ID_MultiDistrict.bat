set state=ID

set speddistrict=MultiDistrict

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.30;uid=enrich_db_coupb;pwd=vc3go!!;database=Enrich_DCB9_ID_Boise

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

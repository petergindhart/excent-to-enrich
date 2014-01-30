set state=MI

set speddistrict=Jackson

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.30;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DCB3_MI_Jackson

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

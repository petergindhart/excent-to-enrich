set state=CO
set speddistrict=Littleton
set connection=server=DEVSTATION\SQL2012;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DCB9_CO_Littleton

echo DB Upgrade %state% %speddistrict%
ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

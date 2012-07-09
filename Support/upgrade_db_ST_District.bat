set state=CO

set speddistrict=Mesa51

echo DB Upgrade %state% %speddistrict%

set connection=server=10.0.1.30;uid=DCB2_CO_Mesa51;pwd=vc3go!!;database=Enrich_DCB2_CO_Mesa51

ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection="%connection%" $state="%state%" $speddistrict="%speddistrict%"

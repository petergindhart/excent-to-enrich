
set connection="server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC8_CO_Douglas_1203"
set outputfile="E:\GIT\ConfigUpdates\CO\Douglas\0003-SetupETL.sql"

ExecuteTask\ExecuteTask.exe project projectfile="configuration_export_project.xml" $connection=%connection% $extractdatabase="29D14961-928D-4BEE-9025-238496D144C6" $outputfile=%outputfile%

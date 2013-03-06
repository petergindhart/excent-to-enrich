
set connection="server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DCB8_CO_Douglas"
set outputfile="E:\ETLConfig\New_0003-SetupETL.sql"

ExecuteTask\ExecuteTask.exe project projectfile="configuration_export_project.xml" $connection=%connection% $extractdatabase="29D14961-928D-4BEE-9025-238496D144C6" $outputfile=%outputfile%

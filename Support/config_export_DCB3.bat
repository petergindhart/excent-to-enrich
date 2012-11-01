
set connection="server=.;uid=DCB3_CO_Weld4;pwd=vc3go!!;database=Enrich_DCB3_CO_Weld4"
set outputfile="E:\GIT\excent-to-enrich\Support\New_0003-SetupETL.sql"

ExecuteTask\ExecuteTask.exe project projectfile="configuration_export_project.xml" $connection=%connection% $extractdatabase="29D14961-928D-4BEE-9025-238496D144C6" $outputfile=%outputfile%

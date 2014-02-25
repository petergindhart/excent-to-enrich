
set connection="server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC3_FL_Polk"
set outputfile="E:\GIT\ConfigUpdates\FL\Polk\0002-SetupGiftedETL.sql"

ExecuteTask\ExecuteTask.exe project projectfile="gifted_config_export_project.xml" $connection=%connection% $extractdatabase="" $outputfile=%outputfile%

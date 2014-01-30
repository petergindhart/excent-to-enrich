set connection=server=10.0.1.30;uid=DCB3_DB_User;pwd=vc3go!!;database=Enrich_DCB6_CO_Mountain
ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project_DV.xml" $connection="%connection%" 

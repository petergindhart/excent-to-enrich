The following sample batch files have been provided to simplify executing commands while implementing and testing imports.  These samples were written to be ultimately executed one directory up.  The samples are source controlled; but your specific working copies will not be.

File: SAMPLE_upgrade_db.bat
Purpose: upgrades a database using the contents of the DbScripts directory.
Replace:
	<DATABASE_CONNECTION_STRING>: the connection string to your environments database, ex: "server=ProductionServer;uid=sa;pwd=mysecretpassword;database=Enrich_SC"

File: SAMPLE_import_extract_load.bat
Purpose: runs the ETL process, creating a brand new shapshot and loading the extracted data
Replace:
	<TASK_SERVICE_EXE>: the path to the task service executable, ex: "C:\Program Files (x86)\Excent Enrich\TasksService\TestViewTasksService.exe"
	<EXTRACT_DATABASE_ID>: a specified ID from the VC3ETL.ExtractDatabase table

File: SAMPLE_import_load_only.bat
Purpose: runs the ETL process, loading extracted data from a previously created snapshot.
Replace:
	<TASK_SERVICE_EXE>: the path to the task service executable, ex: "C:\Program Files (x86)\Excent Enrich\TasksService\TestViewTasksService.exe"
	<EXTRACT_DATABASE_ID>: a specified ID from the VC3ETL.ExtractDatabase table
	
File: SAMPLE_configuration_export.bat
Purpose: exports the VC3ETL configuration from the specified database, for the specified VC3ETL.ExtractDatabase.  Produces a SQL file that can be run on another database to sync configurations.
Replace:
	<DATABASE_CONNECTION_STRING>: the connection string to your environments database, ex: "server=ProductionServer;uid=sa;pwd=mysecretpassword;database=Enrich_SC"
	<EXTRACT_DATABASE_ID>: a specified ID from the VC3ETL.ExtractDatabase table
	<OUTPUT_FILE_NAME>: the name you wish the output file to have, ex: "colorado_config.sql"
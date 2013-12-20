
set connection="server=10.0.1.31;uid=enrich_db_user;pwd=dsdar@2012;database=Enrich_DCB5_CO_Mesa51"
set outputfile="C:\Documents and Settings\muralik\My Documents\GIT\Excent\Support\DCB5COM51-SetupETL.sql"

echo %blank%
rem echo Config Export %state% %speddistrict%

ExecuteTask\ExecuteTask.exe project projectfile="configuration_export_project.xml" $connection=%connection% $extractdatabase="29D14961-928D-4BEE-9025-238496D144C6" $outputfile=%outputfile%

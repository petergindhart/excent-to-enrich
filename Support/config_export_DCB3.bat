
set connection="server=10.0.1.23\SQL2008r2;uid=enrich_db_user_dc8;pwd=dsdar@2011;database=EnrichDCB3"
set outputfile="C:\Documents and Settings\muralik\My Documents\GIT\Excent\Support\DCB3-SetupETL.sql"

echo %blank%
rem echo Config Export %state% %speddistrict%

ExecuteTask\ExecuteTask.exe project projectfile="configuration_export_project.xml" $connection=%connection% $extractdatabase="29D14961-928D-4BEE-9025-238496D144C6" $outputfile=%outputfile%

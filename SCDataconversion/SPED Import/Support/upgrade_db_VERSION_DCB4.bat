set modulesdirectory="E:\Inetpub\Sites\Enrich_DCB4\Setup\8.5.0.4303\Product\DbScripts"
set connection=server=10.0.1.30;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DCB4_FL_Bay

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true



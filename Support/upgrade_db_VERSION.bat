
set modulesdirectory="E:\Sites\Enrich\Excent Enrich DC8\Setup\9.0.1.4637\Product\DbScripts"
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC8_FL_Brevard

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true

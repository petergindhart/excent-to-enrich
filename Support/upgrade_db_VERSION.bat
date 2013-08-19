
set modulesdirectory="E:\Sites\Enrich\Excent Enrich DC2\Setup\9.0.1.4637\Product\DbScripts"
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC2_FL_Sarasota

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true

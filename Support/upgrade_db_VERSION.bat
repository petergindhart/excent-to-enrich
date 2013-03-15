
set modulesdirectory="E:\Sites\Enrich\Excent Enrich DC8\Setup\8.3.9.4191\Product\DbScripts"
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC8_CO_Douglas

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true




set modulesdirectory="E:\Sites\Enrich\Excent Enrich DC8\Setup\8.2.14.3967\Product\DbScripts"
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC8_CO_Douglas_1202

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true



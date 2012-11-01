
set modulesdirectory="E:\Sites\Enrich\Excent Enrich DC5\Setup\8.1.4.3779\Product\DbScripts"
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=RtI_Newberry_Train

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true



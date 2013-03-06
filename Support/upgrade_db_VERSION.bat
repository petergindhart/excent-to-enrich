
set modulesdirectory="E:\Sites\Enrich\Excent Enrich DC5\Setup\8.3.0.4105\Product\DbScripts"
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC5_CO_FtLuptonK

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true



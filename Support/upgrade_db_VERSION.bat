
set modulesdirectory="E:\Sites\Enrich\Excent Enrich DC6\Setup\8.6.7.4521\Product\DbScripts"
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DC6_CO_Boulder

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true

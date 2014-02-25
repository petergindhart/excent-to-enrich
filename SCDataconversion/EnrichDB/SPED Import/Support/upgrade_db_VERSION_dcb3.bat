
set modulesdirectory="E:\Inetpub\Sites\Enrich_DCB3\Setup\8.5.3.4354\Product\DbScripts"
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DCB3_MI_Jackson

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true



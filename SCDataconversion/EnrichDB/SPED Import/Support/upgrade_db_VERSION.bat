
set modulesdirectory="E:\Inetpub\Sites\Enrich_DCB7\Setup\9.2.5.4947\Product\DbScripts"
set connection=server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DCB7_SC_Dillon4

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true

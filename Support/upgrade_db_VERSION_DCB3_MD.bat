set modulesdirectory="E:\Inetpub\Sites\Enrich_DCB3\Setup\8.5.6.4418\Product\DbScripts"
set connection=server=10.0.1.30;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_DCB3_ID_MultiDistrict

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true



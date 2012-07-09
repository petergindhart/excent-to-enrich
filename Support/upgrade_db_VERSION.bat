
set modulesdirectory="E:\Inetpub\Sites\Enrich_DCB1_FL_LEE\Setup\7.26.2.3384\Product\DbScripts"
set connection=server=10.0.1.30;uid=DCB1_FL_Lee;pwd=vc3go!!;database=Enrich_DCB1_FL_Lee

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true



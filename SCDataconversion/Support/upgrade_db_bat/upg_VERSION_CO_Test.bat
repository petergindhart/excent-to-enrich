
set modulesdirectory="E:\Inetpub\Sites\Enrich_DCB8\Setup\8.0.6.3744\Product\DbScripts"
set connection=server=10.0.1.30;uid=sa;pwd=vc3go!!;database=Test_CO
ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true




set modulesdirectory="E:\Inetpub\Sites\Enrich_DCB7_DYC\Setup\7.26.4.3419\Product\DbScripts"
set connection=server=10.0.1.30;uid=DCB7_CO_DYC;pwd=vc3go!!;database=Enrich_DCB7_CO_DYC

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true



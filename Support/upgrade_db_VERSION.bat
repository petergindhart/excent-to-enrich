
set modulesdirectory="E:\Sites\Enrich\Excent Enrich DC5 CO Poudre\Setup\7.26.4.3419\Product\DbScripts"
set connection="server=.;uid=CO_UPB_User;pwd=vc3go!!;database=Enrich_COUPB"
ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true



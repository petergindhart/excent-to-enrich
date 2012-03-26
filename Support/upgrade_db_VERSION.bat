set modulesdirectory="E:\Sites\Enrich\Excent Enrich DC3 FL Polk\Setup\7.24.2.3219\Product\DbScripts"
set connection="server=.;uid=DC3_FL_Polk_User;pwd=vc3go!!;database=Enrich_DC3_FL_Polk;Application Name=DC3 Upgrade"

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true



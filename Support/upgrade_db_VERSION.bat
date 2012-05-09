
set modulesdirectory="E:\Sites\Enrich\Excent Enrich DC7 FL Lee\Setup\7.25.2.3314\Product\DbScripts"
set connection="server=.;uid=DC7_FL_Lee_User;pwd=vc3go!!;database=Enrich_DC7_FL_Lee"
ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true



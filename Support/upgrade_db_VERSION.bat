set modulesdirectory="C:\inetpub\Sites\Enrich\Excent Enrich DC7 FL Lee\Setup\7.20.2.2820\Product\DbScripts"
set connection="server=.;uid=DC7_FL_Lee_User;pwd=vc3go!!;database=Enrich_DC7_FL_Lee"

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true



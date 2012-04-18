set modulesdirectory="E:\Inetpub\Sites\EnrichCOUPB\Setup\7.24.2.3249\Product\DbScripts"
set connection="server=10.0.1.31;uid=enrich_db_user;pwd=dsdar@2012;database=Enrich_COUPB"

ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true



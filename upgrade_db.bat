echo %time%
..\Binaries\ExecuteTask\ExecuteTask.exe upgradedb server=appdev-sql database=Richland1_Enrich_Install useintegratedsecurity=true modulesDirectory=DbScripts include=DbScripts\dbo\Include state=SC
echo %time%

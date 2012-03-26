echo off
set svc="E:\Inetpub\Sites\EnrichDCB3\TasksService\TestViewTasksService.exe"
set name="VC3 Scheduled Tasks (DCB3)"

net stop %name%

ExecuteTask.exe uninstallservice ServiceExe=%svc% ServiceName=%name%

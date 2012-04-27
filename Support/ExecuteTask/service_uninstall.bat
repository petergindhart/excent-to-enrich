echo off
set svc="E:\Inetpub\Sites\EnrichCOUPB\TasksService\TestViewTasksService.exe"
set name="VC3 Scheduled Tasks (DCB6COUPB)"

net stop %name%

ExecuteTask.exe uninstallservice ServiceExe=%svc% ServiceName=%name%

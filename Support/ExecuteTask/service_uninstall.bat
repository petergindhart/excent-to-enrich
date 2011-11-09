echo off
set svc="C:\inetpub\Sites\Enrich\Excent Enrich DC7 FL Lee\TasksService\TestViewTasksService.exe"
set name="VC3 TestView Scheduled Tasks (DC7FLLee)"

net stop %name%

ExecuteTask.exe uninstallservice ServiceExe=%svc% ServiceName=%name%

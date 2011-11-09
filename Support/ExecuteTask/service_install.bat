echo off
set exepath=C:\GIT\excent-to-enrich\Support\ExecuteTask\
set svc="C:\inetpub\Sites\Enrich\Excent Enrich DC7 FL Lee\TasksService\TestViewTasksService.exe"
set name="VC3 TestView Scheduled Tasks (DC7FLLee)"

%exepath%\ExecuteTask.exe installservice ServiceExe=%svc% ServiceName=%name%

rem net start %name%

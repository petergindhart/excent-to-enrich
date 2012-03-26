echo off
set exepath="C:\Documents and Settings\muralik\My Documents\GIT\Excent\Support\ExecuteTask\"
set svc="E:\Inetpub\Sites\EnrichDCB3\TasksService\TestViewTasksService.exe"
set name="VC3 Scheduled Tasks (EnrichDCB3)"

%exepath%\ExecuteTask.exe installservice ServiceExe=%svc% ServiceName=%name%

rem net start %name%

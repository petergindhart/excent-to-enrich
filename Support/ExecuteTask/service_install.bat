echo off
set exepath="C:\Documents and Settings\muralik\My Documents\GIT\Excent\Support\ExecuteTask\"
set svc="E:\Inetpub\Sites\EnrichCOUPB\TasksService\TestViewTasksService.exe"
set name="VC3 Scheduled Tasks (DCB6COUPB)"

%exepath%\ExecuteTask.exe installservice ServiceExe=%svc% ServiceName=%name%

rem net start %name%

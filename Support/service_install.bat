set svc="VC3 Scheduled Tasks (DCB7)"
set exe="E:\Inetpub\Sites\Enrich_DCB7_CODYC\TasksService\TestViewTasksService.exe"

ExecuteTask\ExecuteTask.exe installservice ServiceExe=%exe% ServiceName=%svc%

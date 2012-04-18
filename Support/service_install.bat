set svc="VC3 Scheduled Tasks (DC3)"
set exe="E:\Sites\Enrich\Excent Enrich DC3 FL Polk\TasksService\TestViewTasksService.exe"

ExecuteTask\ExecuteTask.exe installservice ServiceExe=%exe% ServiceName=%svc%

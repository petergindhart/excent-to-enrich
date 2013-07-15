
set newsvc="VC3 Scheduled Tasks (DC5)"
set exe="E:\Sites\Enrich\Excent Enrich DC5 CO Poudre\TasksService\TestViewTasksService.exe"

ExecuteTask\ExecuteTask.exe uninstallservice ServiceExe=%exe% ServiceName=%newsvc%

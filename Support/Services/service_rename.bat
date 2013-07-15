set oldsvc="VC3 TestView Scheduled Tasks (DC7CODYC)"
set newsvc="VC3 Scheduled Tasks (DC7)"
set exe="E:\Sites\Enrich\Excent Enrich DC Mainline\TasksService\TestViewTasksService.exe"

sc delete %oldsvc%

ExecuteTask\ExecuteTask.exe installservice ServiceExe=%exe% ServiceName=%newsvc%


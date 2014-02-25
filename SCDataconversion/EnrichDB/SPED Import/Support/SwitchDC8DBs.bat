
set webpath=E:\Sites\Enrich\Excent Enrich DC8\WebUI\
set taskpath=E:\Sites\Enrich\Excent Enrich DC8\TasksService\

set t1config=dc8t1.config
set t2config=dc8t2.config
set t3config=dc8t3.config

set w1config=dc8w1.config
set w2config=dc8w2.config
set w3config=dc8w3.config

rem change the number of the config files to point to the chosen database
copy "%webpath%%w3config%" "%webpath%web.config"
copy "%taskpath%%t3config%" "%taskpath%TestViewTasksService.exe.config"

net stop "VC3 Scheduled Tasks (DC8)"
net start "VC3 Scheduled Tasks (DC8)"

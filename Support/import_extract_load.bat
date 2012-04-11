@echo off
REM import_extract_load

set blank=-

if %1==DC2 (
  set state=FL
  set speddistrict=Brevard
  goto :end
)
if %1==DC3 (
  set state=FL
  set speddistrict=Polk
  goto :end
)
if %1==DC4 (
  set state=FL
  set speddistrict=Collier
  goto :end
)
if %1==DC5 (
  set state=CO
  set speddistrict=Poudre
  goto :end
)
if %1==DC6 (
  set state=CO
  set speddistrict=Aurora
  goto :end
)
if %1==DC7 (
  set state=FL
  set speddistrict=Lee
  goto :end
)
if %1==DCB5 (
  set state=CO
  set speddistrict=Mesa51
  goto :end
) 

goto :exit

:end
set taskservice="C:\inetpub\Sites\Enrich\Excent Enrich %1 %state% %speddistrict%\TasksService\TestViewTasksService.exe"
echo %blank%

%taskservice% /task=BDFBC128-AFA3-4215-8A36-88D4BFD21CDC DatabaseId="29D14961-928D-4BEE-9025-238496D144C6*ACBEF25A-A8EB-465B-97D8-9738F07C3023" CreateSnapshot=true

goto :fin

:exit
echo %blank%
echo My work is done here

:fin

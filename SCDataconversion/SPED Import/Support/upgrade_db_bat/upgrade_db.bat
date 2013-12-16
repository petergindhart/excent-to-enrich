@echo off

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
if %1==DCB7 (
  set state=CO
  set speddistrict=DYC
  goto :end
) 

goto :exit

:end
set connection="server=.;uid=enrich_db_user;pwd=vc3go!!;database=Enrich_%1_%state%_%speddistrict%;Application Name=%1_%state%_%speddistrict%"

echo %blank%
rem echo DB Upgrade %state% %speddistrict%
ExecuteTask\ExecuteTask.exe project projectfile="upgrade_db_project.xml" $connection=%connection% $state="%state%" $speddistrict="%speddistrict%"

goto :fin

:exit
echo %blank%
echo My work is done here

:fin

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

if %1==DC8 (
  set state=FL
  set speddistrict=Lee
  goto :end
) 
goto :exit

:end
set connection="server=.;uid=%1_%state%_%speddistrict%_User;pwd=vc3go!!;database=Enrich_%1_%state%_%speddistrict%;Application Name=%1_%state%_%speddistrict%"
set outputfile="E:\GIT\ConfigUpdates\%state%\%speddistrict%\ConfigExport_%1_%state%_%speddistrict%.sql"

echo %blank%
rem echo Config Export %state% %speddistrict%

ExecuteTask\ExecuteTask.exe project projectfile="configuration_export_project.xml" $connection=%connection% $extractdatabase="29D14961-928D-4BEE-9025-238496D144C6" $outputfile="%outputfile%"

goto :fin

:exit
echo %blank%
echo My work is done here

:fin


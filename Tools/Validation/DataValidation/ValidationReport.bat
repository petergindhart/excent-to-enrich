@echo off
echo.>ValidationSummaryReport.txt
echo.>ValidationReport_DISTRICT.txt
echo.>ValidationReport_GOAL.txt
echo.>ValidationReport_IEP.txt
echo.>ValidationReport_OBJECTIVE.txt
echo.>ValidationReport_SCHOOL.txt
echo.>ValidationReport_SELECTLISTS.txt
echo.>ValidationReport_SERVICE.txt
echo.>ValidationReport_SPEDSTAFFMEMBER.txt
echo.>ValidationReport_STAFFSCHOOL.txt
echo.>ValidationReport_STUDENT.txt
echo.>ValidationReport_TeamMember.txt
sqlcmd -i C:\ValidationSummaryReport\validationreport.sql -o log.txt
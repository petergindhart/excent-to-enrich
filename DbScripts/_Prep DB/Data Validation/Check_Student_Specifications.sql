IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_Student_Specifications')
DROP PROC dbo.Check_Student_Specifications
GO

CREATE PROC dbo.Check_Student_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE Student'
EXEC sp_executesql @stmt = @sql

SET @sql = 'DELETE Student_ValidationSummaryReport'
EXEC sp_executesql @stmt = @sql

INSERT Student
SELECT CONVERT(VARCHAR(150),stu.StudentRefID)
	  ,CONVERT(VARCHAR(50),stu.StudentLocalID)
	  ,CONVERT(VARCHAR(50),stu.StudentStateID)
	  ,CONVERT(VARCHAR(50),stu.Firstname)
	  ,CONVERT(VARCHAR(50),stu.MiddleName)
	  ,CONVERT(VARCHAR(50),stu.LastName)
	  ,CONVERT(VARCHAR(10),stu.Birthdate)
	  ,CONVERT(VARCHAR(150),stu.Gender)
	  ,CONVERT(VARCHAR(50),stu.MedicaidNumber)
	  ,CONVERT(VARCHAR(150),stu.GradeLevelCode)
	  ,CONVERT(VARCHAR(10),stu.ServiceDistrictCode)	 
	  ,CONVERT(VARCHAR(10),stu.ServiceSchoolCode)	 
	  ,CONVERT(VARCHAR(10),stu.HomeDistrictCode)	 
	  ,CONVERT(VARCHAR(10),stu.HomeSchoolCode)
	  ,CONVERT(VARCHAR(1),stu.IsHispanic)
	  ,CONVERT(VARCHAR(1),stu.IsAmericanIndian)
	  ,CONVERT(VARCHAR(1),stu.IsAsian)
	  ,CONVERT(VARCHAR(1),stu.IsBlackAfricanAmerican)
	  ,CONVERT(VARCHAR(1),stu.IsHawaiianPacIslander)
	  ,CONVERT(VARCHAR(1),stu.IsWhite)
	  ,CONVERT(VARCHAR(150),stu.Disability1Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability2Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability3Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability4Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability5Code)  	  
	  ,CONVERT(VARCHAR(150),stu.Disability6Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability7Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability8Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability9Code)	
	  ,CONVERT(VARCHAR(1),stu.EsyElig)
	  ,CONVERT(VARCHAR(10),stu.EsyTBDDate)	
	  ,CONVERT(VARCHAR(10),stu.ExitDate)
	  ,CONVERT(VARCHAR(150),stu.ExitCode)
	  ,CONVERT(VARCHAR(1),stu.SpecialEdStatus)	  
	FROM Student_LOCAL stu 
		 JOIN (SELECT StudentRefID FROM Student_LOCAL GROUP BY StudentRefID HAVING COUNT(*)= 1) ucstu 
		 ON ISNULL(stu.STUDENTREFID,'a') = ISNULL(ucstu.STUDENTREFID,'b')
		 JOIN (SELECT STUDENTREFID FROM Student_LOCAL st JOIN School sc ON (st.ServiceDistrictCode = sc.DistrictCode AND st.ServiceSchoolCode = sc.SchoolCode)) stusersch ON stu.STUDENTREFID = stusersch.STUDENTREFID
		 JOIN (SELECT STUDENTREFID FROM Student_LOCAL st JOIN School sc ON st.HomeDistrictCode = sc.DistrictCode AND st.HomeSchoolCode = sc.SchoolCode) stuhomsch ON stuhomsch.STUDENTREFID = stu.STUDENTREFID 	 
    WHERE ((DATALENGTH(stu.STUDENTREFID)/2)<= 150) 
		  AND ((DATALENGTH(stu.StudentLocalID)/2)<=50) 
		  AND ((DATALENGTH(stu.StudentStateID)/2)<=50) 
		  AND ((DATALENGTH(stu.Firstname)/2)<=50 OR stu.Firstname IS NULL) 
		  AND ((DATALENGTH(stu.MiddleName)/2)<=50 OR stu.MiddleName IS NULL) 
		  AND ((DATALENGTH(stu.LastName)/2)<=50 OR stu.LastName IS NULL) 
		  AND (((DATALENGTH(stu.Birthdate)/2)<=10 OR stu.Birthdate IS NULL) AND ISDATE(stu.BirthDate)=1) 
		  AND ((DATALENGTH(stu.Gender)/2)<=150 OR Gender IS NULL ) 
		  AND ((DATALENGTH(stu.MedicaidNumber)/2)<=50 OR stu.MedicaidNumber IS NULL) 
		  AND ((DATALENGTH(stu.GradeLevelCode)/2)<=150 OR stu.GradeLevelCode IS NULL) 
		  AND ((DATALENGTH(stu.ServiceDistrictCode)/2)<=10 OR stu.ServiceDistrictCode IS NULL) 
		  AND ((DATALENGTH(stu.ServiceSchoolCode)/2)<=10 OR stu.ServiceSchoolCode IS NULL) 
		  AND ((DATALENGTH(stu.HomeDistrictCode)/2)<=10 OR stu.HomeDistrictCode IS NULL) 
		  AND ((DATALENGTH(stu.HomeSchoolCode)/2)<=10 OR stu.HomeSchoolCode IS NULL) 
		  AND ((DATALENGTH(stu.IsHispanic)/2)<=1 OR stu.IsHispanic IS NULL) 
		  AND ((DATALENGTH(stu.IsAmericanIndian)/2)<=1 OR stu.IsAmericanIndian IS NULL) 
		  AND ((DATALENGTH(stu.IsAsian)/2)<=1 OR stu.IsAsian IS NULL) 
		  AND ((DATALENGTH(stu.IsBlackAfricanAmerican)/2)<=1 OR stu.IsBlackAfricanAmerican IS NULL) 
		  AND ((DATALENGTH(stu.IsHawaiianPacIslander)/2)<=1 OR stu.IsHawaiianPacIslander IS NULL) 
		  AND ((DATALENGTH(stu.IsWhite)/2)<=1 OR stu.IsWhite IS NULL)
		  AND ((DATALENGTH(stu.Disability1Code)/2)<=150 OR stu.Disability1Code IS NULL)  
		  AND ((DATALENGTH(stu.Disability2Code)/2)<=150 OR stu.Disability2Code IS NULL) 
		  AND ((DATALENGTH(stu.Disability3Code)/2)<=150 OR stu.Disability3Code IS NULL)
		  AND ((DATALENGTH(stu.Disability4Code)/2)<=150 OR stu.Disability4Code IS NULL) 
		  AND ((DATALENGTH(stu.Disability5Code)/2)<=150 OR stu.Disability5Code IS NULL) 
		  AND ((DATALENGTH(stu.Disability6Code)/2)<=150 OR stu.Disability6Code IS NULL)
		  AND ((DATALENGTH(stu.Disability7Code)/2)<=150 OR stu.Disability7Code IS NULL) 
		  AND ((DATALENGTH(stu.Disability8Code/2))<=150 OR stu.Disability8Code IS NULL) 
		  AND ((DATALENGTH(stu.Disability9Code)/2)<=150 OR stu.Disability9Code IS NULL)
		  AND ((DATALENGTH(stu.EsyElig)/2)<=1 OR stu.EsyElig IS NULL)
		  AND ((DATALENGTH(stu.EsyTBDDate)/2)<=10 OR stu.EsyTBDDate IS NULL) 
		  AND (((DATALENGTH(stu.ExitDate)/2)<=10 OR stu.ExitDate IS NULL) )
		  AND ((DATALENGTH(stu.ExitCode)/2)<=150 OR stu.ExitCode IS NULL)
		  AND ((DATALENGTH(stu.SpecialEdStatus)/2)<=1 OR stu.SpecialEdStatus IS NULL)
		  ---RequiredFields
		  AND (stu.StudentRefID IS NOT NULL) AND (stu.StudentLocalID IS NOT NULL) AND (stu.StudentStateID IS NOT NULL) 
		  AND (stu.Firstname IS NOT NULL) AND (stu.LastName IS NOT NULL) 
		  AND (stu.Birthdate IS NOT NULL) AND (ISDATE(stu.Birthdate)= 1)
		  AND (stu.Gender IS NOT NULL) AND (stu.GradeLevelCode IS NOT NULL) AND (stu.ServiceDistrictCode IS NOT NULL) 
		  AND (stu.ServiceSchoolCode IS NOT NULL) AND (stu.HomeDistrictCode IS NOT NULL) AND (stu.HomeSchoolCode IS NOT NULL)
		  AND (stu.IsHispanic IS NOT NULL) AND (stu.IsAmericanIndian IS NOT NULL) AND (stu.IsAsian IS NOT NULL)
		  AND (stu.IsBlackAfricanAmerican IS NOT NULL) AND (stu.IsHawaiianPacIslander IS NOT NULL) AND (stu.IsWhite IS NOT NULL)
		  AND (stu.Disability1Code IS NOT NULL) AND (stu.SpecialEdStatus IS NOT NULL)
		  AND stu.SpecialEdStatus IN ('A','E') AND stu.IsHispanic IN ('Y','N') AND stu.IsAmericanIndian IN ('Y','N')
		  AND stu.IsAsian IN ('Y','N') AND stu.IsBlackAfricanAmerican IN ('Y','N') AND stu.IsHawaiianPacIslander IN ('Y','N') 
		  AND stu.IsWhite IN ('Y','N') AND (stu.EsyElig IN ('Y','N') OR stu.EsyElig IS NULL)
		  --Referential Integrity
		  --AND NOT EXISTS(SELECT StudentRefID FROM Student_LOCAL GROUP BY StudentRefID HAVING COUNT(*)>1)
		  AND stu.Gender IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Gender')
		  AND stu.GradeLevelCode IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Grade')
		  /*
		  AND EXISTS(SELECT * FROM Student_LOCAL st JOIN School sc ON st.ServiceDistrictCode = sc.DistrictCode 
		                 AND st.ServiceSchoolCode = sc.SchoolCode)
		  AND EXISTS(SELECT * FROM Student_LOCAL st JOIN School sc ON st.HomeDistrictCode = sc.DistrictCode 
		                 AND st.HomeSchoolCode = sc.SchoolCode)
			*/
		  AND  stu.Disability1Code IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')
		  AND (stu.Disability2Code IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')OR stu.Disability2Code IS NULL)
		  AND (stu.Disability3Code IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')OR stu.Disability3Code IS NULL)
		  AND (stu.Disability4Code IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')OR stu.Disability4Code IS NULL)
		  AND (stu.Disability5Code IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')OR stu.Disability5Code IS NULL)
		  AND (stu.Disability6Code IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')OR stu.Disability6Code IS NULL)
		  AND (stu.Disability7Code IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')OR stu.Disability7Code IS NULL)
		  AND (stu.Disability8Code IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')OR stu.Disability8Code IS NULL)
		  AND (stu.Disability9Code IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')OR stu.Disability9Code IS NULL)
	
		  		  
SET @sql = 'IF OBJECT_ID(''tempdb..#Student'') IS NOT NULL DROP TABLE #Student'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO  #Student FROM Student_LOCAL 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'TotalRecords',COUNT(*)
FROM Student_LOCAL
    
INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'SuccessfulRecords',COUNT(*)
FROM Student

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'FailedRecords',((select COUNT(*) FROM Student_LOCAL) - (select COUNT(*) FROM Student))

---To Check the Datalength 
INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
    WHERE ((DATALENGTH(StudentRefID)/2)> 150 AND StudentRefID IS NOT NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of StudentRefID',COUNT(*)
FROM #Student st
    WHERE ((DATALENGTH(StudentRefID)/2)> 150 AND StudentRefID IS NOT NULL) 
    
INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of StudentLocalID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(StudentLocalID)/2)>50 AND StudentLocalID IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of StudentLocalID',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(StudentLocalID)/2)>50 AND StudentLocalID IS NOT NULL)
    
INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of StudentStateID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(StudentStateID)/2)>50 AND StudentStateID IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of StudentStateID',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(StudentStateID)/2)>50 AND StudentStateID IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of Firstname for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(Firstname)/2)>50 AND Firstname IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of Firstname',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(Firstname)/2)>50 AND Firstname IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of MiddleName for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(MiddleName)/2)>50 AND MiddleName IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of MiddleName',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(MiddleName)/2)>50 AND MiddleName IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of LastName for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(LastName)/2)>50 AND LastName IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of LastName',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(LastName)/2)>50 AND LastName IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of Birthdate for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(Birthdate)/2)>10 AND Birthdate IS NOT NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of Birthdate',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(Birthdate)/2)>10 AND Birthdate IS NOT NULL) 


INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of Gender for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(Gender)/2)>150 AND Gender IS NOT NULL ) 


INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of Gender',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(Gender)/2)>150 AND Gender IS NOT NULL ) 

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of MedicaidNumber for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(MedicaidNumber)/2)>50 AND MedicaidNumber IS NOT NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of MedicaidNumber',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(MedicaidNumber)/2)>50 AND MedicaidNumber IS NOT NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of GradeLevelCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(GradeLevelCode)/2)>150 AND GradeLevelCode IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of GradeLevelCode',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(GradeLevelCode)/2)>150 AND GradeLevelCode IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of ServiceDistrictCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(ServiceDistrictCode)/2)>10 AND ServiceDistrictCode IS NOT NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of ServiceDistrictCode',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(ServiceDistrictCode)/2)>10 AND ServiceDistrictCode IS NOT NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of ServiceSchoolCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(ServiceSchoolCode)/2)>10 AND ServiceSchoolCode IS NOT NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of ServiceSchoolCode',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(ServiceSchoolCode)/2)>10 AND ServiceSchoolCode IS NOT NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of HomeDistrictCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(HomeDistrictCode)/2)>10 AND HomeDistrictCode IS NOT NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of HomeDistrictCode',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(HomeDistrictCode)/2)>10 AND HomeDistrictCode IS NOT NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of HomeSchoolCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(HomeSchoolCode)/2)>10 AND HomeSchoolCode IS NOT NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of HomeSchoolCode',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(HomeSchoolCode)/2)>10 AND HomeSchoolCode IS NOT NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of Race fields for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(IsHispanic)/2)>1 AND IsHispanic IS NOT NULL) AND ((DATALENGTH(IsAmericanIndian)/2)>1 AND IsAmericanIndian IS NOT NULL)  AND ((DATALENGTH(IsAsian)/2)>1 AND IsAsian IS NOT NULL)  AND ((DATALENGTH(IsBlackAfricanAmerican)/2)>1 AND IsBlackAfricanAmerican IS NOT NULL)  AND ((DATALENGTH(IsHawaiianPacIslander)/2)>1 AND IsHawaiianPacIslander IS NOT NULL) AND ((DATALENGTH(IsWhite)/2)>1 AND IsWhite IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of Disability1Code for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(Disability1Code)/2)>150 AND Disability1Code IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of Disability1Code',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(Disability1Code)/2)>150 AND Disability1Code IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of Disability2Code for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE((DATALENGTH(Disability2Code)/2)>150 AND Disability2Code IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of Disability2Code',COUNT(*)
FROM #Student st
WHERE((DATALENGTH(Disability2Code)/2)>150 AND Disability2Code IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of Disability3Code for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(Disability3Code)/2)>150 AND Disability3Code IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of Disability3Code',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(Disability3Code)/2)>150 AND Disability3Code IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of Disability4Code for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(Disability4Code)/2)>150 AND Disability4Code IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of Disability4Code',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(Disability4Code)/2)>150 AND Disability4Code IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of DISABILITY5CODE for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(DISABILITY5CODE)/2)>150 AND DISABILITY5CODE IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of DISABILITY5CODE',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(DISABILITY5CODE)/2)>150 AND DISABILITY5CODE IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of DISABILITY6CODE for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(DISABILITY6CODE)/2)>150 AND DISABILITY6CODE IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of DISABILITY6CODE',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(DISABILITY6CODE)/2)>150 AND DISABILITY6CODE IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of DISABILITY7CODE for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(DISABILITY7CODE)/2)>150 AND DISABILITY7CODE IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of DISABILITY7CODE',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(DISABILITY7CODE)/2)>150 AND DISABILITY7CODE IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of DISABILITY8CODE for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(DISABILITY8CODE)/2)>150 AND DISABILITY8CODE IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of DISABILITY8CODE',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(DISABILITY8CODE)/2)>150 AND DISABILITY8CODE IS NOT NULL)


INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of DISABILITY9CODE for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(DISABILITY9CODE)/2)>150 AND DISABILITY9CODE IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of DISABILITY9CODE',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(DISABILITY9CODE)/2)>150 AND DISABILITY9CODE IS NOT NULL)


INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of EsyElig for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(EsyElig)/2)>1 AND EsyElig IS NOT NULL)


INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of EsyElig',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(EsyElig)/2)>1 AND EsyElig IS NOT NULL)


INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of EsyTBDDate for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(EsyTBDDate)/2)>10 AND EsyTBDDate IS NOT NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of EsyTBDDate',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(EsyTBDDate)/2)>10 AND EsyTBDDate IS NOT NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of ExitDate for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (((DATALENGTH(ExitDate)/2)>10 OR ExitDate IS NOT NULL) AND ISDATE(ExitDate)=0)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of ExitDate',COUNT(*)
FROM #Student st
WHERE (((DATALENGTH(ExitDate)/2)>10 OR ExitDate IS NOT NULL) AND ISDATE(ExitDate)=0)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of ExitDate for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(ExitCode)/2)>150 AND ExitCode IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of ExitCode',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(ExitCode)/2)>150 AND ExitCode IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'Please check the datalength of ExitDate for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE ((DATALENGTH(SpecialEdStatus)/2)>1 AND SpecialEdStatus IS NOT NULL)


INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'Issue in the datalength of ExitCode',COUNT(*)
FROM #Student st
WHERE ((DATALENGTH(SpecialEdStatus)/2)>1 AND SpecialEdStatus IS NOT NULL)

---Required Fields

INSERT Student_ValidationReport (Result)
SELECT 'The field "StudentRefID" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (StudentRefID IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The StudentRefID doesnot have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (StudentRefID IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "StudentLocalID" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (StudentLocalID IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The StudentLocalID doesnot have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (StudentLocalID IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "StudentStateID" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (StudentStateID IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The StudentStateID doesnot have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (StudentStateID IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "Firstname" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (Firstname IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Firstname doesnot have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (Firstname IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "LastName" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (LastName IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The LastName doesnot have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (LastName IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "Birthdate" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (Birthdate IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Birthdate does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (Birthdate IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "Gender" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (Gender IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Gender does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (Gender IS NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The field "GradeLevelCode" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (GradeLevelCode IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The GradeLevelCode does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (GradeLevelCode IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "ServiceDistrictCode" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (ServiceDistrictCode IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The ServiceDistrictCode does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (ServiceDistrictCode IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "ServiceSchoolCode" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (ServiceSchoolCode IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The ServiceSchoolCode does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (ServiceSchoolCode IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "HomeDistrictCode" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (HomeDistrictCode IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The HomeDistrictCode does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (HomeDistrictCode IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "HomeSchoolCode" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (HomeSchoolCode IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The HomeSchoolCode does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (HomeSchoolCode IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "IsHispanic" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (IsHispanic IS NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The IsHispanic does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (IsHispanic IS NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The field "IsAmericanIndian" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (IsAmericanIndian IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The IsAmericanIndian does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (IsAmericanIndian IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "IsAsian" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (IsAsian IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The IsAsian does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (IsAsian IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "IsBlackAfricanAmerican" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (IsBlackAfricanAmerican IS NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The IsBlackAfricanAmerican does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (IsBlackAfricanAmerican IS NULL)  

INSERT Student_ValidationReport (Result)
SELECT 'The field "IsHawaiianPacIslander" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (IsHawaiianPacIslander IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The IsHawaiianPacIslander does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (IsHawaiianPacIslander IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "IsHawaiianPacIslander" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (IsWhite IS NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The IsWhite does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (IsWhite IS NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The field "Disability1Code" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (Disability1Code IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Disability1Code does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (Disability1Code IS NULL) 

INSERT Student_ValidationReport (Result)
SELECT 'The field "SpecialEdStatus" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (SpecialEdStatus IS NULL) 

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The SpecialEdStatus does not have any value, It is required column',COUNT(*)
FROM #Student st
WHERE (SpecialEdStatus IS NULL) 


INSERT Student_ValidationReport (Result)
SELECT 'The field "IsHispanic" should have "Y" or "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (IsHispanic NOT IN ('Y','N') AND IsHispanic IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The IsHispanic does not have "Y"/"N".',COUNT(*)
FROM #Student st
WHERE (IsHispanic NOT IN ('Y','N') AND IsHispanic IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The field "IsAmericanIndian" should have "Y" or "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (IsAmericanIndian NOT IN ('Y','N') AND IsAmericanIndian IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The IsAmericanIndian does not have "Y"/"N".',COUNT(*)
FROM #Student st
WHERE (IsAmericanIndian NOT IN ('Y','N') AND IsAmericanIndian IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The field "IsAsian" should have "Y" or "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (IsAsian NOT IN ('Y','N') AND IsAsian IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The IsAsian does not have "Y"/"N".',COUNT(*)
FROM #Student st
WHERE (IsAsian NOT IN ('Y','N') AND IsAsian IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The field "IsBlackAfricanAmerican" should have "Y" or "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (IsBlackAfricanAmerican NOT IN ('Y','N') AND IsBlackAfricanAmerican IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The IsBlackAfricanAmerican does not have "Y"/"N".',COUNT(*)
FROM #Student st
WHERE (IsBlackAfricanAmerican NOT IN ('Y','N') AND IsBlackAfricanAmerican IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The field "IsHawaiianPacIslander" should have "Y" or "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (IsHawaiianPacIslander NOT IN ('Y','N') AND IsHawaiianPacIslander IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The IsHawaiianPacIslander does not have "Y"/"N".',COUNT(*)
FROM #Student st
WHERE (IsHawaiianPacIslander NOT IN ('Y','N') AND IsHawaiianPacIslander IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The field "IsWhite" should have "Y" or "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (IsWhite NOT IN ('Y','N') AND IsWhite IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The IsWhite does not have "Y"/"N".',COUNT(*)
FROM #Student st
WHERE (IsWhite NOT IN ('Y','N') AND IsWhite IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The field "SpecialEdStatus" should have "A" or "E". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (SpecialEdStatus NOT IN ('A','E') AND IsWhite IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The SpecialEdStatus does not have "A"/"E".',COUNT(*)
FROM #Student st
WHERE (SpecialEdStatus NOT IN ('A','E') AND IsWhite IS NOT NULL)

--To Check Referential Integrity 
INSERT Student_ValidationReport (Result)
SELECT 'The ServiceSchoolCode and ServiceDistrictCode combination does not exist in School file. The line no is '+CAST(st.LINE AS VARCHAR(50))+ '.'+ISNULL(st.STUDENTREFID,'')+'|'+ISNULL(st.StudentLocalID,'')+'|'+ISNULL(st.StudentStateID,'')+'|'+ISNULL(st.Firstname,'')+'|'+ISNULL(st.MiddleName,'')+'|'+ISNULL(st.LastName,'')+'|'+ISNULL(st.Birthdate,'')+'|'+ISNULL(st.Gender,'')+'|'+ISNULL(st.MEDICAIDNUMBER,'')+'|'+ISNULL(st.GRADELEVELCODE,'')+'|'+ISNULL(st.SERVICEDISTRICTCODE,'')+'|'+ISNULL(st.SERVICESCHOOLCODE,'')+'|'+ISNULL(st.HOMEDISTRICTCODE,'')+'|'+ISNULL(st.HOMESCHOOLCODE,'')+'|'+ISNULL(st.ISHISPANIC,'')+'|'+ISNULL(st.ISAMERICANINDIAN,'')+'|'+ISNULL(st.ISASIAN,'')+'|'+ISNULL(st.ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(st.ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(st.ISWHITE,'')+'|'+ISNULL(st.DISABILITY1CODE,'')+'|'+ISNULL(st.DISABILITY2CODE,'')+'|'+ISNULL(st.DISABILITY3CODE,'')+'|'+ISNULL(st.DISABILITY4CODE,'')+'|'+ISNULL(st.DISABILITY5CODE,'')+'|'+ISNULL(st.DISABILITY6CODE,'')+'|'+ISNULL(st.DISABILITY7CODE,'')+'|'+ISNULL(st.DISABILITY8CODE,'')+'|'+ISNULL(st.DISABILITY9CODE,'')+'|'+ISNULL(st.ESYELIG,'')+'|'+ISNULL(st.ESYTBDDATE,'')+'|'+ISNULL(st.EXITDATE,'')+'|'+ISNULL(st.EXITCODE,'')+'|'+ISNULL(st.SPECIALEDSTATUS,'')
FROM #Student st
LEFT JOIN (SELECT STUDENTREFID FROM Student_LOCAL st JOIN School sc ON st.ServiceDistrictCode = sc.DistrictCode AND st.ServiceSchoolCode = sc.SchoolCode) stusersch ON st.STUDENTREFID = stusersch.STUDENTREFID
WHERE stusersch.STUDENTREFID IS NULL

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The ServiceSchoolCode and ServiceDistrictCode combination does not exist in School file.',COUNT(*)
FROM #Student st
LEFT JOIN (SELECT STUDENTREFID FROM Student_LOCAL st JOIN School sc ON st.ServiceDistrictCode = sc.DistrictCode AND st.ServiceSchoolCode = sc.SchoolCode) stusersch ON st.STUDENTREFID = stusersch.STUDENTREFID
WHERE stusersch.STUDENTREFID IS NULL
		                 
INSERT Student_ValidationReport (Result)
SELECT 'The HomeSchoolCode and HomeDistrictCode combination does not exist in School file. The line no is '+CAST(st.LINE AS VARCHAR(50))+ '.'+ISNULL(st.STUDENTREFID,'')+'|'+ISNULL(st.StudentLocalID,'')+'|'+ISNULL(st.StudentStateID,'')+'|'+ISNULL(st.Firstname,'')+'|'+ISNULL(st.MiddleName,'')+'|'+ISNULL(st.LastName,'')+'|'+ISNULL(st.Birthdate,'')+'|'+ISNULL(st.Gender,'')+'|'+ISNULL(st.MEDICAIDNUMBER,'')+'|'+ISNULL(st.GRADELEVELCODE,'')+'|'+ISNULL(st.SERVICEDISTRICTCODE,'')+'|'+ISNULL(st.SERVICESCHOOLCODE,'')+'|'+ISNULL(st.HOMEDISTRICTCODE,'')+'|'+ISNULL(st.HOMESCHOOLCODE,'')+'|'+ISNULL(st.ISHISPANIC,'')+'|'+ISNULL(st.ISAMERICANINDIAN,'')+'|'+ISNULL(st.ISASIAN,'')+'|'+ISNULL(st.ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(st.ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(st.ISWHITE,'')+'|'+ISNULL(st.DISABILITY1CODE,'')+'|'+ISNULL(st.DISABILITY2CODE,'')+'|'+ISNULL(st.DISABILITY3CODE,'')+'|'+ISNULL(st.DISABILITY4CODE,'')+'|'+ISNULL(st.DISABILITY5CODE,'')+'|'+ISNULL(st.DISABILITY6CODE,'')+'|'+ISNULL(st.DISABILITY7CODE,'')+'|'+ISNULL(st.DISABILITY8CODE,'')+'|'+ISNULL(st.DISABILITY9CODE,'')+'|'+ISNULL(st.ESYELIG,'')+'|'+ISNULL(st.ESYTBDDATE,'')+'|'+ISNULL(st.EXITDATE,'')+'|'+ISNULL(st.EXITCODE,'')+'|'+ISNULL(st.SPECIALEDSTATUS,'')
FROM #Student st
LEFT JOIN (SELECT STUDENTREFID FROM Student_LOCAL st JOIN School sc ON st.HomeDistrictCode = sc.DistrictCode AND st.HomeSchoolCode = sc.SchoolCode) stuhomsch ON st.STUDENTREFID = stuhomsch.STUDENTREFID
WHERE stuhomsch.STUDENTREFID IS NULL

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The HomeSchoolCode and HomeDistrictCode combination does not exist in School file.',COUNT(*)
FROM #Student st
LEFT JOIN (SELECT STUDENTREFID FROM Student_LOCAL st JOIN School sc ON st.HomeDistrictCode = sc.DistrictCode AND st.HomeSchoolCode = sc.SchoolCode) stuhomsch ON st.STUDENTREFID = stuhomsch.STUDENTREFID
WHERE stuhomsch.STUDENTREFID IS NULL


INSERT Student_ValidationReport (Result)
SELECT 'The StudentRefID is unique field, It should not be repeated. The line no is '+CAST(st.LINE AS VARCHAR(50))+ '.'+ISNULL(st.STUDENTREFID,'')+'|'+ISNULL(st.StudentLocalID,'')+'|'+ISNULL(st.StudentStateID,'')+'|'+ISNULL(st.Firstname,'')+'|'+ISNULL(st.MiddleName,'')+'|'+ISNULL(st.LastName,'')+'|'+ISNULL(st.Birthdate,'')+'|'+ISNULL(st.Gender,'')+'|'+ISNULL(st.MEDICAIDNUMBER,'')+'|'+ISNULL(st.GRADELEVELCODE,'')+'|'+ISNULL(st.SERVICEDISTRICTCODE,'')+'|'+ISNULL(st.SERVICESCHOOLCODE,'')+'|'+ISNULL(st.HOMEDISTRICTCODE,'')+'|'+ISNULL(st.HOMESCHOOLCODE,'')+'|'+ISNULL(st.ISHISPANIC,'')+'|'+ISNULL(st.ISAMERICANINDIAN,'')+'|'+ISNULL(st.ISASIAN,'')+'|'+ISNULL(st.ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(st.ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(st.ISWHITE,'')+'|'+ISNULL(st.DISABILITY1CODE,'')+'|'+ISNULL(st.DISABILITY2CODE,'')+'|'+ISNULL(st.DISABILITY3CODE,'')+'|'+ISNULL(st.DISABILITY4CODE,'')+'|'+ISNULL(st.DISABILITY5CODE,'')+'|'+ISNULL(st.DISABILITY6CODE,'')+'|'+ISNULL(st.DISABILITY7CODE,'')+'|'+ISNULL(st.DISABILITY8CODE,'')+'|'+ISNULL(st.DISABILITY9CODE,'')+'|'+ISNULL(st.ESYELIG,'')+'|'+ISNULL(st.ESYTBDDATE,'')+'|'+ISNULL(st.EXITDATE,'')+'|'+ISNULL(st.EXITCODE,'')+'|'+ISNULL(st.SPECIALEDSTATUS,'')
FROM #Student st
JOIN (SELECT StudentRefID FROM Student_LOCAL GROUP BY StudentRefID HAVING COUNT(*)>1) ucstu ON ucstu.STUDENTREFID = st.STUDENTREFID

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The StudentRefID has duplicated.',COUNT(*)
FROM #Student st
JOIN (SELECT StudentRefID FROM Student_LOCAL GROUP BY StudentRefID HAVING COUNT(*)>1) ucstu ON ucstu.STUDENTREFID = st.STUDENTREFID

INSERT Student_ValidationReport (Result)
SELECT 'The Gender "'+Gender+'" does not exist in SelectLists file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE Gender NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Gender')

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Gender value does not exist in Selectlists file, It existed in Student file.',COUNT(*)
FROM #Student st
WHERE Gender NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Gender')

INSERT Student_ValidationReport (Result)
SELECT 'The GradeLevelCode "'+GradeLevelCode+'" does not exist in SelectLists file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE GradeLevelCode NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Grade')

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The GradeLevelCode value does not exist in Selectlists file, It existed in Student file.',COUNT(*)
FROM #Student st
WHERE GradeLevelCode NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Grade')


INSERT Student_ValidationReport (Result)
SELECT 'The Disability1Code "'+Disability1Code+'" does not exist in SelectLists file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE Disability1Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Disability1Code value does not exist in Selectlists file, It existed in Student file.',COUNT(*)
FROM #Student st
WHERE Disability1Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')

INSERT Student_ValidationReport (Result)
SELECT 'The Disability2Code "'+Disability2Code+'" does not exist in SelectLists file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (Disability2Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')AND Disability2Code IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Disability2Code value does not exist in Selectlists file, It existed in Student file.',COUNT(*)
FROM #Student st
WHERE (Disability2Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')AND Disability2Code IS NOT NULL)


INSERT Student_ValidationReport (Result)
SELECT 'The Disability3Code "'+Disability3Code+'" does not exist in SelectLists file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (Disability3Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab') AND Disability3Code IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Disability3Code value does not exist in Selectlists file, It existed in Student file.',COUNT(*)
FROM #Student st
WHERE (Disability3Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab') AND Disability3Code IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The Disability4Code "'+Disability4Code+'" does not exist in SelectLists file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (Disability4Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')AND Disability4Code IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Disability4Code value does not exist in Selectlists file, It existed in Student file.',COUNT(*)
FROM #Student st
WHERE (Disability4Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab')AND Disability4Code IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The Disability5Code "'+Disability5Code+'" does not exist in SelectLists file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (Disability5Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab') AND Disability5Code IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Disability5Code value does not exist in Selectlists file, It existed in Student file.',COUNT(*)
FROM #Student st
WHERE (Disability5Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab') AND Disability5Code IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The Disability6Code "'+Disability6Code+'" does not exist in SelectLists file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (Disability6Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab') AND Disability6Code IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Disability6Code value does not exist in Selectlists file, It existed in Student file.',COUNT(*)
FROM #Student st
WHERE (Disability6Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab') AND Disability6Code IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The Disability7Code "'+Disability7Code+'" does not exist in SelectLists file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (Disability7Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab') AND Disability7Code IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Disability7Code value does not exist in Selectlists file, It existed in Student file.',COUNT(*)
FROM #Student st
WHERE (Disability7Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab') AND Disability7Code IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The Disability8Code "'+Disability8Code+'" does not exist in SelectLists file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (Disability8Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab') AND Disability8Code IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Disability8Code value does not exist in Selectlists file, It existed in Student file.',COUNT(*)
FROM #Student st
WHERE (Disability8Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab') AND Disability8Code IS NOT NULL)

INSERT Student_ValidationReport (Result)
SELECT 'The Disability9Code "'+Disability9Code+'" does not exist in SelectLists file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StudentRefID,'')+'|'+ISNULL(StudentLocalID,'')+'|'+ISNULL(StudentStateID,'')+'|'+ISNULL(Firstname,'')+'|'+ISNULL(MiddleName,'')+'|'+ISNULL(LastName,'')+'|'+ISNULL(Birthdate,'')+'|'+ISNULL(Gender,'')+'|'+ISNULL(MEDICAIDNUMBER,'')+'|'+ISNULL(GRADELEVELCODE,'')+'|'+ISNULL(SERVICEDISTRICTCODE,'')+'|'+ISNULL(SERVICESCHOOLCODE,'')+'|'+ISNULL(HOMEDISTRICTCODE,'')+'|'+ISNULL(HOMESCHOOLCODE,'')+'|'+ISNULL(ISHISPANIC,'')+'|'+ISNULL(ISAMERICANINDIAN,'')+'|'+ISNULL(ISASIAN,'')+'|'+ISNULL(ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(ISWHITE,'')+'|'+ISNULL(DISABILITY1CODE,'')+'|'+ISNULL(DISABILITY2CODE,'')+'|'+ISNULL(DISABILITY3CODE,'')+'|'+ISNULL(DISABILITY4CODE,'')+'|'+ISNULL(DISABILITY5CODE,'')+'|'+ISNULL(DISABILITY6CODE,'')+'|'+ISNULL(DISABILITY7CODE,'')+'|'+ISNULL(DISABILITY8CODE,'')+'|'+ISNULL(DISABILITY9CODE,'')+'|'+ISNULL(ESYELIG,'')+'|'+ISNULL(ESYTBDDATE,'')+'|'+ISNULL(EXITDATE,'')+'|'+ISNULL(EXITCODE,'')+'|'+ISNULL(SPECIALEDSTATUS,'')
FROM #Student st
WHERE (Disability9Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab') AND Disability9Code IS NOT NULL)

INSERT Student_ValidationSummaryReport(Description,NoOfRecords)
SELECT 'The Disability9Code value does not exist in Selectlists file, It existed in Student file.',COUNT(*)
FROM #Student st
WHERE (Disability9Code NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Disab') AND Disability9Code IS NOT NULL)

	 
SET @sql = 'IF OBJECT_ID(''tempdb..#Student'') IS NOT NULL DROP TABLE #Student'	
EXEC sp_executesql @stmt = @sql   
      
END






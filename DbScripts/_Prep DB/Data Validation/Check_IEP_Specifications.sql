--Get rid off old version
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_IEP_Specifcations')
DROP PROC dbo.Check_IEP_Specifcations
GO

CREATE PROC dbo.Check_IEP_Specifcations
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE IEP'

EXEC sp_executesql @stmt = @sql

INSERT IEP 
SELECT CONVERT(VARCHAR(150),IepRefID)
	  ,CONVERT(VARCHAR(150),StudentRefID)
	  ,CONVERT(DATETIME ,IEPMeetDate)
	  ,CONVERT(DATETIME ,IEPStartDate)
	  ,CONVERT(DATETIME ,IEPEndDate)
	  ,CONVERT(DATETIME ,InitialEvaluationDate)
	  ,CONVERT(DATETIME ,LatestEvaluationDate)
	  ,CONVERT(DATETIME ,NextEvaluationDate)
	  ,CONVERT(DATETIME ,EligibilityDate)
	  ,CONVERT(DATETIME ,ConsentForServicesDate)
	  ,CONVERT(DATETIME ,ConsentForEvaluationDate)
	  ,CONVERT(VARCHAR(3) ,LREAgeGroup)
	  ,CONVERT(VARCHAR(150),LRECode)
	  ,CONVERT(int,MinutesPerWeek)
	  ,CONVERT(VARCHAR(8000),ServiceDeliveryStatement)
	FROM IEP_LOCAL
    WHERE ((DATALENGTH(IepRefID)/2)<= 150) 
		  AND ((DATALENGTH(StudentRefID)/2)<=150) 
		  AND ((DATALENGTH(IEPMeetDate)/2) <= 10 AND ISDATE(IEPMEETDATE) = 1) 
		  AND ((DATALENGTH(IEPStartDate)/2)<= 10 AND ISDATE(IEPStartDate)= 1) 
		  AND ((DATALENGTH(IEPEndDate)/2)  <= 10 AND ISDATE(IEPEndDate) = 1)
		  AND ((DATALENGTH(InitialEvaluationDate)/2)<= 10 AND (ISDATE(InitialEvaluationDate) = 1 OR InitialEvaluationDate IS NULL ) ) 
		  AND ((DATALENGTH(LatestEvaluationDate)/2)<= 10 AND ISDATE(LatestEvaluationDate) = 1) 
		  AND ((DATALENGTH(NextEvaluationDate)/2)<= 10 AND ISDATE(NextEvaluationDate) = 1)
		  AND ((DATALENGTH(EligibilityDate)/2)<= 10 AND (ISDATE(EligibilityDate) = 1 OR EligibilityDate IS NULL ) ) 
		  AND ((DATALENGTH(ConsentForServicesDate)/2)<= 10 AND ISDATE(ConsentForServicesDate) = 1) 
		  AND ((DATALENGTH(ConsentForEvaluationDate)/2)<= 10  AND (ISDATE(ConsentForEvaluationDate) = 1 OR ConsentForEvaluationDate IS NULL ))
		  AND ((DATALENGTH(LREAgeGroup)/2)<= 3) 
		  AND ((DATALENGTH(LRECode)/2)<= 150) 
		  AND (ISNUMERIC(MinutesPerWeek)=1) AND ((DATALENGTH(MinutesPerWeek)/2)<= 4)  ---!!!Need to check this out!!!
		  AND ((DATALENGTH(ServiceDeliveryStatement)/2)<= 8000) 
		  AND NOT EXISTS (SELECT IepRefID FROM IEP_LOCAL GROUP BY IepRefID HAVING COUNT(*)>1) ---!!!Need to check this out!!!
		  AND NOT EXISTS (SELECT StudentRefID FROM IEP_LOCAL GROUP BY StudentRefID HAVING COUNT(*)>1)
		  --Required Fields
		  AND (IepRefID IS NOT NULL) 
		  AND (StudentRefID IS NOT NULL)
		  AND (IEPMeetDate IS NOT NULL)
		  AND (IEPStartDate IS NOT NULL)
		  AND (IEPEndDate IS NOT NULL) 
		  AND (NextReviewDate IS NOT NULL)
		  AND (LatestEvaluationDate IS NOT NULL)
		  AND (NextEvaluationDate IS NOT NULL)
		  AND (ConsentForServicesDate IS NOT NULL)
		  AND (LRECode IS NOT NULL)
		  AND (MinutesPerWeek IS NOT NULL)
		  --Referential Integrity
		  AND StudentRefID IN (SELECT StudentRefID FROM Student_LOCAL)
		  AND LRECODE IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'LRE')
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#IEP'') IS NOT NULL DROP TABLE #IEP'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO  #IEP FROM IEP_LOCAL 

--To check the Datalength of the fields
INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of IepRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(IepRefID)/2) > 150)

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(StudentRefID)/2)> 150)

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(IEPMeetDate)/2)> 10) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(IEPStartDate)/2)> 10) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(IEPEndDate)/2)> 10) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(NextReviewDate)/2)> 10) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(InitialEvaluationDate)/2)> 10) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(LatestEvaluationDate)/2)> 10) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(NextEvaluationDate)/2)> 10) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(EligibilityDate)/2)> 10) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(ConsentForServicesDate)/2)> 10) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(ConsentForEvaluationDate)/2)> 10) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(LREAgeGroup)/2)> 3) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(LRECode)/2)> 150) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(MinutesPerWeek)/2)> 4) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(ServiceDeliveryStatement)/2)> 8000) 

---Required Fields
INSERT IEP_ValidationReport(Result)
SELECT 'The IEPRefID is required filed, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (IepRefID IS NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'The StudentRefID is required filed, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (StudentRefID IS NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'The IEPMeetDate is required filed, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (IEPMeetDate IS NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'The IEPStartDate is required filed, It can not be blank. The line no is  '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (IEPStartDate IS NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'The IEPEndDate is required filed, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (IEPEndDate IS NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'The NextReviewDate is required filed, It can not be blank. The line no is  '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (NextReviewDate IS NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'The LatestEvaluationDate is required filed, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (LatestEvaluationDate IS NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'The NextEvaluationDate is required filed, It can not be blank. The line no is  '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (NextEvaluationDate IS NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'The NextReviewDate is required filed, It can not be blank. The line no is  '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (NextReviewDate IS NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'The LatestEvaluationDate is required filed, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (LatestEvaluationDate IS NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'The NextEvaluationDate is required filed, It can not be blank. The line no is  '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (NextEvaluationDate IS NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'The ConsentForServicesDate is required filed, It can not be blank. The line no is  '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (ConsentForServicesDate IS NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'The LRECode is required filed, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (LRECode IS NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'The MinutesPerWeek is required filed, It can not be blank. The line no is  '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (MinutesPerWeek IS NULL) 

--Unique Fileds
INSERT IEP_ValidationReport(Result)
SELECT 'The "IepRefID" ' +IepRefID+' is duplicated. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE EXISTS (SELECT IepRefID FROM IEP_LOCAL GROUP BY IepRefID HAVING COUNT(*)>1) 

INSERT IEP_ValidationReport(Result)
SELECT 'The "StudentRefID" ' +StudentRefID+' is duplicated. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE EXISTS (SELECT StudentRefID FROM IEP_LOCAL GROUP BY StudentRefID HAVING COUNT(*)>1)
	 

--To Check the Referential Integrity
SELECT 'The StudentRefID "'+ StudentRefID+'" were not existed in Student File or were not validated successfully. The line no is  '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE StudentRefID NOT IN (SELECT StudentRefID FROM Student_LOCAL)

SELECT 'The LRECODE "'+ LRECODE+'" does not exist in SelectLists file, but it exists in IEP file. The line no is  '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE LRECODE IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'LRE')

--To Check the Date Format

SELECT 'Please check the date format. The line no is  '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE (ISDATE(IEPMEETDATE) = 0 AND IEPMEETDATE IS NOT NULL) OR (ISDATE(IEPStartDate) = 0 AND IEPStartDate IS NOT NULL ) 
OR (ISDATE(IEPEndDate) = 0 AND IEPEndDate IS NOT NULL) OR (ISDATE(NextReviewDate) = 0 AND NextReviewDate IS NOT NULL ) 
OR (ISDATE(InitialEvaluationDate) = 0 AND InitialEvaluationDate IS NOT NULL ) 
OR (ISDATE(LatestEvaluationDate) = 0 AND LatestEvaluationDate IS NOT NULL ) 
OR (ISDATE(NextEvaluationDate) = 0 AND NextEvaluationDate IS NOT NULL ) 
OR (ISDATE(EligibilityDate) = 0 AND EligibilityDate IS NOT NULL ) 
OR (ISDATE(ConsentForServicesDate) = 0 AND ConsentForServicesDate IS NOT NULL ) 
OR (ISDATE(ConsentForEvaluationDate) = 0 AND ConsentForEvaluationDate IS NOT NULL )

SET @sql = 'IF OBJECT_ID(''tempdb..#IEP'') IS NOT NULL DROP TABLE #IEP'	
EXEC sp_executesql @stmt = @sql   
      
END



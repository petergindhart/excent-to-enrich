--Get rid off old version
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_IEP_Specifications')
DROP PROC dbo.Check_IEP_Specifications
GO

CREATE PROC dbo.Check_IEP_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE IEP'

EXEC sp_executesql @stmt = @sql

INSERT IEP 
SELECT CONVERT(VARCHAR(150),iep.IepRefID)
	  ,CONVERT(VARCHAR(150),iep.StudentRefID)
	  ,CONVERT(DATETIME ,iep.IEPMeetDate)
	  ,CONVERT(DATETIME ,iep.IEPStartDate)
	  ,CONVERT(DATETIME ,iep.IEPEndDate)
	  ,CONVERT(DATETIME ,iep.NEXTREVIEWDATE)
	  ,CONVERT(DATETIME ,iep.InitialEvaluationDate)
	  ,CONVERT(DATETIME ,iep.LatestEvaluationDate)
	  ,CONVERT(DATETIME ,iep.NextEvaluationDate)
	  ,CONVERT(DATETIME ,iep.EligibilityDate)
	  ,CONVERT(DATETIME ,iep.ConsentForServicesDate)
	  ,CONVERT(DATETIME ,iep.ConsentForEvaluationDate)
	  ,CONVERT(VARCHAR(3) ,iep.LREAgeGroup)
	  ,CONVERT(VARCHAR(150),iep.LRECode)
	  ,CONVERT(int,iep.MinutesPerWeek)
	  ,CONVERT(VARCHAR(8000),iep.ServiceDeliveryStatement)
	FROM IEP_LOCAL iep
		 JOIN Student st ON iep.STUDENTREFID = st.StudentRefID
		 JOIN (SELECT IepRefID FROM IEP_LOCAL GROUP BY IepRefID HAVING COUNT(*)=1) ucieprefid ON iep.IEPREFID  = ucieprefid.IEPREFID
		 JOIN (SELECT StudentRefID FROM IEP_LOCAL GROUP BY StudentRefID HAVING COUNT(*)=1) ucstu ON iep.STUDENTREFID = ucstu.STUDENTREFID
    WHERE ((DATALENGTH(iep.IepRefID)/2)<= 150) 
		  AND ((DATALENGTH(iep.STUDENTREFID)/2)<=150) 
		  AND ((DATALENGTH(iep.IEPMeetDate)/2) <= 10 AND ISDATE(iep.IEPMEETDATE) = 1) 
		  AND ((DATALENGTH(iep.IEPStartDate)/2)<= 10 AND ISDATE(iep.IEPStartDate)= 1) 
		  AND ((DATALENGTH(iep.IEPEndDate)/2)  <= 10 AND ISDATE(iep.IEPEndDate) = 1)
		  AND ((DATALENGTH(iep.NextReviewDate)/2)  <= 10 AND ISDATE(iep.NextReviewDate) = 1)
		  AND ((DATALENGTH(iep.InitialEvaluationDate)/2)<= 10 AND (ISDATE(iep.InitialEvaluationDate) = 1 OR iep. InitialEvaluationDate IS NULL ) ) 
		  AND ((DATALENGTH(iep.LatestEvaluationDate)/2)<= 10 AND ISDATE(iep.LatestEvaluationDate) = 1) 
		  AND ((DATALENGTH(iep.NextEvaluationDate)/2)<= 10 AND ISDATE(iep.NextEvaluationDate) = 1)
		  AND ((DATALENGTH(iep.EligibilityDate)/2)<= 10 AND (ISDATE(iep.EligibilityDate) = 1 OR iep.EligibilityDate IS NULL ) ) 
		  AND ((DATALENGTH(iep.ConsentForServicesDate)/2)<= 10 AND ISDATE(iep.ConsentForServicesDate) = 1) 
		  AND (((DATALENGTH(iep.ConsentForEvaluationDate)/2)<= 10 OR iep.ConsentForEvaluationDate IS NULL) AND (ISDATE(iep.ConsentForEvaluationDate) = 1 OR iep.ConsentForEvaluationDate IS NULL ))
		  AND ((DATALENGTH(iep.LREAgeGroup)/2)<= 3 OR iep.LREAGEGROUP IS NULL) 
		  AND ((DATALENGTH(iep.LRECode)/2)<= 150) 
		  AND (ISNUMERIC(iep.MinutesPerWeek)=1) AND ((DATALENGTH(iep.MinutesPerWeek)/2)<= 4)  ---!!!Need to check this out!!!
		  AND ((DATALENGTH(iep.ServiceDeliveryStatement)/2)<= 8000 OR iep.SERVICEDELIVERYSTATEMENT IS NULL) 
		  --AND NOT EXISTS (SELECT IepRefID FROM IEP_LOCAL GROUP BY IepRefID HAVING COUNT(*)>1) ---!!!Need to check this out!!!
		  --AND NOT EXISTS (SELECT StudentRefID FROM IEP_LOCAL GROUP BY StudentRefID HAVING COUNT(*)>1)
		  --Required Fields
		  AND (iep.IepRefID IS NOT NULL) 
		  AND (iep.StudentRefID IS NOT NULL)
		  AND (iep.IEPMeetDate IS NOT NULL)
		  AND (iep.IEPStartDate IS NOT NULL)
		  AND (iep.IEPEndDate IS NOT NULL) 
		  AND (iep.NextReviewDate IS NOT NULL)
		  AND (iep.LatestEvaluationDate IS NOT NULL)
		  AND (iep.NextEvaluationDate IS NOT NULL)
		  AND (iep.ConsentForServicesDate IS NOT NULL)
		  AND (iep.LRECode IS NOT NULL)
		  AND (iep.MinutesPerWeek IS NOT NULL)
		  --Referential Integrity
		  --AND StudentRefID IN (SELECT StudentRefID FROM Student_LOCAL)
		  AND iep.LRECODE IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'LRE')
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#IEP'') IS NOT NULL DROP TABLE #IEP'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO  #IEP FROM IEP_LOCAL 

--To check the Datalength of the fields
INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of IepRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(IepRefID)/2) > 150 AND IepRefID IS NOT NULL)

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(StudentRefID)/2)> 150 AND StudentRefID IS NOT NULL)

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(IEPMeetDate)/2)> 10 AND IEPMeetDate IS NOT NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(IEPStartDate)/2)> 10 AND IEPStartDate IS NOT NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(IEPEndDate)/2)> 10 AND IEPEndDate IS NOT NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(NextReviewDate)/2)> 10 AND NextReviewDate IS NOT NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(InitialEvaluationDate)/2)> 10 AND InitialEvaluationDate IS NOT NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(LatestEvaluationDate)/2)> 10 AND LatestEvaluationDate IS NOT NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(NextEvaluationDate)/2)> 10 AND NextEvaluationDate IS NOT NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(EligibilityDate)/2)> 10 AND EligibilityDate IS NOT NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(ConsentForServicesDate)/2)> 10 AND ConsentForServicesDate IS NOT NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(ConsentForEvaluationDate)/2)> 10 AND ConsentForEvaluationDate IS NOT NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(LREAgeGroup)/2)> 3 AND LREAgeGroup IS NOT NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(LRECode)/2)> 150 AND LRECode IS NOT NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(MinutesPerWeek)/2)> 4 AND MinutesPerWeek IS NOT NULL) 

INSERT IEP_ValidationReport(Result)
SELECT 'Please check the datalength of StudentRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE ((DATALENGTH(ServiceDeliveryStatement)/2)> 8000 AND ServiceDeliveryStatement IS NOT NULL) 

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
SELECT 'The "IepRefID" ' +tiep.IEPREFID+' is duplicated. The line no is '+CAST(tiep.LINE AS VARCHAR(50))+ '.'+ISNULL(tiep.IEPREFID,'')+'|'+ISNULL(tiep.STUDENTREFID,'')+'|'+ISNULL(tiep.IEPMeetDate,'')+'|'+ISNULL(tiep.IEPStartDate,'')+ISNULL(tiep.IEPEndDate,'')+'|'+ISNULL(tiep.NextReviewDate,'')+'|'+ISNULL(tiep.InitialEvaluationDate,'')+'|'+ISNULL(tiep.LatestEvaluationDate,'')+'|'+ISNULL(tiep.NextEvaluationDate,'')+ISNULL(tiep.EligibilityDate,'')+'|'+ISNULL(tiep.ConsentForServicesDate,'')+'|'+ISNULL(tiep.ConsentForEvaluationDate,'')+'|'+ISNULL(tiep.LREAgeGroup,'')+'|'+ISNULL(tiep.LRECode,'')+'|'+ISNULL(tiep.MinutesPerWeek,'')+'|'+ISNULL(tiep.ServiceDeliveryStatement,'')
FROM #IEP tiep
JOIN (SELECT IepRefID FROM IEP_LOCAL GROUP BY IepRefID HAVING COUNT(*)> 1) ucieprefid ON tiep.IEPREFID  = ucieprefid.IEPREFID


INSERT IEP_ValidationReport(Result)
SELECT 'The "StudentRefID" ' +tiep.STUDENTREFID+' is duplicated. The line no is '+CAST(tiep.LINE AS VARCHAR(50))+ '.'+ISNULL(tiep.IEPREFID,'')+'|'+ISNULL(tiep.STUDENTREFID,'')+'|'+ISNULL(tiep.IEPMeetDate,'')+'|'+ISNULL(tiep.IEPStartDate,'')+ISNULL(tiep.IEPEndDate,'')+'|'+ISNULL(tiep.NextReviewDate,'')+'|'+ISNULL(tiep.InitialEvaluationDate,'')+'|'+ISNULL(tiep.LatestEvaluationDate,'')+'|'+ISNULL(tiep.NextEvaluationDate,'')+ISNULL(tiep.EligibilityDate,'')+'|'+ISNULL(tiep.ConsentForServicesDate,'')+'|'+ISNULL(tiep.ConsentForEvaluationDate,'')+'|'+ISNULL(tiep.LREAgeGroup,'')+'|'+ISNULL(tiep.LRECode,'')+'|'+ISNULL(tiep.MinutesPerWeek,'')+'|'+ISNULL(tiep.ServiceDeliveryStatement,'')
FROM #IEP tiep
JOIN (SELECT StudentRefID FROM IEP_LOCAL GROUP BY StudentRefID HAVING COUNT(*)>1) ucstu ON tiep.STUDENTREFID = ucstu.STUDENTREFID
 

--To Check the Referential Integrity
INSERT IEP_ValidationReport(Result)
SELECT 'The StudentRefID "'+ StudentRefID+'" were not existed in Student File or were not validated successfully. The line no is  '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP 
WHERE StudentRefID NOT IN (SELECT StudentRefID FROM Student)

INSERT IEP_ValidationReport(Result)
SELECT 'The LRECODE "'+ LRECODE+'" does not exist in SelectLists file, but it exists in IEP file. The line no is  '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(IepRefID,'')+'|'+ISNULL(StudentRefID,'')+'|'+ISNULL(IEPMeetDate,'')+'|'+ISNULL(IEPStartDate,'')+ISNULL(IEPEndDate,'')+'|'+ISNULL(NextReviewDate,'')+'|'+ISNULL(InitialEvaluationDate,'')+'|'+ISNULL(LatestEvaluationDate,'')+'|'+ISNULL(NextEvaluationDate,'')+ISNULL(EligibilityDate,'')+'|'+ISNULL(ConsentForServicesDate,'')+'|'+ISNULL(ConsentForEvaluationDate,'')+'|'+ISNULL(LREAgeGroup,'')+'|'+ISNULL(LRECode,'')+'|'+ISNULL(MinutesPerWeek,'')+'|'+ISNULL(ServiceDeliveryStatement,'')
FROM #IEP
WHERE LRECODE NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists WHERE TYPE= 'LRE')

--To Check the Date Format
INSERT IEP_ValidationReport(Result)
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



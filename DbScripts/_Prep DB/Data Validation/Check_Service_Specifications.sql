IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_Service_Specifcations')
DROP PROC dbo.Check_Service_Specifcations
GO

CREATE PROC dbo.Check_Service_Specifcations
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE Service'

EXEC sp_executesql @stmt = @sql

INSERT Service 
SELECT CONVERT(VARCHAR(20),ServiceType)
	  ,CONVERT(VARCHAR(150),ServiceRefId)
	  ,CONVERT(VARCHAR(150),IepRefId)
	  ,CONVERT(VARCHAR(150),ServiceDefinitionCode)
	  ,CONVERT(VARCHAR(10),BeginDate)
	  ,CONVERT(VARCHAR(10),EndDate)
	  ,CONVERT(VARCHAR(1),IsRelated)
	  ,CONVERT(VARCHAR(1),IsDirect)
	  ,CONVERT(VARCHAR(1),ExcludesFromGenEd)
	  ,CONVERT(VARCHAR(150),ServiceLocationCode)
	  ,CONVERT(VARCHAR(150),ServiceProviderTitleCode)
	  ,CONVERT(INT ,Sequence)
	  ,CONVERT(VARCHAR(1),IsESY)
	  ,CONVERT(INT ,ServiceTime)
	  ,CONVERT(VARCHAR(150),ServiceFrequencyCode)
	  ,CONVERT(VARCHAR(11) ,ServiceProviderSSN)
	  ,CONVERT(VARCHAR(150),StaffEmail)
	  ,CONVERT(VARCHAR(254),ServiceAreaText)
	FROM Service_Local
    WHERE ((DATALENGTH(ServiceType)/2)<= 20) 
		  AND ((DATALENGTH(ServiceRefId)/2)<=150) 
		  AND ((DATALENGTH(IepRefId)/2)<= 150) 
		  AND ((DATALENGTH(ServiceDefinitionCode)/2)<=150 OR ServiceDefinitionCode IS NULL)
		  AND ((DATALENGTH(BeginDate)/2)<=150 AND ISDATE(BeginDate)=1) 
		  AND (((DATALENGTH(EndDate)/2)<= 150 AND ISDATE(EndDate)= 1)OR EndDate IS NULL)  
		  AND ((DATALENGTH(IsRelated)/2)<=1) 
		  AND ((DATALENGTH(IsDirect)/2)<= 1) 
		  AND ((DATALENGTH(ExcludesFromGenEd)/2)<= 1) 
		  AND ((DATALENGTH(ServiceLocationCode)/2)<= 1) 
		  AND ((DATALENGTH(ServiceProviderTitleCode)/2)<= 1) 
		  AND ((DATALENGTH(Sequence)/2)<= 2 OR Sequence IS NULL) 
		  AND ((DATALENGTH(IsESY)/2)<= 1 OR IsESY IS NULL) 
		  AND ((DATALENGTH(ServiceTime)/2)<= 4) 
		  AND ((DATALENGTH(ServiceFrequencyCode)/2)<= 150) 
		  AND ((DATALENGTH(ServiceProviderSSN)/2)<= 11 OR ServiceProviderSSN IS NULL) 
		  AND ((DATALENGTH(StaffEmail)/2)<= 1 OR StaffEmail IS NULL) 
		  AND ((DATALENGTH(ServiceAreaText)/2)<= 254 OR ServiceAreaText IS NULL) 
		  AND NOT EXISTS (SELECT ServiceRefId FROM Service_Local GROUP BY ServiceRefId HAVING COUNT(*)>1) 
		  AND (ServiceType IS NOT NULL) 
		  AND (ServiceRefId IS NOT NULL)
		  AND (IepRefId IS NOT NULL) 
		  AND (BeginDate IS NOT NULL)
		  AND (IsRelated IS NOT NULL) 
		  AND (IsDirect IS NOT NULL)
		  AND (ExcludesFromGenEd IS NOT NULL) 
		  AND (ServiceLocationCode IS NOT NULL)
		  AND (ServiceProviderTitleCode IS NOT NULL)
		  AND (ServiceTime IS NOT NULL) 
		  AND (ServiceFrequencyCode IS NOT NULL)
		  AND IepRefId IN (SELECT IepRefId FROM IEP)
		  AND (ServiceDefinitionCode IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Service') OR ServiceDefinitionCode IS NULL)
		  AND ServiceLocationCode IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'ServLoc')
		  AND ServiceProviderTitleCode IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'ServProv')
		  AND ServiceFrequencyCode IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'ServFreq')
		  AND IsRelated IN ('Y','N')
		  AND IsDirect IN ('Y','N')
		  AND ExcludesFromGenEd IN ('Y','N')
		  AND (IsESY IN ('Y','N') OR IsESY IS NULL)
		/*
		  AND NOT EXISTS ( Select * FROM Service_LOCAL ser JOIN IEP i ON ser.IepRefId = i.IepRefID WHERE ser.BeginDate < i.IEPStartDate)
		  AND NOT EXISTS ( Select * FROM Service_LOCAL ser JOIN IEP i ON ser.IepRefId = i.IepRefID WHERE i.IEPEndDate < ser.EndDate)
		 */
		 
SET @sql = 'IF OBJECT_ID(''tempdb..#Service'') IS NOT NULL DROP TABLE #Service'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO #Service FROM Service_LOCAL 
	
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceType for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceType)/2)> 20) 

INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceRefId for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceRefId)/2)> 150) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of IepRefId for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(IepRefId)/2) > 150) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceDefinitionCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceDefinitionCode)/2)> 150 OR ServiceDefinitionCode IS NOT NULL)
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of BeginDate for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(BeginDate)/2)>150 AND ISDATE(BeginDate)=0) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of EndDate for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE (((DATALENGTH(EndDate)/2)> 150 AND ISDATE(EndDate)= 0)OR EndDate IS NOT NULL)
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of IsRelated for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(IsRelated)/2)>1) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of IsDirect for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(IsDirect)/2)> 1)  
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ExcludesFromGenEd for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ExcludesFromGenEd)/2)> 1) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceLocationCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceLocationCode)/2)> 1) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceProviderTitleCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceProviderTitleCode)/2)> 1) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of Sequence for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(Sequence)/2) > 2 OR Sequence IS NULL) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of IsESY for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(IsESY)/2) > 1 OR IsESY IS NULL)  
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceTime for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE (((DATALENGTH(ServiceTime)/2) > 4) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceFrequencyCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceFrequencyCode)/2)<= 150) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceProviderSSN for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceProviderSSN)/2) > 11 OR ServiceProviderSSN IS NOT NULL) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of StaffEmail for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(StaffEmail)/2) > 1 OR StaffEmail IS NOT NULL) 
    
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceAreaText for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceAreaText)/2)> 254 AND ServiceAreaText IS NOT NULL) 
    
--Required Fields
INSERT Service_ValidationReport(Result)
SELECT 'The field "ServiceType" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ServiceType IS NULL
    
INSERT Service_ValidationReport(Result)
SELECT 'The field "ServiceRefId" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ServiceRefId IS NULL
    
INSERT Service_ValidationReport(Result)
SELECT 'The field "IepRefId" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE IepRefId IS NULL
    
INSERT Service_ValidationReport(Result)
SELECT 'The field "BeginDate" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE BeginDate IS NULL
    
INSERT Service_ValidationReport(Result)
SELECT 'The field "IsRelated" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE IsRelated IS NULL
    
INSERT Service_ValidationReport(Result)
SELECT 'The field "IsDirect" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE IsDirect IS NULL
    
INSERT Service_ValidationReport(Result)
SELECT 'The field "ExcludesFromGenEd" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ExcludesFromGenEd IS NULL
    
INSERT Service_ValidationReport(Result)
SELECT 'The field "ServiceLocationCode" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ServiceLocationCode IS NULL
    
INSERT Service_ValidationReport(Result)
SELECT 'The field "ServiceProviderTitleCode" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ServiceProviderTitleCode IS NULL
    
INSERT Service_ValidationReport(Result)
SELECT 'The field "ServiceTime" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ServiceTime IS NULL
    
INSERT Service_ValidationReport(Result)
SELECT 'The field "ServiceFrequencyCode" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ServiceFrequencyCode IS NULL
    
---Unique Fields
INSERT Service_ValidationReport(Result)
SELECT 'The "ServiceRefId" ' +ServiceRefId+' is unique field, It can not be duplicated. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE EXISTS (SELECT ServiceRefId FROM Service_Local GROUP BY ServiceRefId HAVING COUNT(*)>1)   
    
--To check the referential integrity issues
INSERT Service_ValidationReport(Result)
SELECT 'The "IepRefId" ' +IepRefId+' does not exist in IEP file or were not validated succuessfully. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE IepRefId NOT IN (SELECT IepRefId FROM IEP)
  
INSERT Service_ValidationReport(Result)
SELECT 'The "ServiceDefinitionCode" ' +ServiceDefinitionCode+' does not exist in SelectLists file, but it existed in Service file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE ( ServiceDefinitionCode NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Service') AND ServiceDefinitionCode IS NOT NULL)

INSERT Service_ValidationReport(Result)
SELECT 'The "ServiceLocationCode" ' +ServiceLocationCode+' does not exist in SelectLists file, but it existed in Service file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE (ServiceLocationCode NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'ServLoc') AND ServiceLocationCode IS NOT NULL)

INSERT Service_ValidationReport(Result)
SELECT 'The "ServiceProviderTitleCode" ' +ServiceProviderTitleCode+' does not exist in SelectLists file, but it existed in Service file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE (ServiceProviderTitleCode IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'ServProv') AND ServiceProviderTitleCode IS NOT NULL)

INSERT Service_ValidationReport(Result)
SELECT 'The "ServiceProviderTitleCode" ' +ServiceProviderTitleCode+' does not exist in SelectLists file, but it existed in Service file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE (ServiceProviderTitleCode IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'ServProv') AND ServiceProviderTitleCode IS NOT NULL)

INSERT Service_ValidationReport(Result)
SELECT 'The "ServiceFrequencyCode" ' +ServiceFrequencyCode+' does not exist in SelectLists file, but it existed in Service file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE (ServiceFrequencyCode IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'ServFreq') AND ServiceFrequencyCode IS NOT NULL)


INSERT Service_ValidationReport(Result)
SELECT 'The field "IsRelated" should have "Y" or "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE (IsRelated NOT IN ('Y','N') AND IsRelated IS NOT NULL)


INSERT Service_ValidationReport(Result)
SELECT 'The field "IsDirect" should have "Y" or "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE (IsDirect NOT IN ('Y','N') AND IsDirect IS NOT NULL)


INSERT Service_ValidationReport(Result)
SELECT 'The field "ExcludesFromGenEd" should have "Y" or "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE (ExcludesFromGenEd NOT IN ('Y','N') AND ExcludesFromGenEd IS NOT NULL)

INSERT Service_ValidationReport(Result)
SELECT 'The field "IsESY" should have "Y" or "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE (IsESY NOT IN ('Y','N') AND IsESY IS NOT NULL)

--To Check the Date format 
INSERT Service_ValidationReport(Result)
SELECT 'Please check the date format of BeginDate and EndDate. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE ((ISDATE(BeginDate)= 0 AND EndDate IS NOT NULL)  OR (ISDATE(BeginDate)= 0 AND EndDate IS NOT NULL))

--Service StartDate is before IEP StartDate
INSERT Service_ValidationReport(Result)
SELECT 'The Service StartDate does not exist in IEP date range. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE ServiceRefId IN (Select ServiceRefId FROM Service_LOCAL ser JOIN IEP i ON ser.IepRefId = i.IepRefID WHERE ser.BeginDate < i.IEPStartDate)

--Service EndDate is after IEPEndDate
INSERT Service_ValidationReport(Result)
SELECT 'The Service EndDate does not exist in IEP date range. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE ServiceRefId IN (Select ServiceRefId FROM Service_LOCAL ser JOIN IEP i ON ser.IepRefId = i.IepRefID WHERE i.IEPEndDate < ser.EndDate)
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#Service'') IS NOT NULL DROP TABLE #Service'	
EXEC sp_executesql @stmt = @sql   
      
END

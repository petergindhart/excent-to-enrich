IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_Service_Specifcations')
DROP PROC dbo.Check_Service_Specifications
GO

CREATE PROC dbo.Check_Service_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE Service'

EXEC sp_executesql @stmt = @sql

INSERT Service 
SELECT CONVERT(VARCHAR(20),ser.ServiceType)
	  ,CONVERT(VARCHAR(150),ser.ServiceRefId)
	  ,CONVERT(VARCHAR(150),ser.IepRefId)
	  ,CONVERT(VARCHAR(150),ser.ServiceDefinitionCode)
	  ,CONVERT(VARCHAR(10),ser.BeginDate)
	  ,CONVERT(VARCHAR(10),ser.EndDate)
	  ,CONVERT(VARCHAR(1),ser.IsRelated)
	  ,CONVERT(VARCHAR(1),ser.IsDirect)
	  ,CONVERT(VARCHAR(1),ser.ExcludesFromGenEd)
	  ,CONVERT(VARCHAR(150),ser.ServiceLocationCode)
	  ,CONVERT(VARCHAR(150),ser.ServiceProviderTitleCode)
	  ,CONVERT(INT ,ser.Sequence)
	  ,CONVERT(VARCHAR(1),ser.IsESY)
	  ,CONVERT(INT ,ser.ServiceTime)
	  ,CONVERT(VARCHAR(150),ser.ServiceFrequencyCode)
	  ,CONVERT(VARCHAR(11) ,ser.ServiceProviderSSN)
	  ,CONVERT(VARCHAR(150),ser.StaffEmail)
	  ,CONVERT(VARCHAR(254),ser.ServiceAreaText)
	FROM Service_Local ser
		 JOIN (SELECT ServiceRefId FROM Service_Local GROUP BY ServiceRefId HAVING COUNT(*)= 1) ucser ON ucser.SERVICEREFID = ser.SERVICEREFID
    WHERE ((DATALENGTH(ser.SERVICETYPE)/2)<= 10) 
		  AND ((DATALENGTH(ser.ServiceRefId)/2)<=150) 
		  AND ((DATALENGTH(ser.IepRefId)/2)<= 150) 
		  AND ((DATALENGTH(ser.ServiceDefinitionCode)/2)<=150 OR ser.ServiceDefinitionCode IS NULL)
		  AND ((DATALENGTH(ser.BeginDate)/2)<=150 AND ISDATE(ser.BeginDate)=1) 
		  AND (((DATALENGTH(ser.EndDate)/2)<= 150 AND ISDATE(ser.EndDate)= 1)OR ser.EndDate IS NULL)  
		  AND ((DATALENGTH(ser.IsRelated)/2)<=1) 
		  AND ((DATALENGTH(ser.IsDirect)/2)<= 1) 
		  AND ((DATALENGTH(ser.ExcludesFromGenEd)/2)<= 1) 
		  AND ((DATALENGTH(ser.ServiceLocationCode)/2)<= 150) 
		  AND ((DATALENGTH(ser.ServiceProviderTitleCode)/2)<= 150) 
		  AND ((DATALENGTH(ser.Sequence)/2)<= 2 OR ser.Sequence IS NULL) 
		  AND ((DATALENGTH(ser.IsESY)/2)<= 1 OR ser.IsESY IS NULL) 
		  AND ((DATALENGTH(ser.ServiceTime)/2)<= 4) 
		  AND ((DATALENGTH(ser.ServiceFrequencyCode)/2)<= 150) 
		  AND ((DATALENGTH(ser.ServiceProviderSSN)/2)<= 11 OR ser.ServiceProviderSSN IS NULL) 
		  AND ((DATALENGTH(ser.StaffEmail)/2)<= 1 OR ser.StaffEmail IS NULL) 
		  AND ((DATALENGTH(ser.ServiceAreaText)/2)<= 254 OR ser.ServiceAreaText IS NULL) 
		 --AND NOT EXISTS (SELECT ServiceRefId FROM Service_Local GROUP BY ServiceRefId HAVING COUNT(*)>1) 
		  AND (ser.ServiceType IS NOT NULL) 
		  AND (ser.ServiceRefId IS NOT NULL)
		  AND (ser.IepRefId IS NOT NULL) 
		  AND (ser.BeginDate IS NOT NULL)
		  AND (ser.IsRelated IS NOT NULL) 
		  AND (ser.IsDirect IS NOT NULL)
		  AND (ser.ExcludesFromGenEd IS NOT NULL) 
		  AND (ser.ServiceLocationCode IS NOT NULL)
		  AND (ser.ServiceProviderTitleCode IS NOT NULL)
		  AND (ser.ServiceTime IS NOT NULL) 
		  AND (ser.ServiceFrequencyCode IS NOT NULL)
		  AND ser.IepRefId IN (SELECT IepRefId FROM IEP)
		  AND (ser.ServiceDefinitionCode IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'Service') OR ServiceDefinitionCode IS NULL)
		  AND ser.ServiceLocationCode IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'ServLoc')
		  AND ser.ServiceProviderTitleCode IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'ServProv')
		  AND ser.ServiceFrequencyCode IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'ServFreq')
		  AND ser.IsRelated IN ('Y','N')
		  AND ser.IsDirect IN ('Y','N')
		  AND ser.ExcludesFromGenEd IN ('Y','N')
		  AND (ser.IsESY IN ('Y','N') OR ser.IsESY IS NULL)
		  AND (ser.STAFFEMAIL IN (Select StaffEmail from SpedStaffMember) OR ser.STAFFEMAIL IS NULL)
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
    WHERE ((DATALENGTH(ServiceType)/2)> 20 AND ServiceType IS NOT NULL) 

INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceRefId for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceRefId)/2)> 150 AND ServiceRefId IS NOT NULL) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of IepRefId for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(IepRefId)/2) > 150 AND IepRefId IS NOT NULL) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceDefinitionCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceDefinitionCode)/2)> 150 AND ServiceDefinitionCode IS NOT NULL)
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of BeginDate for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(BeginDate)/2)>150 AND ISDATE(BeginDate)=0 AND BeginDate IS NOT NULL) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of EndDate for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE (((DATALENGTH(EndDate)/2)> 150 AND ISDATE(EndDate)= 0) AND EndDate IS NOT NULL)
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of IsRelated for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(IsRelated)/2)>1 AND IsRelated IS NOT NULL) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of IsDirect for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(IsDirect)/2)> 1 AND IsDirect IS NOT NULL)  
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ExcludesFromGenEd for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ExcludesFromGenEd)/2)> 1 AND ExcludesFromGenEd IS NOT NULL) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceLocationCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceLocationCode)/2)> 1 AND ServiceLocationCode IS NOT NULL) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceProviderTitleCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceProviderTitleCode)/2)> 1 AND ServiceProviderTitleCode IS NOT NULL) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of Sequence for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(Sequence)/2) > 2 AND Sequence IS NOT NULL) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of IsESY for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(IsESY)/2) > 1 AND IsESY IS NOT NULL)  
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceTime for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE (((DATALENGTH(ServiceTime)/2) > 4) AND ServiceTime IS NOT NULL) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceFrequencyCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceFrequencyCode)/2)<= 150 AND ServiceFrequencyCode IS NOT NULL) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of ServiceProviderSSN for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(ServiceProviderSSN)/2) > 11 AND ServiceProviderSSN IS NOT NULL) 
    
INSERT Service_ValidationReport(Result)
SELECT 'Please check the datalength of StaffEmail for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
    WHERE ((DATALENGTH(StaffEmail)/2) > 1 AND StaffEmail IS NOT NULL) 
    
    
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
SELECT 'The "ServiceRefId" ' +ser.SERVICEREFID+' is unique field, It can not be duplicated. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ser.SERVICEREFID,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service ser
JOIN (SELECT ServiceRefId FROM Service_Local GROUP BY ServiceRefId HAVING COUNT(*)>1) ucser
ON ucser.SERVICEREFID = ser.SERVICEREFID 
    
--To check the referential integrity issues
INSERT Service_ValidationReport(Result)
SELECT 'The "IepRefId" ' +IepRefId+' does not exist in IEP file or were not validated succuessfully. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE IepRefId NOT IN (SELECT IepRefId FROM IEP)
 
INSERT Service_ValidationReport(Result)
SELECT 'The "StaffEmail" ' +StaffEmail+' does not exist in IEP file or were not validated succuessfully. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE (StaffEmail NOT IN (SELECT STAFFEMAIL FROM SpedStaffMember) AND StaffEmail IS NOT NULL)

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
WHERE (ServiceProviderTitleCode NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'ServProv') AND ServiceProviderTitleCode IS NOT NULL)

INSERT Service_ValidationReport(Result)
SELECT 'The "ServiceFrequencyCode" ' +ServiceFrequencyCode+' does not exist in SelectLists file, but it existed in Service file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM #Service 
WHERE (ServiceFrequencyCode NOT IN (SELECT LEGACYSPEDCODE FROM SelectLists_LOCAL WHERE TYPE= 'ServFreq') AND ServiceFrequencyCode IS NOT NULL)


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

--Get rid off old version
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_School_Specifcations')
DROP PROC dbo.Check_School_Specifcations
GO

CREATE PROC dbo.Check_School_Specifcations
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE School'

EXEC sp_executesql @stmt = @sql

INSERT School 
SELECT CONVERT(VARCHAR(10) ,sch.SCHOOLCODE)
	  ,CONVERT(VARCHAR(255),sch.SCHOOLNAME)
	  ,CONVERT(VARCHAR(10) ,sch.DISTRICTCODE)
	  ,CONVERT(int ,sch.MINUTESPERWEEK)
	FROM School_LOCAL sch
		 JOIN District dt ON dt.DistrictCode = Sch.DISTRICTCODE
		 JOIN (SELECT SchoolCode,DISTRICTCODE FROM School_LOCAL GROUP BY SchoolCode,DISTRICTCODE HAVING COUNT(*)=1) ucsch
		 ON sch.SCHOOLCODE = ucsch.SCHOOLCODE
    WHERE ((DATALENGTH(sch.SCHOOLCODE)/2)<= 10) 
		  AND ((DATALENGTH(sch.SCHOOLNAME)/2)<=254) 
		  AND ((DATALENGTH(sch.DISTRICTCODE)/2)<= 10) 
		  AND (ISNUMERIC(sch.MINUTESPERWEEK)=1) AND ((DATALENGTH(sch.MINUTESPERWEEK)/2)<= 4)  ---!!!Need to check this out!!!
		 -- AND NOT EXISTS (SELECT SchoolCode,DISTRICTCODE FROM School_LOCAL GROUP BY SchoolCode,DISTRICTCODE HAVING COUNT(*)>1) ---!!!Need to check this out!!!
		  AND (sch.SCHOOLCODE IS NOT NULL) 
		  AND (sch.SCHOOLNAME IS NOT NULL)
		  AND (sch.DISTRICTCODE IS NOT NULL)
		  AND (sch.MINUTESPERWEEK IS NOT NULL)
		 -- AND DistrictCode IN (SELECT DISTINCT DistrictCode FROM District_LOCAL)
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#School'') IS NOT NULL DROP TABLE #School'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO  #School FROM School_LOCAL 

--To check the Datalength of the fields
INSERT District_ValidationReport (Result)
SELECT 'Please check the datalength of SchoolCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(SchoolCode,'')+'|'+ISNULL(SchoolName,'')+'|'+ISNULL(DistrictCode,'')+'|'+ISNULL(MinutesPerWeek,'')
FROM #School 
    WHERE ((DATALENGTH(SchoolCode)/2)> 10) 

INSERT District_ValidationReport (Result)  
SELECT 'Please check the datalenth of SchoolName for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(SchoolCode,'')+'|'+ISNULL(SchoolName,'')+'|'+ISNULL(DistrictCode,'')+'|'+ISNULL(MinutesPerWeek,'')
FROM #School 
     WHERE ((DATALENGTH(SchoolName)/2)>254) 

INSERT District_ValidationReport (Result)
SELECT 'Please check the datalenth of DistrictCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(SchoolCode,'')+'|'+ISNULL(SchoolName,'')+'|'+ISNULL(DistrictCode,'')+'|'+ISNULL(MinutesPerWeek,'')
FROM #School 
WHERE ((DATALENGTH(DistrictCode)/2)> 10) 

INSERT District_ValidationReport (Result)
SELECT 'Please check the datalenth of MinutesPerWeek for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(SchoolCode,'')+'|'+ISNULL(SchoolName,'')+'|'+ISNULL(DistrictCode,'')+'|'+ISNULL(MinutesPerWeek,'')
FROM #School 
WHERE ((ISNUMERIC(MinutesPerWeek)=0) AND ((DATALENGTH(MinutesPerWeek)/2)>4) )

---Required Fields
INSERT District_ValidationReport(Result)
SELECT 'The field "SchoolCode" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(SchoolCode,'')+'|'+ISNULL(SchoolName,'')+'|'+ISNULL(DistrictCode,'')+'|'+ISNULL(MinutesPerWeek,'')
FROM #School 
WHERE (SchoolCode IS NULL) 

INSERT District_ValidationReport (Result)
SELECT 'The field "SchoolName" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(SchoolCode,'')+'|'+ISNULL(SchoolName,'')+'|'+ISNULL(DistrictCode,'')+'|'+ISNULL(MinutesPerWeek,'')
FROM #School 
WHERE (SchoolName IS NULL) 

INSERT District_ValidationReport(Result)
SELECT 'The field "DistrictCode" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(SchoolCode,'')+'|'+ISNULL(SchoolName,'')+'|'+ISNULL(DistrictCode,'')+'|'+ISNULL(MinutesPerWeek,'')
FROM #School 
WHERE (DistrictCode IS NULL) 

INSERT District_ValidationReport(Result)
SELECT 'The field "MinutesPerWeek" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(SchoolCode,'')+'|'+ISNULL(SchoolName,'')+'|'+ISNULL(DistrictCode,'')+'|'+ISNULL(MinutesPerWeek,'')
FROM #School 
WHERE (MinutesPerWeek IS NULL) 

--To Check Duplicate Records
INSERT District_ValidationReport (Result)
SELECT Distinct 'The "SchoolCode" ' +SchoolCode+' is duplicated. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(SchoolCode,'')+'|'+ISNULL(SchoolName,'')+'|'+ISNULL(DistrictCode,'')+'|'+ISNULL(MinutesPerWeek,'')
FROM #School tsch
JOIN (SELECT SchoolCode,DISTRICTCODE FROM School_LOCAL GROUP BY SchoolCode,DISTRICTCODE HAVING COUNT(*)>1) ucsch
		 ON tsch.SCHOOLCODE = ucsch.SCHOOLCODE
 
	
--To Check the Referential Integrity
INSERT District_ValidationReport (Result)
SELECT 'The DistrictCode "' +tsch.DISTRICTCODE+'" does not exist in District File or were not validated successfully. The line no is '+CAST(tsch.LINE AS VARCHAR(50))+ '.'+ISNULL(tsch.SCHOOLCODE,'')+'|'+ISNULL(tsch.SCHOOLNAME,'')+'|'+ISNULL(tsch.DISTRICTCODE,'')+'|'+ISNULL(tsch.MINUTESPERWEEK,'')
FROM #School tsch
LEFT JOIN District dt ON dt.DistrictCode = tsch.DISTRICTCODE
WHERE dt.DistrictCode IS NOT NULL

SET @sql = 'IF OBJECT_ID(''tempdb..#School'') IS NOT NULL DROP TABLE #School'	
EXEC sp_executesql @stmt = @sql   
      
END



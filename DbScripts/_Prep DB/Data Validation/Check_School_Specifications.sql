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
SELECT CONVERT(VARCHAR(10) ,SchoolCode)
	  ,CONVERT(VARCHAR(255),SchoolName)
	  ,CONVERT(VARCHAR(10) ,DistrictCode)
	  ,CONVERT(int,MinutesPerWeek)
	FROM School_LOCAL
    WHERE ((DATALENGTH(SchoolCode)/2)<= 10) 
		  AND ((DATALENGTH(SchoolName)/2)<=254) 
		  AND ((DATALENGTH(DistrictCode)/2)<= 10) 
		  AND (ISNUMERIC(MinutesPerWeek)=1) AND ((DATALENGTH(MinutesPerWeek)/2)<= 4)  ---!!!Need to check this out!!!
		  AND NOT EXISTS (SELECT SchoolCode,DISTRICTCODE FROM School_LOCAL GROUP BY SchoolCode,DISTRICTCODE HAVING COUNT(*)>1) ---!!!Need to check this out!!!
		  AND (SchoolCode IS NOT NULL) 
		  AND (SchoolName IS NOT NULL)
		  AND (DistrictCode IS NOT NULL)
		  AND (MinutesPerWeek IS NOT NULL)
		  AND DistrictCode IN (SELECT DISTINCT DistrictCode FROM District_LOCAL)
		  
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
SELECT 'The "SchoolCode" ' +SchoolCode+' is duplicated. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(SchoolCode,'')+'|'+ISNULL(SchoolName,'')+'|'+ISNULL(DistrictCode,'')+'|'+ISNULL(MinutesPerWeek,'')
FROM #School 
WHERE EXISTS (SELECT SchoolCode,DISTRICTCODE FROM School_LOCAL GROUP BY SchoolCode,DISTRICTCODE HAVING COUNT(*)>1) 
	 
--To Check the Referential Integrity

INSERT District_ValidationReport (Result)
SELECT 'The DistrictCode "' +DistrictCode+'" does not exist in District File or were not validated successfully. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(SchoolCode,'')+'|'+ISNULL(SchoolName,'')+'|'+ISNULL(DistrictCode,'')+'|'+ISNULL(MinutesPerWeek,'')
FROM #School
WHERE DistrictCode IN (SELECT DISTINCT DistrictCode FROM District_LOCAL)

SET @sql = 'IF OBJECT_ID(''tempdb..#School'') IS NOT NULL DROP TABLE #School'	
EXEC sp_executesql @stmt = @sql   
      
END



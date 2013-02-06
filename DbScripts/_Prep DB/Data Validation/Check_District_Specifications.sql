IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_District_Specifications')
DROP PROC dbo.Check_District_Specifications
GO

CREATE PROC dbo.Check_District_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE District'
EXEC sp_executesql @stmt = @sql

SET @sql = 'DELETE District_ValidationSummaryReport'
EXEC sp_executesql @stmt = @sql

INSERT District 
SELECT CONVERT(VARCHAR(10),td.DISTRICTCODE)
	  ,CONVERT(VARCHAR(255),td.DISTRICTNAME)
	FROM District_Local td
		 JOIN (SELECT DISTRICTCODE FROM District_Local GROUP BY DISTRICTCODE HAVING COUNT(*)=1) uctd ON uctd.DISTRICTCODE =td.DISTRICTCODE 
    WHERE ((DATALENGTH(td.DISTRICTCODE)/2)<= 10) 
		  AND ((DATALENGTH(td.DISTRICTNAME)/2)<=255) 
		  --AND NOT EXISTS (SELECT DISTRICTCODE FROM District_Local GROUP BY DISTRICTCODE HAVING COUNT(*)>1) 
		  AND (td.DISTRICTCODE IS NOT NULL) 
		  AND (td.DISTRICTNAME IS NOT NULL)
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#District'') IS NOT NULL DROP TABLE #District'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO  #District FROM District_LOCAL 

INSERT District_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'TotalRecords',COUNT(*)
FROM District_LOCAL
    
INSERT District_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'SuccessfulRecords',COUNT(*)
FROM District

INSERT District_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'FailedRecords',((select COUNT(*) FROM District_LOCAL) - (select COUNT(*) FROM District))

INSERT District_ValidationReport (Result)
SELECT 'Please check the datalength of DistrictCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(DISTRICTCODE,'')+'|'+ISNULL(DISTRICTNAME,'')
FROM #District 
    WHERE ((DATALENGTH(DistrictCode)/2)>20 AND DistrictCode IS NOT NULL)
    
INSERT District_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'Issue in the datalength of DistrictCode',COUNT(*)
FROM #District 
    WHERE ((DATALENGTH(DistrictCode)/2)>20 AND DistrictCode IS NOT NULL)

INSERT District_ValidationReport (Result)  
SELECT 'Please check the datalenth of DistrictName for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(DISTRICTCODE,'')+'|'+ISNULL(DISTRICTNAME,'')
FROM #District dt
    WHERE ((DATALENGTH(dt.DISTRICTNAME)/2)>255 AND DISTRICTNAME IS NOT NULL)

INSERT District_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'Issue in the datalength of DistrictName',COUNT(*)
FROM #District 
    WHERE ((DATALENGTH(DISTRICTNAME)/2)>255 AND DISTRICTNAME IS NOT NULL)  

INSERT District_ValidationReport (Result)
SELECT 'The field "DistrictCode" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(DISTRICTCODE,'')+'|'+ISNULL(DISTRICTNAME,'')
FROM #District dt
WHERE (DISTRICTCODE IS NULL) 

INSERT District_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'The DistrictCode doesnot contain any record',COUNT(*)
FROM #District 
    WHERE (DISTRICTCODE IS NULL)  

INSERT District_ValidationReport(Result)
SELECT 'The field "DistrictName" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(DISTRICTCODE,'')+'|'+ISNULL(DISTRICTNAME,'')
FROM #District dt
WHERE (DISTRICTNAME IS NULL) 

INSERT District_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'The DISTRICTNAME doesnot contain any record',COUNT(*)
FROM #District 
    WHERE (DISTRICTNAME IS NULL)  
    
INSERT District_ValidationReport (Result)
SELECT 'The "DistrictCode"' +dt.DISTRICTCODE+'is unique field, It can not be duplicated. The line no is '+CAST(dt.LINE AS VARCHAR(50))+ '.'+ISNULL(dt.DISTRICTCODE,'')+'|'+ISNULL(dt.DISTRICTNAME,'')
FROM #District dt
JOIN (SELECT DISTRICTCODE FROM District_Local GROUP BY DISTRICTCODE HAVING COUNT(*)>1) uctd ON uctd.DISTRICTCODE =dt.DISTRICTCODE 

INSERT District_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'The DISTRICTCODE has duplicated.',COUNT(*)
FROM #District dt
JOIN (SELECT DISTRICTCODE FROM District_Local GROUP BY DISTRICTCODE HAVING COUNT(*)>1) uctd ON uctd.DISTRICTCODE =dt.DISTRICTCODE 

SET @sql = 'IF OBJECT_ID(''tempdb..#District'') IS NOT NULL DROP TABLE #District'	
EXEC sp_executesql @stmt = @sql   
      
END

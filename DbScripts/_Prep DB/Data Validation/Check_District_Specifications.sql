IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_District_Specifcations')
DROP PROC dbo.Check_District_Specifcations
GO

CREATE PROC dbo.Check_District_Specifcations
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE District'

EXEC sp_executesql @stmt = @sql

INSERT District 
SELECT CONVERT(VARCHAR(10),DISTRICTCODE)
	  ,CONVERT(VARCHAR(255),DISTRICTNAME)
	FROM District_Local
    WHERE ((DATALENGTH(DistrictCode)/2)<= 10) 
		  AND ((DATALENGTH(DISTRICTNAME)/2)<=255) 
		  AND NOT EXISTS (SELECT DISTRICTCODE FROM District_Local GROUP BY DISTRICTCODE HAVING COUNT(*)>1) 
		  AND (DISTRICTCODE IS NOT NULL) 
		  AND (DISTRICTNAME IS NOT NULL)
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#District'') IS NOT NULL DROP TABLE #District'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO  #District FROM District_LOCAL 
	
INSERT District_ValidationReport (Result)
SELECT 'Please check the datalength of DistrictCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(DISTRICTCODE,'')+'|'+ISNULL(DISTRICTNAME,'')
FROM #District dt
    WHERE ((DATALENGTH(dt.DistrictCode)/2)>20)

INSERT District_ValidationReport (Result)  
SELECT 'Please check the datalenth of DistrictName for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(DISTRICTCODE,'')+'|'+ISNULL(DISTRICTNAME,'')
FROM #District dt
    WHERE ((DATALENGTH(dt.DISTRICTNAME)/2)>255)


INSERT District_ValidationReport (Result)
SELECT 'The field "DistrictCode" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(DISTRICTCODE,'')+'|'+ISNULL(DISTRICTNAME,'')
FROM #District dt
WHERE (DISTRICTCODE IS NULL) 

INSERT District_ValidationReport(Result)
SELECT 'The field "DistrictName" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(DISTRICTCODE,'')+'|'+ISNULL(DISTRICTNAME,'')
FROM #District dt
WHERE (DISTRICTNAME IS NULL) 

INSERT District_ValidationReport (Result)
SELECT 'The "DistrictCode"' +dt.DISTRICTCODE+'is unique field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(DISTRICTCODE,'')+'|'+ISNULL(DISTRICTNAME,'')
FROM #District dt
WHERE EXISTS (SELECT DISTRICTCODE FROM District_Local GROUP BY DISTRICTCODE HAVING COUNT(*)>1) 
	 
SET @sql = 'IF OBJECT_ID(''tempdb..#District'') IS NOT NULL DROP TABLE #District'	
EXEC sp_executesql @stmt = @sql   
      
END

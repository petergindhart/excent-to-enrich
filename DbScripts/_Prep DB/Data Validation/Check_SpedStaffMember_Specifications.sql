IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_SpedStaffMember_Specifcations')
DROP PROC dbo.Check_SpedStaffMember_Specifcations
GO

CREATE PROC dbo.Check_SpedStaffMember_Specifcations
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE SpedStaffMember'

EXEC sp_executesql @stmt = @sql

INSERT SpedStaffMember 
SELECT CONVERT(VARCHAR(150),StaffEmail)
	  ,CONVERT(VARCHAR(50) ,LASTNAME)
	  ,CONVERT(VARCHAR(50) ,Firstname)
	  ,CONVERT(VARCHAR(50) ,EnrichRole)
	FROM SpedStaffMember_LOCAL
    WHERE ((DATALENGTH(StaffEmail)/2)<= 150 OR StaffEmail IS NULL) 
		  AND ((DATALENGTH(LASTNAME)/2)<=50 OR LASTNAME IS NULL) 
		  AND ((DATALENGTH(Firstname)/2)<= 50 OR Firstname IS NULL) 
		  AND ((DATALENGTH(EnrichRole)/2)<=50 OR EnrichRole IS NULL) 
		  AND NOT EXISTS (SELECT StaffEmail FROM SpedStaffMember_LOCAL GROUP BY StaffEmail HAVING COUNT(*)>1) 
		  AND (StaffEmail IS NOT NULL) 
		  AND (Lastname   IS NOT NULL)
		  AND (Firstname  IS NOT NULL)
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#SpedStaffMember'') IS NOT NULL DROP TABLE #SpedStaffMember'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO  #SpedStaffMember FROM SpedStaffMember_LOCAL 
	
INSERT SpedStaffMember_ValidationReport (Result)
SELECT 'Please check the datalength of StaffEmail for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
    WHERE ((DATALENGTH(StaffEmail)/2)>150)

INSERT SpedStaffMember_ValidationReport (Result) 
SELECT 'Please check the datalength of StaffEmail for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
    WHERE ((DATALENGTH(LASTNAME)/2)>50)
    
INSERT SpedStaffMember_ValidationReport (Result)
SELECT 'Please check the datalength of StaffEmail for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
    WHERE ((DATALENGTH(Firstname)/2)>50)

INSERT SpedStaffMember_ValidationReport (Result) 
SELECT 'Please check the datalength of StaffEmail for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
    WHERE ((DATALENGTH(EnrichRole)/2)>50)

--Required Fields
INSERT SpedStaffMember_ValidationReport (Result) 
SELECT 'The StaffEmail is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
WHERE (StaffEmail IS NOT NULL) 

INSERT SpedStaffMember_ValidationReport (Result) 
SELECT 'The StaffEmail is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
WHERE (Lastname IS NULL) 

INSERT SpedStaffMember_ValidationReport (Result) 
SELECT 'The StaffEmail is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
WHERE (Firstname IS NULL) 

--Unique Fields
INSERT SpedStaffMember_ValidationReport (Result) 
SELECT 'The StaffEmail'+STAFFEMAIL+' is unique field, It can not be duplicated. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
WHERE EXISTS (SELECT StaffEmail FROM SpedStaffMember_LOCAL GROUP BY StaffEmail HAVING COUNT(*)>1) 
	 
SET @sql = 'IF OBJECT_ID(''tempdb..#SpedStaffMember'') IS NOT NULL DROP TABLE #SpedStaffMember'	
EXEC sp_executesql @stmt = @sql   
      
END

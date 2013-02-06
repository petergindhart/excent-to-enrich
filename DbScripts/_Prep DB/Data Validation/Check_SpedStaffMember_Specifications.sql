IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_SpedStaffMember_Specifications')
DROP PROC dbo.Check_SpedStaffMember_Specifications
GO

CREATE PROC dbo.Check_SpedStaffMember_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE SpedStaffMember'
EXEC sp_executesql @stmt = @sql

EXEC sp_executesql @stmt = @sql
SET @sql = 'DELETE SpedStaffMember_ValidationSummaryReport'

INSERT SpedStaffMember 
SELECT CONVERT(VARCHAR(150),spedstaff.STAFFEMAIL)
	  ,CONVERT(VARCHAR(50) ,spedstaff.LASTNAME)
	  ,CONVERT(VARCHAR(50) ,spedstaff.FIRSTNAME)
	  ,CONVERT(VARCHAR(50) ,spedstaff.ENRICHROLE)
	FROM SpedStaffMember_LOCAL spedstaff 
		 JOIN (SELECT StaffEmail FROM SpedStaffMember_LOCAL GROUP BY StaffEmail HAVING COUNT(*)=1) ucspedstaff ON spedstaff.STAFFEMAIL = ucspedstaff.STAFFEMAIL
    WHERE ((DATALENGTH(spedstaff.STAFFEMAIL)/2)<= 150 OR spedstaff.STAFFEMAIL IS NULL) 
		  AND ((DATALENGTH(spedstaff.LASTNAME)/2)<=50 OR spedstaff.LASTNAME IS NULL) 
		  AND ((DATALENGTH(spedstaff.FIRSTNAME)/2)<= 50 OR spedstaff.FIRSTNAME IS NULL) 
		  AND ((DATALENGTH(spedstaff.ENRICHROLE)/2)<=50 OR spedstaff.ENRICHROLE IS NULL) 
		  --AND NOT EXISTS (SELECT StaffEmail FROM SpedStaffMember_LOCAL GROUP BY StaffEmail HAVING COUNT(*)>1) 
		  AND (spedstaff.StaffEmail IS NOT NULL) 
		  AND (spedstaff.Lastname   IS NOT NULL)
		  AND (spedstaff.Firstname  IS NOT NULL)
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#SpedStaffMember'') IS NOT NULL DROP TABLE #SpedStaffMember'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO  #SpedStaffMember FROM SpedStaffMember_LOCAL 

INSERT SpedStaffMember_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'TotalRecords',COUNT(*)
FROM SpedStaffMember_LOCAL
    
INSERT SpedStaffMember_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'SuccessfulRecords',COUNT(*)
FROM SpedStaffMember

INSERT SpedStaffMember_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'FailedRecords',((select COUNT(*) FROM SpedStaffMember_LOCAL) - (select COUNT(*) FROM SpedStaffMember))
	
INSERT SpedStaffMember_ValidationReport (Result)
SELECT 'Please check the datalength of StaffEmail for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
    WHERE ((DATALENGTH(StaffEmail)/2)>150 AND StaffEmail IS NOT NULL)

INSERT SpedStaffMember_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'Issue in the datalength of DistrictCode',COUNT(*)
FROM #SpedStaffMember 
    WHERE ((DATALENGTH(StaffEmail)/2)>150 AND StaffEmail IS NOT NULL)
    
INSERT SpedStaffMember_ValidationReport (Result) 
SELECT 'Please check the datalength of StaffEmail for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
    WHERE ((DATALENGTH(LASTNAME)/2)>50 AND LASTNAME IS NOT NULL)
    
INSERT SpedStaffMember_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'Issue in the datalength of LASTNAME',COUNT(*)
FROM #SpedStaffMember 
    WHERE ((DATALENGTH(LASTNAME)/2)>50 AND LASTNAME IS NOT NULL)
    
INSERT SpedStaffMember_ValidationReport (Result)
SELECT 'Please check the datalength of StaffEmail for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
    WHERE ((DATALENGTH(Firstname)/2)>50 AND Firstname IS NOT NULL)
    
INSERT SpedStaffMember_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'Issue in the datalength of Firstname',COUNT(*)
FROM #SpedStaffMember 
    WHERE ((DATALENGTH(Firstname)/2)>50 AND Firstname IS NOT NULL)

INSERT SpedStaffMember_ValidationReport (Result) 
SELECT 'Please check the datalength of EnrichRole for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
    WHERE ((DATALENGTH(EnrichRole)/2)>50 AND EnrichRole IS NOT NULL)

INSERT SpedStaffMember_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'Issue in the datalength of EnrichRole',COUNT(*)
FROM #SpedStaffMember 
    WHERE ((DATALENGTH(EnrichRole)/2)>50 AND EnrichRole IS NOT NULL)
    
--Required Fields
INSERT SpedStaffMember_ValidationReport (Result) 
SELECT 'The StaffEmail is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
WHERE (StaffEmail IS NULL) 

INSERT SpedStaffMember_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'The StaffEmail doesnot have any value, It is required column',COUNT(*)
FROM #SpedStaffMember 
WHERE (StaffEmail IS NULL) 
    
INSERT SpedStaffMember_ValidationReport (Result) 
SELECT 'The StaffEmail is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
WHERE (Lastname IS NULL) 

INSERT SpedStaffMember_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'The Lastname doesnot have any value, It is required column',COUNT(*)
FROM #SpedStaffMember 
WHERE (Lastname IS NULL) 

INSERT SpedStaffMember_ValidationReport (Result) 
SELECT 'The StaffEmail is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(LASTNAME,'')+ISNULL(Firstname,'')+'|'+ISNULL(EnrichRole,'')
FROM #SpedStaffMember 
WHERE (Firstname IS NULL) 

INSERT SpedStaffMember_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'The Firstname doesnot have any value, It is required column',COUNT(*)
FROM #SpedStaffMember 
WHERE (Firstname IS NULL) 

--Unique Fields
INSERT SpedStaffMember_ValidationReport (Result) 
SELECT 'The StaffEmail'+tspedstaff.STAFFEMAIL+' is unique field, It can not be duplicated. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(tspedstaff.STAFFEMAIL,'')+'|'+ISNULL(tspedstaff.LASTNAME,'')+ISNULL(tspedstaff.FIRSTNAME,'')+'|'+ISNULL(tspedstaff.ENRICHROLE,'')
FROM #SpedStaffMember tspedstaff
JOIN (SELECT StaffEmail FROM SpedStaffMember_LOCAL GROUP BY StaffEmail HAVING COUNT(*)>1) ucspedstaff ON tspedstaff.STAFFEMAIL = ucspedstaff.STAFFEMAIL

INSERT SpedStaffMember_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'The StaffEmail record has duplicated.',COUNT(*)
FROM #SpedStaffMember tspedstaff
JOIN (SELECT StaffEmail FROM SpedStaffMember_LOCAL GROUP BY StaffEmail HAVING COUNT(*)>1) ucspedstaff ON tspedstaff.STAFFEMAIL = ucspedstaff.STAFFEMAIL
	 
SET @sql = 'IF OBJECT_ID(''tempdb..#SpedStaffMember'') IS NOT NULL DROP TABLE #SpedStaffMember'	
EXEC sp_executesql @stmt = @sql   
      
END

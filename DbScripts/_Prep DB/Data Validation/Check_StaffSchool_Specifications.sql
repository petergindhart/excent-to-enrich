--Get rid off old version
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_StaffSchool_Specifications')
DROP PROC dbo.Check_StaffSchool_Specifications
GO

CREATE PROC dbo.Check_StaffSchool_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE StaffSchool'
EXEC sp_executesql @stmt = @sql

EXEC sp_executesql @stmt = @sql
SET @sql = 'DELETE StaffSchool_ValidationSummaryReport'

INSERT StaffSchool 
SELECT CONVERT(VARCHAR(150) ,ss.StaffEmail)
	  ,CONVERT(VARCHAR(10) ,ss.SchoolCode)
	FROM StaffSchool_LOCAL ss 
		 JOIN School sc ON sc.SchoolCode = ss.SchoolCode
		 JOIN SpedStaffMember sped ON sped.StaffEmail = ss.StaffEmail
		 JOIN (SELECT StaffEmail,SchoolCode FROM StaffSchool_LOCAL GROUP BY StaffEmail,SchoolCode HAVING COUNT(*)=1) ucss
		 ON (ucss.StaffEmail = ss.StaffEmail) AND (ucss.SchoolCode = ss.SchoolCode)
    WHERE ((DATALENGTH(ss.StaffEmail)/2)<= 150) 
		  AND ((DATALENGTH(ss.SchoolCode)/2) <=10) 
		  AND (ss.StaffEmail IS NOT NULL) 
		  AND (ss.SchoolCode IS NOT NULL)
		
		  		
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#StaffSchool'') IS NOT NULL DROP TABLE #StaffSchool'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO  #StaffSchool FROM StaffSchool_LOCAL 

INSERT StaffSchool_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'TotalRecords',COUNT(*)
FROM StaffSchool_LOCAL
    
INSERT StaffSchool_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'SuccessfulRecords',COUNT(*)
FROM StaffSchool

INSERT StaffSchool_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'FailedRecords',((select COUNT(*) FROM StaffSchool_LOCAL) - (select COUNT(*) FROM StaffSchool))

--To check the Datalength of the fields
INSERT StaffSchool_ValidationReport (Result)
SELECT 'Please check the datalength of StaffEmail for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(SchoolCode,'')
FROM #StaffSchool
    WHERE ((DATALENGTH(StaffEmail)/2)> 150 AND StaffEmail IS NOT NULL) 

INSERT StaffSchool_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'Issue in the datalength of StaffEmail',COUNT(*)
FROM #StaffSchool
    WHERE ((DATALENGTH(StaffEmail)/2)> 150 AND StaffEmail IS NOT NULL) 
    
INSERT StaffSchool_ValidationReport (Result)
SELECT 'Please check the datalength of SchoolCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(SchoolCode,'')
FROM #StaffSchool
    WHERE ((DATALENGTH(SchoolCode)/2)> 10 AND SchoolCode IS NOT NULL) 

INSERT StaffSchool_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'Issue in the datalength of SchoolCode',COUNT(*)
FROM #StaffSchool
    WHERE ((DATALENGTH(SchoolCode)/2)> 10 AND SchoolCode IS NOT NULL) 
    
---Required Fields
INSERT StaffSchool_ValidationReport (Result)
SELECT 'The StaffEmail is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(SchoolCode,'')
FROM #StaffSchool
WHERE (StaffEmail IS NULL) 

INSERT StaffSchool_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'The StaffEmail does not have any value, It is required column',COUNT(*)
FROM #StaffSchool
WHERE (StaffEmail IS NULL) 
    
INSERT StaffSchool_ValidationReport (Result)
SELECT 'The SchoolCode is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(SchoolCode,'')
FROM #StaffSchool
WHERE (SchoolCode IS NULL) 

INSERT StaffSchool_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'The SchoolCode does not have any value, It is required column',COUNT(*)
FROM #StaffSchool
WHERE (SchoolCode IS NULL) 

--To Check Duplicate Records
INSERT StaffSchool_ValidationReport (Result)
SELECT 'The record "'+tss.StaffEmail+','+tss.SchoolCode+'" was duplicated. The line no is '+CAST(tss.LINE AS VARCHAR(50))+ '.'+ISNULL(tss.StaffEmail,'')+'|'+ISNULL(tss.SchoolCode,'')
FROM #StaffSchool tss
 JOIN (SELECT StaffEmail,SchoolCode FROM StaffSchool_LOCAL GROUP BY StaffEmail,SchoolCode HAVING COUNT(*)>1) ucss
		 ON (ucss.StaffEmail = tss.StaffEmail) AND (ucss.SchoolCode = tss.SchoolCode)

INSERT StaffSchool_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'The "StaffEmail,SchoolCode" has duplicated',COUNT(*)
FROM #StaffSchool tss
 JOIN (SELECT StaffEmail,SchoolCode FROM StaffSchool_LOCAL GROUP BY StaffEmail,SchoolCode HAVING COUNT(*)>1) ucss
		 ON (ucss.StaffEmail = tss.StaffEmail) AND (ucss.SchoolCode = tss.SchoolCode)
 
--To Check the Referential Integrity
INSERT StaffSchool_ValidationReport (Result)
SELECT 'The SchoolCode' +tss.SchoolCode+' does not exist in School file or were not validated successfully, It existed in StaffSchool file. The line no is '+CAST(tss.LINE AS VARCHAR(50))+ '.'+ISNULL(tss.StaffEmail,'')+'|'+ISNULL(tss.SchoolCode,'')
FROM #StaffSchool tss
LEFT JOIN School sc ON sc.SchoolCode = tss.SchoolCode
WHERE sc.SchoolCode IS NULL

INSERT StaffSchool_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'The SchoolCode does not exist in School file, It existed in StaffSchool file',COUNT(*)
FROM #StaffSchool tss
LEFT JOIN School sc ON sc.SchoolCode = tss.SchoolCode
WHERE sc.SchoolCode IS NULL
		 
INSERT StaffSchool_ValidationReport (Result)
SELECT 'The StaffEmail' +tss.StaffEmail+' does not exist in SpedStaffMember file or were not validated successfully, It existed in StaffSchool file. The line no is '+CAST(tss.LINE AS VARCHAR(50))+ '.'+ISNULL(tss.StaffEmail,'')+'|'+ISNULL(tss.SchoolCode,'')
FROM #StaffSchool tss
LEFT JOIN SpedStaffMember sped ON sped.StaffEmail = tss.StaffEmail
WHERE sped.StaffEmail IS NULL

INSERT StaffSchool_ValidationSummaryReport (Description,NoOfRecords)
SELECT 'The StaffEmail does not exist in SpedStaffMember file, It existed in StaffSchool file',COUNT(*)
FROM #StaffSchool tss
LEFT JOIN SpedStaffMember sped ON sped.StaffEmail = tss.StaffEmail
WHERE sped.StaffEmail IS NULL

SET @sql = 'IF OBJECT_ID(''tempdb..#StaffSchool'') IS NOT NULL DROP TABLE #StaffSchool'	
EXEC sp_executesql @stmt = @sql   
      
END



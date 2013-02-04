--Get rid off old version
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_TeamMember_Specifications')
DROP PROC dbo.Check_TeamMember_Specifications
GO

CREATE PROC dbo.Check_TeamMember_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE TeamMember'

EXEC sp_executesql @stmt = @sql

INSERT TeamMember 
SELECT CONVERT(VARCHAR(150) ,team.StaffEmail)
	  ,CONVERT(VARCHAR(150) ,team.StudentRefId)
	  ,CONVERT(VARCHAR(1)   ,team.IsCaseManager)
	FROM TeamMember_LOCAL team 
		 JOIN Student st ON st.StudentRefID = team.StudentRefID
		 JOIN SpedStaffMember sped ON sped.StaffEmail = team.StaffEmail
		 JOIN (SELECT StaffEmail,StudentRefId FROM TeamMember_LOCAL GROUP BY StaffEmail,StudentRefId HAVING COUNT(*)=1) ucteam 
		 ON (ucteam.StaffEmail = team.StaffEmail) AND (ucteam.StudentRefID = team.StudentRefID)
    WHERE ((DATALENGTH(team.StaffEmail)/2)<= 150) 
		  AND ((DATALENGTH(team.StudentRefId)/2) <=150) 
		  AND ((DATALENGTH(team.IsCaseManager)/2) <= 1) 
		--  AND NOT EXISTS (SELECT StaffEmail,StudentRefId FROM TeamMember_LOCAL GROUP BY StaffEmail,StudentRefId HAVING COUNT(*)=1) ---!!!Need to check this out!!!
		  AND (team.StaffEmail IS NOT NULL) 
		  AND (team.StudentRefId IS NOT NULL)
		  AND (team.IsCaseManager IS NOT NULL AND team.IsCaseManager IN ('Y','N'))
		  		
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#TeamMember'') IS NOT NULL DROP TABLE #TeamMember'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO  #TeamMember FROM TeamMember_LOCAL 

--To check the Datalength of the fields
INSERT TeamMember_ValidationReport (Result)
SELECT 'Please check the datalength of StaffEmail for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(StudentRefId,'')+'|'+ISNULL(IsCaseManager,'')
FROM #TeamMember 
    WHERE ((DATALENGTH(StaffEmail)/2)> 150 AND StaffEmail IS NOT NULL) 

INSERT TeamMember_ValidationReport (Result)
SELECT 'Please check the datalength of StudentRefId for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(StudentRefId,'')+'|'+ISNULL(IsCaseManager,'')
FROM #TeamMember 
    WHERE ((DATALENGTH(StudentRefId)/2)> 150 AND StudentRefId IS NOT NULL)  

INSERT TeamMember_ValidationReport (Result)
SELECT 'Please check the datalength of IsCaseManager for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(StudentRefId,'')+'|'+ISNULL(IsCaseManager,'')
FROM #TeamMember 
    WHERE ((DATALENGTH(IsCaseManager)/2)> 150 AND IsCaseManager IS NOT NULL) 

---Required Fields
INSERT TeamMember_ValidationReport (Result)
SELECT 'The StaffEmail is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(StudentRefId,'')+'|'+ISNULL(IsCaseManager,'')
FROM #TeamMember 
WHERE (StaffEmail IS NULL) 

INSERT TeamMember_ValidationReport (Result)
SELECT 'The StudentRefId is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(StudentRefId,'')+'|'+ISNULL(IsCaseManager,'')
FROM #TeamMember 
WHERE (StudentRefId IS NULL) 

INSERT TeamMember_ValidationReport (Result)
SELECT 'The IsCaseManager is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(StaffEmail,'')+'|'+ISNULL(StudentRefId,'')+'|'+ISNULL(IsCaseManager,'')
FROM #TeamMember 
WHERE (IsCaseManager IS NULL) 

--To Check Duplicate Records
INSERT TeamMember_ValidationReport (Result)
SELECT 'The record'+tteam.StaffEmail+','+tteam.StudentRefID+' is duplicated. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(tteam.STAFFEMAIL,'')+'|'+ISNULL(tteam.STUDENTREFID,'')+'|'+ISNULL(IsCaseManager,'')
FROM #TeamMember tteam
JOIN (SELECT StaffEmail,StudentRefId FROM TeamMember_LOCAL GROUP BY StaffEmail,StudentRefId HAVING COUNT(*)>1) ucteam 
		 ON (ucteam.StaffEmail = tteam.StaffEmail) AND (ucteam.StudentRefID = tteam.StudentRefID)
 
--To Check the Referential Integrity
INSERT TeamMember_ValidationReport (Result)
SELECT 'The StudentRefID' +tteam.StudentRefID+' does not exist in Student file or were not validated successfully, It existed in TeamMember file. The line no is '+CAST(tteam.LINE AS VARCHAR(50))+ '.'+ISNULL(tteam.StaffEmail,'')+'|'+ISNULL(tteam.StudentRefId,'')+'|'+ISNULL(tteam.IsCaseManager,'')
FROM #TeamMember tteam
LEFT JOIN Student st ON st.StudentRefID = tteam.StudentRefID
WHERE st.StudentRefID IS NULL

INSERT TeamMember_ValidationReport (Result)
SELECT 'The StaffEmail' +tteam.StaffEmail+' does not exist in SpedStaffMember file or were not validated successfully, It existed in TeamMember file. The line no is '+CAST(tteam.LINE AS VARCHAR(50))+ '.'+ISNULL(tteam.StaffEmail,'')+'|'+ISNULL(tteam.StudentRefId,'')+'|'+ISNULL(tteam.IsCaseManager,'')
FROM #TeamMember tteam
LEFT JOIN SpedStaffMember sped ON sped.StaffEmail = tteam.StaffEmail
WHERE sped.StaffEmail IS NULL


INSERT TeamMember_ValidationReport (Result)
SELECT 'The IsCaseManager should have "Y" or "N". The line no is '+CAST(tteam.LINE AS VARCHAR(50))+ '.'+ISNULL(tteam.StaffEmail,'')+'|'+ISNULL(tteam.StudentRefId,'')+'|'+ISNULL(tteam.IsCaseManager,'')
FROM #TeamMember tteam
WHERE (tteam.IsCaseManager IN ('Y','N') AND tteam.IsCaseManager IS NOT NULL)

SET @sql = 'IF OBJECT_ID(''tempdb..#TeamMember'') IS NOT NULL DROP TABLE #TeamMember'	
EXEC sp_executesql @stmt = @sql   
      
END



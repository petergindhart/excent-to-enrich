--Get rid off old version
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_Objective_Specifications')
DROP PROC dbo.Check_Objective_Specifications
GO

CREATE PROC dbo.Check_Objective_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE Objective'

EXEC sp_executesql @stmt = @sql

INSERT Objective 
SELECT CONVERT(VARCHAR(150) ,obj.OBJECTIVEREFID)
	  ,CONVERT(VARCHAR(150),obj.GOALREFID)
	  ,CONVERT(INT ,obj.SEQUENCE)
	  ,CONVERT(VARCHAR(8000) ,obj.OBJTEXT)
	FROM Objective_LOCAL obj
		 JOIN Goal g ON obj.GOALREFID = g.GOALREFID
		 JOIN (SELECT ObjectiveRefID FROM Objective_LOCAL GROUP BY ObjectiveRefID HAVING COUNT(*)=1) uc_obj 
		 ON obj.OBJECTIVEREFID = uc_obj.OBJECTIVEREFID
	WHERE ((DATALENGTH(obj.OBJECTIVEREFID)/2)<= 150) 
		  AND ((DATALENGTH(obj.GOALREFID)/2)<=150) 
		  AND (((DATALENGTH(obj.SEQUENCE)/2)<= 2 AND ISNUMERIC(obj.SEQUENCE) = 1) OR obj.SEQUENCE IS NULL)  ---!!!Need to check this out!!!
		  AND ((DATALENGTH(obj.OBJTEXT)/2)<= 8000) 
		  AND (obj.OBJECTIVEREFID IS NOT NULL) 
		  AND (obj.GOALREFID IS NOT NULL)
		  AND (obj.OBJTEXT IS NOT NULL)
		 -- AND obj.GOALREFID IN (SELECT GoalRefID FROM Goal_LOCAL)
		 --AND EXISTS (SELECT ObjectiveRefID FROM Objective_LOCAL GROUP BY ObjectiveRefID HAVING COUNT(*)>1)
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#Objective'') IS NOT NULL DROP TABLE #Objective'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO  #Objective FROM Objective_LOCAL 

--To check the Datalength of the fields
INSERT Objective_ValidationReport (Result)
SELECT 'Please check the datalength of ObjectiveRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ObjectiveRefID,'')+'|'+ISNULL(GoalRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(ObjText,'')
FROM #Objective 
    WHERE ((DATALENGTH(ObjectiveRefID)/2)> 150 AND ObjectiveRefID IS NOT NULL) 

INSERT Objective_ValidationReport (Result)
SELECT 'Please check the datalength of GoalRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ObjectiveRefID,'')+'|'+ISNULL(GoalRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(ObjText,'')
FROM #Objective 
    WHERE ((DATALENGTH(GoalRefID)/2)> 150 AND GoalRefID IS NOT NULL) 
    
INSERT Objective_ValidationReport (Result)
SELECT 'Please check the datalength of Sequence for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ObjectiveRefID,'')+'|'+ISNULL(GoalRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(ObjText,'')
FROM #Objective 
    WHERE ((DATALENGTH(Sequence)/2)> 2 AND Sequence IS NOT NULL) 
    
INSERT Objective_ValidationReport (Result)
SELECT 'Please check the datalength of ObjText for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ObjectiveRefID,'')+'|'+ISNULL(GoalRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(ObjText,'')
FROM #Objective 
    WHERE ((DATALENGTH(ObjText)/2)> 8000 AND ObjText IS NOT NULL) 

---Required Fields
INSERT Objective_ValidationReport (Result)
SELECT 'The field "ObjectiveRefID" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ObjectiveRefID,'')+'|'+ISNULL(GoalRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(ObjText,'')
FROM #Objective 
WHERE (ObjectiveRefID IS NULL) 

INSERT Objective_ValidationReport (Result)
SELECT 'The field "GoalRefID" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ObjectiveRefID,'')+'|'+ISNULL(GoalRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(ObjText,'')
FROM #Objective 
WHERE (GoalRefID IS NULL) 

INSERT Objective_ValidationReport (Result)
SELECT 'The field "ObjText" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ObjectiveRefID,'')+'|'+ISNULL(GoalRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(ObjText,'')
FROM #Objective 
WHERE (ObjText IS NULL) 

--To Check Duplicate Records
INSERT Objective_ValidationReport (Result)
SELECT 'The record "ObjectiveRefID"'+tobj.OBJECTIVEREFID+ 'is duplicated. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(tobj.OBJECTIVEREFID,'')+'|'+ISNULL(tobj.GOALREFID,'')+'|'+ISNULL(tobj.SEQUENCE,'')+'|'+ISNULL(tobj.OBJTEXT,'')
FROM #Objective tobj 
	JOIN (SELECT ObjectiveRefID FROM Objective_LOCAL GROUP BY ObjectiveRefID HAVING COUNT(*)>1) uc_obj 
		 ON tobj.OBJECTIVEREFID = uc_obj.OBJECTIVEREFID
	--WHERE EXISTS (SELECT ObjectiveRefID FROM Objective_LOCAL GROUP BY ObjectiveRefID HAVING COUNT(*)>1)
	 
--To Check the Referential Integrity
INSERT Objective_ValidationReport (Result)
SELECT 'The record "GoalRefID"'+GoalRefID+ ' does not exist in Goal file, It existed in Goal file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(ObjectiveRefID,'')+'|'+ISNULL(GoalRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(ObjText,'')
FROM #Objective 
WHERE GoalRefID NOT IN (SELECT GoalRefID FROM Goal)

SET @sql = 'IF OBJECT_ID(''tempdb..#Objective'') IS NOT NULL DROP TABLE #Objective'	
EXEC sp_executesql @stmt = @sql   
      
END



--Get rid off old version
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_Goal_Specifcations')
DROP PROC dbo.Check_Goal_Specifcations
GO

CREATE PROC dbo.Check_Goal_Specifcations
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE Goal'

EXEC sp_executesql @stmt = @sql

INSERT School 
SELECT CONVERT(VARCHAR(10) ,GoalRefID)
	  ,CONVERT(VARCHAR(255),IepRefID)
	  ,CONVERT(VARCHAR(3) ,Sequence)
	  ,CONVERT(VARCHAR(150),GoalAreaCode)
	  ,CONVERT(VARCHAR(1) ,PSEducation)
	  ,CONVERT(VARCHAR(1),PSEmployment)
	  ,CONVERT(VARCHAR(1) ,PSIndependent)
	  ,CONVERT(VARCHAR(1),IsEsy)
	  ,CONVERT(VARCHAR(100) ,UNITOFMEASUREMENT)
	  ,CONVERT(VARCHAR(100),BASELINEDATAPOINT)
	  ,CONVERT(VARCHAR(100) ,EVALUATIONMETHOD)
	  ,CONVERT(VARCHAR(8000),GoalStatement)
	FROM Goal_LOCAL
    WHERE ((DATALENGTH(GoalRefID)/2)<= 10) 
		  AND ((DATALENGTH(IepRefID)/2)<=254) 
		  AND ((DATALENGTH(Sequence)/2)<= 10) 
		  AND ((DATALENGTH(GoalAreaCode)/2)<= 4)  
		  AND ((DATALENGTH(PSEducation)/2)<= 1) 
		  AND ((DATALENGTH(PSEmployment)/2)<=1) 
		  AND ((DATALENGTH(PSIndependent)/2)<= 1) 
		  AND ((DATALENGTH(IsEsy)/2)<= 1)
		  AND ((DATALENGTH(UNITOFMEASUREMENT)/2)<= 100) 
		  AND ((DATALENGTH(BASELINEDATAPOINT)/2)<=100) 
		  AND ((DATALENGTH(EVALUATIONMETHOD)/2)<= 100) 
		  AND ((DATALENGTH(GoalStatement)/2) <= 8000)
		  AND NOT EXISTS (SELECT GoalRefID FROM Goal_LOCAL GROUP BY GoalRefID HAVING COUNT(*)>1)
		  AND IepRefID IN (SELECT IepRefID FROM IEP)
		  AND (GoalAreaCode IN (SELECT LEGACYSPEDCODE FROM SelectLists WHERE TYPE= 'GoalArea') OR GoalAreaCode IS NOT NULL)
		  AND (GoalRefID IS NOT NULL) 
		  AND (IepRefID IS NOT NULL)
		  AND (IsEsy IS NOT NULL)
		  AND (GoalStatement IS NOT NULL)
		  AND (PSEducation IN ('Y','N') OR PSEducation IS NOT NULL)
		  AND (PSEmployment IN ('Y','N') OR PSEmployment IS NOT NULL)
		  AND (PSIndependent IN ('Y','N') OR PSIndependent IS NOT NULL)
		  AND (IsEsy IN ('Y','N') OR IsEsy IS NOT NULL)
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#Goal'') IS NOT NULL DROP TABLE #Goal'	
EXEC sp_executesql @stmt = @sql


SELECT LINE = IDENTITY(INT,1,1),* INTO  #Goal FROM Goal_LOCAL 

--To check the Datalength of the fields
INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of GoalRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(GoalRefID)/2)> 150) 

INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of IepRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(IepRefID)/2)> 150) 

INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of Sequence for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(Sequence)/2)> 3 AND Sequence IS NOT NULL) 
    
INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of GoalAreaCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(GoalAreaCode)/2)> 150 AND GoalAreaCode IS NOT NULL) 
    
INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of PSEducation for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(PSEducation)/2)> 1 AND PSEducation IS NOT NULL) 
    
INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of PSEmployment for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(PSEmployment)/2)> 1 AND PSEmployment IS NOT NULL) 
    
INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of PSIndependent for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(PSIndependent)/2)> 1 AND PSIndependent IS NOT NULL) 
    
INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of IsEsy for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(IsEsy)/2)> 1 AND PSIndependent IS NOT NULL) 
    
INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of UNITOFMEASUREMENT for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(UNITOFMEASUREMENT)/2)> 100 AND UNITOFMEASUREMENT IS NOT NULL) 
    
INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of BASELINEDATAPOINT for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(BASELINEDATAPOINT)/2)> 100 AND BASELINEDATAPOINT IS NOT NULL) 
    
INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of EVALUATIONMETHOD for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(EVALUATIONMETHOD)/2)> 100 AND EVALUATIONMETHOD IS NOT NULL) 
    
INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of GoalStatement for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(GoalStatement)/2)> 8000 AND GoalStatement IS NOT NULL) 

---Required Fields
INSERT Goal_ValidationReport (Result)
SELECT 'The field "GoalRefID" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
WHERE GoalRefID IS NULL
    
INSERT Goal_ValidationReport (Result)
SELECT 'The field "IepRefID" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
WHERE IepRefID IS NULL

INSERT Goal_ValidationReport (Result)
SELECT 'The field "IsEsy" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
WHERE IsEsy IS NULL

INSERT Goal_ValidationReport (Result)
SELECT 'The field "GoalStatement" is required field, It can not be blank. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
WHERE GoalStatement IS NULL

--To Check Duplicate Records
INSERT Goal_ValidationReport (Result)
SELECT 'The field "GoalRefID" ' +GoalRefID+'is unique field, It can not be duplicated. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
WHERE EXISTS (SELECT GoalRefID FROM Goal_LOCAL GROUP BY GoalRefID HAVING COUNT(*)>1)
	 
--To Check the Referential Integrity
INSERT Goal_ValidationReport (Result)
SELECT 'The "IepRefID" ' +IepRefID+' does not exist in IEP file or was not validated successfully. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
WHERE IepRefID NOT IN (SELECT IepRefID FROM IEP)

INSERT Goal_ValidationReport (Result)
SELECT 'The "GoalAreaCode" ' +GoalAreaCode+' does not exist in SelectLists file, It existed in Goal file. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
WHERE (GoalAreaCode IN (SELECT LEGACYSPEDCODE FROM SelectLists WHERE TYPE= 'GoalArea') OR GoalAreaCode IS NOT NULL)



INSERT Goal_ValidationReport (Result)
SELECT 'The "PSEducation" should have "Y" OR "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
WHERE (PSEducation IN ('Y','N') AND PSEducation IS NOT NULL)

INSERT Goal_ValidationReport (Result)
SELECT 'The "PSEmployment" should have "Y" OR "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
WHERE (PSEmployment IN ('Y','N') AND PSEmployment IS NOT NULL)


INSERT Goal_ValidationReport (Result)
SELECT 'The "PSIndependent" should have "Y" OR "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
WHERE PSIndependent IN ('Y','N') AND PSIndependent IS NOT NULL)

INSERT Goal_ValidationReport (Result)
SELECT 'The "IsEsy" should have "Y" OR "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
WHERE (IsEsy IN ('Y','N') AND IsEsy IS NOT NULL)


SET @sql = 'IF OBJECT_ID(''tempdb..#School'') IS NOT NULL DROP TABLE #School'	
EXEC sp_executesql @stmt = @sql   
      
END



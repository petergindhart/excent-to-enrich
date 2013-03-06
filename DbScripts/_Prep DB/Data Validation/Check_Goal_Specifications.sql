--Get rid off old version
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_Goal_Specifications')
DROP PROC dbo.Check_Goal_Specifications
GO

CREATE PROC dbo.Check_Goal_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE Goal'

EXEC sp_executesql @stmt = @sql

INSERT Goal 
SELECT CONVERT(VARCHAR(10) ,g.GOALREFID)
	  ,CONVERT(VARCHAR(255),g.IEPREFID)
	  ,CONVERT(VARCHAR(3)  ,g.SEQUENCE)
	  ,CONVERT(VARCHAR(150),g.GOALAREACODE)
	  ,CONVERT(VARCHAR(1)  ,g.PSEDUCATION)
	  ,CONVERT(VARCHAR(1)  ,g.PSEMPLOYMENT)
	  ,CONVERT(VARCHAR(1)  ,g.PSINDEPENDENT)
	  ,CONVERT(VARCHAR(1)   ,g.ISESY)
	  ,CONVERT(VARCHAR(100) ,g.UNITOFMEASUREMENT)
	  ,CONVERT(VARCHAR(100) ,g.BASELINEDATAPOINT)
	  ,CONVERT(VARCHAR(100) ,g.EVALUATIONMETHOD)
	  ,CONVERT(VARCHAR(8000) ,g.GOALSTATEMENT)
	FROM Goal_LOCAL g
		JOIN (SELECT GoalRefID FROM Goal_LOCAL GROUP BY GoalRefID HAVING COUNT(*)=1) uc_g
		ON g.GOALREFID = uc_g.GOALREFID
    WHERE ((DATALENGTH(g.GOALREFID)/2)<= 10) 
		  AND ((DATALENGTH(g.IEPREFID)/2)<=254) 
		  AND ((DATALENGTH(g.SEQUENCE)/2)<= 10 OR g.SEQUENCE IS NULL) 
		  AND ((DATALENGTH(g.GOALAREACODE)/2)<= 4 OR g.GOALAREACODE IS NULL)  
		  AND ((DATALENGTH(g.PSEDUCATION)/2)<= 1 OR g.PSEDUCATION IS NULL) 
		  AND ((DATALENGTH(g.PSEMPLOYMENT)/2)<=1 OR g.PSEMPLOYMENT IS NULL) 
		  AND ((DATALENGTH(PSIndependent)/2)<= 1 OR g.PSINDEPENDENT IS NULL) 
		  AND ((DATALENGTH(g.ISESY)/2)<= 1 OR g.ISESY IS NULL)
		  AND ((DATALENGTH(g.UNITOFMEASUREMENT)/2)<= 100 OR g.UNITOFMEASUREMENT IS NULL) 
		  AND ((DATALENGTH(g.BASELINEDATAPOINT)/2)<=100 OR g.BASELINEDATAPOINT IS NULL) 
		  AND ((DATALENGTH(g.EVALUATIONMETHOD)/2)<= 100 OR g.EVALUATIONMETHOD IS NULL) 
		  AND ((DATALENGTH(g.GOALSTATEMENT)/2) <= 8000)
		  --AND NOT EXISTS (SELECT GoalRefID FROM Goal_LOCAL GROUP BY GoalRefID HAVING COUNT(*)>1)
		  AND g.IEPREFID IN (SELECT IepRefID FROM IEP)
		  AND (g.GOALAREACODE IN (SELECT LEGACYSPEDCODE FROM SelectLists WHERE TYPE= 'GoalArea') OR g.GOALAREACODE IS NOT NULL)
		  AND (g.GOALREFID IS NOT NULL) 
		  AND (g.IEPREFID IS NOT NULL)
		  AND (g.ISESY IS NOT NULL)
		  AND (g.GOALSTATEMENT IS NOT NULL)
		  AND (g.PSEDUCATION IN ('Y','N') OR g.PSEDUCATION IS NOT NULL)
		  AND (g.PSEMPLOYMENT IN ('Y','N') OR g.PSEMPLOYMENT IS NOT NULL)
		  AND (g.PSINDEPENDENT IN ('Y','N') OR g.PSINDEPENDENT IS NOT NULL)
		  AND (g.ISESY IN ('Y','N') OR g.ISESY IS NULL)
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#Goal'') IS NOT NULL DROP TABLE #Goal'	
EXEC sp_executesql @stmt = @sql


SELECT LINE = IDENTITY(INT,1,1),* INTO  #Goal FROM Goal_LOCAL 

--To check the Datalength of the fields
INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of GoalRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(GoalRefID)/2)> 150 AND GoalRefID IS NOT NULL) 

INSERT Goal_ValidationReport (Result)
SELECT 'Please check the datalength of IepRefID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
    WHERE ((DATALENGTH(IepRefID)/2)> 150 AND IepRefID IS NOT NULL) 

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
    WHERE ((DATALENGTH(IsEsy)/2)> 1 AND IsEsy IS NOT NULL) 
    
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
SELECT 'The field "GoalRefID" ' +tg.GOALREFID+'is unique field, It can not be duplicated. The line no is '+CAST(tg.LINE AS VARCHAR(50))+ '.'+ISNULL(tg.GOALREFID,'')+'|'+ISNULL(tg.IEPREFID,'')+'|'+ISNULL(tg.SEQUENCE,'')+'|'+ISNULL(tg.GOALAREACODE,'')+ISNULL(tg.PSEDUCATION,'')+'|'+ISNULL(tg.PSEMPLOYMENT,'')+'|'+ISNULL(tg.PSINDEPENDENT,'')+'|'+ISNULL(IsEsy,'')+ISNULL(tg.UNITOFMEASUREMENT,'')+'|'+ISNULL(tg.BASELINEDATAPOINT,'')+'|'+ISNULL(tg.EVALUATIONMETHOD,'')+'|'+ISNULL(tg.GOALSTATEMENT,'')
FROM #Goal tg
JOIN (SELECT GoalRefID FROM Goal_LOCAL GROUP BY GoalRefID HAVING COUNT(*)>1) uc_g
		ON tg.GOALREFID = uc_g.GOALREFID 

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
WHERE (PSIndependent IN ('Y','N') AND PSIndependent IS NOT NULL)

INSERT Goal_ValidationReport (Result)
SELECT 'The "IsEsy" should have "Y" OR "N". The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(GoalRefID,'')+'|'+ISNULL(IepRefID,'')+'|'+ISNULL(Sequence,'')+'|'+ISNULL(GoalAreaCode,'')+ISNULL(PSEducation,'')+'|'+ISNULL(PSEmployment,'')+'|'+ISNULL(PSIndependent,'')+'|'+ISNULL(IsEsy,'')+ISNULL(UNITOFMEASUREMENT,'')+'|'+ISNULL(BASELINEDATAPOINT,'')+'|'+ISNULL(EVALUATIONMETHOD,'')+'|'+ISNULL(GoalStatement,'')
FROM #Goal 
WHERE (IsEsy IN ('Y','N') AND IsEsy IS NOT NULL)


SET @sql = 'IF OBJECT_ID(''tempdb..#Goal'') IS NOT NULL DROP TABLE #Goal'	
EXEC sp_executesql @stmt = @sql   
      
END



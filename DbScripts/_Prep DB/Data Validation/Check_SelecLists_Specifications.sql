IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_SelectLists_Specifcations')
DROP PROC dbo.Check_SelectLists_Specifcations
GO

CREATE PROC dbo.Check_SelectLists_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE SelectLists'

EXEC sp_executesql @stmt = @sql

INSERT SelectLists 
SELECT CONVERT(VARCHAR(20),TYPE)
	  ,CONVERT(VARCHAR(20),SUBTYPE)
	  ,CONVERT(VARCHAR(150),ENRICHID)
	  ,CONVERT(VARCHAR(20),STATECODE)
	  ,CONVERT(VARCHAR(20),LEGACYSPEDCODE)
	  ,CONVERT(VARCHAR(254),ENRICHLABEL)
FROM SelectLists_LOCAL 
    WHERE (DATALENGTH(Type)<=20) 
		  AND (DATALENGTH(SUBTYPE)<=20 OR SUBTYPE IS NULL) 
		  AND (DATALENGTH(ENRICHID)<=150 OR ENRICHID IS NULL) 
		  AND (DATALENGTH(STATECODE)<=20 OR STATECODE IS NULL)AND (DATALENGTH(LEGACYSPEDCODE)<=150 OR LEGACYSPEDCODE IS NULL) 
		  AND (DATALENGTH(ENRICHLABEL)<=254) AND TYPE IN ('Ethnic','Grade','Gender','Disab','Exit','LRE','Service','ServLoc','ServProv',				   'ServFreq','GoalArea','PostSchArea') 
		  AND NOT EXISTS (SELECT TYPE,SUBTYPE,ENRICHID,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL GROUP BY TYPE,SUBTYPE,ENRICHID,							   LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) 
		  AND (TYPE IS NOT NULL) 
		  AND (ENRICHLABEL IS NOT NULL)
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#selectlists'') IS NOT NULL DROP TABLE #selectlists'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO  #Selectlists FROM SelectLists_LOCAL 
	
INSERT SelectLists_ValidationReport (Result)
SELECT 'Please check the datalenth of Type for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists sl
    WHERE (DATALENGTH(sl.TYPE)>20)

INSERT SelectLists_ValidationReport (Result)  
SELECT 'Please check the datalenth of SUBTYPE for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists sl
    WHERE (DATALENGTH(sl.SUBTYPE)>20)

INSERT SelectLists_ValidationReport (Result)             
SELECT 'Please check the datalenth of ENRICHID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists sl
    WHERE (DATALENGTH(ENRICHID)>150 AND ENRICHID IS NOT NULL)

INSERT SelectLists_ValidationReport (Result)    
SELECT 'Please check the datalenth of StateCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists sl
    WHERE (DATALENGTH(StateCode)>20 AND StateCode IS NOT NULL)
 
INSERT SelectLists_ValidationReport (Result)   
SELECT 'Please check the datalenth of LegacySpedCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.' + ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists sl
    WHERE (DATALENGTH(LegacySpedCode)>20 AND LegacySpedCode IS NOT NULL)

INSERT SelectLists_ValidationReport (Result)         
SELECT 'Please check the datalenth of EnrichLabel for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.' + ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists sl
    WHERE (DATALENGTH(EnrichLabel)>254)

INSERT SelectLists_ValidationReport (Result)
SELECT 'Please check the name of Type for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.' +ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists 
WHERE TYPE NOT IN ('Ethnic','Grade','Gender','Disab','Exit','LRE','Service','ServLoc','ServProv','ServFreq','GoalArea','PostSchArea')

INSERT SelectLists_ValidationReport (Result)
SELECT 'The field "Type" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.' +ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists 
WHERE (TYPE IS NULL) 

INSERT SelectLists_ValidationReport (Result)
SELECT 'The field "ENRICHLABEL" is required field. The line no is '+CAST(LINE AS VARCHAR(50))+ '.' +ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists 
WHERE (ENRICHLABEL IS NULL) 

INSERT SelectLists_ValidationReport (Result)
SELECT 'The SubType is required for Type "LRE". The line no is '+CAST(LINE AS VARCHAR(50))+ '.' +ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists 
WHERE (TYPE = 'LRE' AND SUBTYPE IS  NULL)

INSERT SelectLists_ValidationReport (Result)
SELECT 'The SubType is required for Type "Service". The line no is '+CAST(LINE AS VARCHAR(50))+ '.' +ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists 
WHERE (TYPE = 'Service' AND SUBTYPE IS  NULL)
	 
SET @sql = 'IF OBJECT_ID(''tempdb..#selectlists'') IS NOT NULL DROP TABLE #selectlists'	
EXEC sp_executesql @stmt = @sql   
      
END


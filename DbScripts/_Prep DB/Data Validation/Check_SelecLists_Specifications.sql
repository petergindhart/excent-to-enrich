IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'Check_SelectLists_Specifications')
DROP PROC dbo.Check_SelectLists_Specifications
GO

CREATE PROC dbo.Check_SelectLists_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE SelectLists'

EXEC sp_executesql @stmt = @sql

INSERT SelectLists 
SELECT CONVERT(VARCHAR(20),sl.TYPE)
	  ,CONVERT(VARCHAR(20),sl.SUBTYPE)
	  ,CONVERT(VARCHAR(150),sl.ENRICHID)
	  ,CONVERT(VARCHAR(20),sl.STATECODE)
	  ,CONVERT(VARCHAR(20),sl.LEGACYSPEDCODE)
	  ,CONVERT(VARCHAR(254),sl.ENRICHLABEL)
FROM SelectLists_LOCAL sl
	 JOIN (
	 SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'Ethnic' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION 	
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'Grade' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'Gender' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION 
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'Disab' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'Exit' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'LRE' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'SERVICE' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'SERVLOC' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'SERVPROV' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'ServFreq' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'GoalArea' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'PostSchArea' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
) ucsel ON ISNULL(ucsel.TYPE,'x') = ISNULL(sl.TYPE,'y') AND ISNULL(ucsel.LEGACYSPEDCODE,'a') = ISNULL(sl.LEGACYSPEDCODE,'b')  AND ISNULL(ucsel.ENRICHLABEL,'a') = ISNULL(sl.EnrichLabel,'s')
    WHERE ((DATALENGTH(sl.TYPE)/2)<=20) 
		  AND ((DATALENGTH(sl.SUBTYPE)/2)<=20 OR sl.SUBTYPE IS NULL) 
		  AND ((DATALENGTH(sl.ENRICHID)/2)<=150 OR sl.ENRICHID IS NULL) 
		  AND ((DATALENGTH(sl.STATECODE)/2)<=20 OR sl.STATECODE IS NULL)
		  AND ((DATALENGTH(sl.LEGACYSPEDCODE)/2)<=150 OR sl.LEGACYSPEDCODE IS NULL) 
		  AND ((DATALENGTH(sl.ENRICHLABEL)/2)<=254) 
		  AND sl.TYPE IN ('Ethnic','Grade','Gender','Disab','Exit','LRE','Service','ServLoc','ServProv','ServFreq','GoalArea','PostSchArea') 
		 -- AND NOT EXISTS (SELECT TYPE,SUBTYPE,ENRICHID,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL GROUP BY TYPE,SUBTYPE,ENRICHID,		   LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) 
		  AND (sl.TYPE IS NOT NULL) 
		  AND (sl.ENRICHLABEL IS NOT NULL)
		  
SET @sql = 'IF OBJECT_ID(''tempdb..#selectlists'') IS NOT NULL DROP TABLE #selectlists'	
EXEC sp_executesql @stmt = @sql

SELECT LINE = IDENTITY(INT,1,1),* INTO  #Selectlists FROM SelectLists_LOCAL 
	
INSERT SelectLists_ValidationReport (Result)
SELECT 'Please check the datalenth of Type for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists sl
    WHERE ((DATALENGTH(sl.TYPE)/2)>20 AND TYPE IS NOT NULL)

INSERT SelectLists_ValidationReport (Result)  
SELECT 'Please check the datalenth of SUBTYPE for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists sl
    WHERE ((DATALENGTH(sl.SUBTYPE)/2)>20 AND SUBTYPE IS NOT NULL)

INSERT SelectLists_ValidationReport (Result)             
SELECT 'Please check the datalenth of ENRICHID for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists sl
    WHERE ((DATALENGTH(ENRICHID)/2)>150 AND ENRICHID IS NOT NULL)

INSERT SelectLists_ValidationReport (Result)    
SELECT 'Please check the datalenth of StateCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.'+ ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists sl
    WHERE ((DATALENGTH(StateCode)/2)>20 AND StateCode IS NOT NULL)
 
INSERT SelectLists_ValidationReport (Result)   
SELECT 'Please check the datalenth of LegacySpedCode for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.' + ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists sl
    WHERE ((DATALENGTH(LegacySpedCode)/2)>20 AND LegacySpedCode IS NOT NULL)

INSERT SelectLists_ValidationReport (Result)         
SELECT 'Please check the datalenth of EnrichLabel for the following record. The line no is '+CAST(LINE AS VARCHAR(50))+ '.' + ISNULL(TYPE,'')+'|'+ISNULL(SUBTYPE,'')+'|'+ISNULL(ENRICHID,'')+'|'+ISNULL(STATECODE,'')+'|'+ISNULL(LEGACYSPEDCODE,'')+'|'+ISNULL(EnrichLabel,'')
FROM #Selectlists sl
    WHERE ((DATALENGTH(EnrichLabel)/2)>254)

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

--Unique Fields
INSERT SelectLists_ValidationReport (Result)
SELECT 'The Race record is duplicated. The line no is '+CAST(tsl.LINE AS VARCHAR(50))+ '.' +ISNULL(tsl.TYPE,'')+'|'+ISNULL(tsl.SUBTYPE,'')+'|'+ISNULL(tsl.ENRICHID,'')+'|'+ISNULL(tsl.STATECODE,'')+'|'+ISNULL(tsl.LEGACYSPEDCODE,'')+'|'+ISNULL(tsl.ENRICHLABEL,'')
FROM #Selectlists tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'Ethnic' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) uceth ON ISNULL(uceth.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(uceth.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(uceth.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT SelectLists_ValidationReport (Result)
SELECT 'The Gender record is duplicated. The line no is '+CAST(tsl.LINE AS VARCHAR(50))+ '.' +ISNULL(tsl.TYPE,'')+'|'+ISNULL(tsl.SUBTYPE,'')+'|'+ISNULL(tsl.ENRICHID,'')+'|'+ISNULL(tsl.STATECODE,'')+'|'+ISNULL(tsl.LEGACYSPEDCODE,'')+'|'+ISNULL(tsl.ENRICHLABEL,'')
FROM #Selectlists tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'Gender' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucgen ON ISNULL(ucgen.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucgen.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucgen.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT SelectLists_ValidationReport (Result)
SELECT 'The Grade record is duplicated. The line no is '+CAST(tsl.LINE AS VARCHAR(50))+ '.' +ISNULL(tsl.TYPE,'')+'|'+ISNULL(tsl.SUBTYPE,'')+'|'+ISNULL(tsl.ENRICHID,'')+'|'+ISNULL(tsl.STATECODE,'')+'|'+ISNULL(tsl.LEGACYSPEDCODE,'')+'|'+ISNULL(tsl.ENRICHLABEL,'')
FROM #Selectlists tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'Grade' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucgrad ON ISNULL(ucgrad.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucgrad.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucgrad.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT SelectLists_ValidationReport (Result)
SELECT 'The "Disability" record is duplicated. The line no is '+CAST(tsl.LINE AS VARCHAR(50))+ '.' +ISNULL(tsl.TYPE,'')+'|'+ISNULL(tsl.SUBTYPE,'')+'|'+ISNULL(tsl.ENRICHID,'')+'|'+ISNULL(tsl.STATECODE,'')+'|'+ISNULL(tsl.LEGACYSPEDCODE,'')+'|'+ISNULL(tsl.ENRICHLABEL,'')
FROM #Selectlists tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'Disab' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucdisab ON ISNULL(ucdisab.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucdisab.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucdisab.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT SelectLists_ValidationReport (Result)
SELECT 'The "Exit" record is duplicated. The line no is '+CAST(tsl.LINE AS VARCHAR(50))+ '.' +ISNULL(tsl.TYPE,'')+'|'+ISNULL(tsl.SUBTYPE,'')+'|'+ISNULL(tsl.ENRICHID,'')+'|'+ISNULL(tsl.STATECODE,'')+'|'+ISNULL(tsl.LEGACYSPEDCODE,'')+'|'+ISNULL(tsl.ENRICHLABEL,'')
FROM #Selectlists tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'Exit' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucex ON ISNULL(ucex.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucex.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucex.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT SelectLists_ValidationReport (Result)
SELECT 'The "LRE" record is duplicated. The line no is '+CAST(tsl.LINE AS VARCHAR(50))+ '.' +ISNULL(tsl.TYPE,'')+'|'+ISNULL(tsl.SUBTYPE,'')+'|'+ISNULL(tsl.ENRICHID,'')+'|'+ISNULL(tsl.STATECODE,'')+'|'+ISNULL(tsl.LEGACYSPEDCODE,'')+'|'+ISNULL(tsl.ENRICHLABEL,'')
FROM #Selectlists tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'LRE' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) uclre ON ISNULL(uclre.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(uclre.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(uclre.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT SelectLists_ValidationReport (Result)
SELECT 'The "Service" record is duplicated. The line no is '+CAST(tsl.LINE AS VARCHAR(50))+ '.' +ISNULL(tsl.TYPE,'')+'|'+ISNULL(tsl.SUBTYPE,'')+'|'+ISNULL(tsl.ENRICHID,'')+'|'+ISNULL(tsl.STATECODE,'')+'|'+ISNULL(tsl.LEGACYSPEDCODE,'')+'|'+ISNULL(tsl.ENRICHLABEL,'')
FROM #Selectlists tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'Service' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucser ON ISNULL(ucser.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucser.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucser.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT SelectLists_ValidationReport (Result)
SELECT 'The "ServLoc" record is duplicated. The line no is '+CAST(tsl.LINE AS VARCHAR(50))+ '.' +ISNULL(tsl.TYPE,'')+'|'+ISNULL(tsl.SUBTYPE,'')+'|'+ISNULL(tsl.ENRICHID,'')+'|'+ISNULL(tsl.STATECODE,'')+'|'+ISNULL(tsl.LEGACYSPEDCODE,'')+'|'+ISNULL(tsl.ENRICHLABEL,'')
FROM #Selectlists tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'ServLoc' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucserloc ON ISNULL(ucserloc.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucserloc.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucserloc.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT SelectLists_ValidationReport (Result)
SELECT 'The "ServProv" record is duplicated. The line no is '+CAST(tsl.LINE AS VARCHAR(50))+ '.' +ISNULL(tsl.TYPE,'')+'|'+ISNULL(tsl.SUBTYPE,'')+'|'+ISNULL(tsl.ENRICHID,'')+'|'+ISNULL(tsl.STATECODE,'')+'|'+ISNULL(tsl.LEGACYSPEDCODE,'')+'|'+ISNULL(tsl.ENRICHLABEL,'')
FROM #Selectlists tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'ServProv' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucserprov ON ISNULL(ucserprov.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucserprov.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucserprov.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT SelectLists_ValidationReport (Result)
SELECT 'The "ServFreq" record is duplicated. The line no is '+CAST(tsl.LINE AS VARCHAR(50))+ '.' +ISNULL(tsl.TYPE,'')+'|'+ISNULL(tsl.SUBTYPE,'')+'|'+ISNULL(tsl.ENRICHID,'')+'|'+ISNULL(tsl.STATECODE,'')+'|'+ISNULL(tsl.LEGACYSPEDCODE,'')+'|'+ISNULL(tsl.ENRICHLABEL,'')
FROM #Selectlists tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'ServFreq' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucserfreq ON ISNULL(ucserfreq.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucserfreq.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucserfreq.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT SelectLists_ValidationReport (Result)
SELECT 'The "GoalArea" record is duplicated. The line no is '+CAST(tsl.LINE AS VARCHAR(50))+ '.' +ISNULL(tsl.TYPE,'')+'|'+ISNULL(tsl.SUBTYPE,'')+'|'+ISNULL(tsl.ENRICHID,'')+'|'+ISNULL(tsl.STATECODE,'')+'|'+ISNULL(tsl.LEGACYSPEDCODE,'')+'|'+ISNULL(tsl.ENRICHLABEL,'')
FROM #Selectlists tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'GoalArea' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucgoal ON ISNULL(ucgoal.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucgoal.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucgoal.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT SelectLists_ValidationReport (Result)
SELECT 'The "PostSchArea" record is duplicated. The line no is '+CAST(tsl.LINE AS VARCHAR(50))+ '.' +ISNULL(tsl.TYPE,'')+'|'+ISNULL(tsl.SUBTYPE,'')+'|'+ISNULL(tsl.ENRICHID,'')+'|'+ISNULL(tsl.STATECODE,'')+'|'+ISNULL(tsl.LEGACYSPEDCODE,'')+'|'+ISNULL(tsl.ENRICHLABEL,'')
FROM #Selectlists tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM SelectLists_LOCAL WHERE TYPE = 'GoalArea' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucpsa ON ISNULL(ucpsa.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucpsa.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucpsa.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')


SET @sql = 'IF OBJECT_ID(''tempdb..#selectlists'') IS NOT NULL DROP TABLE #selectlists'	
EXEC sp_executesql @stmt = @sql   
      
END


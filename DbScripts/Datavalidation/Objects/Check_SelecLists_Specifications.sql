IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'Check_SelectLists_Specifications')
DROP PROC Datavalidation.Check_SelectLists_Specifications
GO

CREATE PROC Datavalidation.Check_SelectLists_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE Datavalidation.SelectLists'
EXEC sp_executesql @stmt = @sql

INSERT Datavalidation.SelectLists 
SELECT sl.Line_No
      ,CONVERT(VARCHAR(20),sl.TYPE)
	  ,CONVERT(VARCHAR(20),sl.SUBTYPE)
	  ,CONVERT(VARCHAR(150),sl.ENRICHID)
	  ,CONVERT(VARCHAR(10),sl.STATECODE)
	  ,CONVERT(VARCHAR(20),sl.LEGACYSPEDCODE)
	  ,CONVERT(VARCHAR(254),sl.ENRICHLABEL)
FROM Datavalidation.Selectlists_LOCAL sl
JOIN (
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Ethnic' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION 	
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Grade' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Gender' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION 
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Disab' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Exit' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'LRE' GROUP BY TYPE,SubType,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Service' GROUP BY TYPE,SubType,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'SERVLOC' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'SERVPROV' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'ServFreq' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'GoalArea' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
UNION
SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'PostSchArea' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)= 1
) ucsel ON ISNULL(ucsel.TYPE,'x') = ISNULL(sl.TYPE,'y') AND ISNULL(ucsel.LEGACYSPEDCODE,'a') = ISNULL(sl.LEGACYSPEDCODE,'b')  AND ISNULL(ucsel.ENRICHLABEL,'a') = ISNULL(sl.EnrichLabel,'s')
WHERE ((DATALENGTH(sl.TYPE)/2)<=20) 
		  AND ((DATALENGTH(sl.SUBTYPE)/2)<=20 OR sl.SUBTYPE IS NULL) 
		  AND ((DATALENGTH(sl.ENRICHID)/2)<=150 OR sl.ENRICHID IS NULL) 
		  AND ((DATALENGTH(sl.STATECODE)/2)<=10 OR sl.STATECODE IS NULL)
		  AND ((DATALENGTH(sl.LEGACYSPEDCODE)/2)<=150 OR sl.LEGACYSPEDCODE IS NULL) 
		  AND ((DATALENGTH(sl.ENRICHLABEL)/2)<=254) 
		  AND sl.TYPE IN ('Ethnic','Grade','Gender','Disab','Exit','LRE','Service','ServLoc','ServProv','ServFreq','GoalArea','PostSchArea') 
		  AND (sl.TYPE IS NOT NULL) 
		  AND (sl.ENRICHLABEL IS NOT NULL)

--================================================================================		  
--Log the count of successful records
--================================================================================	  
INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','SuccessfulRecords',COUNT(*)
FROM Datavalidation.SelectLists

--=========================================================================
--Log the Validation Results (If any issues we encounter)
--=========================================================================


--select * from datavalidation.ValidationRules

IF (SELECT CURSOR_STATUS('global','chkSpecifications')) >=0 
BEGIN
DEALLOCATE chkSpecifications
END

DECLARE @tableschema VARCHAR(50),@tablename VARCHAR(50),@columnname VARCHAR(50),@datatype VARCHAR(50),@datalength VARCHAR(50),@isrequired bit,@isuniquefield bit,@isFkRelation bit, @parenttable VARCHAR(50),@parentcolumn VARCHAR(50),@islookupcolumn bit, @lookuptable VARCHAR(50),@lookupcolumn VARCHAR(50),@lookuptype VARCHAR(50),@isFlagfield bit,@flagrecords VARCHAR(50)

DECLARE chkSpecifications CURSOR FOR 
SELECT TableSchema, TableName,ColumnName,DataType,DataLength,IsRequired,IsUniqueField,IsFkRelation,ParentTable,ParentColumn,IsLookupColumn,LookupTable,LookupColumn,LookupType,IsFlagfield,FlagRecords
FROM Datavalidation.ValidationRules WHERE TableName = 'SelectLists'
--AND IS_NULLABLE = 'NO'

OPEN chkSpecifications

FETCH NEXT FROM chkSpecifications INTO @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
DECLARE @vsql nVARCHAR(MAX)
DECLARE @sumsql NVARCHAR(MAX)
DECLARE @query nVARCHAR(MAX)
WHILE @@FETCH_STATUS = 0
BEGIN
--Check the required fields
IF (@isrequired=1)
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''SelectLists'',''The field '+@columnname+' is required field.'',Line_No,ISNULL(CONVERT(VARCHAR(max),TYPE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SUBTYPE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ENRICHID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),STATECODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LEGACYSPEDCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EnrichLabel),'''')
FROM Datavalidation.SelectLists_Local WHERE 1 = 1'

SET @query  = ' AND ('+@columnname+' IS NULL)'
SET @vsql = @vsql + @query
--PRINT @vsql
EXEC sp_executesql @stmt=@vsql

SET @sumsql = 'INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''SelectLists'',''The field '+@columnname+' is required field.'', COUNT(*)
FROM Datavalidation.SelectLists_Local WHERE 1 = 1'

SET @query  = ' AND ('+@columnname+' IS NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END
--Check the datalength of Every Fields in the file
IF (1=1)
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''SelectLists'',''The issue is in the datalength of the field '+@columnname+'.'',Line_No,ISNULL(CONVERT(VARCHAR(max),TYPE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SUBTYPE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ENRICHID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),STATECODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LEGACYSPEDCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EnrichLabel),'''')
FROM Datavalidation.SelectLists_Local WHERE 1 = 1'

SET @query  = ' AND ((DATALENGTH ('+@columnname+')/2) > '+@datalength+' AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''SelectLists'',''The issue is in the datalength of the field '+@columnname+'.'', COUNT(*)
FROM Datavalidation.SelectLists_Local WHERE 1 = 1'

SET @query  = ' AND ((DATALENGTH ('+@columnname+')/2) > '+@datalength+' AND '+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

FETCH NEXT FROM chkSpecifications INTO  @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
END
CLOSE chkSpecifications
DEALLOCATE chkSpecifications


/*
-----------------------------------------------------------------------------
--DataLength issues
-----------------------------------------------------------------------------

------------------------------------------------------------------------
--Referential Integrity
------------------------------------------------------------------------    
*/

INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The SubType is required for Type "LRE".',Line_No,ISNULL(CONVERT(VARCHAR(MAX),TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),EnrichLabel),'')
FROM Datavalidation.Selectlists_LOCAL 
WHERE (TYPE = 'LRE' AND SUBTYPE IS  NULL)

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The SubType is required for Type "LRE".',COUNT(*)
FROM Datavalidation.SelectLists_Local
WHERE (TYPE = 'LRE' AND SUBTYPE IS  NULL)

INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The SubType is required for Type "Service".',Line_No,ISNULL(CONVERT(VARCHAR(MAX),TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),EnrichLabel),'')
FROM Datavalidation.Selectlists_LOCAL 
WHERE (TYPE = 'Service' AND SUBTYPE IS  NULL)

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The SubType is required for Type "Service".',COUNT(*)
FROM Datavalidation.SelectLists_Local
WHERE (TYPE = 'Service' AND SUBTYPE IS  NULL)

INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The Given type is not listed in our specifications.',Line_No,ISNULL(CONVERT(VARCHAR(MAX),TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),EnrichLabel),'')
FROM Datavalidation.Selectlists_LOCAL 
WHERE TYPE NOT IN ('Ethnic','Grade','Gender','Disab','Exit','LRE','Service','ServLoc','ServProv','ServFreq','GoalArea','PostSchArea')

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The Given type is not listed in our specifications.',COUNT(*)
FROM Datavalidation.SelectLists_Local
WHERE TYPE NOT IN ('Ethnic','Grade','Gender','Disab','Exit','LRE','Service','ServLoc','ServProv','ServFreq','GoalArea','PostSchArea')

-----------------------------------------------------------------------------------
--Unique Fields
-----------------------------------------------------------------------------------
INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The Race record is duplicated.',tsl.Line_No,ISNULL(CONVERT(VARCHAR(MAX),tsl.TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHLABEL),'')
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Ethnic' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) uceth ON ISNULL(uceth.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(uceth.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(uceth.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT  'SelectLists','The Race record is duplicated.',COUNT(*)
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Ethnic' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) uceth ON ISNULL(uceth.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(uceth.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(uceth.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')


INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The Gender record is duplicated.',tsl.Line_No,ISNULL(CONVERT(VARCHAR(MAX),tsl.TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHLABEL),'')
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Gender' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucgen ON ISNULL(ucgen.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucgen.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucgen.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The Gender record is duplicated.',COUNT(*)
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Gender' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucgen ON ISNULL(ucgen.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucgen.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucgen.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')


INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The Grade record is duplicated.',tsl.Line_No,ISNULL(CONVERT(VARCHAR(MAX),tsl.TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHLABEL),'')
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Grade' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucgrad ON ISNULL(ucgrad.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucgrad.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucgrad.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The Grade record is duplicated.',COUNT(*)
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Grade' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucgrad ON ISNULL(ucgrad.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucgrad.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucgrad.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')


INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The "Disability" record is duplicated.',tsl.Line_No,ISNULL(CONVERT(VARCHAR(MAX),tsl.TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHLABEL),'')
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Disab' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucdisab ON ISNULL(ucdisab.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucdisab.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucdisab.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The "Disability" record is duplicated.',COUNT(*)
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Disab' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucdisab ON ISNULL(ucdisab.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucdisab.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucdisab.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The "Exit" record is duplicated.',tsl.Line_No,ISNULL(CONVERT(VARCHAR(MAX),tsl.TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHLABEL),'')
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Exit' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucex ON ISNULL(ucex.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucex.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucex.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The "Exit" record is duplicated.',COUNT(*)
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Exit' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucex ON ISNULL(ucex.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucex.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucex.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The "LRE" record is duplicated.',tsl.Line_No,ISNULL(CONVERT(VARCHAR(MAX),tsl.TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHLABEL),'')
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'LRE' GROUP BY TYPE,SubType,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) uclre ON ISNULL(uclre.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(uclre.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(uclre.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The "LRE" record is duplicated.',COUNT(*)
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'LRE' GROUP BY TYPE,SubType,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) uclre ON ISNULL(uclre.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(uclre.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(uclre.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The "Service" record is duplicated.',tsl.Line_No,ISNULL(CONVERT(VARCHAR(MAX),tsl.TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHLABEL),'')
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,SubType,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Service' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL,SubType HAVING COUNT(*)>1) ucser ON ISNULL(ucser.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucser.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucser.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s') AND ISNULL(ucser.SubType,'a') = ISNULL(tsl.SubType,'s')

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The "Service" record is duplicated.',COUNT(*)
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,SubType,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'Service' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL,SubType HAVING COUNT(*)>1) ucser ON ISNULL(ucser.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucser.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucser.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s') AND ISNULL(ucser.SubType,'a') = ISNULL(tsl.SubType,'s')

INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The "ServLoc" record is duplicated.',tsl.Line_No,ISNULL(CONVERT(VARCHAR(MAX),tsl.TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHLABEL),'')
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'ServLoc' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucserloc ON ISNULL(ucserloc.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucserloc.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucserloc.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')


INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The "ServLoc" record is duplicated.',COUNT(*)
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'ServLoc' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucserloc ON ISNULL(ucserloc.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucserloc.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucserloc.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')


INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The "ServProv" record is duplicated.',tsl.Line_No,ISNULL(CONVERT(VARCHAR(MAX),tsl.TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHLABEL),'')
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'ServProv' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucserprov ON ISNULL(ucserprov.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucserprov.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucserprov.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')


INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The "ServProv" record is duplicated.',COUNT(*)
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'ServProv' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucserprov ON ISNULL(ucserprov.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucserprov.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucserprov.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')


INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The "ServFreq" record is duplicated.',tsl.Line_No,ISNULL(CONVERT(VARCHAR(MAX),tsl.TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHLABEL),'')
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'ServFreq' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucserfreq ON ISNULL(ucserfreq.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucserfreq.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucserfreq.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The "ServFreq" record is duplicated.',COUNT(*)
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'ServFreq' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucserfreq ON ISNULL(ucserfreq.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucserfreq.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucserfreq.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The "GoalArea" record is duplicated.',tsl.Line_No,ISNULL(CONVERT(VARCHAR(MAX),tsl.TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHLABEL),'')
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'GoalArea' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucgoal ON ISNULL(ucgoal.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucgoal.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucgoal.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The "GoalArea" record is duplicated.',COUNT(*)
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'GoalArea' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucgoal ON ISNULL(ucgoal.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucgoal.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucgoal.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'SelectLists','The "PostSchArea" record is duplicated.',tsl.Line_No,ISNULL(CONVERT(VARCHAR(MAX),tsl.TYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.SUBTYPE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHID),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.STATECODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.LEGACYSPEDCODE),'')+'|'+ISNULL(CONVERT(VARCHAR(MAX),tsl.ENRICHLABEL),'')
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'PostSchArea' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucpsa ON ISNULL(ucpsa.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucpsa.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucpsa.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'SelectLists','The "PostSchArea" record is duplicated.',COUNT(*)
FROM Datavalidation.Selectlists_LOCAL tsl
JOIN (SELECT TYPE,LEGACYSPEDCODE,ENRICHLABEL FROM Datavalidation.Selectlists_LOCAL WHERE TYPE = 'PostSchArea' GROUP BY TYPE,LEGACYSPEDCODE,ENRICHLABEL HAVING COUNT(*)>1) ucpsa ON ISNULL(ucpsa.TYPE,'x') = ISNULL(tsl.TYPE,'y') AND ISNULL(ucpsa.LEGACYSPEDCODE,'a') = ISNULL(tsl.LEGACYSPEDCODE,'b')  AND ISNULL(ucpsa.ENRICHLABEL,'a') = ISNULL(tsl.EnrichLabel,'s')
  
END


--Get rid off old version
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'Check_Goal_Specifications')
DROP PROC x_DATAVALIDATION.Check_Goal_Specifications
GO
/*
To check the specfication of Goal file with our data specification
*/
CREATE PROC x_DATAVALIDATION.Check_Goal_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)

SET @sql = 'DELETE x_DATAVALIDATION.Goal'
EXEC sp_executesql @stmt = @sql

---Validated data
DECLARE @sqlvalidated VARCHAR(MAX)
SET @sqlvalidated = 
'INSERT  x_DATAVALIDATION.Goal  
SELECT g.Line_No '
             
DECLARE @MaxCount INTEGER
DECLARE @Count INTEGER
DECLARE @sel VARCHAR(MAX)
DECLARE @tblsel table (id int, columnname varchar(50),datatype varchar(50),datalength varchar(5))
INSERT @tblsel
SELECT ColumnOrder,columnname,DataType,datalength
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Goal' 

SET @Count = 1
SET @sel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblsel)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'varchar')
    BEGIN
    SET @sel=@sel+', CONVERT ( VARCHAR ('+(SELECT datalength from @tblsel WHERE ID = @Count)+'), g.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'datetime')
    BEGIN
    SET @sel=@sel+', CONVERT ( DATETIME , g.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'int')
    BEGIN
    SET @sel=@sel+', CONVERT ( INT , g.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE
    BEGIN
    SET @sel=@sel+', CONVERT ( VARCHAR ('+(SELECT datalength from @tblsel WHERE ID = @Count)+'), g.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    SET @Count=@Count+1
    END
--print @sel
SET @sqlvalidated = @sqlvalidated + @sel+ ' FROM x_DATAVALIDATION.Goal_Local g'

DECLARE @Txtreq VARCHAR(MAX)
DECLARE @tblreq table (id int, columnname varchar(50))
INSERT @tblreq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Goal' AND IsRequired =1

SET @Count = 1
SET @Txtreq = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblreq)
WHILE @Count<=@MaxCount
    BEGIN
        SET @Txtreq=@Txtreq+' AND g.'+(select columnname from @tblreq WHERE ID=@Count) + ' IS NOT NULL '
    SET @Count=@Count+1
    END
--SELECT @Txtreq AS Txt

DECLARE @Txtdatalength VARCHAR(MAX)
DECLARE @tbldl table (id int, columnname varchar(50),datalength varchar(10),isrequired bit)
INSERT @tbldl
SELECT ROW_NUMBER()over(order by columnname),columnname,datalength,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Goal' 
SET @Count = 1
SET @Txtdatalength = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldl)
WHILE @Count<=@MaxCount
    BEGIN
    IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE DATALENGTH(REPLACE('+'g.'+(select columnname from @tbldl WHERE ID=@Count) + ','''''''',''''))/2 <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    ELSE IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE DATALENGTH(REPLACE('+'g.'+(select columnname from @tbldl WHERE ID=@Count) + ','''''''',''''))/2 <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (g.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL)'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND DATALENGTH(REPLACE('+'g.'+(select columnname from @tbldl WHERE ID=@Count) + ','''''''',''''))/2 <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (g.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL)'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND DATALENGTH(REPLACE('+'g.'+(select columnname from @tbldl WHERE ID=@Count) + ','''''''',''''))/2 <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    SET @Count=@Count+1
    END
--SELECT @Txtdatalength AS Txtdl

DECLARE @Txtflag VARCHAR(MAX)
DECLARE @tblflag table (id int,columnname varchar(50),flagrecords varchar(50),isrequired varchar(50))
INSERT @tblflag
SELECT ROW_NUMBER()over(order by columnname),columnname,FlagRecords,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Goal' and IsFlagfield = 1

SET @Count = 1
SET @Txtflag = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblflag)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tblflag WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtflag=@Txtflag+' AND g.'+(select columnname from @tblflag WHERE ID=@Count) + ' IN ('+(select flagrecords from @tblflag WHERE ID=@Count)+')'
    END
    ELSE IF ((select isrequired from @tblflag WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtflag=@Txtflag+' AND (g.'+(select columnname from @tblflag WHERE ID=@Count) + ' IN ('+(select flagrecords from @tblflag WHERE ID=@Count)+') OR g.'+(select columnname from @tblflag WHERE ID=@Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtflag AS Txtflag

DECLARE @Txtfkrel VARCHAR(MAX)
DECLARE @tblfkrel table (id int, columnname varchar(50),parenttable varchar(50), parentcolumn varchar(50))
INSERT @tblfkrel
SELECT ROW_NUMBER()over(order by columnname),columnname,ParentTable,ParentColumn
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Goal' AND IsFkRelation = 1
SET @Count = 1
SET @Txtfkrel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblfkrel)
WHILE @Count<=@MaxCount
    BEGIN
    SET @Txtfkrel=@Txtfkrel+' JOIN x_DATAVALIDATION.'+(SELECT parenttable FROM @tblfkrel WHERE ID= @Count)+' '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+' ON '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+'.'+(SELECT parentcolumn FROM @tblfkrel WHERE ID= @Count)+' = g.'+(SELECT columnname FROM @tblfkrel WHERE ID= @Count)
    SET @Count=@Count+1
    END
--SELECT @Txtfkrel AS Txtfk

DECLARE @Txtlookup VARCHAR(MAX)
DECLARE @tbllookup table (id int, columnname varchar(50),lookuptable varchar(50),lookupcolumn varchar(50),lookuptype varchar(50), isrequired bit)
INSERT @tbllookup
SELECT ROW_NUMBER()over(order by columnname),columnname,LookupTable,LookupColumn,LookUpType,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Goal' AND IsLookupColumn = 1
SET @Count = 1
SET @Txtlookup = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbllookup)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND g.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND g.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+''')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND (g.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' OR g.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND g.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+'''OR g.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtlookup AS Txtl

DECLARE @Txtdatatype VARCHAR(MAX)
DECLARE @tbldttype table (id int, columnname varchar(50),datatype varchar(50),isrequired bit)
INSERT @tbldttype
SELECT ROW_NUMBER()over(order by columnname),columnname,DataType,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Goal' 

SET @Count = 1
SET @Txtdatatype = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldttype)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND x_DATAVALIDATION.udf_IsInteger( g.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND (x_DATAVALIDATION.udf_IsInteger( g.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR g.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL)'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND ISDATE(g.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND ( ISDATE( g.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR g.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtdatatype AS Txt

DECLARE @Txtunique VARCHAR(MAX)
DECLARE @tbluq table (id int, columnname varchar(50))
INSERT @tbluq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Goal'  AND IsUniqueField = 1
SET @Count = 1
SET @Txtunique = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbluq)
WHILE @Count<=@MaxCount
    BEGIN
    SET @Txtunique=@Txtunique + ' JOIN (SELECT ' +(select columnname from @tbluq WHERE ID=@Count)+ ' FROM x_DATAVALIDATION.Goal_LOCAL GROUP BY '+(select columnname from @tbluq WHERE ID=@Count)+' HAVING COUNT(*)=1) '+(select left(columnname,3) from @tbluq WHERE ID=@Count)+' ON ' +(select left(columnname,3) from @tbluq WHERE ID=@Count)+'.' +(select columnname from @tbluq WHERE ID=@Count) +' = g.'+(select columnname from @tbluq WHERE ID=@Count)        
        
        SET @Count=@Count+1
    END
--SELECT @Txtunique AS Txtq

SET @sqlvalidated = @sqlvalidated +@Txtunique+@Txtfkrel+@Txtdatalength+@Txtreq+@Txtflag+@Txtdatatype
print @sqlvalidated

EXEC (@sqlvalidated)



/*
--Stored validated data of Goal file in x_DATAVALIDATION.Goal
INSERT x_DATAVALIDATION.Goal 
SELECT g.Line_No
      ,CONVERT(VARCHAR(10) ,g.GOALREFID)
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
	FROM x_DATAVALIDATION.Goal_Local  g
		JOIN (SELECT GoalRefID FROM x_DATAVALIDATION.Goal_Local GROUP BY GoalRefID HAVING COUNT(*)=1) uc_g
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
		  AND g.IEPREFID IN (SELECT IepRefID FROM x_DATAVALIDATION.IEP)
		  AND (g.GOALAREACODE IN (SELECT LEGACYSPEDCODE FROM x_DATAVALIDATION.SelectLists WHERE TYPE= 'GoalArea') OR g.GOALAREACODE IS NOT NULL)
		  AND (g.GOALREFID IS NOT NULL) 
		  AND (g.IEPREFID IS NOT NULL)
		  AND (g.ISESY IS NOT NULL)
		  AND (g.GOALSTATEMENT IS NOT NULL)
		  AND (g.PSEDUCATION IN ('Y','N') OR g.PSEDUCATION IS NOT NULL)
		  AND (g.PSEMPLOYMENT IN ('Y','N') OR g.PSEMPLOYMENT IS NOT NULL)
		  AND (g.PSINDEPENDENT IN ('Y','N') OR g.PSINDEPENDENT IS NOT NULL)
		  AND (g.ISESY IN ('Y','N') OR g.ISESY IS NULL)
		  */
--================================================================================		  
--Log the count of successful records
--================================================================================    
INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'Goal','SuccessfulRecords',COUNT(*)
FROM x_DATAVALIDATION.Goal

--=========================================================================
--Log the Validation Results (If any issues we encounter)
--=========================================================================
--To check the Datalength of the fields

IF (SELECT CURSOR_STATUS('global','chkSpecifications')) >=0 
BEGIN
DEALLOCATE chkSpecifications
END

DECLARE @tableschema VARCHAR(50),@tablename VARCHAR(50),@columnname VARCHAR(50),@datatype VARCHAR(50),@datalength VARCHAR(50),@isrequired bit,@isuniquefield bit,@isFkRelation bit, @parenttable VARCHAR(50),@parentcolumn VARCHAR(50),@islookupcolumn bit, @lookuptable VARCHAR(50),@lookupcolumn VARCHAR(50),@lookuptype VARCHAR(50),@isFlagfield bit,@flagrecords VARCHAR(50)

DECLARE chkSpecifications CURSOR FOR 
SELECT TableSchema, TableName,ColumnName,DataType,DataLength,IsRequired,IsUniqueField,IsFkRelation,ParentTable,ParentColumn,IsLookupColumn,LookupTable,LookupColumn,LookupType,IsFlagfield,FlagRecords
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Goal'

OPEN chkSpecifications

FETCH NEXT FROM chkSpecifications INTO @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
DECLARE @vsql nVARCHAR(MAX)
DECLARE @sumsql nVARCHAR(MAX)
DECLARE @query nVARCHAR(MAX)
DECLARE @uncol nVARCHAR(MAX)
DECLARE @uniqoncol nVARCHAR(MAX)

WHILE @@FETCH_STATUS = 0
BEGIN
------------------------------------------------
--Check the required fields
------------------------------------------------
IF (@isrequired=1)
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The field '+@columnname+' is required field.'',Line_No,ISNULL(CONVERT(VARCHAR(max),GoalRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Sequence),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),GoalAreaCode),'''')+ISNULL(CONVERT(VARCHAR(max),PSEducation),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),PSEmployment),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),PSIndependent),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IsEsy),'''')+ISNULL(CONVERT(VARCHAR(max),UNITOFMEASUREMENT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),BASELINEDATAPOINT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EVALUATIONMETHOD),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),GoalStatement),'''') FROM x_DATAVALIDATION.Goal_Local WHERE 1 = 1'

SET @query  = ' AND ('+@columnname+' IS NULL)'
SET @vsql = @vsql + @query
--PRINT @vsql
EXEC sp_executesql @stmt=@vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Goal'',''The field '+@columnname+' is required field, it cannot be empty.'', COUNT(*)
FROM x_DATAVALIDATION.Goal_Local WHERE 1 = 1 '

SET @query  = ' AND ('+@columnname+' IS NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END
----------------------------------------------------------------
--Check the datalength of Every Fields in the file
----------------------------------------------------------------
IF (1=1)
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The issue is in the datalength of the field '+@columnname+'.'',Line_No,ISNULL(CONVERT(VARCHAR(max),GoalRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Sequence),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),GoalAreaCode),'''')+ISNULL(CONVERT(VARCHAR(max),PSEducation),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),PSEmployment),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),PSIndependent),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IsEsy),'''')+ISNULL(CONVERT(VARCHAR(max),UNITOFMEASUREMENT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),BASELINEDATAPOINT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EVALUATIONMETHOD),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),GoalStatement),'''') FROM x_DATAVALIDATION.Goal_Local WHERE 1 = 1'

SET @query  = ' AND ((DATALENGTH (REPLACE('+@columnname+','''''''',''''))/2) > '+@datalength+' AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Goal'',''The issue is in the datalength of the field '+@columnname+'.'', COUNT(*)
FROM x_DATAVALIDATION.Goal_Local WHERE 1 = 1 '

SET @query  = ' AND ((DATALENGTH (REPLACE('+@columnname+','''''''',''''))/2) > '+@datalength+' AND '+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql

END
-------------------------------------------------------------------
--Check the Referntial Integrity Issues
-------------------------------------------------------------------
IF (@isFkRelation = 1)
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The '+@columnname+' ''''''+CONVERT(VARCHAR(MAX),goal.'+@columnname+')+'''''' does not exist in '+@parenttable+'  or were not validated successfully, but it existed in '+@tablename+'.'',goal.Line_No,ISNULL(CONVERT(VARCHAR(max),goal.GoalRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.Sequence),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.GoalAreaCode),'''')+ISNULL(CONVERT(VARCHAR(max),goal.PSEducation),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.PSEmployment),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.PSIndependent),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.IsEsy),'''')+ISNULL(CONVERT(VARCHAR(max),goal.UNITOFMEASUREMENT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.BASELINEDATAPOINT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.EVALUATIONMETHOD),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.GoalStatement),'''')
FROM x_DATAVALIDATION.Goal_Local goal '

SET @query  = ' LEFT JOIN x_DATAVALIDATION.'+@parenttable+' dt ON goal.'+@columnname+' = dt.'+@parentcolumn+' WHERE dt.'+@parentcolumn+' IS NULL'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Goal'',''Some of the '+@parentcolumn+' does not exist in '+@parenttable+' or were not validated successfully, but it existed in '+@tablename+'.'', COUNT(*)
FROM x_DATAVALIDATION.Goal_Local goal '

SET @query  = ' LEFT JOIN x_DATAVALIDATION.'+@parenttable+' dt ON goal.'+@columnname+' = dt.'+@parentcolumn+' WHERE dt.'+@parentcolumn+' IS NULL'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

-------------------------------------------------------------------
--Check the flag fields
-------------------------------------------------------------------
IF (@isFlagfield = 1)
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The field '+@columnname+' should have one of the value in '''+LTRIM(REPLACE(@flagrecords,''',''','/'))+''', It has value as ''''''+goal.'+@columnname+'+''''''.'',goal.Line_No,ISNULL(CONVERT(VARCHAR(max),goal.GoalRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.Sequence),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.GoalAreaCode),'''')+ISNULL(CONVERT(VARCHAR(max),goal.PSEducation),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.PSEmployment),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.PSIndependent),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.IsEsy),'''')+ISNULL(CONVERT(VARCHAR(max),goal.UNITOFMEASUREMENT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.BASELINEDATAPOINT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.EVALUATIONMETHOD),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.GoalStatement),'''') FROM x_DATAVALIDATION.Goal_Local goal '

SET @query  = '  WHERE (goal.'+@columnname+' NOT IN  ('+@flagrecords+') AND goal.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql


SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Goal'',''The field '+@columnname+' should have one of the value in '''+LTRIM(REPLACE(@flagrecords,''',''','/'))+'''.'', COUNT(*)
FROM x_DATAVALIDATION.Goal_Local goal '

SET @query  = '  WHERE (goal.'+@columnname+' NOT IN  ('+@flagrecords+') AND goal.'+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END
-------------------------------------------------------------------
--Check the unique fields
-------------------------------------------------------------------

IF (@isuniquefield = 1)
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The field '+@columnname+' is unique field, Here ''''''+CONVERT(VARCHAR(MAX),goal.'+@columnname+')+'''''' record is repeated.'',goal.Line_No,ISNULL(CONVERT(VARCHAR(max),goal.GoalRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.Sequence),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.GoalAreaCode),'''')+ISNULL(CONVERT(VARCHAR(max),goal.PSEducation),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.PSEmployment),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.PSIndependent),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.IsEsy),'''')+ISNULL(CONVERT(VARCHAR(max),goal.UNITOFMEASUREMENT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.BASELINEDATAPOINT),'''')+''|''+ISNULL(CONVERT(VARCHAR(150),goal.EVALUATIONMETHOD),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.GoalStatement),'''') FROM x_DATAVALIDATION.Goal_Local goal JOIN '

SET @query  = ' (SELECT '+@columnname+' FROM x_DATAVALIDATION.Goal_LOCAL GROUP BY '+@columnname+' HAVING COUNT(*)>1) ucgoal ON ucgoal.'+@columnname+' = goal.'+@columnname+' '
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Goal'',''The field '+@columnname+' is unique field, Here '+@columnname+' record is repeated.'', COUNT(*)
FROM x_DATAVALIDATION.Goal_Local goal JOIN  '

SET @query  = ' (SELECT '+@columnname+' FROM x_DATAVALIDATION.Goal_LOCAL GROUP BY '+@columnname+' HAVING COUNT(*)>1) ucgoal ON ucgoal.'+@columnname+' = goal.'+@columnname+' '
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql

END
-------------------------------------------------------------------
--Check the Lookup columns and Referntial issues
-------------------------------------------------------------------
IF (@islookupcolumn = 1 AND @lookuptable = 'SelectLists')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The '+@columnname+' ''''''+CONVERT(VARCHAR(MAX),goal.'+@columnname+')+'''''' does not exist in '+@lookuptable+', but it existed in '+@tablename+''',goal.Line_No,ISNULL(CONVERT(VARCHAR(max),goal.GoalRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.Sequence),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.GoalAreaCode),'''')+ISNULL(CONVERT(VARCHAR(max),goal.PSEducation),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.PSEmployment),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.PSIndependent),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.IsEsy),'''')+ISNULL(CONVERT(VARCHAR(max),goal.UNITOFMEASUREMENT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.BASELINEDATAPOINT),'''')+''|''+ISNULL(CONVERT(VARCHAR(150),goal.EVALUATIONMETHOD),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.GoalStatement),'''') FROM x_DATAVALIDATION.Goal_Local goal '

SET @query  = ' WHERE (goal.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+' WHERE Type = '''+@lookuptype+''') AND goal.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Goal'',''Some of the '+@columnname+' does not exist in '+@lookuptable+' or were not validated succesfully, but it existed in '+@tablename+''', COUNT(*)
FROM x_DATAVALIDATION.Goal_Local goal  '

SET @query  = ' WHERE (goal.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+' WHERE Type = '''+@lookuptype+''') AND goal.'+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql

END

IF (@islookupcolumn =1 AND @lookuptable != 'SelectLists')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The '+@columnname+' ''''''+ goal.'+@columnname+'+'''''' does not exist in '+@lookuptable+', but it existed in '+@tablename+''',goal.Line_No,ISNULL(CONVERT(VARCHAR(max),goal.GoalRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.Sequence),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.GoalAreaCode),'''')+ISNULL(CONVERT(VARCHAR(max),goal.PSEducation),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.PSEmployment),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.PSIndependent),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.IsEsy),'''')+ISNULL(CONVERT(VARCHAR(max),goal.UNITOFMEASUREMENT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.BASELINEDATAPOINT),'''')+''|''+ISNULL(CONVERT(VARCHAR(150),goal.EVALUATIONMETHOD),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),goal.GoalStatement),'''') FROM x_DATAVALIDATION.Goal_Local goal '

SET @query  = ' WHERE (goal.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+') AND goal.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Goal'',''Some of the '+@columnname+' does not exist in '+@lookuptable+' or were not validated succesfully, but it existed in '+@tablename+'.'', COUNT(*)
FROM x_DATAVALIDATION.Goal_Local goal  '

SET @query  = ' WHERE (goal.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+') AND goal.'+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql

END


IF (@datatype = 'datetime')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The date format issue is in '+@columnname+'.'',Line_No,ISNULL(CONVERT(VARCHAR(max),GoalRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Sequence),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),GoalAreaCode),'''')+ISNULL(CONVERT(VARCHAR(max),PSEducation),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),PSEmployment),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),PSIndependent),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IsEsy),'''')+ISNULL(CONVERT(VARCHAR(max),UNITOFMEASUREMENT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),BASELINEDATAPOINT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EVALUATIONMETHOD),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),GoalStatement),'''') FROM x_DATAVALIDATION.Goal_Local WHERE 1 = 1 '

SET @query  = ' AND (ISDATE('''+@columnname+''') = 0 AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Goal'',''The date format issue is in '+@columnname+'.'', COUNT(*)
FROM x_DATAVALIDATION.Goal_Local WHERE 1 = 1 '

SET @query  = ' AND (ISDATE('''+@columnname+''') = 0 AND '+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql

END

IF (@datatype = 'int')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The field '+@columnname+' should have integer records.'',Line_No,ISNULL(CONVERT(VARCHAR(max),GoalRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Sequence),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),GoalAreaCode),'''')+ISNULL(CONVERT(VARCHAR(max),PSEducation),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),PSEmployment),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),PSIndependent),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IsEsy),'''')+ISNULL(CONVERT(VARCHAR(max),UNITOFMEASUREMENT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),BASELINEDATAPOINT),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EVALUATIONMETHOD),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),GoalStatement),'''') FROM x_DATAVALIDATION.Goal_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (x_DATAVALIDATION.udf_IsInteger('+@columnname+') = 0 AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Goal'',''The field '+@columnname+' should have integer records.'', COUNT(*)
FROM x_DATAVALIDATION.Goal_Local WHERE 1 = 1 '

SET @query  = ' AND (x_DATAVALIDATION.udf_IsInteger('+@columnname+') = 0 AND '+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql

END

FETCH NEXT FROM chkSpecifications INTO  @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
END
CLOSE chkSpecifications
DEALLOCATE chkSpecifications
/*
---------------------------------------------------------------------------------
---Required Fields
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------- 
--To Check Duplicate Records
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
--To Check the Referential Integrity
----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
--Checking the flags columns whether is having "Y"/"N" (as per our dataspecification)
-----------------------------------------------------------------------------------------
*/
END



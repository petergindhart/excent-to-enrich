--Get rid off old version
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'Check_Goal_Specifications')
DROP PROC Datavalidation.Check_Goal_Specifications
GO
/*
To check the specfication of Goal file with our data specification
*/
CREATE PROC Datavalidation.Check_Goal_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)

SET @sql = 'DELETE Datavalidation.Goal'
EXEC sp_executesql @stmt = @sql

---Validated data
DECLARE @sqlvalidated VARCHAR(MAX)
SET @sqlvalidated = 
'INSERT  Datavalidation.Goal  
SELECT g.Line_No '
             
DECLARE @MaxCount INTEGER
DECLARE @Count INTEGER
DECLARE @sel VARCHAR(MAX)
DECLARE @tblsel table (id int, columnname varchar(50),datatype varchar(50),datalength varchar(5))
INSERT @tblsel
SELECT ColumnOrder,columnname,DataType,datalength
FROM Datavalidation.ValidationRules WHERE TableName = 'Goal' 

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
SET @sqlvalidated = @sqlvalidated + @sel+ ' FROM Datavalidation.Goal_Local g'

DECLARE @Txtreq VARCHAR(MAX)
DECLARE @tblreq table (id int, columnname varchar(50))
INSERT @tblreq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM Datavalidation.ValidationRules WHERE TableName = 'Goal' AND IsRequired =1

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
FROM Datavalidation.ValidationRules WHERE TableName = 'Goal' 
SET @Count = 1
SET @Txtdatalength = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldl)
WHILE @Count<=@MaxCount
    BEGIN
    IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE (DATALENGTH('+'g.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    ELSE IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE ((DATALENGTH('+'g.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (g.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL))'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND ((DATALENGTH('+'g.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (g.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL))'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND (DATALENGTH('+'g.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    SET @Count=@Count+1
    END
--SELECT @Txtdatalength AS Txtdl

DECLARE @Txtflag VARCHAR(MAX)
DECLARE @tblflag table (id int,columnname varchar(50),flagrecords varchar(50),isrequired varchar(50))
INSERT @tblflag
SELECT ROW_NUMBER()over(order by columnname),columnname,FlagRecords,IsRequired
FROM Datavalidation.ValidationRules WHERE TableName = 'Goal' and IsFlagfield = 1

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
FROM Datavalidation.ValidationRules WHERE TableName = 'Goal' AND IsFkRelation = 1
SET @Count = 1
SET @Txtfkrel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblfkrel)
WHILE @Count<=@MaxCount
    BEGIN
    SET @Txtfkrel=@Txtfkrel+' JOIN Datavalidation.'+(SELECT parenttable FROM @tblfkrel WHERE ID= @Count)+' '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+' ON '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+'.'+(SELECT parentcolumn FROM @tblfkrel WHERE ID= @Count)+' = g.'+(SELECT columnname FROM @tblfkrel WHERE ID= @Count)
    SET @Count=@Count+1
    END
--SELECT @Txtfkrel AS Txtfk

DECLARE @Txtlookup VARCHAR(MAX)
DECLARE @tbllookup table (id int, columnname varchar(50),lookuptable varchar(50),lookupcolumn varchar(50),lookuptype varchar(50), isrequired bit)
INSERT @tbllookup
SELECT ROW_NUMBER()over(order by columnname),columnname,LookupTable,LookupColumn,LookUpType,IsRequired
FROM Datavalidation.ValidationRules WHERE TableName = 'Goal' AND IsLookupColumn = 1
SET @Count = 1
SET @Txtlookup = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbllookup)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND g.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM Datavalidation.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND g.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM Datavalidation.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+''')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND (g.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM Datavalidation.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' OR g.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND g.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM Datavalidation.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+'''OR g.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtlookup AS Txtl

DECLARE @Txtdatatype VARCHAR(MAX)
DECLARE @tbldttype table (id int, columnname varchar(50),datatype varchar(50),isrequired bit)
INSERT @tbldttype
SELECT ROW_NUMBER()over(order by columnname),columnname,DataType,IsRequired
FROM Datavalidation.ValidationRules WHERE TableName = 'Goal' 

SET @Count = 1
SET @Txtdatatype = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldttype)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND Datavalidation.udf_IsInteger( g.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND (Datavalidation.udf_IsInteger( g.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR g.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL)'
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
FROM Datavalidation.ValidationRules WHERE TableName = 'Goal'  AND IsUniqueField = 1
SET @Count = 1
SET @Txtunique = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbluq)
WHILE @Count<=@MaxCount
    BEGIN
        SET @Txtunique=@Txtunique + ' JOIN (SELECT ' +(select columnname from @tbluq WHERE ID=@Count)+ ' FROM Datavalidation.Goal_LOCAL GROUP BY '+(select columnname from @tbluq WHERE ID=@Count)+' HAVING COUNT(*)=1) ucg ON ucg.' +(select columnname from @tbluq WHERE ID=@Count) +'= g. '+(select columnname from @tbluq WHERE ID=@Count)
        
        SET @Count=@Count+1
    END
--SELECT @Txtunique AS Txtq

SET @sqlvalidated = @sqlvalidated +@Txtunique +@Txtdatalength+@Txtreq+@Txtflag+@Txtdatatype
print @sqlvalidated

EXEC (@sqlvalidated)



/*
--Stored validated data of Goal file in Datavalidation.Goal
INSERT Datavalidation.Goal 
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
	FROM Datavalidation.Goal_Local  g
		JOIN (SELECT GoalRefID FROM Datavalidation.Goal_Local GROUP BY GoalRefID HAVING COUNT(*)=1) uc_g
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
		  AND g.IEPREFID IN (SELECT IepRefID FROM Datavalidation.IEP)
		  AND (g.GOALAREACODE IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'GoalArea') OR g.GOALAREACODE IS NOT NULL)
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
INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'Goal','SuccessfulRecords',COUNT(*)
FROM Datavalidation.Goal

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
FROM Datavalidation.ValidationRules WHERE TableName = 'Goal'

OPEN chkSpecifications

FETCH NEXT FROM chkSpecifications INTO @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
DECLARE @vsql nVARCHAR(MAX)
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

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The field '+@columnname+' is required field.'',Line_No,ISNULL(GoalRefID,'''')+''|''+ISNULL(IepRefID,'''')+''|''+ISNULL(Sequence,'''')+''|''+ISNULL(GoalAreaCode,'''')+ISNULL(PSEducation,'''')+''|''+ISNULL(PSEmployment,'''')+''|''+ISNULL(PSIndependent,'''')+''|''+ISNULL(IsEsy,'''')+ISNULL(UNITOFMEASUREMENT,'''')+''|''+ISNULL(BASELINEDATAPOINT,'''')+''|''+ISNULL(EVALUATIONMETHOD,'''')+''|''+ISNULL(GoalStatement,'''')
FROM Datavalidation.Goal_Local WHERE 1 = 1'

SET @query  = ' AND ('+@columnname+' IS NULL)'
SET @vsql = @vsql + @query
--PRINT @vsql
EXEC sp_executesql @stmt=@vsql
END
----------------------------------------------------------------
--Check the datalength of Every Fields in the file
----------------------------------------------------------------
IF (1=1)
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The issue is in the datalength of the field '+@columnname+'.'',Line_No,ISNULL(GoalRefID,'''')+''|''+ISNULL(IepRefID,'''')+''|''+ISNULL(Sequence,'''')+''|''+ISNULL(GoalAreaCode,'''')+ISNULL(PSEducation,'''')+''|''+ISNULL(PSEmployment,'''')+''|''+ISNULL(PSIndependent,'''')+''|''+ISNULL(IsEsy,'''')+ISNULL(UNITOFMEASUREMENT,'''')+''|''+ISNULL(BASELINEDATAPOINT,'''')+''|''+ISNULL(EVALUATIONMETHOD,'''')+''|''+ISNULL(GoalStatement,'''')
FROM Datavalidation.Goal_Local WHERE 1 = 1'

SET @query  = ' AND ((DATALENGTH ('+@columnname+')/2) > '+@datalength+' AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

END
-------------------------------------------------------------------
--Check the Referntial Integrity Issues
-------------------------------------------------------------------
IF (@isFkRelation = 1)
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''Some of the '+@parentcolumn+' does not exist in '+@parenttable+' File or were not validated successfully, but it existed in '+@tablename+'.csv.'',goal.Line_No,ISNULL(goal.GoalRefID,'''')+''|''+ISNULL(goal.IepRefID,'''')+''|''+ISNULL(goal.Sequence,'''')+''|''+ISNULL(goal.GoalAreaCode,'''')+ISNULL(goal.PSEducation,'''')+''|''+ISNULL(goal.PSEmployment,'''')+''|''+ISNULL(goal.PSIndependent,'''')+''|''+ISNULL(goal.IsEsy,'''')+ISNULL(goal.UNITOFMEASUREMENT,'''')+''|''+ISNULL(goal.BASELINEDATAPOINT,'''')+''|''+ISNULL(goal.EVALUATIONMETHOD,'''')+''|''+ISNULL(goal.GoalStatement,'''')
FROM Datavalidation.Goal_Local goal '

SET @query  = ' LEFT JOIN Datavalidation.'+@parenttable+' dt ON goal.'+@columnname+' = dt.'+@parentcolumn+' WHERE dt.'+@parentcolumn+' IS NULL'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END

-------------------------------------------------------------------
--Check the flag fields
-------------------------------------------------------------------
IF (@isFlagfield = 1)
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The field '+@columnname+' should have one of the value in '''+LTRIM(REPLACE(@flagrecords,''',''','/'))+''''',goal.Line_No,ISNULL(goal.GoalRefID,'''')+''|''+ISNULL(goal.IepRefID,'''')+''|''+ISNULL(goal.Sequence,'''')+''|''+ISNULL(goal.GoalAreaCode,'''')+ISNULL(goal.PSEducation,'''')+''|''+ISNULL(goal.PSEmployment,'''')+''|''+ISNULL(goal.PSIndependent,'''')+''|''+ISNULL(goal.IsEsy,'''')+ISNULL(goal.UNITOFMEASUREMENT,'''')+''|''+ISNULL(goal.BASELINEDATAPOINT,'''')+''|''+ISNULL(goal.EVALUATIONMETHOD,'''')+''|''+ISNULL(goal.GoalStatement,'''')
FROM Datavalidation.Goal_Local goal '

SET @query  = '  WHERE (goal.'+@columnname+' NOT IN  ('+@flagrecords+') AND goal.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END
-------------------------------------------------------------------
--Check the unique fields
-------------------------------------------------------------------

IF (@isuniquefield = 1)
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The field '+@columnname+' is unique field, Here '+@columnname+' record is repeated.'',goal.Line_No,ISNULL(goal.GoalRefID,'''')+''|''+ISNULL(goal.IepRefID,'''')+''|''+ISNULL(goal.Sequence,'''')+''|''+ISNULL(goal.GoalAreaCode,'''')+ISNULL(goal.PSEducation,'''')+''|''+ISNULL(goal.PSEmployment,'''')+''|''+ISNULL(goal.PSIndependent,'''')+''|''+ISNULL(goal.IsEsy,'''')+ISNULL(goal.UNITOFMEASUREMENT,'''')+''|''+ISNULL(goal.BASELINEDATAPOINT,'''')+''|''+ISNULL(goal.EVALUATIONMETHOD,'''')+''|''+ISNULL(goal.GoalStatement,'''')
FROM Datavalidation.Goal_Local goal JOIN'

SET @query  = ' (SELECT '+@columnname+' FROM Datavalidation.Goal_LOCAL GROUP BY '+@columnname+' HAVING COUNT(*)>1) ucgoal ON ucgoal.'+@columnname+' = goal.'+@columnname+' '
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END
-------------------------------------------------------------------
--Check the Lookup columns and Referntial issues
-------------------------------------------------------------------
IF (@islookupcolumn = 1 AND @lookuptable = 'SelectLists')
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The '+@columnname+' "''+ goal.'+@columnname+'+''" does not exist in '+@lookuptable+'.csv, but it existed in '+@tablename+'.csv'',goal.Line_No,ISNULL(goal.GoalRefID,'''')+''|''+ISNULL(goal.IepRefID,'''')+''|''+ISNULL(goal.Sequence,'''')+''|''+ISNULL(goal.GoalAreaCode,'''')+ISNULL(goal.PSEducation,'''')+''|''+ISNULL(goal.PSEmployment,'''')+''|''+ISNULL(goal.PSIndependent,'''')+''|''+ISNULL(goal.IsEsy,'''')+ISNULL(goal.UNITOFMEASUREMENT,'''')+''|''+ISNULL(goal.BASELINEDATAPOINT,'''')+''|''+ISNULL(goal.EVALUATIONMETHOD,'''')+''|''+ISNULL(goal.GoalStatement,'''')
FROM Datavalidation.Goal_Local goal '

SET @query  = ' WHERE (goal.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM Datavalidation.'+@lookuptable+' WHERE Type = '''+@lookuptype+''') AND goal.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END

IF (@islookupcolumn =1 AND @lookuptable != 'SelectLists')
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The '+@columnname+' "''+ goal.'+@columnname+'+''" does not exist in '+@lookuptable+'.csv, but it existed in '+@tablename+'.csv'',goal.Line_No,ISNULL(goal.GoalRefID,'''')+''|''+ISNULL(goal.IepRefID,'''')+''|''+ISNULL(goal.Sequence,'''')+''|''+ISNULL(goal.GoalAreaCode,'''')+ISNULL(goal.PSEducation,'''')+''|''+ISNULL(goal.PSEmployment,'''')+''|''+ISNULL(goal.PSIndependent,'''')+''|''+ISNULL(goal.IsEsy,'''')+ISNULL(goal.UNITOFMEASUREMENT,'''')+''|''+ISNULL(goal.BASELINEDATAPOINT,'''')+''|''+ISNULL(goal.EVALUATIONMETHOD,'''')+''|''+ISNULL(goal.GoalStatement,'''')
FROM Datavalidation.Goal_Local goal '

SET @query  = ' WHERE (goal.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM Datavalidation.'+@lookuptable+') AND goal.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END


IF (@datatype = 'datetime')
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The date format issue is in '+@columnname+'.'',Line_No,ISNULL(GoalRefID,'''')+''|''+ISNULL(IepRefID,'''')+''|''+ISNULL(Sequence,'''')+''|''+ISNULL(GoalAreaCode,'''')+ISNULL(PSEducation,'''')+''|''+ISNULL(PSEmployment,'''')+''|''+ISNULL(PSIndependent,'''')+''|''+ISNULL(IsEsy,'''')+ISNULL(UNITOFMEASUREMENT,'''')+''|''+ISNULL(BASELINEDATAPOINT,'''')+''|''+ISNULL(EVALUATIONMETHOD,'''')+''|''+ISNULL(GoalStatement,'''')
FROM Datavalidation.Goal_Local WHERE 1 = 1 '

SET @query  = ' AND (ISDATE('''+@columnname+''') = 0 AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

END

IF (@datatype = 'int')
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Goal'',''The field '+@columnname+' should have integer records.'',Line_No,ISNULL(GoalRefID,'''')+''|''+ISNULL(IepRefID,'''')+''|''+ISNULL(Sequence,'''')+''|''+ISNULL(GoalAreaCode,'''')+ISNULL(PSEducation,'''')+''|''+ISNULL(PSEmployment,'''')+''|''+ISNULL(PSIndependent,'''')+''|''+ISNULL(IsEsy,'''')+ISNULL(UNITOFMEASUREMENT,'''')+''|''+ISNULL(BASELINEDATAPOINT,'''')+''|''+ISNULL(EVALUATIONMETHOD,'''')+''|''+ISNULL(GoalStatement,'''') FROM Datavalidation.Goal_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (Datavalidation.udf_IsInteger('+@columnname+') = 0 AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

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



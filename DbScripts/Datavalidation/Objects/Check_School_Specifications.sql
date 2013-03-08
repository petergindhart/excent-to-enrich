--Get rid off old version
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'Check_School_Specifications')
DROP PROC Datavalidation.Check_School_Specifications
GO

CREATE PROC Datavalidation.Check_School_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE Datavalidation.School'
EXEC sp_executesql @stmt = @sql

---Validated data
DECLARE @sqlvalidated nVARCHAR(MAX)
SET @sqlvalidated = 
'INSERT  Datavalidation.School
SELECT sc.Line_No '
             
DECLARE @MaxCount INTEGER
DECLARE @Count INTEGER
DECLARE @sel VARCHAR(MAX)
DECLARE @tblsel table (id int, columnname varchar(50),datatype varchar(50),datalength varchar(5))
INSERT @tblsel
SELECT ColumnOrder,columnname,DataType,datalength
FROM Datavalidation.ValidationRules WHERE TableName = 'School' 

SET @Count = 1
SET @sel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblsel)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'varchar')
    BEGIN
    SET @sel=@sel+', CONVERT ( VARCHAR ('+(SELECT datalength from @tblsel WHERE ID = @Count)+'), sc.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE IF((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'int')
    BEGIN
    SET @sel=@sel+', CONVERT ( INT , sc.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE
    PRINT ''
    SET @Count=@Count+1
    END
print @sel
SET @sqlvalidated = @sqlvalidated + @sel+ ' FROM Datavalidation.School_Local sc'

DECLARE @Txtreq VARCHAR(MAX)
DECLARE @tblreq table (id int, columnname varchar(50))
INSERT @tblreq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM Datavalidation.ValidationRules WHERE TableName = 'School' AND IsRequired =1

SET @Count = 1
SET @Txtreq = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblreq)
WHILE @Count<=@MaxCount
    BEGIN
        SET @Txtreq=@Txtreq+' AND sc.'+(select columnname from @tblreq WHERE ID=@Count) + ' IS NOT NULL '
    SET @Count=@Count+1
    END
--SELECT @Txtreq AS Txt
	
DECLARE @Txtdatalength VARCHAR(MAX)
DECLARE @tbldl table (id int, columnname varchar(50),datalength varchar(10))
INSERT @tbldl
SELECT ROW_NUMBER()over(order by columnname),columnname,datalength
FROM Datavalidation.ValidationRules WHERE TableName = 'School' 
SET @Count = 1
SET @Txtdatalength = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldl)
WHILE @Count<=@MaxCount
    BEGIN
    IF (@Txtdatalength = '')
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE (DATALENGTH('+'sc.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    ELSE
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND (DATALENGTH('+'sc.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    SET @Count=@Count+1
    END
SELECT @Txtdatalength AS Txta


DECLARE @Txtfkrel VARCHAR(MAX)
DECLARE @tblfkrel table (id int, columnname varchar(50),parenttable varchar(50), parentcolumn varchar(50))
INSERT @tblfkrel
SELECT ROW_NUMBER()over(order by columnname),columnname,ParentTable,ParentColumn
FROM Datavalidation.ValidationRules WHERE TableName = 'School' AND IsFkRelation = 1
SET @Count = 1
SET @Txtfkrel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblfkrel)
WHILE @Count<=@MaxCount
    BEGIN
    SET @Txtfkrel=@Txtfkrel+' JOIN Datavalidation.'+(SELECT parenttable FROM @tblfkrel WHERE ID= @Count)+' '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+' ON '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+'.'+(SELECT parentcolumn FROM @tblfkrel WHERE ID= @Count)+' = sc.'+(SELECT columnname FROM @tblfkrel WHERE ID= @Count)
    SET @Count=@Count+1
    END
SELECT @Txtfkrel AS Txta

DECLARE @Txtdatatype VARCHAR(MAX)
DECLARE @tbldttype table (id int, columnname varchar(50),datatype varchar(50),isrequired bit)
INSERT @tbldttype
SELECT ROW_NUMBER()over(order by columnname),columnname,DataType,IsRequired
FROM Datavalidation.ValidationRules WHERE TableName = 'School' 

SET @Count = 1
SET @Txtdatatype = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldttype)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND Datavalidation.udf_IsInteger( sc.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND (Datavalidation.udf_IsInteger( sc.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR sc.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL)'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND ISDATE(sc.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND (ISDATE(sc.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR sc.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtdatatype AS Txt


DECLARE @Txtunique VARCHAR(MAX)
--DECLARE @tbluq table (id int, columnname varchar(50))
--INSERT @tbluq
--SELECT ROW_NUMBER()over(order by columnname),columnname
--FROM Datavalidation.ValidationRules WHERE TableName = 'School'  AND IsUniqueField = 1
--SET @Count = 1
--SET @Txtunique = ''
--SET @MaxCount = (SELECT MAX(id)FROM @tbluq)
--WHILE @Count<=@MaxCount
--    BEGIN
--        SET @Txtunique=@Txtunique + ' JOIN  (SELECT ' +(select columnname from @tbluq WHERE ID=@Count)+ ' FROM Datavalidation.School_LOCAL GROUP BY '+(select columnname from @tbluq WHERE ID=@Count)+' HAVING COUNT(*)=1) ucdt ON ucsc.' +(select columnname from @tbluq WHERE ID=@Count) +'= sc. '+(select columnname from @tbluq WHERE ID=@Count)
        
--        SET @Count=@Count+1
--    END
SET @Txtunique = ' JOIN (SELECT SchoolCode,DISTRICTCODE FROM Datavalidation.School_LOCAL GROUP BY SchoolCode,DISTRICTCODE HAVING COUNT(*)=1) ucsc ON sc.SCHOOLCODE = ucsc.SCHOOLCODE AND sc.DISTRICTCODE = ucsc.DISTRICTCODE'
SELECT @Txtunique AS Txtq

SET @sqlvalidated = @sqlvalidated +@Txtunique +@Txtfkrel+@Txtdatalength+@Txtreq+@Txtdatatype
--print @sqlvalidated

EXEC sp_executesql @stmt = @sqlvalidated

/*
INSERT Datavalidation.School 
SELECT sch.Line_No
      ,CONVERT(VARCHAR(10) ,sch.SCHOOLCODE)
	  ,CONVERT(VARCHAR(255),sch.SCHOOLNAME)
	  ,CONVERT(VARCHAR(10) ,sch.DISTRICTCODE)
	  ,CONVERT(int ,sch.MINUTESPERWEEK)
	FROM Datavalidation.School_LOCAL sch
		 JOIN Datavalidation.District dt ON dt.DistrictCode = Sch.DISTRICTCODE
		 JOIN (SELECT SchoolCode,DISTRICTCODE FROM Datavalidation.School_LOCAL GROUP BY SchoolCode,DISTRICTCODE HAVING COUNT(*)=1) ucsch
		 ON sch.SCHOOLCODE = ucsch.SCHOOLCODE
    WHERE ((DATALENGTH(sch.SCHOOLCODE)/2)<= 10) 
		  AND ((DATALENGTH(sch.SCHOOLNAME)/2)<=255) 
		  AND ((DATALENGTH(sch.DISTRICTCODE)/2)<= 10) 
		  AND (ISNUMERIC(sch.MINUTESPERWEEK)=1) AND ((DATALENGTH(sch.MINUTESPERWEEK)/2)<= 4)  ---!!!Need to check this out!!!
		 -- AND NOT EXISTS (SELECT SchoolCode,DISTRICTCODE FROM Datavalidation.School_LOCAL GROUP BY SchoolCode,DISTRICTCODE HAVING COUNT(*)>1) ---!!!Need to check this out!!!
		  AND (sch.SCHOOLCODE IS NOT NULL) 
		  AND (sch.SCHOOLNAME IS NOT NULL)
		  AND (sch.DISTRICTCODE IS NOT NULL)
		  AND (sch.MINUTESPERWEEK IS NOT NULL)
		 -- AND DistrictCode IN (SELECT DISTINCT DistrictCode FROM District_LOCAL)
*/
--================================================================================		  
--Log the count of successful records in ValidationSummaryReport
--================================================================================	 
 
INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'School','SuccessfulRecords',COUNT(*)
FROM Datavalidation.School 

IF (SELECT CURSOR_STATUS('global','chkSpecifications')) >=0 
BEGIN
DEALLOCATE chkSpecifications
END


DECLARE @tableschema VARCHAR(50),@tablename VARCHAR(50),@columnname VARCHAR(50),@datatype VARCHAR(50),@datalength VARCHAR(50),@isrequired bit,@isuniquefield bit,@isFkRelation bit, @parenttable VARCHAR(50),@parentcolumn VARCHAR(50),@islookupcolumn bit, @lookuptable VARCHAR(50),@lookupcolumn VARCHAR(50),@lookuptype VARCHAR(50),@isFlagfield bit,@flagrecords VARCHAR(50)

DECLARE chkSpecifications CURSOR FOR 
SELECT TableSchema, TableName,ColumnName,DataType,DataLength,IsRequired,IsUniqueField,IsFkRelation,ParentTable,ParentColumn,IsLookupColumn,LookupTable,LookupColumn,LookupType,IsFlagfield,FlagRecords
FROM Datavalidation.ValidationRules WHERE TableName = 'School'
--AND IS_NULLABLE = 'NO'

OPEN chkSpecifications

FETCH NEXT FROM chkSpecifications INTO @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
DECLARE @vsql nVARCHAR(MAX)
DECLARE @query nVARCHAR(MAX)
DECLARE @uncol nVARCHAR(MAX)
DECLARE @uniqoncol nVARCHAR(MAX)
SET @uncol = ''
SET @uniqoncol = ''
WHILE @@FETCH_STATUS = 0
BEGIN
------------------------------------------------
--Check the required fields
------------------------------------------------
IF (@isrequired=1)
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''School'',''The field '+@columnname+' is required field.'',Line_No,(ISNULL(CONVERT(VARCHAR(max),SchoolCode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SchoolName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DistrictCode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MinutesPerWeek),'''')) as line
FROM Datavalidation.School_LOCAL  WHERE 1 = 1'

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
SELECT ''School'',''The issue is in the datalength of the field '+@columnname+'.'',Line_No,(ISNULL(CONVERT(VARCHAR(max),SchoolCode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SchoolName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DistrictCode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MinutesPerWeek),'''')) as line
FROM Datavalidation.School_LOCAL  WHERE 1 = 1'

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
SELECT ''School'',''Some of the '+@parentcolumn+' does not exist in '+@parenttable+' File or were not validated successfully, but it existed in School.'',tsch.Line_No,(ISNULL(CONVERT(VARCHAR(max),tsch.SchoolCode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),tsch.SchoolName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),tsch.DistrictCode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),tsch.MinutesPerWeek),'''')) as line
FROM Datavalidation.School_LOCAL tsch'

SET @query  = ' LEFT JOIN Datavalidation.'+@parenttable+' dt ON tsch.'+@columnname+' = dt.'+@parentcolumn+' WHERE dt.'+@parentcolumn+' IS NULL'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END


IF (@datatype = 'int')
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''School'',''The field '+@columnname+' should have integer records.'',Line_No,(ISNULL(CONVERT(VARCHAR(max),SchoolCode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SchoolName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DistrictCode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MinutesPerWeek),'''')) as line FROM Datavalidation.School_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (Datavalidation.udf_IsInteger('+@columnname+') = 0 AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

END

--IF(@isuniquefield = 1)

--BEGIN
----SET @uncol = ''
--SET @uncol = @uncol +','+ @columnname
--SET @uniqoncol = @uniqoncol +'AND tsch.'+ @columnname+' = usch.'+@columnname
--END
--print @uncol
--print @uniqoncol

FETCH NEXT FROM chkSpecifications INTO  @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
END
CLOSE chkSpecifications
DEALLOCATE chkSpecifications

----------------------------------------------------------------------------------------------
--Checking the composite primary key  --!!Try to make as dynamic query for this!!
----------------------------------------------------------------------------------------------
--Is it important to check the combination of SchoolCode, DistrictCode?
INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT Distinct 'School','The combination SchoolCode ,DistrictCode is duplicated.',tsch.Line_No,ISNULL(tsch.SCHOOLCODE,'')+'|'+ISNULL(tsch.SCHOOLNAME,'')+'|'+ISNULL(tsch.DISTRICTCODE,'')+'|'+ISNULL(convert(varchar(10),tsch.MINUTESPERWEEK),'')
FROM Datavalidation.School_LOCAL tsch
JOIN (SELECT SchoolCode,DISTRICTCODE FROM Datavalidation.School_LOCAL GROUP BY SchoolCode,DISTRICTCODE HAVING COUNT(*)>1) ucsch
		 ON tsch.SCHOOLCODE = ucsch.SCHOOLCODE AND tsch.DistrictCode = ucsch.DistrictCode

END



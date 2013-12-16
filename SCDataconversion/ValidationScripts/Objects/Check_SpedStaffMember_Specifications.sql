IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'Check_SpedStaffMember_Specifications')
DROP PROC x_DATAVALIDATION.Check_SpedStaffMember_Specifications
GO

CREATE PROC x_DATAVALIDATION.Check_SpedStaffMember_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)

SET @sql = 'DELETE x_DATAVALIDATION.SpedStaffMember'
EXEC sp_executesql @stmt = @sql

---Validated data
DECLARE @sqlvalidated VARCHAR(MAX)
SET @sqlvalidated = 
'INSERT  x_DATAVALIDATION.SpedStaffMember  
SELECT sped.Line_No '
             
DECLARE @MaxCount INTEGER
DECLARE @Count INTEGER
DECLARE @sel VARCHAR(MAX)
DECLARE @tblsel table (id int, columnname varchar(50),datatype varchar(50),datalength varchar(5))
INSERT @tblsel
SELECT ColumnOrder,columnname,DataType,datalength
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'SpedStaffMember' 

SET @Count = 1
SET @sel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblsel)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'varchar')
    BEGIN
    SET @sel=@sel+', CONVERT ( VARCHAR ('+(SELECT datalength from @tblsel WHERE ID = @Count)+'), sped.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'datetime')
    BEGIN
    SET @sel=@sel+', CONVERT ( DATETIME , sped.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'int')
    BEGIN
    SET @sel=@sel+', CONVERT ( INT , sped.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE
    BEGIN
    SET @sel=@sel+', CONVERT ( VARCHAR ('+(SELECT datalength from @tblsel WHERE ID = @Count)+'), sped.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    SET @Count=@Count+1
    END
--print @sel
SET @sqlvalidated = @sqlvalidated + @sel+ ' FROM x_DATAVALIDATION.SpedStaffMember_Local sped'

DECLARE @Txtreq VARCHAR(MAX)
DECLARE @tblreq table (id int, columnname varchar(50))
INSERT @tblreq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'SpedStaffMember' AND IsRequired =1

SET @Count = 1
SET @Txtreq = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblreq)
WHILE @Count<=@MaxCount
    BEGIN
        SET @Txtreq=@Txtreq+' AND sped.'+(select columnname from @tblreq WHERE ID=@Count) + ' IS NOT NULL '
    SET @Count=@Count+1
    END
--SELECT @Txtreq AS Txt

DECLARE @Txtdatalength VARCHAR(MAX)
DECLARE @tbldl table (id int, columnname varchar(50),datalength varchar(10),isrequired bit)
INSERT @tbldl
SELECT ROW_NUMBER()over(order by columnname),columnname,datalength,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'SpedStaffMember' 
SET @Count = 1
SET @Txtdatalength = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldl)
WHILE @Count<=@MaxCount
    BEGIN
    IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE (DATALENGTH('+'sped.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    ELSE IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE ((DATALENGTH('+'sped.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (sped.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL))'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND ((DATALENGTH('+'sped.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (sped.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL))'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND (DATALENGTH('+'sped.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    SET @Count=@Count+1
    END
--SELECT @Txtdatalength AS Txtdl

DECLARE @Txtflag VARCHAR(MAX)
DECLARE @tblflag table (id int,columnname varchar(50),flagrecords varchar(50),isrequired varchar(50))
INSERT @tblflag
SELECT ROW_NUMBER()over(order by columnname),columnname,FlagRecords,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'SpedStaffMember' and IsFlagfield = 1

SET @Count = 1
SET @Txtflag = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblflag)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tblflag WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtflag=@Txtflag+' AND sped.'+(select columnname from @tblflag WHERE ID=@Count) + ' IN ('+(select flagrecords from @tblflag WHERE ID=@Count)+')'
    END
    ELSE IF ((select isrequired from @tblflag WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtflag=@Txtflag+' AND (sped.'+(select columnname from @tblflag WHERE ID=@Count) + ' IN ('+(select flagrecords from @tblflag WHERE ID=@Count)+') OR sped.'+(select columnname from @tblflag WHERE ID=@Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtflag AS Txtflag

DECLARE @Txtfkrel VARCHAR(MAX)
DECLARE @tblfkrel table (id int, columnname varchar(50),parenttable varchar(50), parentcolumn varchar(50))
INSERT @tblfkrel
SELECT ROW_NUMBER()over(order by columnname),columnname,ParentTable,ParentColumn
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'SpedStaffMember' AND IsFkRelation = 1
SET @Count = 1
SET @Txtfkrel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblfkrel)
WHILE @Count<=@MaxCount
    BEGIN
    SET @Txtfkrel=@Txtfkrel+' JOIN x_DATAVALIDATION.'+(SELECT parenttable FROM @tblfkrel WHERE ID= @Count)+' '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+' ON '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+'.'+(SELECT parentcolumn FROM @tblfkrel WHERE ID= @Count)+' = sped.'+(SELECT columnname FROM @tblfkrel WHERE ID= @Count)
    SET @Count=@Count+1
    END
--SELECT @Txtfkrel AS Txtfk

DECLARE @Txtlookup VARCHAR(MAX)
DECLARE @tbllookup table (id int, columnname varchar(50),lookuptable varchar(50),lookupcolumn varchar(50),lookuptype varchar(50), isrequired bit)
INSERT @tbllookup
SELECT ROW_NUMBER()over(order by columnname),columnname,LookupTable,LookupColumn,LookUpType,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'SpedStaffMember' AND IsLookupColumn = 1
SET @Count = 1
SET @Txtlookup = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbllookup)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND sped.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND sped.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+''')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND (sped.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' OR sped.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND sped.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+'''OR sped.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtlookup AS Txtl

DECLARE @Txtdatatype VARCHAR(MAX)
DECLARE @tbldttype table (id int, columnname varchar(50),datatype varchar(50),isrequired bit)
INSERT @tbldttype
SELECT ROW_NUMBER()over(order by columnname),columnname,DataType,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'SpedStaffMember' 

SET @Count = 1
SET @Txtdatatype = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldttype)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND x_DATAVALIDATION.udf_IsInteger( sped.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND (x_DATAVALIDATION.udf_IsInteger( sped.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR sped.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL)'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND ISDATE( sped.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND ( ISDATE( sped.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR sped.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL) '
    END
    SET @Count=@Count+1
    END
--SELECT @Txtdatatype AS Txt

DECLARE @Txtunique VARCHAR(MAX)
DECLARE @tbluq table (id int, columnname varchar(50))
INSERT @tbluq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'SpedStaffMember'  AND IsUniqueField = 1
SET @Count = 1
SET @Txtunique = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbluq)
WHILE @Count<=@MaxCount
    BEGIN
      SET @Txtunique=@Txtunique + ' JOIN (SELECT ' +(select columnname from @tbluq WHERE ID=@Count)+ ' FROM x_DATAVALIDATION.SpedStaffMember_LOCAL GROUP BY '+(select columnname from @tbluq WHERE ID=@Count)+' HAVING COUNT(*)=1) '+(select left(columnname,3) from @tbluq WHERE ID=@Count)+' ON ' +(select left(columnname,3) from @tbluq WHERE ID=@Count)+'.' +(select columnname from @tbluq WHERE ID=@Count) +' = sped.'+(select columnname from @tbluq WHERE ID=@Count) 
        SET @Count=@Count+1
    END
--SELECT @Txtunique AS Txtq

SET @sqlvalidated = @sqlvalidated +@Txtunique +@Txtfkrel+@Txtdatalength+@Txtreq+@Txtflag+@Txtdatatype
print @sqlvalidated

EXEC (@sqlvalidated)
/*
INSERT x_DATAVALIDATION.SpedStaffMember 
SELECT spedstaff.Line_No
      ,CONVERT(VARCHAR(150),spedstaff.STAFFEMAIL)
	  ,CONVERT(VARCHAR(50) ,spedstaff.LASTNAME)
	  ,CONVERT(VARCHAR(50) ,spedstaff.FIRSTNAME)
	  ,CONVERT(VARCHAR(50) ,spedstaff.ENRICHROLE)
	FROM x_DATAVALIDATION.SpedStaffMember_LOCAL spedstaff 
		 JOIN (SELECT StaffEmail FROM x_DATAVALIDATION.SpedStaffMember_LOCAL GROUP BY StaffEmail HAVING COUNT(*)=1) ucspedstaff ON spedstaff.STAFFEMAIL = ucspedstaff.STAFFEMAIL
    WHERE ((DATALENGTH(spedstaff.STAFFEMAIL)/2)<= 150 OR spedstaff.STAFFEMAIL IS NULL) 
		  AND ((DATALENGTH(spedstaff.LASTNAME)/2)<=50 OR spedstaff.LASTNAME IS NULL) 
		  AND ((DATALENGTH(spedstaff.FIRSTNAME)/2)<= 50 OR spedstaff.FIRSTNAME IS NULL) 
		  AND ((DATALENGTH(spedstaff.ENRICHROLE)/2)<=50 OR spedstaff.ENRICHROLE IS NULL) 
		  --AND NOT EXISTS (SELECT StaffEmail FROM x_DATAVALIDATION.SpedStaffMember_LOCAL GROUP BY StaffEmail HAVING COUNT(*)>1) 
		  AND (spedstaff.StaffEmail IS NOT NULL) 
		  AND (spedstaff.Lastname   IS NOT NULL)
		  AND (spedstaff.Firstname  IS NOT NULL)
		  */
--================================================================================		  
--Log the count of successful records
--================================================================================	   
INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'SpedStaffMember','SuccessfulRecords',COUNT(*)
FROM x_DATAVALIDATION.SpedStaffMember

--=========================================================================
--Log the Validation Results (If any issues we encounter)
--=========================================================================
IF (SELECT CURSOR_STATUS('global','chkSpecifications')) >=0 
BEGIN
DEALLOCATE chkSpecifications
END

DECLARE @tableschema VARCHAR(50),@tablename VARCHAR(50),@columnname VARCHAR(50),@datatype VARCHAR(50),@datalength VARCHAR(50),@isrequired bit,@isuniquefield bit,@isFkRelation bit, @parenttable VARCHAR(50),@parentcolumn VARCHAR(50),@islookupcolumn bit, @lookuptable VARCHAR(50),@lookupcolumn VARCHAR(50),@lookuptype VARCHAR(50),@isFlagfield bit,@flagrecords VARCHAR(50)

DECLARE chkSpecifications CURSOR FOR 
SELECT TableSchema, TableName,ColumnName,DataType,DataLength,IsRequired,IsUniqueField,IsFkRelation,ParentTable,ParentColumn,IsLookupColumn,LookupTable,LookupColumn,LookupType,IsFlagfield,FlagRecords
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'SpedStaffMember'

OPEN chkSpecifications

FETCH NEXT FROM chkSpecifications INTO @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
DECLARE @vsql nVARCHAR(MAX)
DECLARE @sumsql NVARCHAR(MAX)
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
SELECT ''SpedStaffMember'',''The field '+@columnname+' is required field.'',Line_No,ISNULL(CONVERT(VARCHAR(max),StaffEmail),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LASTNAME),'''')+ISNULL(CONVERT(VARCHAR(max),Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EnrichRole),'''')
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL WHERE 1 = 1 '

SET @query  = ' AND ('+@columnname+' IS NULL)'
SET @vsql = @vsql + @query
--PRINT @vsql
EXEC sp_executesql @stmt=@vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''SpedStaffMember'',''The field '+@columnname+' is required field.'', COUNT(*)
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL WHERE 1 = 1 '

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
SELECT ''SpedStaffMember'',''The issue is in the datalength of the field '+@columnname+'.'',Line_No,ISNULL(CONVERT(VARCHAR(max),StaffEmail),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LASTNAME),'''')+ISNULL(CONVERT(VARCHAR(max),Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EnrichRole),'''')
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL WHERE 1 = 1'

SET @query  = ' AND ((DATALENGTH ('+@columnname+')/2) > '+@datalength+' AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''SpedStaffMember'',''The issue is in the datalength of the field '+@columnname+'.'', COUNT(*)
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL WHERE 1 = 1 '

SET @query  = ' AND ((DATALENGTH ('+@columnname+')/2) > '+@datalength+' AND '+@columnname+' IS NOT NULL)'
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
SELECT ''SpedStaffMember'',''The '+@columnname+' ''''''+CONVERT(VARCHAR(MAX),sped.'+@columnname+')+'''''' does not exist in '+@parenttable+'  or were not validated successfully, but it existed in '+@tablename+'.'',Line_No,ISNULL(CONVERT(VARCHAR(max),sped.StaffEmail),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),sped.LASTNAME),'''')+ISNULL(CONVERT(VARCHAR(max),sped.Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),sped.EnrichRole),'''')
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL sped'

SET @query  = ' LEFT JOIN x_DATAVALIDATION.'+@parenttable+' dt ON sped.'+@columnname+' = dt.'+@parentcolumn+' WHERE dt.'+@parentcolumn+' IS NULL'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''SpedStaffMember'',''Some of the '+@parentcolumn+' does not exist in '+@parenttable+' File or were not validated successfully, but it existed in SpedStaffMember.'', COUNT(*)
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL sped'

SET @query  = ' LEFT JOIN x_DATAVALIDATION.'+@parenttable+' dt ON sped.'+@columnname+' = dt.'+@parentcolumn+' WHERE dt.'+@parentcolumn+' IS NULL'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END


IF (@isFlagfield = 1)
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''SpedStaffMember'',''The field '+@columnname+' should have one of the value in '''+LTRIM(REPLACE(@flagrecords,''',''','/'))+''', It has value as ''''''+'+@columnname+'+''''''.'',Line_No,ISNULL(CONVERT(VARCHAR(max),StaffEmail),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LASTNAME),'''')+ISNULL(CONVERT(VARCHAR(max),Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EnrichRole),'''')
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL '

SET @query  = '  WHERE ('+@columnname+' NOT IN  ('+@flagrecords+') AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''SpedStaffMember'',''The field '+@columnname+' should have one of the value in '''+LTRIM(REPLACE(@flagrecords,''',''','/'))+''''', COUNT(*)
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL '

SET @query  = '  WHERE ('+@columnname+' NOT IN  ('+@flagrecords+') AND '+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END


IF (@isuniquefield = 1)
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''SpedStaffMember'',''The field '+@columnname+' is unique field, Here ''''''+CONVERT(VARCHAR(MAX),sped.'+@columnname+')+'''''' record is repeated.'',sped.Line_No,ISNULL(CONVERT(VARCHAR(max),sped.StaffEmail),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),sped.LASTNAME),'''')+ISNULL(CONVERT(VARCHAR(max),sped.Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),sped.EnrichRole),'''')
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL sped JOIN'

SET @query  = ' (SELECT '+@columnname+' FROM x_DATAVALIDATION.SpedStaffMember_LOCAL GROUP BY '+@columnname+' HAVING COUNT(*)>1) ucsped ON ucsped.'+@columnname+' = sped.'+@columnname+' '
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''SpedStaffMember'',''The field '+@columnname+' is unique field, Here '+@columnname+' record is repeated.'', COUNT(*)
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL sped JOIN'

SET @query  = ' (SELECT '+@columnname+' FROM x_DATAVALIDATION.SpedStaffMember_LOCAL GROUP BY '+@columnname+' HAVING COUNT(*)>1) ucsped ON ucsped.'+@columnname+' = sped.'+@columnname+' '
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

IF (@islookupcolumn =1 AND @lookuptable = 'SelectLists')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''SpedStaffMember'',''The '+@columnname+' ''''''+ sped.'+@columnname+'+'''''' does not exist in '+@lookuptable+', but it existed in '+@tablename+''',sped.Line_No,ISNULL(CONVERT(VARCHAR(max),sped.StaffEmail),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),sped.LASTNAME),'''')+ISNULL(CONVERT(VARCHAR(max),sped.Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),sped.EnrichRole),'''')
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL sped '

SET @query  = ' WHERE (sped.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+' WHERE Type = '''+@lookuptype+''') AND sped.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''SpedStaffMember'',''The '+@columnname+' does not exist in '+@lookuptable+', but it existed in '+@tablename+''', COUNT(*)
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL sped JOIN'

SET @query  = ' WHERE (sped.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+' WHERE Type = '''+@lookuptype+''') AND sped.'+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

IF (@islookupcolumn =1 AND @lookuptable != 'SelectLists')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''SpedStaffMember'',''The '+@columnname+' ''''''+ sped.'+@columnname+'+'''''' does not exist in '+@lookuptable+', but it existed in '+@tablename+''',sped.Line_No,ISNULL(CONVERT(VARCHAR(max),sped.StaffEmail),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),sped.LASTNAME),'''')+ISNULL(CONVERT(VARCHAR(max),sped.Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),sped.EnrichRole),'''')
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL sped '

SET @query  = ' WHERE (sped.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+') AND sped.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''SpedStaffMember'',''The '+@columnname+' does not exist in '+@lookuptable+', but it existed in '+@tablename+''' COUNT(*)
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL sped JOIN'

SET @query  = ' WHERE (sped.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+') AND sped.'+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

IF (@datatype = 'int')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''SpedStaffMember'',''The field '+@columnname+' should have integer records.'',Line_No,ISNULL(CONVERT(VARCHAR(max),StaffEmail),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LASTNAME),'''')+ISNULL(CONVERT(VARCHAR(max),Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EnrichRole),'''')
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (x_DATAVALIDATION.udf_IsInteger('+@columnname+') = 0 AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''SpedStaffMember'',''The field '+@columnname+' should have integer records.'',COUNT(*)
FROM x_DATAVALIDATION.SpedStaffMember_LOCAL WHERE 1 = 1 '

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
---------------------------------------------------------------------------    
--Required Fields
---------------------------------------------------------------------------
-------------------------------------------------------------------------------
--Unique Fields
--------------------------------------------------------------------------------
 */    
END

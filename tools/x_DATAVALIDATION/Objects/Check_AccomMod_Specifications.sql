--Get rid off old version
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'Check_AccomMod_Specifications')
DROP PROC x_DATAVALIDATION.Check_AccomMod_Specifications
GO

CREATE PROC x_DATAVALIDATION.Check_AccomMod_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE x_DATAVALIDATION.AccomMod'
EXEC sp_executesql @stmt = @sql

---Validated data
DECLARE @sqlvalidated VARCHAR(MAX)
SET @sqlvalidated = 
'INSERT  x_DATAVALIDATION.AccomMod  
SELECT ac.Line_No '
             
DECLARE @MaxCount INTEGER
DECLARE @Count INTEGER
DECLARE @sel VARCHAR(MAX)
DECLARE @tblsel table (id int, columnname varchar(50),datatype varchar(50),datalength varchar(5))
INSERT @tblsel
SELECT ColumnOrder,columnname,DataType,datalength
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'AccomMod' 

SET @Count = 1
SET @sel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblsel)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'varchar')
    BEGIN
    SET @sel=@sel+', CONVERT ( VARCHAR ('+(SELECT datalength from @tblsel WHERE ID = @Count)+'), ac.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'datetime')
    BEGIN
    SET @sel=@sel+', CONVERT ( DATETIME , ac.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'int')
    BEGIN
    SET @sel=@sel+', CONVERT ( INT , ac.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE
    BEGIN
    SET @sel=@sel+', CONVERT ( VARCHAR ('+(SELECT datalength from @tblsel WHERE ID = @Count)+'), ac.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    SET @Count=@Count+1
    END
--print @sel
SET @sqlvalidated = @sqlvalidated + @sel+ ' FROM x_DATAVALIDATION.AccomMod_Local ac '

DECLARE @Txtreq VARCHAR(MAX)
DECLARE @tblreq table (id int, columnname varchar(50))
INSERT @tblreq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'AccomMod' AND IsRequired =1

SET @Count = 1
SET @Txtreq = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblreq)
WHILE @Count<=@MaxCount
    BEGIN
        SET @Txtreq=@Txtreq+' AND ac.'+(select columnname from @tblreq WHERE ID=@Count) + ' IS NOT NULL '
    SET @Count=@Count+1
    END
--SELECT @Txtreq AS Txt

DECLARE @Txtdatalength VARCHAR(MAX)
DECLARE @tbldl table (id int, columnname varchar(50),datalength varchar(10),isrequired bit)
INSERT @tbldl
SELECT ROW_NUMBER()over(order by columnname),columnname,datalength,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'AccomMod' 
SET @Count = 1
SET @Txtdatalength = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldl)
WHILE @Count<=@MaxCount
    BEGIN
    IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE (DATALENGTH('+'ac.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    ELSE IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE ((DATALENGTH('+'ac.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (ac.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL))'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND ((DATALENGTH('+'ac.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (ac.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL))'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND (DATALENGTH('+'ac.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    SET @Count=@Count+1
    END
--SELECT @Txtdatalength AS Txtdl

DECLARE @Txtflag VARCHAR(MAX)
DECLARE @tblflag table (id int,columnname varchar(50),flagrecords varchar(50),isrequired varchar(50))
INSERT @tblflag
SELECT ROW_NUMBER()over(order by columnname),columnname,FlagRecords,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'AccomMod' and IsFlagfield = 1

SET @Count = 1
SET @Txtflag = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblflag)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tblflag WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtflag=@Txtflag+' AND ac.'+(select columnname from @tblflag WHERE ID=@Count) + ' IN ('+(select flagrecords from @tblflag WHERE ID=@Count)+')'
    END
    ELSE IF ((select isrequired from @tblflag WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtflag=@Txtflag+' AND (ac.'+(select columnname from @tblflag WHERE ID=@Count) + ' IN ('+(select flagrecords from @tblflag WHERE ID=@Count)+') OR ac.'+(select columnname from @tblflag WHERE ID=@Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtflag AS Txtflag

DECLARE @Txtfkrel VARCHAR(MAX)
DECLARE @tblfkrel table (id int, columnname varchar(50),parenttable varchar(50), parentcolumn varchar(50))
INSERT @tblfkrel
SELECT ROW_NUMBER()over(order by columnname),columnname,ParentTable,ParentColumn
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'AccomMod' AND IsFkRelation = 1
SET @Count = 1
SET @Txtfkrel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblfkrel)
WHILE @Count<=@MaxCount
    BEGIN
    SET @Txtfkrel=@Txtfkrel+' JOIN x_DATAVALIDATION.'+(SELECT parenttable FROM @tblfkrel WHERE ID= @Count)+' '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+' ON '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+'.'+(SELECT parentcolumn FROM @tblfkrel WHERE ID= @Count)+' = ac.'+(SELECT columnname FROM @tblfkrel WHERE ID= @Count)
    SET @Count=@Count+1
    END
--SELECT @Txtfkrel AS Txtfk

DECLARE @Txtlookup VARCHAR(MAX)
DECLARE @tbllookup table (id int, columnname varchar(50),lookuptable varchar(50),lookupcolumn varchar(50),lookuptype varchar(50), isrequired bit)
INSERT @tbllookup
SELECT ROW_NUMBER()over(order by columnname),columnname,LookupTable,LookupColumn,LookUpType,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'AccomMod' AND IsLookupColumn = 1
SET @Count = 1
SET @Txtlookup = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbllookup)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND ac.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND ac.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+''')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND (ac.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' OR ac.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND ac.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+'''OR ac.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtlookup AS Txtl

DECLARE @Txtunique VARCHAR(MAX)
DECLARE @tbluq table (id int, columnname varchar(50))
INSERT @tbluq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'AccomMod'  AND IsUniqueField = 1
SET @Count = 1
SET @Txtunique = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbluq)
WHILE @Count<=@MaxCount
    BEGIN
        SET @Txtunique=@Txtunique + ' JOIN (SELECT ' +(select columnname from @tbluq WHERE ID=@Count)+ ' FROM x_DATAVALIDATION.AccomMod_LOCAL GROUP BY '+(select columnname from @tbluq WHERE ID=@Count)+' HAVING COUNT(*)=1) ucac ON ucac.' +(select columnname from @tbluq WHERE ID=@Count) +'= ac. '+(select columnname from @tbluq WHERE ID=@Count)
        
        SET @Count=@Count+1
    END
--SELECT @Txtunique AS Txtq



DECLARE @Txtdatatype VARCHAR(MAX)
DECLARE @tbldttype table (id int, columnname varchar(50),datatype varchar(50),isrequired bit)
INSERT @tbldttype
SELECT ROW_NUMBER()over(order by columnname),columnname,DataType,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'AccomMod' 

SET @Count = 1
SET @Txtdatatype = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldttype)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND x_DATAVALIDATION.udf_IsInteger( ac.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND (x_DATAVALIDATION.udf_IsInteger( ac.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR ac.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL)'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND ISDATE( ac.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND ( ISDATE( ac.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR ac.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL) '
    END
    SET @Count=@Count+1
    END
--SELECT @Txtdatatype AS Txt

--DECLARE @Txtunique VARCHAR(MAX)
--SET @Txtunique = ' JOIN (SELECT StaffEmail,StudentRefId FROM x_DATAVALIDATION.TeamMember_LOCAL GROUP BY StaffEmail,StudentRefId HAVING COUNT(*)=1) ucteam ON (ucteam.StaffEmail = team.StaffEmail) AND (ucteam.StudentRefID = team.StudentRefID)'
SET @sqlvalidated = @sqlvalidated +@Txtunique+@Txtfkrel+@Txtdatalength+@Txtreq+@Txtflag+@Txtdatatype
--print @sqlvalidated

EXEC (@sqlvalidated)

/*
INSERT x_DATAVALIDATION.TeamMember 
SELECT team.Line_No
      ,CONVERT(VARCHAR(150),team.StaffEmail)
	  ,CONVERT(VARCHAR(150),team.StudentRefId)
	  ,CONVERT(VARCHAR(1),team.IsCaseManager)
	FROM x_DATAVALIDATION.TeamMember_LOCAL team 
		 JOIN x_DATAVALIDATION.Student st ON st.StudentRefID = team.StudentRefID
		 JOIN x_DATAVALIDATION.SpedStaffMember sped ON sped.StaffEmail = team.StaffEmail
		 JOIN (SELECT StaffEmail,StudentRefId FROM x_DATAVALIDATION.TeamMember_LOCAL GROUP BY StaffEmail,StudentRefId HAVING COUNT(*)=1) ucteam
		 ON (ucteam.StaffEmail = team.StaffEmail) AND (ucteam.StudentRefID = team.StudentRefID)
    WHERE ((DATALENGTH(team.StaffEmail)/2)<= 150) 
		  AND ((DATALENGTH(team.StudentRefId)/2) <=150) 
		  AND ((DATALENGTH(team.IsCaseManager)/2) <= 1) 
		  AND (team.StaffEmail IS NOT NULL) 
		  AND (team.StudentRefId IS NOT NULL)
		  AND (team.IsCaseManager IS NOT NULL AND team.IsCaseManager IN ('Y','N'))
	*/	  		
--================================================================================		  
--Log the count of successful records
--================================================================================    
INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'AccomMod','SuccessfulRecords',COUNT(*)
FROM x_DATAVALIDATION.AccomMod
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
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'AccomMod'

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
SELECT ''AccomMod'',''The field '+@columnname+' is required field.'',Line_No,ISNULL(CONVERT(VARCHAR(max),IEPRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),AccomStatement),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ModStatement),'''')
FROM x_DATAVALIDATION.AccomMod_LOCAL WHERE 1 = 1'

SET @query  = ' AND ('+@columnname+' IS NULL)'
SET @vsql = @vsql + @query
--PRINT @vsql
EXEC sp_executesql @stmt=@vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''AccomMod'',''The field '+@columnname+' is required field.'', COUNT(*)
FROM x_DATAVALIDATION.AccomMod_LOCAL WHERE 1 = 1 '

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
SELECT ''AccomMod'',''The issue is in the datalength of the field '+@columnname+'.'',Line_No,ISNULL(IEPRefID,'''')+''|''+ISNULL(CONVERT(VARCHAR(max),AccomStatement),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ModStatement),'''')
FROM x_DATAVALIDATION.AccomMod_LOCAL WHERE 1 = 1'

SET @query  = ' AND ((DATALENGTH ('+@columnname+')/2) > '+@datalength+' AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''AccomMod'',''The issue is in the datalength of the field '+@columnname+'.'', COUNT(*)
FROM x_DATAVALIDATION.AccomMod_LOCAL WHERE 1 = 1 '

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
SELECT ''AccomMod'',''The '+@columnname+' ''''''+CONVERT(VARCHAR(MAX),ac.'+@columnname+')+'''''' does not exist in '+@parenttable+'  or were not validated successfully, but it existed in '+@tablename+'.'',ac.Line_No,ISNULL(CONVERT(VARCHAR(max),ac.IEPRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ac.AccomStatement),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ac.ModStatement),'''')
FROM x_DATAVALIDATION.AccomMod_LOCAL ac '

SET @query  = ' LEFT JOIN x_DATAVALIDATION.'+@parenttable+' dt ON ac.'+@columnname+' = dt.'+@parentcolumn+' WHERE dt.'+@parentcolumn+' IS NULL'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''AccomMod'',''Some of the '+@parentcolumn+' does not exist in '+@parenttable+' File or were not validated successfully, but it existed in '+@tablename+'.'', COUNT(*)
FROM x_DATAVALIDATION.AccomMod_LOCAL ac '

SET @query  = ' LEFT JOIN x_DATAVALIDATION.'+@parenttable+' dt ON ac.'+@columnname+' = dt.'+@parentcolumn+' WHERE dt.'+@parentcolumn+' IS NULL'
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
SELECT ''AccomMod'',''The field '+@columnname+' should have one of the value in '''+LTRIM(REPLACE(@flagrecords,''',''','/'))+''', It has value as ''''''+ac.'+@columnname+'+''''''.'',ac.Line_No,ISNULL(CONVERT(VARCHAR(max),ac.IEPRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ac.AccomStatement),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ac.ModStatement),'''')
FROM x_DATAVALIDATION.AccomMod_LOCAL ac '

SET @query  = '  WHERE (ac.'+@columnname+' NOT IN  ('+@flagrecords+') AND ac.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''AccomMod'',''The field '+@columnname+' should have one of the value in '''+LTRIM(REPLACE(@flagrecords,''',''','/'))+''''', COUNT(*)
FROM x_DATAVALIDATION.AccomMod_LOCAL ac '

SET @query  = '  WHERE (ac.'+@columnname+' NOT IN  ('+@flagrecords+') AND ac.'+@columnname+' IS NOT NULL)'
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
SELECT ''AccomMod'',''The field '+@columnname+' is unique field, Here ''''''+CONVERT(VARCHAR(MAX),ac.'+@columnname+')+'''''' record is repeated.'',ac.Line_No,ISNULL(CONVERT(VARCHAR(max),ac.IEPRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ac.AccomStatement),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ac.ModStatement),'''')
FROM x_DATAVALIDATION.AccomMod_LOCAL ac  JOIN'

SET @query  = ' (SELECT IEPRefId FROM x_DATAVALIDATION.AccomMod_LOCAL GROUP BY IEPRefId HAVING COUNT(*)>1) ucac ON (ucac.IEPRefID = ac.IEPRefID)'
--SET @query  = ' (SELECT '+@columnname+' FROM x_DATAVALIDATION.Service_LOCAL GROUP BY '+@columnname+' HAVING COUNT(*)>1) ucteam ON ucteam.'+@columnname+' = team.'+@columnname+' '
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql


SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''AccomMod'',''The field '+@columnname+' is unique field, Here '+@columnname+' record is repeated.'', COUNT(*)
FROM x_DATAVALIDATION.AccomMod_LOCAL ac JOIN '

SET @query  = ' (SELECT IEPRefId FROM x_DATAVALIDATION.AccomMod_LOCAL GROUP BY IEPRefId HAVING COUNT(*)>1) ucac ON (ucac.IEPRefID = ac.IEPRefID)'

SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

-------------------------------------------------------------------
--Check the lookup field and referntial issues
-------------------------------------------------------------------

IF (@islookupcolumn = 1 AND @lookuptable = 'SelectLists')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''AccomMod'',''The '+@columnname+' ''''''+ ac.'+@columnname+'+'''''' does not exist in '+@lookuptable+', but it existed in '+@tablename+''',ac.Line_No,ISNULL(CONVERT(VARCHAR(max),ac.IEPRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ac.AccomStatement),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ac.ModStatement),'''')
FROM x_DATAVALIDATION.AccomMod_LOCAL ac  '

SET @query  = ' WHERE (ac.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+' WHERE Type = '''+@lookuptype+''') AND ac.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''AccomMod'',''The '+@columnname+' does not exist in '+@lookuptable+', but it existed in '+@tablename+''', COUNT(*)
FROM x_DATAVALIDATION.AccomMod_LOCAL ac JOIN '

SET @query  = ' WHERE (ac.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+' WHERE Type = '''+@lookuptype+''') AND ac.'+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

IF (@islookupcolumn =1 AND @lookuptable != 'SelectLists')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''AccomMod'',''The '+@columnname+' ''''''+ ac.'+@columnname+'+'''''' does not exist in '+@lookuptable+', but it existed in '+@tablename+''',ac.Line_No,ISNULL(CONVERT(VARCHAR(max),ac.IEPRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ac.AccomStatement),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ac.ModStatement),'''')
FROM x_DATAVALIDATION.AccomMod_LOCAL ac '

SET @query  = '  WHERE (ac.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+') AND ac.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''AccomMod'',''The '+@columnname+' does not exist in '+@lookuptable+', but it existed in '+@tablename+''', COUNT(*)
FROM x_DATAVALIDATION.AccomMod_LOCAL ac '

SET @query  = '  WHERE (ac.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+') AND ac.'+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END


IF (@datatype = 'datetime')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''AccomMod'',''The date format issue is in '+@columnname+'.'',Line_No,ISNULL(CONVERT(VARCHAR(max),IEPRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),AccomStatement),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ModStatement),'''')
FROM x_DATAVALIDATION.AccomMod_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (ISDATE('''+@columnname+''') = 0 AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''AccomMod'',''The date format issue is in '+@columnname+'.'', COUNT(*)
FROM x_DATAVALIDATION.AccomMod_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (ISDATE('''+@columnname+''') = 0 AND '+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

IF (@datatype = 'int')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''AccomMod'',''The field '+@columnname+' should have integer records.'',Line_No,ISNULL(CONVERT(VARCHAR(max),IEPRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),AccomStatement),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ModStatement),'''')
FROM x_DATAVALIDATION.AccomMod_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (x_DATAVALIDATION.udf_IsInteger('+@columnname+') = 0 AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''AccomMod'',''The field '+@columnname+' should have integer records.'', COUNT(*)
FROM x_DATAVALIDATION.AccomMod_LOCAL WHERE 1 = 1 '

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
--To check the Datalength of the fields
-----------------------------------------------------------
---Required Fields
-----------------------------------------------------------
-----------------------------------------------------------
--To Check Duplicate Records
-----------------------------------------------------------
--------------------------------------------------------------
--To Check the Referential Integrity
--------------------------------------------------------------
*/      
END



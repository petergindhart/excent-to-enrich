IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'Check_District_Specifications')
DROP PROC x_DATAVALIDATION.Check_District_Specifications
GO
/*
To check the specfication of District file with our data specification
*/
CREATE PROC x_DATAVALIDATION.Check_District_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
--Delete the old data
SET @sql = 'DELETE x_DATAVALIDATION.District'
EXEC sp_executesql @stmt = @sql

---Validated data
DECLARE @sqlvalidated nVARCHAR(MAX)
SET @sqlvalidated = 
'INSERT  x_DATAVALIDATION.District
SELECT dt.Line_No '
             
DECLARE @MaxCount INTEGER
DECLARE @Count INTEGER
DECLARE @sel VARCHAR(MAX)
DECLARE @tblsel table (id int, columnname varchar(50),datatype varchar(50),datalength varchar(5))
INSERT @tblsel
SELECT ColumnOrder,columnname,DataType,datalength
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'District' 

SET @Count = 1
SET @sel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblsel)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'varchar')
    SET @sel=@sel+', CONVERT ( VARCHAR ('+(SELECT datalength from @tblsel WHERE ID = @Count)+'), dt.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    SET @Count=@Count+1
    END
--print @sel
SET @sqlvalidated = @sqlvalidated + @sel+ ' FROM x_DATAVALIDATION.District_Local dt'

DECLARE @Txtreq VARCHAR(MAX)
DECLARE @tblreq table (id int, columnname varchar(50))
INSERT @tblreq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'District' AND IsRequired =1

SET @Count = 1
SET @Txtreq = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblreq)
WHILE @Count<=@MaxCount
    BEGIN
        SET @Txtreq=@Txtreq+' AND dt.'+(select columnname from @tblreq WHERE ID=@Count) + ' IS NOT NULL '
    SET @Count=@Count+1
    END
--SELECT @Txtreq AS Txt

DECLARE @Txtdatalength VARCHAR(MAX)
DECLARE @tbldl table (id int, columnname varchar(50),datalength varchar(10))
INSERT @tbldl
SELECT ROW_NUMBER()over(order by columnname),columnname,datalength
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'District' 
SET @Count = 1
SET @Txtdatalength = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldl)
WHILE @Count<=@MaxCount
    BEGIN
    IF (@Txtdatalength = '')
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE (DATALENGTH('+'dt.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    ELSE
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND (DATALENGTH('+'dt.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    SET @Count=@Count+1
    END
    END
--SELECT @Txtdatalength AS Txta

DECLARE @Txtunique VARCHAR(MAX)
DECLARE @tbluq table (id int, columnname varchar(50))
INSERT @tbluq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'District'  AND IsUniqueField = 1
SET @Count = 1
SET @Txtunique = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbluq)
WHILE @Count<=@MaxCount
    BEGIN
    SET @Txtunique=@Txtunique + ' JOIN (SELECT ' +(select columnname from @tbluq WHERE ID=@Count)+ ' FROM x_DATAVALIDATION.District_LOCAL GROUP BY '+(select columnname from @tbluq WHERE ID=@Count)+' HAVING COUNT(*)=1) '+(select left(columnname,5) from @tbluq WHERE ID=@Count)+' ON ' +(select left(columnname,5) from @tbluq WHERE ID=@Count)+'.' +(select columnname from @tbluq WHERE ID=@Count) +' = dt.'+(select columnname from @tbluq WHERE ID=@Count)  
        
        SET @Count=@Count+1
    END
--SELECT @Txtunique AS Txtq

SET @sqlvalidated = @sqlvalidated +@Txtunique +@Txtdatalength+@Txtreq
--print @sqlvalidated

EXEC sp_executesql @stmt = @sqlvalidated


/*
INSERT  x_DATAVALIDATION.District
SELECT
       td.Line_No
      ,CONVERT(VARCHAR(10),td.DISTRICTCODE)
	  ,CONVERT(VARCHAR(255),td.DISTRICTNAME)
	FROM x_DATAVALIDATION.District_Local td
		 JOIN (SELECT DISTRICTCODE FROM x_DATAVALIDATION.District_Local GROUP BY DISTRICTCODE HAVING COUNT(*)=1) uctd ON uctd.DISTRICTCODE =td.DISTRICTCODE 
    WHERE ((DATALENGTH(td.DISTRICTCODE)/2)<= 10) 
		  AND ((DATALENGTH(td.DISTRICTNAME)/2)<=255) 
		  AND (td.DISTRICTCODE IS NOT NULL) 
		  AND (td.DISTRICTNAME IS NOT NULL)
*/
--========================================================================	  
--Log the count of successful records
--========================================================================
INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'District','SuccessfulRecords',COUNT(*) as cnt 
FROM x_DATAVALIDATION.District
--=========================================================================
--Log the Validation Results (If any issues we encounter)
--=========================================================================

--select * from x_DATAVALIDATION.ValidationRules

IF (SELECT CURSOR_STATUS('global','chkSpecifications')) >=0 
BEGIN
DEALLOCATE chkSpecifications
END

DECLARE @tableschema VARCHAR(50),@tablename VARCHAR(50),@columnname VARCHAR(50),@datatype VARCHAR(50),@datalength VARCHAR(50),@isrequired bit,@isuniquefield bit,@isFkRelation bit, @parenttable VARCHAR(50),@parentcolumn VARCHAR(50),@islookupcolumn bit, @lookuptable VARCHAR(50),@lookupcolumn VARCHAR(50),@lookuptype VARCHAR(50),@isFlagfield bit,@flagrecords VARCHAR(50)

DECLARE chkSpecifications CURSOR FOR 
SELECT TableSchema, TableName,ColumnName,DataType,DataLength,IsRequired,IsUniqueField,IsFkRelation,ParentTable,ParentColumn,IsLookupColumn,LookupTable,LookupColumn,LookupType,IsFlagfield,FlagRecords
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'District'
--AND IS_NULLABLE = 'NO'

OPEN chkSpecifications

FETCH NEXT FROM chkSpecifications INTO @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
DECLARE @vsql nVARCHAR(MAX)
DECLARE @sumsql nVARCHAR(MAX)
DECLARE @query nVARCHAR(MAX)
WHILE @@FETCH_STATUS = 0
BEGIN
--Check the required fields
IF (@isrequired=1)
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''District'',''The field '+@columnname+' is required field.'',Line_No,(ISNULL(CONVERT(VARCHAR(max),DISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISTRICTNAME),'''')) as line
FROM x_DATAVALIDATION.District_Local WHERE 1 = 1 '

SET @query  = ' AND ('+@columnname+' IS NULL)'
SET @vsql = @vsql + @query
--PRINT @vsql
EXEC sp_executesql @stmt=@vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''District'',''The field '+@columnname+' is required field, it cannot be empty.'', COUNT(*)
FROM x_DATAVALIDATION.District_Local WHERE 1 = 1 '

SET @query  = ' AND ('+@columnname+' IS NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END
--Check the datalength of Every Fields in the file
IF (1=1)
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''District'',''The issue is in the datalength of the field '+@columnname+'.'',Line_No,(ISNULL(CONVERT(VARCHAR(max),DISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISTRICTNAME),'''')) as line
FROM x_DATAVALIDATION.District_Local WHERE 1 = 1'

SET @query  = ' AND ((DATALENGTH ('+@columnname+')/2) > '+@datalength+' AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''District'',''The issue is in the datalength of the field '+@columnname+'.'', COUNT(*)
FROM x_DATAVALIDATION.District_Local WHERE 1 = 1 '

SET @query  = ' AND ((DATALENGTH ('+@columnname+')/2) > '+@datalength+' AND '+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

IF (@isuniquefield = 1 )

BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''District'',''The field '+@columnname+' is unique field, Here the record "''+dt.'+@columnname+'+''"is repeated.'',dt.Line_No,(ISNULL(CONVERT(VARCHAR(max),dt.DISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),dt.DISTRICTNAME),'''')) as line
FROM x_DATAVALIDATION.District_Local dt JOIN '

SET @query  = ' (SELECT '+@columnname+' FROM x_DATAVALIDATION.District_Local GROUP BY '+@columnname+' HAVING COUNT(*)>1) uctd ON uctd.'+@columnname+' =dt.'+@columnname+''
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''District'',''The field '+@columnname+' is unique field, It cannot be repeated.'', COUNT(*)
FROM x_DATAVALIDATION.District_Local dt JOIN '

SET @query  = ' (SELECT '+@columnname+' FROM x_DATAVALIDATION.District_Local GROUP BY '+@columnname+' HAVING COUNT(*)>1) uctd ON uctd.'+@columnname+' =dt.'+@columnname+''
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END


FETCH NEXT FROM chkSpecifications INTO  @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
END
CLOSE chkSpecifications
DEALLOCATE chkSpecifications
/*
--DataLength issues
--Required Columns
--Unique Constraint     
 */    
END


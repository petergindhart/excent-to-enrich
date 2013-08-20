--Get rid off old version
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'Check_IEP_Specifications')
DROP PROC x_DATAVALIDATION.Check_IEP_Specifications
GO

CREATE PROC x_DATAVALIDATION.Check_IEP_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)

SET @sql = 'DELETE x_DATAVALIDATION.IEP'
EXEC sp_executesql @stmt = @sql

---Validated data
DECLARE @sqlvalidated VARCHAR(MAX)
SET @sqlvalidated = 
'INSERT  x_DATAVALIDATION.IEP  
SELECT i.Line_No '
--fields to insert             
DECLARE @MaxCount INTEGER
DECLARE @Count INTEGER
DECLARE @sel VARCHAR(MAX)
DECLARE @tblsel table (id int, columnname varchar(50),datatype varchar(50),datalength varchar(5))
INSERT @tblsel
SELECT ColumnOrder,columnname,DataType,datalength
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'IEP' 

SET @Count = 1
SET @sel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblsel)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'varchar')
    BEGIN
    SET @sel=@sel+', CONVERT ( VARCHAR ('+(SELECT datalength from @tblsel WHERE ID = @Count)+'), i.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'datetime')
    BEGIN
    SET @sel=@sel+', CONVERT ( DATETIME , i.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'int')
    BEGIN
    SET @sel=@sel+', CONVERT ( INT , i.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE
    BEGIN
    SET @sel=@sel+', CONVERT ( VARCHAR ('+(SELECT datalength from @tblsel WHERE ID = @Count)+'), i.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    SET @Count=@Count+1
    END
--print @sel
SET @sqlvalidated = @sqlvalidated + @sel+ ' FROM x_DATAVALIDATION.IEP_Local i'
--checking the required fields
DECLARE @Txtreq VARCHAR(MAX)
DECLARE @tblreq table (id int, columnname varchar(50))
INSERT @tblreq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'IEP' AND IsRequired =1

SET @Count = 1
SET @Txtreq = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblreq)
WHILE @Count<=@MaxCount
    BEGIN
        SET @Txtreq=@Txtreq+' AND i.'+(select columnname from @tblreq WHERE ID=@Count) + ' IS NOT NULL '
    SET @Count=@Count+1
    END
--SELECT @Txtreq AS Txt
--checking the datalength of records
DECLARE @Txtdatalength VARCHAR(MAX)
DECLARE @tbldl table (id int, columnname varchar(50),datalength varchar(10),isrequired bit)
INSERT @tbldl
SELECT ROW_NUMBER()over(order by columnname),columnname,datalength,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'IEP' 
SET @Count = 1
SET @Txtdatalength = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldl)
WHILE @Count<=@MaxCount
    BEGIN
    IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE (DATALENGTH('+'i.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    ELSE IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE ((DATALENGTH('+'i.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (i.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL))'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND ((DATALENGTH('+'i.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (i.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL))'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND (DATALENGTH('+'i.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    SET @Count=@Count+1
    END
--SELECT @Txtdatalength AS Txtdl

DECLARE @Txtflag VARCHAR(MAX)
DECLARE @tblflag table (id int,columnname varchar(50),flagrecords varchar(50),isrequired varchar(50))
INSERT @tblflag
SELECT ROW_NUMBER()over(order by columnname),columnname,FlagRecords,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'IEP' and IsFlagfield = 1

SET @Count = 1
SET @Txtflag = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblflag)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tblflag WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtflag=@Txtflag+' AND i.'+(select columnname from @tblflag WHERE ID=@Count) + ' IN ('+(select flagrecords from @tblflag WHERE ID=@Count)+')'
    END
    ELSE IF ((select isrequired from @tblflag WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtflag=@Txtflag+' AND (i.'+(select columnname from @tblflag WHERE ID=@Count) + ' IN ('+(select flagrecords from @tblflag WHERE ID=@Count)+') OR i.'+(select columnname from @tblflag WHERE ID=@Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtflag AS Txtflag

DECLARE @Txtfkrel VARCHAR(MAX)
DECLARE @tblfkrel table (id int, columnname varchar(50),parenttable varchar(50), parentcolumn varchar(50))
INSERT @tblfkrel
SELECT ROW_NUMBER()over(order by columnname),columnname,ParentTable,ParentColumn
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'IEP' AND IsFkRelation = 1
SET @Count = 1
SET @Txtfkrel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblfkrel)
WHILE @Count<=@MaxCount
    BEGIN
    SET @Txtfkrel=@Txtfkrel+' JOIN x_DATAVALIDATION.'+(SELECT parenttable FROM @tblfkrel WHERE ID= @Count)+' '+(SELECT LEFT(parenttable,4) FROM @tblfkrel WHERE ID= @Count)+' ON '+(SELECT LEFT(parenttable,4) FROM @tblfkrel WHERE ID= @Count)+'.'+(SELECT parentcolumn FROM @tblfkrel WHERE ID= @Count)+' = i.'+(SELECT columnname FROM @tblfkrel WHERE ID= @Count)
    SET @Count=@Count+1
    END
--SELECT @Txtfkrel AS Txtfk

DECLARE @Txtlookup VARCHAR(MAX)
DECLARE @tbllookup table (id int, columnname varchar(50),lookuptable varchar(50),lookupcolumn varchar(50),lookuptype varchar(50), isrequired bit)
INSERT @tbllookup
SELECT ROW_NUMBER()over(order by columnname),columnname,LookupTable,LookupColumn,LookUpType,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'IEP' AND IsLookupColumn = 1
SET @Count = 1
SET @Txtlookup = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbllookup)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND i.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND i.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+''')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND (i.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' OR i.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND i.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+'''OR i.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtlookup AS Txtl

DECLARE @Txtdatatype VARCHAR(MAX)
DECLARE @tbldttype table (id int, columnname varchar(50),datatype varchar(50),isrequired bit)
INSERT @tbldttype
SELECT ROW_NUMBER()over(order by columnname),columnname,DataType,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'IEP' 

SET @Count = 1
SET @Txtdatatype = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldttype)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND x_DATAVALIDATION.udf_IsInteger( i.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND (x_DATAVALIDATION.udf_IsInteger( i.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR i.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL)'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND ISDATE( i.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND ( ISDATE( i.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR i.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL) '
    END
    SET @Count=@Count+1
    END
--SELECT @Txtdatatype AS Txt

DECLARE @Txtunique VARCHAR(MAX)
DECLARE @tbluq table (id int, columnname varchar(50))
INSERT @tbluq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'IEP'  AND IsUniqueField = 1
SET @Count = 1
SET @Txtunique = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbluq)
WHILE @Count<=@MaxCount
    BEGIN
     SET @Txtunique=@Txtunique + ' JOIN (SELECT ' +(select columnname from @tbluq WHERE ID=@Count)+ ' FROM x_DATAVALIDATION.IEP_LOCAL GROUP BY '+(select columnname from @tbluq WHERE ID=@Count)+' HAVING COUNT(*)=1) '+(select left(columnname,3) from @tbluq WHERE ID=@Count)+' ON ' +(select left(columnname,3) from @tbluq WHERE ID=@Count)+'.' +(select columnname from @tbluq WHERE ID=@Count) +' = i.'+(select columnname from @tbluq WHERE ID=@Count)        
        SET @Count=@Count+1
    END
--SELECT @Txtunique AS Txtq

SET @sqlvalidated = @sqlvalidated +@Txtunique +@Txtfkrel+@Txtdatalength+@Txtreq+@Txtflag+@Txtdatatype
--print @sqlvalidated

EXEC (@sqlvalidated)

/*
INSERT x_DATAVALIDATION.IEP 
SELECT iep.Line_No
      ,CONVERT(VARCHAR(150),iep.IepRefID)
	  ,CONVERT(VARCHAR(150),iep.StudentRefID)
	  ,CONVERT(DATETIME ,iep.IEPMeetDate)
	  ,CONVERT(DATETIME ,iep.IEPStartDate)
	  ,CONVERT(DATETIME ,iep.IEPEndDate)
	  ,CONVERT(DATETIME ,iep.NEXTREVIEWDATE)
	  ,CONVERT(DATETIME ,iep.InitialEvaluationDate)
	  ,CONVERT(DATETIME ,iep.LatestEvaluationDate)
	  ,CONVERT(DATETIME ,iep.NextEvaluationDate)
	  ,CONVERT(DATETIME ,iep.EligibilityDate)
	  ,CONVERT(DATETIME ,iep.ConsentForServicesDate)
	  ,CONVERT(DATETIME ,iep.ConsentForEvaluationDate)
	  ,CONVERT(VARCHAR(3) ,iep.LREAgeGroup)
	  ,CONVERT(VARCHAR(150),iep.LRECode)
	  ,CONVERT(int,iep.MinutesPerWeek)
	  ,CONVERT(VARCHAR(8000),iep.ServiceDeliveryStatement)
FROM x_DATAVALIDATION.IEP_LOCAL iep
		 JOIN x_DATAVALIDATION.Student st ON iep.STUDENTREFID = st.StudentRefID
		 JOIN (SELECT IepRefID FROM x_DATAVALIDATION.IEP_LOCAL GROUP BY IepRefID HAVING COUNT(*)=1) ucieprefid ON iep.IEPREFID  = ucieprefid.IEPREFID
		 JOIN (SELECT StudentRefID FROM x_DATAVALIDATION.IEP_LOCAL GROUP BY StudentRefID HAVING COUNT(*)=1) ucstu ON iep.STUDENTREFID = ucstu.STUDENTREFID
    WHERE ((DATALENGTH(iep.IepRefID)/2)<= 150) 
		  AND ((DATALENGTH(iep.STUDENTREFID)/2)<=150) 
		  AND ((DATALENGTH(iep.IEPMeetDate)/2) <= 10 AND ISDATE(iep.IEPMEETDATE) = 1) 
		  AND ((DATALENGTH(iep.IEPStartDate)/2)<= 10 AND ISDATE(iep.IEPStartDate)= 1) 
		  AND ((DATALENGTH(iep.IEPEndDate)/2)  <= 10 AND ISDATE(iep.IEPEndDate) = 1)
		  AND ((DATALENGTH(iep.NextReviewDate)/2)  <= 10 AND ISDATE(iep.NextReviewDate) = 1)
		  AND (((DATALENGTH(iep.InitialEvaluationDate)/2)<= 10 AND (ISDATE(iep.InitialEvaluationDate) = 1) OR iep. InitialEvaluationDate IS NULL ) ) 
		  AND ((DATALENGTH(iep.LatestEvaluationDate)/2)<= 10 AND ISDATE(iep.LatestEvaluationDate) = 1) 
		  AND ((DATALENGTH(iep.NextEvaluationDate)/2)<= 10 AND ISDATE(iep.NextEvaluationDate) = 1)
		  AND ((DATALENGTH(iep.EligibilityDate)/2)<= 10 AND (ISDATE(iep.EligibilityDate) = 1 OR iep.EligibilityDate IS NULL ) ) 
		  AND ((DATALENGTH(iep.ConsentForServicesDate)/2)<= 10 AND ISDATE(iep.ConsentForServicesDate) = 1) 
		  AND (((DATALENGTH(iep.ConsentForEvaluationDate)/2)<= 10 OR iep.ConsentForEvaluationDate IS NULL) AND (ISDATE(iep.ConsentForEvaluationDate) = 1 OR iep.ConsentForEvaluationDate IS NULL ))
		  AND ((DATALENGTH(iep.LREAgeGroup)/2)<= 3 OR iep.LREAGEGROUP IS NULL) 
		  AND ((DATALENGTH(iep.LRECode)/2)<= 150) 
		  AND (ISNUMERIC(iep.MinutesPerWeek)=1) AND ((DATALENGTH(iep.MinutesPerWeek)/2)<= 4)  ---!!!Need to check this out!!!
		  AND ((DATALENGTH(iep.ServiceDeliveryStatement)/2)<= 8000 OR iep.SERVICEDELIVERYSTATEMENT IS NULL) 
		  --Required Fields
		  AND (iep.IepRefID IS NOT NULL) 
		  AND (iep.StudentRefID IS NOT NULL)
		  AND (iep.IEPMeetDate IS NOT NULL)
		  AND (iep.IEPStartDate IS NOT NULL)
		  AND (iep.IEPEndDate IS NOT NULL) 
		  AND (iep.NextReviewDate IS NOT NULL)
		  AND (iep.LatestEvaluationDate IS NOT NULL)
		  AND (iep.NextEvaluationDate IS NOT NULL)
		  AND (iep.ConsentForServicesDate IS NOT NULL)
		  AND (iep.LRECode IS NOT NULL)
		  AND (iep.MinutesPerWeek IS NOT NULL)
		  --Referential Integrity
		  --AND StudentRefID IN (SELECT StudentRefID FROM Student_LOCAL)
		  AND iep.LRECODE IN (SELECT LEGACYSPEDCODE FROM x_DATAVALIDATION.SelectLists WHERE TYPE= 'LRE')
*/
--================================================================================		  
--Log the count of successful records
--================================================================================   
INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'IEP','SuccessfulRecords',COUNT(*)
FROM x_DATAVALIDATION.IEP

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
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'IEP' 

OPEN chkSpecifications

FETCH NEXT FROM chkSpecifications INTO @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
DECLARE @vsql nVARCHAR(MAX)
DECLARE @sumsql nVARCHAR(MAX)
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
SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''IEP'',''The date format issue is in '+@columnname+'.'',Line_No,ISNULL(CONVERT(VARCHAR(max),IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPMeetDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPStartDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPEndDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),NextReviewDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),InitialEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LatestEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),NextEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EligibilityDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ConsentForServicesDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ConsentForEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LREAgeGroup),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LRECode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MinutesPerWeek),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ServiceDeliveryStatement),'''')
FROM x_DATAVALIDATION.IEP_LOCAL WHERE 1 = 1 '

SET @query  = ' AND ('+@columnname+' IS NULL)'
SET @vsql = @vsql + @query
--PRINT @vsql
EXEC sp_executesql @stmt=@vsql


SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''IEP'',''The field '+@columnname+' is required field, it cannot be empty.'', COUNT(*)
FROM x_DATAVALIDATION.IEP_LOCAL WHERE 1 = 1 '

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
SELECT ''IEP'',''The date format issue is in '+@columnname+'.'',Line_No,ISNULL(CONVERT(VARCHAR(max),IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPMeetDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPStartDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPEndDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),NextReviewDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),InitialEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LatestEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),NextEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EligibilityDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ConsentForServicesDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ConsentForEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LREAgeGroup),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LRECode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MinutesPerWeek),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ServiceDeliveryStatement),'''')
FROM x_DATAVALIDATION.IEP_LOCAL WHERE 1 = 1 '

SET @query  = ' AND ((DATALENGTH ('+@columnname+')/2) > '+@datalength+' AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''IEP'',''The issue is in the datalength of the field '+@columnname+'.'', COUNT(*)
FROM x_DATAVALIDATION.IEP_LOCAL  WHERE 1 = 1 '

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
SELECT ''IEP'',''The '+@columnname+' ''''''+CONVERT(VARCHAR(MAX),iep.'+@columnname+')+'''''' does not exist in '+@parenttable+'  or were not validated successfully, but it existed in '+@tablename+'.'',iep.Line_No,ISNULL(CONVERT(VARCHAR(max),iep.IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.IEPMeetDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.IEPStartDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.IEPEndDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.NextReviewDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.InitialEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.LatestEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.NextEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.EligibilityDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.ConsentForServicesDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.ConsentForEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.LREAgeGroup),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.LRECode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.MinutesPerWeek),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.ServiceDeliveryStatement),'''')
FROM x_DATAVALIDATION.IEP_LOCAL iep '

SET @query  = ' LEFT JOIN x_DATAVALIDATION.'+@parenttable+' i ON i.'+@columnname+' = iep.'+@parentcolumn+' WHERE i.'+@parentcolumn+' IS NULL'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''IEP'',''Some of the '+@parentcolumn+' does not exist in '+@parenttable+' or were not validated successfully, but it existed in IEP.'', COUNT(*)
FROM x_DATAVALIDATION.IEP_LOCAL iep  '

SET @query  = ' LEFT JOIN x_DATAVALIDATION.'+@parenttable+' i ON i.'+@columnname+' = iep.'+@parentcolumn+' WHERE i.'+@parentcolumn+' IS NULL'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql

END


IF (@isFlagfield = 1)
BEGIN
SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''IEP'',''The date format issue is in '+@columnname+'.'',Line_No,ISNULL(CONVERT(VARCHAR(max),IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPMeetDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPStartDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPEndDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),NextReviewDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),InitialEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LatestEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),NextEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EligibilityDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ConsentForServicesDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ConsentForEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LREAgeGroup),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LRECode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MinutesPerWeek),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ServiceDeliveryStatement),'''')
FROM x_DATAVALIDATION.IEP_LOCAL '

SET @query  = '  WHERE ('+@columnname+' NOT IN  ('+@flagrecords+') AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''IEP'',''The field '+@columnname+' should have one of the value in '''+LTRIM(REPLACE(@flagrecords,''',''','/'))+'''.'', COUNT(*)
FROM x_DATAVALIDATION.IEP_LOCAL '

SET @query  = '  WHERE ('+@columnname+' NOT IN  ('+@flagrecords+') AND '+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql

END


IF (@isuniquefield = 1)

BEGIN
SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''IEP'',''The field '+@columnname+' is unique field, Here ''''''+CONVERT(VARCHAR(MAX),iep.'+@columnname+')+'''''' record is repeated.'',iep.Line_No,ISNULL(CONVERT(VARCHAR(max),iep.IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.IEPMeetDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.IEPStartDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.IEPEndDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.NextReviewDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.InitialEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.LatestEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.NextEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.EligibilityDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.ConsentForServicesDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.ConsentForEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.LREAgeGroup),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.LRECode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.MinutesPerWeek),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.ServiceDeliveryStatement),'''')
FROM x_DATAVALIDATION.IEP_LOCAL iep JOIN'
--print @vsql
SET @query  = ' (SELECT '+@columnname+' FROM x_DATAVALIDATION.IEP_LOCAL GROUP BY '+@columnname+' HAVING COUNT(*)>1) uci ON uci.'+@columnname+' =iep.'+@columnname+' '
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''IEP'',''The field '+@columnname+' is unique field, It cannot be repeated.'', COUNT(*)
FROM x_DATAVALIDATION.IEP_LOCAL iep JOIN'
print @sumsql
SET @query  = ' (SELECT '+@columnname+' FROM x_DATAVALIDATION.IEP_LOCAL GROUP BY '+@columnname+' HAVING COUNT(*)>1) uci ON uci.'+@columnname+' =iep.'+@columnname+' '
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

IF (@islookupcolumn =1 AND @lookuptable = 'SelectLists')
BEGIN
SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''IEP'',''The '+@columnname+' ''''''+ iep.'+@columnname+'+'''''' does not exist in '+@lookuptable+', but it existed in '+@tablename+''',iep.Line_No,ISNULL(CONVERT(VARCHAR(max),iep.IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.IEPMeetDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.IEPStartDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.IEPEndDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.NextReviewDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.InitialEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.LatestEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.NextEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.EligibilityDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.ConsentForServicesDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.ConsentForEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.LREAgeGroup),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.LRECode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.MinutesPerWeek),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.ServiceDeliveryStatement),'''')
FROM x_DATAVALIDATION.IEP_LOCAL iep '

SET @query  = ' WHERE (iep.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+' WHERE Type = '''+@lookuptype+''') AND iep.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
--EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''IEP'',''Some of the '+@columnname+' does not exist in '+@lookuptable+', but it existed in '+@tablename+''', COUNT(*)
FROM x_DATAVALIDATION.IEP_LOCAL iep '

SET @query  = ' WHERE (iep.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+' WHERE Type = '''+@lookuptype+''') AND iep.'+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
--EXEC sp_executesql @stmt=@sumsql
END

IF (@islookupcolumn =1 AND @lookuptable != 'SelectLists')
BEGIN
SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''IEP'',''The '+@columnname+' ''''''+ iep.'+@columnname+'+'''''' does not exist in '+@lookuptable+', but it existed in '+@tablename+''',iep.Line_No,ISNULL(CONVERT(VARCHAR(max),iep.IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.IEPMeetDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.IEPStartDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.IEPEndDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.NextReviewDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.InitialEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.LatestEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.NextEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.EligibilityDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.ConsentForServicesDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.ConsentForEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.LREAgeGroup),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.LRECode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.MinutesPerWeek),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),iep.ServiceDeliveryStatement),'''')
FROM x_DATAVALIDATION.IEP_LOCAL iep '

SET @query  = ' WHERE (iep.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+') AND iep.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''IEP'',''The '+@columnname+' ''''''+ iep.'+@columnname+'+'''''' does not exist in '+@lookuptable+', but it existed in '+@tablename+''', COUNT(*)
FROM x_DATAVALIDATION.IEP_LOCAL iep '

SET @query  = ' WHERE (iep.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+') AND iep.'+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

IF (@datatype = 'datetime')
BEGIN
SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''IEP'',''The date format issue is in '+@columnname+'.'',Line_No,ISNULL(CONVERT(VARCHAR(max),IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPMeetDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPStartDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPEndDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),NextReviewDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),InitialEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LatestEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),NextEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EligibilityDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ConsentForServicesDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ConsentForEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LREAgeGroup),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LRECode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MinutesPerWeek),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ServiceDeliveryStatement),'''')
FROM x_DATAVALIDATION.IEP_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (ISDATE('+@columnname+') = 0 AND ('+@columnname+' IS NOT NULL))'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''IEP'',''The date format issue is in '+@columnname+'.'', COUNT(*)
FROM x_DATAVALIDATION.IEP_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (ISDATE('+@columnname+') = 0 AND ('+@columnname+' IS NOT NULL))'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

IF (@datatype = 'int')
BEGIN
SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''IEP'',''The date format issue is in '+@columnname+'.'',Line_No,ISNULL(CONVERT(VARCHAR(max),IepRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPMeetDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPStartDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),IEPEndDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),NextReviewDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),InitialEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LatestEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),NextEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EligibilityDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ConsentForServicesDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ConsentForEvaluationDate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LREAgeGroup),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LRECode),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MinutesPerWeek),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ServiceDeliveryStatement),'''')
FROM x_DATAVALIDATION.IEP_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (x_DATAVALIDATION.udf_IsInteger('+@columnname+') = 0 AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''IEP'',''The field '+@columnname+' should have integer records.'', COUNT(*)
FROM x_DATAVALIDATION.IEP_LOCAL WHERE 1 = 1 '

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
---Required Fields
------------------------------------------------------------------------
--Unique Fileds (To find the dupllicate records)
------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--To Check the Referential Integrity
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--To Check the Date Format
--------------------------------------------------------------------------------------------
*/
      
END



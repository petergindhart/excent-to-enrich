IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'Check_Service_Specifications')
DROP PROC Datavalidation.Check_Service_Specifications
GO

CREATE PROC Datavalidation.Check_Service_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE Datavalidation.Service'
EXEC sp_executesql @stmt = @sql

---Validated data
DECLARE @sqlvalidated VARCHAR(MAX)
SET @sqlvalidated = 
'INSERT  Datavalidation.Service  
SELECT ser.Line_No '
             
DECLARE @MaxCount INTEGER
DECLARE @Count INTEGER
DECLARE @sel VARCHAR(MAX)
DECLARE @tblsel table (id int, columnname varchar(50),datatype varchar(50),datalength varchar(5))
INSERT @tblsel
SELECT ColumnOrder,columnname,DataType,datalength
FROM Datavalidation.ValidationRules WHERE TableName = 'Service' 

SET @Count = 1
SET @sel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblsel)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'varchar')
    BEGIN
    SET @sel=@sel+', CONVERT ( VARCHAR ('+(SELECT datalength from @tblsel WHERE ID = @Count)+'), ser.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'datetime')
    BEGIN
    SET @sel=@sel+', CONVERT ( DATETIME , ser.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'int')
    BEGIN
    SET @sel=@sel+', CONVERT ( INT , ser.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    ELSE
    BEGIN
    SET @sel=@sel+', CONVERT ( VARCHAR ('+(SELECT datalength from @tblsel WHERE ID = @Count)+'), ser.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    END
    SET @Count=@Count+1
    END
--print @sel
SET @sqlvalidated = @sqlvalidated + @sel+ ' FROM Datavalidation.Service_Local ser'

DECLARE @Txtreq VARCHAR(MAX)
DECLARE @tblreq table (id int, columnname varchar(50))
INSERT @tblreq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM Datavalidation.ValidationRules WHERE TableName = 'Service' AND IsRequired =1

SET @Count = 1
SET @Txtreq = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblreq)
WHILE @Count<=@MaxCount
    BEGIN
        SET @Txtreq=@Txtreq+' AND ser.'+(select columnname from @tblreq WHERE ID=@Count) + ' IS NOT NULL '
    SET @Count=@Count+1
    END
--SELECT @Txtreq AS Txt

DECLARE @Txtdatalength VARCHAR(MAX)
DECLARE @tbldl table (id int, columnname varchar(50),datalength varchar(10),isrequired bit)
INSERT @tbldl
SELECT ROW_NUMBER()over(order by columnname),columnname,datalength,IsRequired
FROM Datavalidation.ValidationRules WHERE TableName = 'Service' 
SET @Count = 1
SET @Txtdatalength = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldl)
WHILE @Count<=@MaxCount
    BEGIN
    IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE (DATALENGTH('+'ser.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    ELSE IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE ((DATALENGTH('+'ser.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (ser.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL))'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND ((DATALENGTH('+'ser.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (ser.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL))'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND (DATALENGTH('+'ser.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    SET @Count=@Count+1
    END
SELECT @Txtdatalength AS Txtdl

DECLARE @Txtflag VARCHAR(MAX)
DECLARE @tblflag table (id int,columnname varchar(50),flagrecords varchar(50),isrequired varchar(50))
INSERT @tblflag
SELECT ROW_NUMBER()over(order by columnname),columnname,FlagRecords,IsRequired
FROM Datavalidation.ValidationRules WHERE TableName = 'Service' and IsFlagfield = 1

SET @Count = 1
SET @Txtflag = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblflag)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tblflag WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtflag=@Txtflag+' AND ser.'+(select columnname from @tblflag WHERE ID=@Count) + ' IN ('+(select flagrecords from @tblflag WHERE ID=@Count)+')'
    END
    ELSE IF ((select isrequired from @tblflag WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtflag=@Txtflag+' AND (ser.'+(select columnname from @tblflag WHERE ID=@Count) + ' IN ('+(select flagrecords from @tblflag WHERE ID=@Count)+') OR ser.'+(select columnname from @tblflag WHERE ID=@Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
SELECT @Txtflag AS Txtflag

DECLARE @Txtfkrel VARCHAR(MAX)
DECLARE @tblfkrel table (id int, columnname varchar(50),parenttable varchar(50), parentcolumn varchar(50))
INSERT @tblfkrel
SELECT ROW_NUMBER()over(order by columnname),columnname,ParentTable,ParentColumn
FROM Datavalidation.ValidationRules WHERE TableName = 'Service' AND IsFkRelation = 1
SET @Count = 1
SET @Txtfkrel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblfkrel)
WHILE @Count<=@MaxCount
    BEGIN
    SET @Txtfkrel=@Txtfkrel+' JOIN Datavalidation.'+(SELECT parenttable FROM @tblfkrel WHERE ID= @Count)+' '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+' ON '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+'.'+(SELECT parentcolumn FROM @tblfkrel WHERE ID= @Count)+' =  ser.'+(SELECT columnname FROM @tblfkrel WHERE ID= @Count)
    SET @Count=@Count+1
    END
SELECT @Txtfkrel AS Txtfk

DECLARE @Txtlookup VARCHAR(MAX)
DECLARE @tbllookup table (id int, columnname varchar(50),lookuptable varchar(50),lookupcolumn varchar(50),lookuptype varchar(50), isrequired bit)
INSERT @tbllookup
SELECT ROW_NUMBER()over(order by columnname),columnname,LookupTable,LookupColumn,LookUpType,IsRequired
FROM Datavalidation.ValidationRules WHERE TableName = 'Service' AND IsLookupColumn = 1
SET @Count = 1
SET @Txtlookup = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbllookup)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND ser.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM Datavalidation.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND ser.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM Datavalidation.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+''')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND (ser.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM Datavalidation.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' OR ser.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND ser.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM Datavalidation.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+'''OR ser.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtlookup AS Txtl

DECLARE @Txtdatatype VARCHAR(MAX)
DECLARE @tbldttype table (id int, columnname varchar(50),datatype varchar(50),isrequired bit)
INSERT @tbldttype
SELECT ROW_NUMBER()over(order by columnname),columnname,DataType,IsRequired
FROM Datavalidation.ValidationRules WHERE TableName = 'Service' 

SET @Count = 1
SET @Txtdatatype = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldttype)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND Datavalidation.udf_IsInteger( ser.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND (Datavalidation.udf_IsInteger( ser.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR ser.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL)'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND ISDATE( ser.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND ( ISDATE( ser.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR ser.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL) '
    END
    SET @Count=@Count+1
    END
--SELECT @Txtdatatype AS Txt

DECLARE @Txtunique VARCHAR(MAX)
DECLARE @tbluq table (id int, columnname varchar(50))
INSERT @tbluq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM Datavalidation.ValidationRules WHERE TableName = 'Service'  AND IsUniqueField = 1
SET @Count = 1
SET @Txtunique = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbluq)
WHILE @Count<=@MaxCount
    BEGIN
        SET @Txtunique=@Txtunique + ' JOIN (SELECT ' +(select columnname from @tbluq WHERE ID=@Count)+ ' FROM Datavalidation.Service_LOCAL GROUP BY '+(select columnname from @tbluq WHERE ID=@Count)+' HAVING COUNT(*)=1) ucser ON ucser.' +(select columnname from @tbluq WHERE ID=@Count) +'= ser. '+(select columnname from @tbluq WHERE ID=@Count)
        
        SET @Count=@Count+1
    END
--SELECT @Txtunique AS Txtq

SET @sqlvalidated = @sqlvalidated +@Txtunique +@Txtdatalength+@Txtreq+@Txtflag+@Txtdatatype
print @sqlvalidated

EXEC (@sqlvalidated)

/*
INSERT Datavalidation.Service 
SELECT ser.Line_No
      ,CONVERT(VARCHAR(20),ser.ServiceType)
	  ,CONVERT(VARCHAR(150),ser.ServiceRefId)
	  ,CONVERT(VARCHAR(150),ser.IepRefId)
	  ,CONVERT(VARCHAR(150),ser.ServiceDefinitionCode)
	  ,CONVERT(VARCHAR(10),ser.BeginDate)
	  ,CONVERT(VARCHAR(10),ser.EndDate)
	  ,CONVERT(VARCHAR(1),ser.IsRelated)
	  ,CONVERT(VARCHAR(1),ser.IsDirect)
	  ,CONVERT(VARCHAR(1),ser.ExcludesFromGenEd)
	  ,CONVERT(VARCHAR(150),ser.ServiceLocationCode)
	  ,CONVERT(VARCHAR(150),ser.ServiceProviderTitleCode)
	  ,CONVERT(INT ,ser.Sequence)
	  ,CONVERT(VARCHAR(1),ser.IsESY)
	  ,CONVERT(INT ,ser.ServiceTime)
	  ,CONVERT(VARCHAR(150),ser.ServiceFrequencyCode)
	  ,CONVERT(VARCHAR(11) ,ser.ServiceProviderSSN)
	  ,CONVERT(VARCHAR(150),ser.StaffEmail)
	  ,CONVERT(VARCHAR(254),ser.ServiceAreaText)
FROM Datavalidation.Service_LOCAL ser
		 JOIN (SELECT ServiceRefId FROM Datavalidation.Service_LOCAL GROUP BY ServiceRefId HAVING COUNT(*)= 1) ucser ON ucser.SERVICEREFID = ser.SERVICEREFID
    WHERE ((DATALENGTH(ser.SERVICETYPE)/2)<= 10) 
		  AND ((DATALENGTH(ser.ServiceRefId)/2)<=150) 
		  AND ((DATALENGTH(ser.IepRefId)/2)<= 150) 
		  AND ((DATALENGTH(ser.ServiceDefinitionCode)/2)<=150 OR ser.ServiceDefinitionCode IS NULL)
		  AND ((DATALENGTH(ser.BeginDate)/2)<=150 AND ISDATE(ser.BeginDate)=1) 
		  AND (((DATALENGTH(ser.EndDate)/2)<= 150 AND ISDATE(ser.EndDate)= 1)OR ser.EndDate IS NULL)  
		  AND ((DATALENGTH(ser.IsRelated)/2)<=1) 
		  AND ((DATALENGTH(ser.IsDirect)/2)<= 1) 
		  AND ((DATALENGTH(ser.ExcludesFromGenEd)/2)<= 1) 
		  AND ((DATALENGTH(ser.ServiceLocationCode)/2)<= 150) 
		  AND ((DATALENGTH(ser.ServiceProviderTitleCode)/2)<= 150) 
		  AND ((DATALENGTH(ser.Sequence)/2)<= 2 OR ser.Sequence IS NULL) 
		  AND ((DATALENGTH(ser.IsESY)/2)<= 1 OR ser.IsESY IS NULL) 
		  AND ((DATALENGTH(ser.ServiceTime)/2)<= 4) 
		  AND ((DATALENGTH(ser.ServiceFrequencyCode)/2)<= 150) 
		  AND ((DATALENGTH(ser.ServiceProviderSSN)/2)<= 11 OR ser.ServiceProviderSSN IS NULL) 
		  AND ((DATALENGTH(ser.StaffEmail)/2)<= 1 OR ser.StaffEmail IS NULL) 
		  AND ((DATALENGTH(ser.ServiceAreaText)/2)<= 254 OR ser.ServiceAreaText IS NULL) 
		  AND (ser.ServiceType IS NOT NULL) 
		  AND (ser.ServiceRefId IS NOT NULL)
		  AND (ser.IepRefId IS NOT NULL) 
		  AND (ser.BeginDate IS NOT NULL)
		  AND (ser.IsRelated IS NOT NULL) 
		  AND (ser.IsDirect IS NOT NULL)
		  AND (ser.ExcludesFromGenEd IS NOT NULL) 
		  AND (ser.ServiceLocationCode IS NOT NULL)
		  AND (ser.ServiceProviderTitleCode IS NOT NULL)
		  AND (ser.ServiceTime IS NOT NULL) 
		  AND (ser.ServiceFrequencyCode IS NOT NULL)
		  AND ser.IepRefId IN (SELECT IepRefId FROM Datavalidation.IEP)
		  
		  AND (ser.ServiceDefinitionCode IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'Service') OR ServiceDefinitionCode IS NULL)
		  AND ser.ServiceLocationCode IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'ServLoc')
		  AND ser.ServiceProviderTitleCode IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'ServProv')
		  AND ser.ServiceFrequencyCode IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'ServFreq')
		  AND ser.IsRelated IN ('Y','N')
		  AND ser.IsDirect IN ('Y','N')
		  AND ser.ExcludesFromGenEd IN ('Y','N')
		  AND (ser.IsESY IN ('Y','N') OR ser.IsESY IS NULL)
		  AND (ser.STAFFEMAIL IN (Select StaffEmail from Datavalidation.SpedStaffMember) OR ser.STAFFEMAIL IS NULL)
		/*
		  AND NOT EXISTS ( Select * FROM Datavalidation.Service_LOCAL ser JOIN IEP i ON ser.IepRefId = i.IepRefID WHERE ser.BeginDate < i.IEPStartDate)
		  AND NOT EXISTS ( Select * FROM Datavalidation.Service_LOCAL ser JOIN IEP i ON ser.IepRefId = i.IepRefID WHERE i.IEPEndDate < ser.EndDate)
		 */
		 */
--================================================================================		  
--Log the count of successful records
--================================================================================	 
INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'Service','SuccessfulRecords',COUNT(*)
FROM Datavalidation.Service

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
FROM Datavalidation.ValidationRules WHERE TableName = 'Service'

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
SELECT ''Service'',''The field '+@columnname+' is required field.'',Line_No,ISNULL(ServiceType,'''')+''|''+ISNULL(ServiceRefId,'''')+ISNULL(IepRefId,'''')+''|''+ISNULL(ServiceDefinitionCode,'''')+ISNULL(BeginDate,'''')+''|''+ISNULL(EndDate,'''')+ISNULL(IsRelated,'''')+''|''+ISNULL(IsDirect,'''')+ISNULL(ExcludesFromGenEd,'''')+''|''+ISNULL(ServiceLocationCode,'''')+ISNULL(ServiceProviderTitleCode,'''')+''|''+ISNULL(Sequence,'''')+ISNULL(IsESY,'''')+''|''+ISNULL(ServiceTime,'''')+ISNULL(ServiceFrequencyCode,'''')+''|''+ISNULL(ServiceProviderSSN,'''')+ISNULL(StaffEmail,'''')+''|''+ISNULL(ServiceAreaText,'''')
FROM Datavalidation.Service_LOCAL WHERE 1 = 1'

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
SELECT ''Service'',''The issue is in the datalength of the field '+@columnname+'.'',Line_No,ISNULL(ServiceType,'''')+''|''+ISNULL(ServiceRefId,'''')+ISNULL(IepRefId,'''')+''|''+ISNULL(ServiceDefinitionCode,'''')+ISNULL(BeginDate,'''')+''|''+ISNULL(EndDate,'''')+ISNULL(IsRelated,'''')+''|''+ISNULL(IsDirect,'''')+ISNULL(ExcludesFromGenEd,'''')+''|''+ISNULL(ServiceLocationCode,'''')+ISNULL(ServiceProviderTitleCode,'''')+''|''+ISNULL(Sequence,'''')+ISNULL(IsESY,'''')+''|''+ISNULL(ServiceTime,'''')+ISNULL(ServiceFrequencyCode,'''')+''|''+ISNULL(ServiceProviderSSN,'''')+ISNULL(StaffEmail,'''')+''|''+ISNULL(ServiceAreaText,'''')
FROM Datavalidation.Service_LOCAL WHERE 1 = 1'

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
SELECT ''Service'',''Some of the '+@parentcolumn+' does not exist in '+@parenttable+' File or were not validated successfully, but it existed in SpedStaffMember.csv.'',ser.Line_No,ISNULL(ser.ServiceType,'''')+''|''+ISNULL(ser.ServiceRefId,'''')+ISNULL(ser.IepRefId,'''')+''|''+ISNULL(ser.ServiceDefinitionCode,'''')+ISNULL(ser.BeginDate,'''')+''|''+ISNULL(ser.EndDate,'''')+ISNULL(ser.IsRelated,'''')+''|''+ISNULL(ser.IsDirect,'''')+ISNULL(ser.ExcludesFromGenEd,'''')+''|''+ISNULL(ser.ServiceLocationCode,'''')+ISNULL(ser.ServiceProviderTitleCode,'''')+''|''+ISNULL(ser.Sequence,'''')+ISNULL(ser.IsESY,'''')+''|''+ISNULL(ser.ServiceTime,'''')+ISNULL(ServiceFrequencyCode,'''')+''|''+ISNULL(ServiceProviderSSN,'''')+ISNULL(StaffEmail,'''')+''|''+ISNULL(ServiceAreaText,'''')
FROM Datavalidation.Service_LOCAL ser '

SET @query  = ' LEFT JOIN Datavalidation.'+@parenttable+' dt ON ser.'+@columnname+' = dt.'+@parentcolumn+' WHERE dt.'+@parentcolumn+' IS NULL'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END


IF (@isFlagfield = 1)
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Service'',''The field '+@columnname+' should have one of the value in '''+LTRIM(REPLACE(@flagrecords,''',''','/'))+''''',ser.Line_No,ISNULL(ser.ServiceType,'''')+''|''+ISNULL(ser.ServiceRefId,'''')+ISNULL(ser.IepRefId,'''')+''|''+ISNULL(ser.ServiceDefinitionCode,'''')+ISNULL(ser.BeginDate,'''')+''|''+ISNULL(ser.EndDate,'''')+ISNULL(ser.IsRelated,'''')+''|''+ISNULL(ser.IsDirect,'''')+ISNULL(ser.ExcludesFromGenEd,'''')+''|''+ISNULL(ser.ServiceLocationCode,'''')+ISNULL(ser.ServiceProviderTitleCode,'''')+''|''+ISNULL(ser.Sequence,'''')+ISNULL(ser.IsESY,'''')+''|''+ISNULL(ser.ServiceTime,'''')+ISNULL(ServiceFrequencyCode,'''')+''|''+ISNULL(ServiceProviderSSN,'''')+ISNULL(StaffEmail,'''')+''|''+ISNULL(ServiceAreaText,'''')
FROM Datavalidation.Service_LOCAL ser '

SET @query  = '  WHERE (ser.'+@columnname+' NOT IN  ('+@flagrecords+') AND ser.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END


IF (@isuniquefield = 1)
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Service'',''The field '+@columnname+' is unique field, Here '+@columnname+' record is repeated.'',ser.Line_No,ISNULL(ser.ServiceType,'''')+''|''+ISNULL(ser.ServiceRefId,'''')+ISNULL(ser.IepRefId,'''')+''|''+ISNULL(ser.ServiceDefinitionCode,'''')+ISNULL(ser.BeginDate,'''')+''|''+ISNULL(ser.EndDate,'''')+ISNULL(ser.IsRelated,'''')+''|''+ISNULL(ser.IsDirect,'''')+ISNULL(ser.ExcludesFromGenEd,'''')+''|''+ISNULL(ser.ServiceLocationCode,'''')+ISNULL(ser.ServiceProviderTitleCode,'''')+''|''+ISNULL(ser.Sequence,'''')+ISNULL(ser.IsESY,'''')+''|''+ISNULL(ser.ServiceTime,'''')+ISNULL(ServiceFrequencyCode,'''')+''|''+ISNULL(ServiceProviderSSN,'''')+ISNULL(StaffEmail,'''')+''|''+ISNULL(ServiceAreaText,'''')
FROM Datavalidation.Service_LOCAL ser JOIN'

SET @query  = ' (SELECT '+@columnname+' FROM Datavalidation.Service_LOCAL GROUP BY '+@columnname+' HAVING COUNT(*)>1) ucser ON ucser.'+@columnname+' = ser.'+@columnname+' '
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END

IF (@islookupcolumn = 1 AND @lookuptable = 'SelectLists')
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Service'',''The '+@columnname+' "''+ ser.'+@columnname+'+''" does not exist in '+@lookuptable+'.csv, but it existed in '+@tablename+'.csv'',ser.Line_No,ISNULL(ser.ServiceType,'''')+''|''+ISNULL(ser.ServiceRefId,'''')+ISNULL(ser.IepRefId,'''')+''|''+ISNULL(ser.ServiceDefinitionCode,'''')+ISNULL(ser.BeginDate,'''')+''|''+ISNULL(ser.EndDate,'''')+ISNULL(ser.IsRelated,'''')+''|''+ISNULL(ser.IsDirect,'''')+ISNULL(ser.ExcludesFromGenEd,'''')+''|''+ISNULL(ser.ServiceLocationCode,'''')+ISNULL(ser.ServiceProviderTitleCode,'''')+''|''+ISNULL(ser.Sequence,'''')+ISNULL(ser.IsESY,'''')+''|''+ISNULL(ser.ServiceTime,'''')+ISNULL(ServiceFrequencyCode,'''')+''|''+ISNULL(ServiceProviderSSN,'''')+ISNULL(StaffEmail,'''')+''|''+ISNULL(ServiceAreaText,'''')
FROM Datavalidation.Service_LOCAL ser '

SET @query  = ' WHERE (ser.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM Datavalidation.'+@lookuptable+' WHERE Type = '''+@lookuptype+''') AND ser.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END

IF (@islookupcolumn =1 AND @lookuptable != 'SelectLists')
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Service'',''The '+@columnname+' "''+ ser.'+@columnname+'+''" does not exist in '+@lookuptable+'.csv, but it existed in '+@tablename+'.csv'',ser.Line_No,ISNULL(ser.ServiceType,'''')+''|''+ISNULL(ser.ServiceRefId,'''')+ISNULL(ser.IepRefId,'''')+''|''+ISNULL(ser.ServiceDefinitionCode,'''')+ISNULL(ser.BeginDate,'''')+''|''+ISNULL(ser.EndDate,'''')+ISNULL(ser.IsRelated,'''')+''|''+ISNULL(ser.IsDirect,'''')+ISNULL(ser.ExcludesFromGenEd,'''')+''|''+ISNULL(ser.ServiceLocationCode,'''')+ISNULL(ser.ServiceProviderTitleCode,'''')+''|''+ISNULL(ser.Sequence,'''')+ISNULL(ser.IsESY,'''')+''|''+ISNULL(ser.ServiceTime,'''')+ISNULL(ServiceFrequencyCode,'''')+''|''+ISNULL(ServiceProviderSSN,'''')+ISNULL(StaffEmail,'''')+''|''+ISNULL(ServiceAreaText,'''')
FROM Datavalidation.Service_LOCAL ser '

SET @query  = ' WHERE (ser.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM Datavalidation.'+@lookuptable+') AND ser.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END


IF (@datatype = 'datetime')
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Service'',''The date format issue is in '+@columnname+'.'',Line_No,ISNULL(ServiceType,'''')+''|''+ISNULL(ServiceRefId,'''')+''|''+ISNULL(IepRefId,'''')+''|''+ISNULL(ServiceDefinitionCode,'''')+''|''+ISNULL(BeginDate,'''')+''|''+ISNULL(EndDate,'''')+''|''+ISNULL(IsRelated,'''')+''|''+ISNULL(IsDirect,'''')+''|''+ISNULL(ExcludesFromGenEd,'''')+''|''+ISNULL(ServiceLocationCode,'''')+''|''+ISNULL(ServiceProviderTitleCode,'''')+''|''+ISNULL(Sequence,'''')+''|''+ISNULL(IsESY,'''')+''|''+ISNULL(ServiceTime,'''')+''|''+ISNULL(ServiceFrequencyCode,'''')+''|''+ISNULL(ServiceProviderSSN,'''')+''|''+ISNULL(StaffEmail,'''')+''|''+ISNULL(ServiceAreaText,'''')
FROM Datavalidation.Service_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (ISDATE('+@columnname+') = 0 AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

END

IF (@datatype = 'int')
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Service'',''The field '+@columnname+' should have integer records.'',Line_No,ISNULL(ServiceType,'''')+''|''+ISNULL(ServiceRefId,'''')+ISNULL(IepRefId,'''')+''|''+ISNULL(ServiceDefinitionCode,'''')+ISNULL(BeginDate,'''')+''|''+ISNULL(EndDate,'''')+ISNULL(IsRelated,'''')+''|''+ISNULL(IsDirect,'''')+ISNULL(ExcludesFromGenEd,'''')+''|''+ISNULL(ServiceLocationCode,'''')+ISNULL(ServiceProviderTitleCode,'''')+''|''+ISNULL(Sequence,'''')+ISNULL(IsESY,'''')+''|''+ISNULL(ServiceTime,'''')+ISNULL(ServiceFrequencyCode,'''')+''|''+ISNULL(ServiceProviderSSN,'''')+ISNULL(StaffEmail,'''')+''|''+ISNULL(ServiceAreaText,'''') FROM Datavalidation.Service_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (Datavalidation.udf_IsInteger('+@columnname+') = 0 AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

END

FETCH NEXT FROM chkSpecifications INTO  @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
END
CLOSE chkSpecifications
DEALLOCATE chkSpecifications

------------------------------------------------------------------------
--Service Date range issue
------------------------------------------------------------------------
--Service StartDate is before IEP StartDate
INSERT Datavalidation.ValidationReport(TableName,ErrorMessage,LineNumber,Line)
SELECT 'Service','The Service StartDate does not exist in IEP date range.',Line_No,ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM Datavalidation.Service_LOCAL 
WHERE ServiceRefId IN (Select ServiceRefId FROM Datavalidation.Service_LOCAL ser JOIN IEP i ON ser.IepRefId = i.IepRefID WHERE ser.BeginDate < i.IEPStartDate)

--Service EndDate is after IEPEndDate
INSERT Datavalidation.ValidationReport(TableName,ErrorMessage,LineNumber,Line)
SELECT 'Service','The Service EndDate does not exist in IEP date range.',Line_No,ISNULL(ServiceType,'')+'|'+ISNULL(ServiceRefId,'')+ISNULL(IepRefId,'')+'|'+ISNULL(ServiceDefinitionCode,'')+ISNULL(BeginDate,'')+'|'+ISNULL(EndDate,'')+ISNULL(IsRelated,'')+'|'+ISNULL(IsDirect,'')+ISNULL(ExcludesFromGenEd,'')+'|'+ISNULL(ServiceLocationCode,'')+ISNULL(ServiceProviderTitleCode,'')+'|'+ISNULL(Sequence,'')+ISNULL(IsESY,'')+'|'+ISNULL(ServiceTime,'')+ISNULL(ServiceFrequencyCode,'')+'|'+ISNULL(ServiceProviderSSN,'')+ISNULL(StaffEmail,'')+'|'+ISNULL(ServiceAreaText,'')
FROM Datavalidation.Service_LOCAL 
WHERE ServiceRefId IN (Select ServiceRefId FROM Datavalidation.Service_LOCAL ser JOIN IEP i ON ser.IepRefId = i.IepRefID WHERE i.IEPEndDate < ser.EndDate)




/*
----------------------------------------------------------------------------
--DataLength issues
----------------------------------------------------------------------------
------------------------------------------------------------------------------------      
--Required Fields
------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------        
---Unique Fields
-----------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
--To check the referential integrity issues
-------------------------------------------------------------------------------------------
-----------------------------------------------------------------------
--To Check the Date format 
-----------------------------------------------------------------------
*/
END

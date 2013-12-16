IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'Check_Student_Specifications')
DROP PROC x_DATAVALIDATION.Check_Student_Specifications
GO

CREATE PROC x_DATAVALIDATION.Check_Student_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE x_DATAVALIDATION.Student'
EXEC sp_executesql @stmt = @sql

---Validated data
DECLARE @sqlvalidated VARCHAR(MAX)
SET @sqlvalidated = 
'INSERT  x_DATAVALIDATION.Student  
SELECT st.Line_No '
             
DECLARE @MaxCount INTEGER
DECLARE @Count INTEGER
DECLARE @sel VARCHAR(MAX)
DECLARE @tblsel table (id int, columnname varchar(50),datatype varchar(50),datalength varchar(5))
INSERT @tblsel
SELECT ColumnOrder,columnname,DataType,datalength
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Student' 

SET @Count = 1
SET @sel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblsel)
WHILE @Count<=@MaxCount
    BEGIN
--    IF ((SELECT datatype FROM @tblsel WHERE ID = @Count) = 'varchar')
    SET @sel=@sel+', CONVERT ( VARCHAR ('+(SELECT datalength from @tblsel WHERE ID = @Count)+'), st.' +(SELECT columnname from @tblsel WHERE ID = @Count)+')'
    SET @Count=@Count+1
    END
print @sel
SET @sqlvalidated = @sqlvalidated + @sel+ ' FROM x_DATAVALIDATION.Student_Local st'

DECLARE @TxtScAndDt VARCHAR(MAX)
SET @TxtScAndDt = ' JOIN (SELECT STUDENTREFID FROM x_DATAVALIDATION.Student_LOCAL st JOIN x_DATAVALIDATION.School sc ON (st.ServiceDistrictCode = sc.DistrictCode AND st.ServiceSchoolCode = sc.SchoolCode)) stusersch ON st.STUDENTREFID = stusersch.STUDENTREFID JOIN (SELECT STUDENTREFID FROM x_DATAVALIDATION.Student_LOCAL st JOIN x_DATAVALIDATION.School sc ON (st.HomeDistrictCode = sc.DistrictCode AND st.HomeSchoolCode = sc.SchoolCode)) stuhomsch ON stuhomsch.STUDENTREFID = st.STUDENTREFID'
		 
DECLARE @Txtreq VARCHAR(MAX)
DECLARE @tblreq table (id int, columnname varchar(50))
INSERT @tblreq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Student' AND IsRequired =1

SET @Count = 1
SET @Txtreq = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblreq)
WHILE @Count<=@MaxCount
    BEGIN
        SET @Txtreq=@Txtreq+' AND st.'+(select columnname from @tblreq WHERE ID=@Count) + ' IS NOT NULL '
    SET @Count=@Count+1
    END
--SELECT @Txtreq AS Txt

DECLARE @Txtdatalength VARCHAR(MAX)
DECLARE @tbldl table (id int, columnname varchar(50),datalength varchar(10),isrequired bit)
INSERT @tbldl
SELECT ROW_NUMBER()over(order by columnname),columnname,datalength,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Student' 
SET @Count = 1
SET @Txtdatalength = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldl)
WHILE @Count<=@MaxCount
    BEGIN
    IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE (DATALENGTH('+'st.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    ELSE IF (@Txtdatalength = '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' WHERE ((DATALENGTH('+'st.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (st.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL))'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND ((DATALENGTH('+'st.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count) +' OR (st.'+(select columnname from @tbldl WHERE ID=@Count)+' IS NULL))'
    END
    ELSE IF (@Txtdatalength != '' and (select isrequired from @tbldl WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtdatalength=@Txtdatalength+' AND (DATALENGTH('+'st.'+(select columnname from @tbldl WHERE ID=@Count) + ')/2) <= '+(select datalength from @tbldl WHERE ID=@Count)
    END
    SET @Count=@Count+1
    END
--SELECT @Txtdatalength AS Txtdl

DECLARE @Txtflag VARCHAR(MAX)
DECLARE @tblflag table (id int,columnname varchar(50),flagrecords varchar(50),isrequired varchar(50))
INSERT @tblflag
SELECT ROW_NUMBER()over(order by columnname),columnname,FlagRecords,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Student' and IsFlagfield = 1

SET @Count = 1
SET @Txtflag = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblflag)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tblflag WHERE ID=@Count)= 1)
    BEGIN
    SET @Txtflag=@Txtflag+' AND st.'+(select columnname from @tblflag WHERE ID=@Count) + ' IN ('+(select flagrecords from @tblflag WHERE ID=@Count)+')'
    END
    ELSE IF ((select isrequired from @tblflag WHERE ID=@Count)= 0)
    BEGIN
    SET @Txtflag=@Txtflag+' AND (st.'+(select columnname from @tblflag WHERE ID=@Count) + ' IN ('+(select flagrecords from @tblflag WHERE ID=@Count)+') OR st.'+(select columnname from @tblflag WHERE ID=@Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtflag AS Txtflag

DECLARE @Txtfkrel VARCHAR(MAX)
DECLARE @tblfkrel table (id int, columnname varchar(50),parenttable varchar(50), parentcolumn varchar(50))
INSERT @tblfkrel
SELECT ROW_NUMBER()over(order by columnname),columnname,ParentTable,ParentColumn
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Student' AND IsFkRelation = 1
SET @Count = 1
SET @Txtfkrel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblfkrel)
WHILE @Count<=@MaxCount
    BEGIN
    SET @Txtfkrel=@Txtfkrel+' JOIN x_DATAVALIDATION.'+(SELECT parenttable FROM @tblfkrel WHERE ID= @Count)+' '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+' ON '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+'.'+(SELECT parentcolumn FROM @tblfkrel WHERE ID= @Count)+' = st.'+(SELECT columnname FROM @tblfkrel WHERE ID= @Count)
    SET @Count=@Count+1
    END
--SELECT @Txtfkrel AS Txtfk

DECLARE @Txtlookup VARCHAR(MAX)
DECLARE @tbllookup table (id int, columnname varchar(50),lookuptable varchar(50),lookupcolumn varchar(50),lookuptype varchar(50), isrequired bit)
INSERT @tbllookup
SELECT ROW_NUMBER()over(order by columnname),columnname,LookupTable,LookupColumn,LookUpType,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Student' AND IsLookupColumn = 1
SET @Count = 1
SET @Txtlookup = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbllookup)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND st.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND st.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+''')'
    END
     ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+'  AND (st.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+') OR st.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+'AND (st.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM x_DATAVALIDATION.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+''') OR st.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtlookup AS Txtl

DECLARE @Txtdatatype VARCHAR(MAX)
DECLARE @tbldttype table (id int, columnname varchar(50),datatype varchar(50),isrequired bit)
INSERT @tbldttype
SELECT ROW_NUMBER()over(order by columnname),columnname,DataType,IsRequired
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Student' 

SET @Count = 1
SET @Txtdatatype = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldttype)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND x_DATAVALIDATION.udf_IsInteger( st.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND (x_DATAVALIDATION.udf_IsInteger( st.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR st.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL)'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND ISDATE( st.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'Datetime' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND ( ISDATE( st.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR st.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL) '
    END
    SET @Count=@Count+1
    END
--SELECT @Txtdatatype AS Txt

DECLARE @Txtunique VARCHAR(MAX)
DECLARE @tbluq table (id int, columnname varchar(50))
INSERT @tbluq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Student'  AND IsUniqueField = 1
SET @Count = 1
SET @Txtunique = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbluq)
WHILE @Count<=@MaxCount
    BEGIN
     SET @Txtunique=@Txtunique + ' JOIN ( SELECT ' +(select columnname from @tbluq WHERE ID=@Count)+ ' FROM x_DATAVALIDATION.Student_LOCAL GROUP BY '+(select columnname from @tbluq WHERE ID=@Count)+' HAVING COUNT(*)=1) '+(select left(columnname,3) from @tbluq WHERE ID=@Count)+' ON ' +(select left(columnname,3) from @tbluq WHERE ID=@Count)+'.' +(select columnname from @tbluq WHERE ID=@Count) +' = st.'+(select columnname from @tbluq WHERE ID=@Count)        
        SET @Count=@Count+1
    END
--SELECT @Txtunique AS Txtq

SET @sqlvalidated = @sqlvalidated +@Txtunique+@Txtfkrel +@TxtScAndDt+@Txtdatalength+@Txtreq+@Txtflag+@Txtdatatype +@Txtlookup
print @sqlvalidated

EXEC (@sqlvalidated)
--EXEC sp_executesql @stmt = @sqlvalidated
/*
INSERT x_DATAVALIDATION.Student
SELECT
       stu.Line_No
      ,CONVERT(VARCHAR(150),stu.StudentRefID)
	  ,CONVERT(VARCHAR(50),stu.StudentLocalID)
	  ,CONVERT(VARCHAR(50),stu.StudentStateID)
	  ,CONVERT(VARCHAR(50),stu.Firstname)
	  ,CONVERT(VARCHAR(50),stu.MiddleName)
	  ,CONVERT(VARCHAR(50),stu.LastName)
	  ,CONVERT(VARCHAR(10),stu.Birthdate)
	  ,CONVERT(VARCHAR(150),stu.Gender)
	  ,CONVERT(VARCHAR(50),stu.MedicaidNumber)
	  ,CONVERT(VARCHAR(150),stu.GradeLevelCode)
	  ,CONVERT(VARCHAR(10),stu.ServiceDistrictCode)	 
	  ,CONVERT(VARCHAR(10),stu.ServiceSchoolCode)	 
	  ,CONVERT(VARCHAR(10),stu.HomeDistrictCode)	 
	  ,CONVERT(VARCHAR(10),stu.HomeSchoolCode)
	  ,CONVERT(VARCHAR(1),stu.IsHispanic)
	  ,CONVERT(VARCHAR(1),stu.IsAmericanIndian)
	  ,CONVERT(VARCHAR(1),stu.IsAsian)
	  ,CONVERT(VARCHAR(1),stu.IsBlackAfricanAmerican)
	  ,CONVERT(VARCHAR(1),stu.IsHawaiianPacIslander)
	  ,CONVERT(VARCHAR(1),stu.IsWhite)
	  ,CONVERT(VARCHAR(150),stu.Disability1Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability2Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability3Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability4Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability5Code)  	  
	  ,CONVERT(VARCHAR(150),stu.Disability6Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability7Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability8Code)	  
	  ,CONVERT(VARCHAR(150),stu.Disability9Code)	
	  ,CONVERT(VARCHAR(1),stu.EsyElig)
	  ,CONVERT(VARCHAR(10),stu.EsyTBDDate)	
	  ,CONVERT(VARCHAR(10),stu.ExitDate)
	  ,CONVERT(VARCHAR(150),stu.ExitCode)
	  ,CONVERT(VARCHAR(1),stu.SpecialEdStatus)	  
FROM x_DATAVALIDATION.Student_LOCAL stu 
		 JOIN (SELECT StudentRefID FROM x_DATAVALIDATION.Student_LOCAL GROUP BY StudentRefID HAVING COUNT(*)= 1) ucstu 
		 ON ISNULL(stu.STUDENTREFID,'a') = ISNULL(ucstu.STUDENTREFID,'b')
		 JOIN (SELECT STUDENTREFID FROM x_DATAVALIDATION.Student_LOCAL st JOIN School sc ON (st.ServiceDistrictCode = sc.DistrictCode AND st.ServiceSchoolCode = sc.SchoolCode)) stusersch ON stu.STUDENTREFID = stusersch.STUDENTREFID
		 JOIN (SELECT STUDENTREFID FROM x_DATAVALIDATION.Student_LOCAL st JOIN School sc ON st.HomeDistrictCode = sc.DistrictCode AND st.HomeSchoolCode = sc.SchoolCode) stuhomsch ON stuhomsch.STUDENTREFID = stu.STUDENTREFID
    WHERE ((DATALENGTH(stu.STUDENTREFID)/2)<= 150) 
		  AND ((DATALENGTH(stu.StudentLocalID)/2)<=50) 
		  AND ((DATALENGTH(stu.StudentStateID)/2)<=50) 
		  AND ((DATALENGTH(stu.Firstname)/2)<=50 OR stu.Firstname IS NULL) 
		  AND ((DATALENGTH(stu.MiddleName)/2)<=50 OR stu.MiddleName IS NULL) 
		  AND ((DATALENGTH(stu.LastName)/2)<=50 OR stu.LastName IS NULL) 
		  AND (((DATALENGTH(stu.Birthdate)/2)<=10 OR stu.Birthdate IS NULL) AND ISDATE(stu.BirthDate)=1) 
		  AND ((DATALENGTH(stu.Gender)/2)<=150 OR Gender IS NULL ) 
		  AND ((DATALENGTH(stu.MedicaidNumber)/2)<=50 OR stu.MedicaidNumber IS NULL) 
		  AND ((DATALENGTH(stu.GradeLevelCode)/2)<=150 OR stu.GradeLevelCode IS NULL) 
		  AND ((DATALENGTH(stu.ServiceDistrictCode)/2)<=10 OR stu.ServiceDistrictCode IS NULL) 
		  AND ((DATALENGTH(stu.ServiceSchoolCode)/2)<=10 OR stu.ServiceSchoolCode IS NULL) 
		  AND ((DATALENGTH(stu.HomeDistrictCode)/2)<=10 OR stu.HomeDistrictCode IS NULL) 
		  AND ((DATALENGTH(stu.HomeSchoolCode)/2)<=10 OR stu.HomeSchoolCode IS NULL) 
		  AND ((DATALENGTH(stu.IsHispanic)/2)<=1 OR stu.IsHispanic IS NULL) 
		  AND ((DATALENGTH(stu.IsAmericanIndian)/2)<=1 OR stu.IsAmericanIndian IS NULL) 
		  AND ((DATALENGTH(stu.IsAsian)/2)<=1 OR stu.IsAsian IS NULL) 
		  AND ((DATALENGTH(stu.IsBlackAfricanAmerican)/2)<=1 OR stu.IsBlackAfricanAmerican IS NULL) 
		  AND ((DATALENGTH(stu.IsHawaiianPacIslander)/2)<=1 OR stu.IsHawaiianPacIslander IS NULL) 
		  AND ((DATALENGTH(stu.IsWhite)/2)<=1 OR stu.IsWhite IS NULL)
		  AND ((DATALENGTH(stu.Disability1Code)/2)<=150 OR stu.Disability1Code IS NULL)  
		  AND ((DATALENGTH(stu.Disability2Code)/2)<=150 OR stu.Disability2Code IS NULL) 
		  AND ((DATALENGTH(stu.Disability3Code)/2)<=150 OR stu.Disability3Code IS NULL)
		  AND ((DATALENGTH(stu.Disability4Code)/2)<=150 OR stu.Disability4Code IS NULL) 
		  AND ((DATALENGTH(stu.Disability5Code)/2)<=150 OR stu.Disability5Code IS NULL) 
		  AND ((DATALENGTH(stu.Disability6Code)/2)<=150 OR stu.Disability6Code IS NULL)
		  AND ((DATALENGTH(stu.Disability7Code)/2)<=150 OR stu.Disability7Code IS NULL) 
		  AND ((DATALENGTH(stu.Disability8Code/2))<=150 OR stu.Disability8Code IS NULL) 
		  AND ((DATALENGTH(stu.Disability9Code)/2)<=150 OR stu.Disability9Code IS NULL)
		  AND ((DATALENGTH(stu.EsyElig)/2)<=1 OR stu.EsyElig IS NULL)
		  AND ((DATALENGTH(stu.EsyTBDDate)/2)<=10 OR stu.EsyTBDDate IS NULL) 
		  AND (((DATALENGTH(stu.ExitDate)/2)<=10 OR stu.ExitDate IS NULL) )
		  AND ((DATALENGTH(stu.ExitCode)/2)<=150 OR stu.ExitCode IS NULL)
		  AND ((DATALENGTH(stu.SpecialEdStatus)/2)<=1 OR stu.SpecialEdStatus IS NULL)
		  ---RequiredFields
		  AND (stu.StudentRefID IS NOT NULL) AND (stu.StudentLocalID IS NOT NULL) AND (stu.StudentStateID IS NOT NULL) 
		  AND (stu.Firstname IS NOT NULL) AND (stu.LastName IS NOT NULL) 
		  AND (stu.Birthdate IS NOT NULL) AND (ISDATE(stu.Birthdate)= 1)
		  AND (stu.Gender IS NOT NULL) AND (stu.GradeLevelCode IS NOT NULL) AND (stu.ServiceDistrictCode IS NOT NULL) 
		  AND (stu.ServiceSchoolCode IS NOT NULL) AND (stu.HomeDistrictCode IS NOT NULL) AND (stu.HomeSchoolCode IS NOT NULL)
		  AND (stu.IsHispanic IS NOT NULL) AND (stu.IsAmericanIndian IS NOT NULL) AND (stu.IsAsian IS NOT NULL)
		  AND (stu.IsBlackAfricanAmerican IS NOT NULL) AND (stu.IsHawaiianPacIslander IS NOT NULL) AND (stu.IsWhite IS NOT NULL)
		  AND (stu.Disability1Code IS NOT NULL) AND (stu.SpecialEdStatus IS NOT NULL)
		  AND stu.SpecialEdStatus IN ('A','E') AND stu.IsHispanic IN ('Y','N') AND stu.IsAmericanIndian IN ('Y','N')
		  AND stu.IsAsian IN ('Y','N') AND stu.IsBlackAfricanAmerican IN ('Y','N') AND stu.IsHawaiianPacIslander IN ('Y','N') 
		  AND stu.IsWhite IN ('Y','N') AND (stu.EsyElig IN ('Y','N') OR stu.EsyElig IS NULL)
		  --Referential Integrity
		  --AND NOT EXISTS(SELECT StudentRefID FROM x_DATAVALIDATION.Student_LOCAL GROUP BY StudentRefID HAVING COUNT(*)>1)
		  AND stu.Gender IN (SELECT LEGACYSPEDCODE FROM x_DATAVALIDATION.SelectLists WHERE TYPE= 'Gender')
		  AND stu.GradeLevelCode IN (SELECT LEGACYSPEDCODE FROM x_DATAVALIDATION.SelectLists WHERE TYPE= 'Grade')
		  /*
		  AND EXISTS(SELECT * FROM x_DATAVALIDATION.Student_LOCAL st JOIN School sc ON st.ServiceDistrictCode = sc.DistrictCode 
		                 AND st.ServiceSchoolCode = sc.SchoolCode)
		  AND EXISTS(SELECT * FROM x_DATAVALIDATION.Student_LOCAL st JOIN School sc ON st.HomeDistrictCode = sc.DistrictCode 
		                 AND st.HomeSchoolCode = sc.SchoolCode)
			*/
		  AND  stu.Disability1Code IN (SELECT LEGACYSPEDCODE FROM x_DATAVALIDATION.SelectLists WHERE TYPE= 'Disab')
		  AND (stu.Disability2Code IN (SELECT LEGACYSPEDCODE FROM x_DATAVALIDATION.SelectLists WHERE TYPE= 'Disab')OR stu.Disability2Code IS NULL)
		  AND (stu.Disability3Code IN (SELECT LEGACYSPEDCODE FROM x_DATAVALIDATION.SelectLists WHERE TYPE= 'Disab')OR stu.Disability3Code IS NULL)
		  AND (stu.Disability4Code IN (SELECT LEGACYSPEDCODE FROM x_DATAVALIDATION.SelectLists WHERE TYPE= 'Disab')OR stu.Disability4Code IS NULL)
		  AND (stu.Disability5Code IN (SELECT LEGACYSPEDCODE FROM x_DATAVALIDATION.SelectLists WHERE TYPE= 'Disab')OR stu.Disability5Code IS NULL)
		  AND (stu.Disability6Code IN (SELECT LEGACYSPEDCODE FROM x_DATAVALIDATION.SelectLists WHERE TYPE= 'Disab')OR stu.Disability6Code IS NULL)
		  AND (stu.Disability7Code IN (SELECT LEGACYSPEDCODE FROM x_DATAVALIDATION.SelectLists WHERE TYPE= 'Disab')OR stu.Disability7Code IS NULL)
		  AND (stu.Disability8Code IN (SELECT LEGACYSPEDCODE FROM x_DATAVALIDATION.SelectLists WHERE TYPE= 'Disab')OR stu.Disability8Code IS NULL)
		  AND (stu.Disability9Code IN (SELECT LEGACYSPEDCODE FROM x_DATAVALIDATION.SelectLists WHERE TYPE= 'Disab')OR stu.Disability9Code IS NULL)
		  */
--================================================================================		  
--Log the count of successful records
--================================================================================  	
INSERT x_DATAVALIDATION.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'Student','SuccessfulRecords',COUNT(*)
FROM x_DATAVALIDATION.Student
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
FROM x_DATAVALIDATION.ValidationRules WHERE TableName = 'Student'
--AND IS_NULLABLE = 'NO'

OPEN chkSpecifications

FETCH NEXT FROM chkSpecifications INTO @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
DECLARE @vsql nVARCHAR(MAX)
DECLARE @sumsql NVARCHAR(MAX)
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
IF (@isrequired = 1)
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Student'',''The field '+@columnname+' is required field.'',Line_No,ISNULL(CONVERT(VARCHAR(max),StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentLocalID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentStateID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MiddleName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LastName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Birthdate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Gender),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MEDICAIDNUMBER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),GRADELEVELCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SERVICEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SERVICESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),HOMEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),HOMESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISHISPANIC),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISAMERICANINDIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISASIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISBLACKAFRICANAMERICAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISHAWAIIANPACISLANDER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISWHITE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY1CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY2CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY3CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY4CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY5CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY6CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY7CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY8CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY9CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ESYELIG),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ESYTBDDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EXITDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EXITCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SPECIALEDSTATUS),'''')
FROM x_DATAVALIDATION.Student_LOCAL WHERE 1 = 1'

SET @query  = ' AND ('+@columnname+' IS NULL)'
SET @vsql = @vsql + @query
--PRINT @vsql
EXEC sp_executesql @stmt=@vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Student'',''The field '+@columnname+' is required field.'', COUNT(*)
FROM x_DATAVALIDATION.Student_LOCAL WHERE 1 = 1'

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
SELECT ''Student'',''The issue is in the datalength of the field '+@columnname+'.'',Line_No,ISNULL(CONVERT(VARCHAR(max),StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentLocalID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentStateID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MiddleName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LastName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Birthdate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Gender),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MEDICAIDNUMBER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),GRADELEVELCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SERVICEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SERVICESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),HOMEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),HOMESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISHISPANIC),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISAMERICANINDIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISASIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISBLACKAFRICANAMERICAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISHAWAIIANPACISLANDER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISWHITE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY1CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY2CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY3CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY4CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY5CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY6CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY7CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY8CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY9CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ESYELIG),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ESYTBDDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EXITDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EXITCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SPECIALEDSTATUS),'''')
FROM x_DATAVALIDATION.Student_LOCAL  WHERE 1 = 1'

SET @query  = ' AND ((DATALENGTH ('+@columnname+')/2) > '+@datalength+' AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Student'',''The issue is in the datalength of the field '+@columnname+'.'', COUNT(*)
FROM x_DATAVALIDATION.Student_LOCAL WHERE 1 = 1'

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
SELECT ''Student'',''The '+@columnname+' ''''''+CONVERT(VARCHAR(MAX),st.'+@columnname+')+'''''' does not exist in '+@parenttable+'  or were not validated successfully, but it existed in '+@tablename+'.'',st.Line_No,ISNULL(CONVERT(VARCHAR(max),st.StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.StudentLocalID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.StudentStateID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.MiddleName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.LastName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.Birthdate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.Gender),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.MEDICAIDNUMBER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.GRADELEVELCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.SERVICEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.SERVICESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.HOMEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.HOMESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISHISPANIC),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISAMERICANINDIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISASIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISBLACKAFRICANAMERICAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISHAWAIIANPACISLANDER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISWHITE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY1CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY2CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY3CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY4CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY5CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY6CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY7CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY8CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY9CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ESYELIG),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ESYTBDDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.EXITDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.EXITCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.SPECIALEDSTATUS),'''')
FROM x_DATAVALIDATION.Student_LOCAL st '

SET @query  = ' LEFT JOIN x_DATAVALIDATION.'+@parenttable+' ft ON st.'+@columnname+' = ft.'+@parentcolumn+' WHERE ft.'+@parentcolumn+' IS NULL'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Student'',''Some of the '+@parentcolumn+' does not exist in '+@parenttable+' File or were not validated successfully, but it existed in Student.'', COUNT(*)
FROM x_DATAVALIDATION.Student_LOCAL st '

SET @query  = ' LEFT JOIN x_DATAVALIDATION.'+@parenttable+' ft ON st.'+@columnname+' = ft.'+@parentcolumn+' WHERE ft.'+@parentcolumn+' IS NULL'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END


IF (@isFlagfield = 1)
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Student'',''The field '+@columnname+' should have one of the value in '''+LTRIM(REPLACE(@flagrecords,''',''','/'))+''', It has value as ''''''+'+@columnname+'+''''''.'',Line_No,ISNULL(CONVERT(VARCHAR(max),StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentLocalID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentStateID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MiddleName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LastName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Birthdate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Gender),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MEDICAIDNUMBER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),GRADELEVELCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SERVICEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SERVICESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),HOMEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),HOMESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISHISPANIC),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISAMERICANINDIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISASIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISBLACKAFRICANAMERICAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISHAWAIIANPACISLANDER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISWHITE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY1CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY2CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY3CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY4CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY5CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY6CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY7CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY8CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY9CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ESYELIG),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ESYTBDDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EXITDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EXITCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SPECIALEDSTATUS),'''')
FROM x_DATAVALIDATION.Student_LOCAL'

SET @query  = '  WHERE ('+@columnname+' NOT IN  ('+@flagrecords+') AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Student'',''The field '+@columnname+' should have one of the value in '''+LTRIM(REPLACE(@flagrecords,''',''','/'))+''''', COUNT(*)
FROM x_DATAVALIDATION.Student_LOCAL'

SET @query  = '  WHERE ('+@columnname+' NOT IN  ('+@flagrecords+') AND '+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END


IF (@isuniquefield = 1)
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Student'',''The field '+@columnname+' is unique field, Here ''''''+CONVERT(VARCHAR(MAX),st.'+@columnname+')+'''''' record is repeated.'',st.Line_No,ISNULL(CONVERT(VARCHAR(max),st.StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.StudentLocalID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.StudentStateID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.MiddleName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.LastName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.Birthdate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.Gender),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.MEDICAIDNUMBER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.GRADELEVELCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.SERVICEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.SERVICESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.HOMEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.HOMESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISHISPANIC),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISAMERICANINDIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISASIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISBLACKAFRICANAMERICAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISHAWAIIANPACISLANDER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISWHITE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY1CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY2CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY3CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY4CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY5CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY6CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY7CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY8CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY9CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ESYELIG),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ESYTBDDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.EXITDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.EXITCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.SPECIALEDSTATUS),'''')
FROM x_DATAVALIDATION.Student_LOCAL st JOIN'

SET @query  = ' (SELECT '+@columnname+' FROM x_DATAVALIDATION.Student_LOCAL GROUP BY '+@columnname+' HAVING COUNT(*)>1) ucst ON ucst.'+@columnname+' =st.'+@columnname+' '
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Student'',''The field '+@columnname+' is unique field, Here '+@columnname+' record is repeated.'', COUNT(*)
FROM x_DATAVALIDATION.Student_LOCAL st JOIN'

SET @query  = ' (SELECT '+@columnname+' FROM x_DATAVALIDATION.Student_LOCAL GROUP BY '+@columnname+' HAVING COUNT(*)>1) ucst ON ucst.'+@columnname+' =st.'+@columnname+' '
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

IF (@islookupcolumn =1 AND @lookuptable = 'SelectLists')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Student'',''The '+@columnname+' ''''''+ st.'+@columnname+'+'''''' does not exist in '+@lookuptable+', but it existed in '+@tablename+''',st.Line_No,ISNULL(CONVERT(VARCHAR(max),st.StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.StudentLocalID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.StudentStateID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.MiddleName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.LastName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.Birthdate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.Gender),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.MEDICAIDNUMBER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.GRADELEVELCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.SERVICEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.SERVICESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.HOMEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.HOMESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISHISPANIC),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISAMERICANINDIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISASIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISBLACKAFRICANAMERICAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISHAWAIIANPACISLANDER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISWHITE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY1CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY2CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY3CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY4CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY5CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY6CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY7CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY8CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY9CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ESYELIG),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ESYTBDDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.EXITDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.EXITCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.SPECIALEDSTATUS),'''')
FROM x_DATAVALIDATION.Student_LOCAL st '

SET @query  = 'WHERE (st.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+' WHERE Type = '''+@lookuptype+''') AND st.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Student'',''The '+@columnname+' does not exist in '+@lookuptable+', but it existed in '+@tablename+''', COUNT(*)
FROM x_DATAVALIDATION.Student_LOCAL st '

SET @query  = 'WHERE (st.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+' WHERE Type = '''+@lookuptype+''') AND st.'+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END

IF (@islookupcolumn =1 AND @lookuptable != 'SelectLists')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Student'',''The '+@columnname+' ''''''+ st.'+@columnname+'+'''''' does not exist in '+@lookuptable+', but it existed in '+@tablename+''',st.Line_No,ISNULL(CONVERT(VARCHAR(max),st.StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.StudentLocalID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.StudentStateID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.MiddleName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.LastName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.Birthdate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.Gender),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.MEDICAIDNUMBER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.GRADELEVELCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.SERVICEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.SERVICESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.HOMEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.HOMESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISHISPANIC),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISAMERICANINDIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISASIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISBLACKAFRICANAMERICAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISHAWAIIANPACISLANDER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ISWHITE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY1CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY2CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY3CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY4CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY5CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY6CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY7CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY8CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.DISABILITY9CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ESYELIG),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.ESYTBDDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.EXITDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.EXITCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),st.SPECIALEDSTATUS),'''')
FROM x_DATAVALIDATION.Student_LOCAL st '

SET @query  = ' WHERE (st.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+') AND st.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Student'',''The '+@columnname+' does not exist in '+@lookuptable+', but it existed in '+@tablename+''', COUNT(*)
FROM x_DATAVALIDATION.Student_LOCAL st '

SET @query  = ' WHERE (st.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM x_DATAVALIDATION.'+@lookuptable+') AND st.'+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql
END


IF (@datatype = 'int')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Student'',''The field '+@columnname+' should have integer records.'',Line_No,ISNULL(CONVERT(VARCHAR(max),StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentLocalID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentStateID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MiddleName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LastName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Birthdate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Gender),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MEDICAIDNUMBER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),GRADELEVELCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SERVICEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SERVICESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),HOMEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),HOMESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISHISPANIC),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISAMERICANINDIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISASIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISBLACKAFRICANAMERICAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISHAWAIIANPACISLANDER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISWHITE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY1CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY2CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY3CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY4CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY5CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY6CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY7CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY8CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY9CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ESYELIG),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ESYTBDDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EXITDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EXITCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SPECIALEDSTATUS),'''')  FROM x_DATAVALIDATION.Student_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (x_DATAVALIDATION.udf_IsInteger('+@columnname+') = 0 AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Student'',''The field '+@columnname+' should have integer records, but it doesnot have integer records.'', COUNT(*)
x_DATAVALIDATION.Student_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (x_DATAVALIDATION.udf_IsInteger('+@columnname+') = 0 AND '+@columnname+' IS NOT NULL)'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql

END


IF (@datatype = 'datetime')
BEGIN

SET @vsql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Student'',''The date format issue is in '+@columnname+'.'',Line_No,ISNULL(CONVERT(VARCHAR(max),StudentRefID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentLocalID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),StudentStateID),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Firstname),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MiddleName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),LastName),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Birthdate),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),Gender),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),MEDICAIDNUMBER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),GRADELEVELCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SERVICEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SERVICESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),HOMEDISTRICTCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),HOMESCHOOLCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISHISPANIC),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISAMERICANINDIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISASIAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISBLACKAFRICANAMERICAN),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISHAWAIIANPACISLANDER),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ISWHITE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY1CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY2CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY3CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY4CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY5CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY6CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY7CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY8CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),DISABILITY9CODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ESYELIG),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),ESYTBDDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EXITDATE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),EXITCODE),'''')+''|''+ISNULL(CONVERT(VARCHAR(max),SPECIALEDSTATUS),'''')  FROM x_DATAVALIDATION.Student_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (ISDATE('+@columnname+') = 0 AND ('+@columnname+' IS NOT NULL))'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql

SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT ''Student'',''The date format issue is in '+@columnname+'.'', COUNT(*)
FROM x_DATAVALIDATION.Student_LOCAL WHERE 1 = 1 '

SET @query  = ' AND (ISDATE('+@columnname+') = 0 AND ('+@columnname+' IS NOT NULL))'
SET @sumsql = @sumsql + @query
--PRINT @sumsql
EXEC sp_executesql @stmt=@sumsql

END

FETCH NEXT FROM chkSpecifications INTO  @tableschema,@tablename,@columnname,@datatype,@datalength,@isrequired,@isuniquefield,@isFkRelation,@parenttable,@parentcolumn,@islookupcolumn,@lookuptable,@lookupcolumn,@lookuptype,@isFlagfield,@flagrecords
END
CLOSE chkSpecifications
DEALLOCATE chkSpecifications

-----------------------------------------------------------------
---To check the SchoolCode and DistrictCode combination 
-----------------------------------------------------------------
INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'Student','The ServiceSchoolCode and ServiceDistrictCode combination '''+st.ServiceDistrictCode+','+st.ServiceSchoolCode+''' does not exist in School.',st.Line_No,ISNULL(convert(varchar(max),st.STUDENTREFID),'')+'|'+ISNULL(convert(varchar(max),st.StudentLocalID),'')+'|'+ISNULL(convert(varchar(max),st.StudentStateID),'')+'|'+ISNULL(convert(varchar(max),st.Firstname),'')+'|'+ISNULL(convert(varchar(max),st.MiddleName),'')+'|'+ISNULL(convert(varchar(max),st.LastName),'')+'|'+ISNULL(convert(varchar(max),st.Birthdate),'')+'|'+ISNULL(convert(varchar(max),st.Gender),'')+'|'+ISNULL(convert(varchar(max),st.MEDICAIDNUMBER),'')+'|'+ISNULL(convert(varchar(max),st.GRADELEVELCODE),'')+'|'+ISNULL(convert(varchar(max),st.SERVICEDISTRICTCODE),'')+'|'+ISNULL(convert(varchar(max),st.SERVICESCHOOLCODE),'')+'|'+ISNULL(convert(varchar(max),st.HOMEDISTRICTCODE),'')+'|'+ISNULL(convert(varchar(max),st.HOMESCHOOLCODE),'')+'|'+ISNULL(convert(varchar(max),st.ISHISPANIC),'')+'|'+ISNULL(convert(varchar(max),st.ISAMERICANINDIAN),'')+'|'+ISNULL(convert(varchar(max),st.ISASIAN),'')+'|'+ISNULL(convert(varchar(max),st.ISBLACKAFRICANAMERICAN),'')+'|'+ISNULL(convert(varchar(max),st.ISHAWAIIANPACISLANDER),'')+'|'+ISNULL(convert(varchar(max),st.ISWHITE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY1CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY2CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY3CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY4CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY5CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY6CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY7CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY8CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY9CODE),'')+'|'+ISNULL(convert(varchar(max),st.ESYELIG),'')+'|'+ISNULL(convert(varchar(max),st.ESYTBDDATE),'')+'|'+ISNULL(convert(varchar(max),st.EXITDATE),'')+'|'+ISNULL(convert(varchar(max),st.EXITCODE),'')+'|'+ISNULL(convert(varchar(max),st.SPECIALEDSTATUS),'')
FROM x_DATAVALIDATION.Student_LOCAL st
LEFT JOIN (SELECT STUDENTREFID FROM x_DATAVALIDATION.Student_LOCAL st JOIN x_DATAVALIDATION.School sc ON st.ServiceDistrictCode = sc.DistrictCode AND st.ServiceSchoolCode = sc.SchoolCode) stusersch ON st.STUDENTREFID = stusersch.STUDENTREFID
WHERE stusersch.STUDENTREFID IS NULL

INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'Student','The ServiceSchoolCode and ServiceDistrictCode combination does not exist in School.',COUNT(*)	 
FROM x_DATAVALIDATION.Student_LOCAL st
LEFT JOIN (SELECT STUDENTREFID FROM x_DATAVALIDATION.Student_LOCAL st JOIN x_DATAVALIDATION.School sc ON st.ServiceDistrictCode = sc.DistrictCode AND st.ServiceSchoolCode = sc.SchoolCode) stusersch ON st.STUDENTREFID = stusersch.STUDENTREFID
WHERE stusersch.STUDENTREFID IS NULL
           
INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'Student','The HomeSchoolCode and HomeDistrictCode combination '''+st.HomeDistrictCode+','+st.HomeSchoolCode+''' does not exist in School.',st.Line_No,ISNULL(convert(varchar(max),st.STUDENTREFID),'')+'|'+ISNULL(convert(varchar(max),st.StudentLocalID),'')+'|'+ISNULL(convert(varchar(max),st.StudentStateID),'')+'|'+ISNULL(convert(varchar(max),st.Firstname),'')+'|'+ISNULL(convert(varchar(max),st.MiddleName),'')+'|'+ISNULL(convert(varchar(max),st.LastName),'')+'|'+ISNULL(convert(varchar(max),st.Birthdate),'')+'|'+ISNULL(convert(varchar(max),st.Gender),'')+'|'+ISNULL(convert(varchar(max),st.MEDICAIDNUMBER),'')+'|'+ISNULL(convert(varchar(max),st.GRADELEVELCODE),'')+'|'+ISNULL(convert(varchar(max),st.SERVICEDISTRICTCODE),'')+'|'+ISNULL(convert(varchar(max),st.SERVICESCHOOLCODE),'')+'|'+ISNULL(convert(varchar(max),st.HOMEDISTRICTCODE),'')+'|'+ISNULL(convert(varchar(max),st.HOMESCHOOLCODE),'')+'|'+ISNULL(convert(varchar(max),st.ISHISPANIC),'')+'|'+ISNULL(convert(varchar(max),st.ISAMERICANINDIAN),'')+'|'+ISNULL(convert(varchar(max),st.ISASIAN),'')+'|'+ISNULL(convert(varchar(max),st.ISBLACKAFRICANAMERICAN),'')+'|'+ISNULL(convert(varchar(max),st.ISHAWAIIANPACISLANDER),'')+'|'+ISNULL(convert(varchar(max),st.ISWHITE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY1CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY2CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY3CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY4CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY5CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY6CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY7CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY8CODE),'')+'|'+ISNULL(convert(varchar(max),st.DISABILITY9CODE),'')+'|'+ISNULL(convert(varchar(max),st.ESYELIG),'')+'|'+ISNULL(convert(varchar(max),st.ESYTBDDATE),'')+'|'+ISNULL(convert(varchar(max),st.EXITDATE),'')+'|'+ISNULL(convert(varchar(max),st.EXITCODE),'')+'|'+ISNULL(convert(varchar(max),st.SPECIALEDSTATUS),'')
FROM x_DATAVALIDATION.Student_LOCAL st
LEFT JOIN (SELECT STUDENTREFID FROM x_DATAVALIDATION.Student_LOCAL st JOIN x_DATAVALIDATION.School sc ON st.HomeDistrictCode = sc.DistrictCode AND st.HomeSchoolCode = sc.SchoolCode) stuhomsch ON st.STUDENTREFID = stuhomsch.STUDENTREFID
WHERE stuhomsch.STUDENTREFID IS NULL

INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT 'Student','The HomeSchoolCode and HomeDistrictCode combination does not exist in School.',COUNT(*)	 
FROM x_DATAVALIDATION.Student_LOCAL st
LEFT JOIN (SELECT STUDENTREFID FROM x_DATAVALIDATION.Student_LOCAL st JOIN x_DATAVALIDATION.School sc ON st.HomeDistrictCode = sc.DistrictCode AND st.HomeSchoolCode = sc.SchoolCode) stuhomsch ON st.STUDENTREFID = stuhomsch.STUDENTREFID
WHERE stuhomsch.STUDENTREFID IS NULL
/*
---------------------------------------------------------
---To Check the Datalength 
---------------------------------------------------------
--------------------------------------------------------------------------------------
---Required Fields
--------------------------------------------------------------------------------------
-----------------------------------------------------------------------
--To Check Referential Integrity 
-------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
----To check duplicate record
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------
--To check the referential issues
---------------------------------------------------------------------------
------------------------------------------------------------------
---To check whether disability code in selectlists
------------------------------------------------------------------
 */     
END






IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'Check_Student_Specifications')
DROP PROC Datavalidation.Check_Student_Specifications
GO

CREATE PROC Datavalidation.Check_Student_Specifications
AS
BEGIN

DECLARE @sql nVARCHAR(MAX)
SET @sql = 'DELETE Datavalidation.Student'
EXEC sp_executesql @stmt = @sql

---Validated data
DECLARE @sqlvalidated VARCHAR(MAX)
SET @sqlvalidated = 
'INSERT  Datavalidation.Student  
SELECT st.Line_No '
             
DECLARE @MaxCount INTEGER
DECLARE @Count INTEGER
DECLARE @sel VARCHAR(MAX)
DECLARE @tblsel table (id int, columnname varchar(50),datatype varchar(50),datalength varchar(5))
INSERT @tblsel
SELECT ColumnOrder,columnname,DataType,datalength
FROM Datavalidation.ValidationRules WHERE TableName = 'Student' 

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
SET @sqlvalidated = @sqlvalidated + @sel+ ' FROM Datavalidation.Student_Local st'

DECLARE @TxtScAndDt VARCHAR(MAX)
SET @TxtScAndDt = ' JOIN (SELECT STUDENTREFID FROM Datavalidation.Student_LOCAL st JOIN Datavalidation.School sc ON (st.ServiceDistrictCode = sc.DistrictCode AND st.ServiceSchoolCode = sc.SchoolCode)) stusersch ON st.STUDENTREFID = stusersch.STUDENTREFID JOIN (SELECT STUDENTREFID FROM Datavalidation.Student_LOCAL st JOIN Datavalidation.School sc ON (st.HomeDistrictCode = sc.DistrictCode AND st.HomeSchoolCode = sc.SchoolCode)) stuhomsch ON stuhomsch.STUDENTREFID = st.STUDENTREFID'
		 
DECLARE @Txtreq VARCHAR(MAX)
DECLARE @tblreq table (id int, columnname varchar(50))
INSERT @tblreq
SELECT ROW_NUMBER()over(order by columnname),columnname
FROM Datavalidation.ValidationRules WHERE TableName = 'Student' AND IsRequired =1

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
FROM Datavalidation.ValidationRules WHERE TableName = 'Student' 
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
FROM Datavalidation.ValidationRules WHERE TableName = 'Student' and IsFlagfield = 1

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
FROM Datavalidation.ValidationRules WHERE TableName = 'Student' AND IsFkRelation = 1
SET @Count = 1
SET @Txtfkrel = ''
SET @MaxCount = (SELECT MAX(id)FROM @tblfkrel)
WHILE @Count<=@MaxCount
    BEGIN
    SET @Txtfkrel=@Txtfkrel+' JOIN Datavalidation.'+(SELECT parenttable FROM @tblfkrel WHERE ID= @Count)+' '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+' ON '+(SELECT LEFT(parenttable,3) FROM @tblfkrel WHERE ID= @Count)+'.'+(SELECT parentcolumn FROM @tblfkrel WHERE ID= @Count)+' = st.'+(SELECT columnname FROM @tblfkrel WHERE ID= @Count)
    SET @Count=@Count+1
    END
--SELECT @Txtfkrel AS Txtfk

DECLARE @Txtlookup VARCHAR(MAX)
DECLARE @tbllookup table (id int, columnname varchar(50),lookuptable varchar(50),lookupcolumn varchar(50),lookuptype varchar(50), isrequired bit)
INSERT @tbllookup
SELECT ROW_NUMBER()over(order by columnname),columnname,LookupTable,LookupColumn,LookUpType,IsRequired
FROM Datavalidation.ValidationRules WHERE TableName = 'Student' AND IsLookupColumn = 1
SET @Count = 1
SET @Txtlookup = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbllookup)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND st.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM Datavalidation.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 1 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND st.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM Datavalidation.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+''')'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) != 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND (st.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM Datavalidation.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' OR st.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    ELSE IF ((select isrequired from @tbllookup WHERE ID=@Count)= 0 and (select lookuptable from @tbllookup WHERE ID=@Count) = 'SelectLists')
    BEGIN
    SET @Txtlookup=@Txtlookup+' AND st.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IN ( SELECT '+(SELECT lookupcolumn FROM @tbllookup WHERE ID= @Count)+' FROM Datavalidation.'+(SELECT lookuptable FROM @tbllookup WHERE ID= @Count)+' WHERE Type = '''+ (SELECT lookuptype FROM @tbllookup WHERE ID= @Count)+'''OR st.'+(SELECT columnname FROM @tbllookup WHERE ID= @Count)+' IS NULL)'
    END
    SET @Count=@Count+1
    END
--SELECT @Txtlookup AS Txtl

DECLARE @Txtdatatype VARCHAR(MAX)
DECLARE @tbldttype table (id int, columnname varchar(50),datatype varchar(50),isrequired bit)
INSERT @tbldttype
SELECT ROW_NUMBER()over(order by columnname),columnname,DataType,IsRequired
FROM Datavalidation.ValidationRules WHERE TableName = 'Student' 

SET @Count = 1
SET @Txtdatatype = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbldttype)
WHILE @Count<=@MaxCount
    BEGIN
    IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 1)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND Datavalidation.udf_IsInteger( st.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1'
    END
    ELSE IF ((SELECT datatype FROM @tbldttype WHERE ID = @Count) = 'INT' and (SELECT isrequired FROM @tbldttype WHERE ID = @Count) = 0)
    BEGIN
    SET @Txtdatatype=@Txtdatatype+' AND (Datavalidation.udf_IsInteger( st.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+') = 1 OR st.'+(SELECT columnname FROM @tbldttype WHERE ID = @Count)+' IS NULL)'
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
FROM Datavalidation.ValidationRules WHERE TableName = 'Student'  AND IsUniqueField = 1
SET @Count = 1
SET @Txtunique = ''
SET @MaxCount = (SELECT MAX(id)FROM @tbluq)
WHILE @Count<=@MaxCount
    BEGIN
     SET @Txtunique=@Txtunique + ' JOIN ( SELECT ' +(select columnname from @tbluq WHERE ID=@Count)+ ' FROM Datavalidation.Student_LOCAL GROUP BY '+(select columnname from @tbluq WHERE ID=@Count)+' HAVING COUNT(*)=1) '+(select left(columnname,3) from @tbluq WHERE ID=@Count)+' ON ' +(select left(columnname,3) from @tbluq WHERE ID=@Count)+'.' +(select columnname from @tbluq WHERE ID=@Count) +' = st.'+(select columnname from @tbluq WHERE ID=@Count)        
        SET @Count=@Count+1
    END
--SELECT @Txtunique AS Txtq

SET @sqlvalidated = @sqlvalidated +@Txtunique +@TxtScAndDt+@Txtdatalength+@Txtreq+@Txtflag+@Txtdatatype
--print @sqlvalidated

EXEC (@sqlvalidated)
--EXEC sp_executesql @stmt = @sqlvalidated
/*
INSERT Datavalidation.Student
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
FROM Datavalidation.Student_LOCAL stu 
		 JOIN (SELECT StudentRefID FROM Datavalidation.Student_LOCAL GROUP BY StudentRefID HAVING COUNT(*)= 1) ucstu 
		 ON ISNULL(stu.STUDENTREFID,'a') = ISNULL(ucstu.STUDENTREFID,'b')
		 JOIN (SELECT STUDENTREFID FROM Datavalidation.Student_LOCAL st JOIN School sc ON (st.ServiceDistrictCode = sc.DistrictCode AND st.ServiceSchoolCode = sc.SchoolCode)) stusersch ON stu.STUDENTREFID = stusersch.STUDENTREFID
		 JOIN (SELECT STUDENTREFID FROM Datavalidation.Student_LOCAL st JOIN School sc ON st.HomeDistrictCode = sc.DistrictCode AND st.HomeSchoolCode = sc.SchoolCode) stuhomsch ON stuhomsch.STUDENTREFID = stu.STUDENTREFID
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
		  --AND NOT EXISTS(SELECT StudentRefID FROM Datavalidation.Student_LOCAL GROUP BY StudentRefID HAVING COUNT(*)>1)
		  AND stu.Gender IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'Gender')
		  AND stu.GradeLevelCode IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'Grade')
		  /*
		  AND EXISTS(SELECT * FROM Datavalidation.Student_LOCAL st JOIN School sc ON st.ServiceDistrictCode = sc.DistrictCode 
		                 AND st.ServiceSchoolCode = sc.SchoolCode)
		  AND EXISTS(SELECT * FROM Datavalidation.Student_LOCAL st JOIN School sc ON st.HomeDistrictCode = sc.DistrictCode 
		                 AND st.HomeSchoolCode = sc.SchoolCode)
			*/
		  AND  stu.Disability1Code IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'Disab')
		  AND (stu.Disability2Code IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'Disab')OR stu.Disability2Code IS NULL)
		  AND (stu.Disability3Code IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'Disab')OR stu.Disability3Code IS NULL)
		  AND (stu.Disability4Code IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'Disab')OR stu.Disability4Code IS NULL)
		  AND (stu.Disability5Code IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'Disab')OR stu.Disability5Code IS NULL)
		  AND (stu.Disability6Code IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'Disab')OR stu.Disability6Code IS NULL)
		  AND (stu.Disability7Code IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'Disab')OR stu.Disability7Code IS NULL)
		  AND (stu.Disability8Code IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'Disab')OR stu.Disability8Code IS NULL)
		  AND (stu.Disability9Code IN (SELECT LEGACYSPEDCODE FROM Datavalidation.SelectLists WHERE TYPE= 'Disab')OR stu.Disability9Code IS NULL)
		  */
--================================================================================		  
--Log the count of successful records
--================================================================================  	
INSERT Datavalidation.ValidationSummaryReport(TableName,ErrorMessage,NumberOfRecords)
SELECT 'Student','SuccessfulRecords',COUNT(*)
FROM Datavalidation.Student
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
FROM Datavalidation.ValidationRules WHERE TableName = 'Student'
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
IF (@isrequired = 1)
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Student'',''The field '+@columnname+' is required field.'',Line_No,ISNULL(StudentRefID,'''')+''|''+ISNULL(StudentLocalID,'''')+''|''+ISNULL(StudentStateID,'''')+''|''+ISNULL(Firstname,'''')+''|''+ISNULL(MiddleName,'''')+''|''+ISNULL(LastName,'''')+''|''+ISNULL(Birthdate,'''')+''|''+ISNULL(Gender,'''')+''|''+ISNULL(MEDICAIDNUMBER,'''')+''|''+ISNULL(GRADELEVELCODE,'''')+''|''+ISNULL(SERVICEDISTRICTCODE,'''')+''|''+ISNULL(SERVICESCHOOLCODE,'''')+''|''+ISNULL(HOMEDISTRICTCODE,'''')+''|''+ISNULL(HOMESCHOOLCODE,'''')+''|''+ISNULL(ISHISPANIC,'''')+''|''+ISNULL(ISAMERICANINDIAN,'''')+''|''+ISNULL(ISASIAN,'''')+''|''+ISNULL(ISBLACKAFRICANAMERICAN,'''')+''|''+ISNULL(ISHAWAIIANPACISLANDER,'''')+''|''+ISNULL(ISWHITE,'''')+''|''+ISNULL(DISABILITY1CODE,'''')+''|''+ISNULL(DISABILITY2CODE,'''')+''|''+ISNULL(DISABILITY3CODE,'''')+''|''+ISNULL(DISABILITY4CODE,'''')+''|''+ISNULL(DISABILITY5CODE,'''')+''|''+ISNULL(DISABILITY6CODE,'''')+''|''+ISNULL(DISABILITY7CODE,'''')+''|''+ISNULL(DISABILITY8CODE,'''')+''|''+ISNULL(DISABILITY9CODE,'''')+''|''+ISNULL(ESYELIG,'''')+''|''+ISNULL(ESYTBDDATE,'''')+''|''+ISNULL(EXITDATE,'''')+''|''+ISNULL(EXITCODE,'''')+''|''+ISNULL(SPECIALEDSTATUS,'''')
FROM Datavalidation.Student_LOCAL WHERE 1 = 1'

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
SELECT ''Student'',''The issue is in the datalength of the field '+@columnname+'.'',Line_No,ISNULL(StudentRefID,'''')+''|''+ISNULL(StudentLocalID,'''')+''|''+ISNULL(StudentStateID,'''')+''|''+ISNULL(Firstname,'''')+''|''+ISNULL(MiddleName,'''')+''|''+ISNULL(LastName,'''')+''|''+ISNULL(Birthdate,'''')+''|''+ISNULL(Gender,'''')+''|''+ISNULL(MEDICAIDNUMBER,'''')+''|''+ISNULL(GRADELEVELCODE,'''')+''|''+ISNULL(SERVICEDISTRICTCODE,'''')+''|''+ISNULL(SERVICESCHOOLCODE,'''')+''|''+ISNULL(HOMEDISTRICTCODE,'''')+''|''+ISNULL(HOMESCHOOLCODE,'''')+''|''+ISNULL(ISHISPANIC,'''')+''|''+ISNULL(ISAMERICANINDIAN,'''')+''|''+ISNULL(ISASIAN,'''')+''|''+ISNULL(ISBLACKAFRICANAMERICAN,'''')+''|''+ISNULL(ISHAWAIIANPACISLANDER,'''')+''|''+ISNULL(ISWHITE,'''')+''|''+ISNULL(DISABILITY1CODE,'''')+''|''+ISNULL(DISABILITY2CODE,'''')+''|''+ISNULL(DISABILITY3CODE,'''')+''|''+ISNULL(DISABILITY4CODE,'''')+''|''+ISNULL(DISABILITY5CODE,'''')+''|''+ISNULL(DISABILITY6CODE,'''')+''|''+ISNULL(DISABILITY7CODE,'''')+''|''+ISNULL(DISABILITY8CODE,'''')+''|''+ISNULL(DISABILITY9CODE,'''')+''|''+ISNULL(ESYELIG,'''')+''|''+ISNULL(ESYTBDDATE,'''')+''|''+ISNULL(EXITDATE,'''')+''|''+ISNULL(EXITCODE,'''')+''|''+ISNULL(SPECIALEDSTATUS,'''')
FROM Datavalidation.Student_LOCAL  WHERE 1 = 1'

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
SELECT ''Student'',''Some of the '+@parentcolumn+' does not exist in '+@parenttable+' File or were not validated successfully, but it existed in Student.csv.'',Line_No,ISNULL(StudentRefID,'''')+''|''+ISNULL(StudentLocalID,'''')+''|''+ISNULL(StudentStateID,'''')+''|''+ISNULL(Firstname,'''')+''|''+ISNULL(MiddleName,'''')+''|''+ISNULL(LastName,'''')+''|''+ISNULL(Birthdate,'''')+''|''+ISNULL(Gender,'''')+''|''+ISNULL(MEDICAIDNUMBER,'''')+''|''+ISNULL(GRADELEVELCODE,'''')+''|''+ISNULL(SERVICEDISTRICTCODE,'''')+''|''+ISNULL(SERVICESCHOOLCODE,'''')+''|''+ISNULL(HOMEDISTRICTCODE,'''')+''|''+ISNULL(HOMESCHOOLCODE,'''')+''|''+ISNULL(ISHISPANIC,'''')+''|''+ISNULL(ISAMERICANINDIAN,'''')+''|''+ISNULL(ISASIAN,'''')+''|''+ISNULL(ISBLACKAFRICANAMERICAN,'''')+''|''+ISNULL(ISHAWAIIANPACISLANDER,'''')+''|''+ISNULL(ISWHITE,'''')+''|''+ISNULL(DISABILITY1CODE,'''')+''|''+ISNULL(DISABILITY2CODE,'''')+''|''+ISNULL(DISABILITY3CODE,'''')+''|''+ISNULL(DISABILITY4CODE,'''')+''|''+ISNULL(DISABILITY5CODE,'''')+''|''+ISNULL(DISABILITY6CODE,'''')+''|''+ISNULL(DISABILITY7CODE,'''')+''|''+ISNULL(DISABILITY8CODE,'''')+''|''+ISNULL(DISABILITY9CODE,'''')+''|''+ISNULL(ESYELIG,'''')+''|''+ISNULL(ESYTBDDATE,'''')+''|''+ISNULL(EXITDATE,'''')+''|''+ISNULL(EXITCODE,'''')+''|''+ISNULL(SPECIALEDSTATUS,'''')
FROM Datavalidation.Student_LOCAL tsch'

SET @query  = ' LEFT JOIN Datavalidation.'+@parenttable+' dt ON tsch.'+@columnname+' = dt.'+@parentcolumn+' WHERE dt.'+@parentcolumn+' IS NULL'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END


IF (@isFlagfield = 1)
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Student'',''The field '+@columnname+' should have one of the value in '''+LTRIM(REPLACE(@flagrecords,''',''','/'))+''''',Line_No,ISNULL(StudentRefID,'''')+''|''+ISNULL(StudentLocalID,'''')+''|''+ISNULL(StudentStateID,'''')+''|''+ISNULL(Firstname,'''')+''|''+ISNULL(MiddleName,'''')+''|''+ISNULL(LastName,'''')+''|''+ISNULL(Birthdate,'''')+''|''+ISNULL(Gender,'''')+''|''+ISNULL(MEDICAIDNUMBER,'''')+''|''+ISNULL(GRADELEVELCODE,'''')+''|''+ISNULL(SERVICEDISTRICTCODE,'''')+''|''+ISNULL(SERVICESCHOOLCODE,'''')+''|''+ISNULL(HOMEDISTRICTCODE,'''')+''|''+ISNULL(HOMESCHOOLCODE,'''')+''|''+ISNULL(ISHISPANIC,'''')+''|''+ISNULL(ISAMERICANINDIAN,'''')+''|''+ISNULL(ISASIAN,'''')+''|''+ISNULL(ISBLACKAFRICANAMERICAN,'''')+''|''+ISNULL(ISHAWAIIANPACISLANDER,'''')+''|''+ISNULL(ISWHITE,'''')+''|''+ISNULL(DISABILITY1CODE,'''')+''|''+ISNULL(DISABILITY2CODE,'''')+''|''+ISNULL(DISABILITY3CODE,'''')+''|''+ISNULL(DISABILITY4CODE,'''')+''|''+ISNULL(DISABILITY5CODE,'''')+''|''+ISNULL(DISABILITY6CODE,'''')+''|''+ISNULL(DISABILITY7CODE,'''')+''|''+ISNULL(DISABILITY8CODE,'''')+''|''+ISNULL(DISABILITY9CODE,'''')+''|''+ISNULL(ESYELIG,'''')+''|''+ISNULL(ESYTBDDATE,'''')+''|''+ISNULL(EXITDATE,'''')+''|''+ISNULL(EXITCODE,'''')+''|''+ISNULL(SPECIALEDSTATUS,'''')
FROM Datavalidation.Student_LOCAL'

SET @query  = '  WHERE ('+@columnname+' NOT IN  ('+@flagrecords+') AND '+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END


IF (@isuniquefield = 1)
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Student'',''The field '+@columnname+' is unique field, Here '+@columnname+' record is repeated.'',st.Line_No,ISNULL(st.StudentRefID,'''')+''|''+ISNULL(st.StudentLocalID,'''')+''|''+ISNULL(st.StudentStateID,'''')+''|''+ISNULL(st.Firstname,'''')+''|''+ISNULL(st.MiddleName,'''')+''|''+ISNULL(st.LastName,'''')+''|''+ISNULL(st.Birthdate,'''')+''|''+ISNULL(st.Gender,'''')+''|''+ISNULL(st.MEDICAIDNUMBER,'''')+''|''+ISNULL(st.GRADELEVELCODE,'''')+''|''+ISNULL(st.SERVICEDISTRICTCODE,'''')+''|''+ISNULL(st.SERVICESCHOOLCODE,'''')+''|''+ISNULL(st.HOMEDISTRICTCODE,'''')+''|''+ISNULL(st.HOMESCHOOLCODE,'''')+''|''+ISNULL(st.ISHISPANIC,'''')+''|''+ISNULL(st.ISAMERICANINDIAN,'''')+''|''+ISNULL(st.ISASIAN,'''')+''|''+ISNULL(st.ISBLACKAFRICANAMERICAN,'''')+''|''+ISNULL(st.ISHAWAIIANPACISLANDER,'''')+''|''+ISNULL(st.ISWHITE,'''')+''|''+ISNULL(st.DISABILITY1CODE,'''')+''|''+ISNULL(st.DISABILITY2CODE,'''')+''|''+ISNULL(st.DISABILITY3CODE,'''')+''|''+ISNULL(st.DISABILITY4CODE,'''')+''|''+ISNULL(st.DISABILITY5CODE,'''')+''|''+ISNULL(st.DISABILITY6CODE,'''')+''|''+ISNULL(st.DISABILITY7CODE,'''')+''|''+ISNULL(st.DISABILITY8CODE,'''')+''|''+ISNULL(st.DISABILITY9CODE,'''')+''|''+ISNULL(st.ESYELIG,'''')+''|''+ISNULL(st.ESYTBDDATE,'''')+''|''+ISNULL(st.EXITDATE,'''')+''|''+ISNULL(st.EXITCODE,'''')+''|''+ISNULL(st.SPECIALEDSTATUS,'''')
FROM Datavalidation.Student_LOCAL st JOIN'

SET @query  = ' (SELECT '+@columnname+' FROM Datavalidation.Student_LOCAL GROUP BY '+@columnname+' HAVING COUNT(*)>1) ucst ON ucst.'+@columnname+' =st.'+@columnname+' '
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END

IF (@islookupcolumn =1 AND @lookuptable = 'SelectLists')
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Student'',''The '+@columnname+' "''+ st.'+@columnname+'+''" does not exist in '+@lookuptable+'.csv, but it existed in '+@tablename+'.csv'',st.Line_No,ISNULL(st.StudentRefID,'''')+''|''+ISNULL(st.StudentLocalID,'''')+''|''+ISNULL(st.StudentStateID,'''')+''|''+ISNULL(st.Firstname,'''')+''|''+ISNULL(st.MiddleName,'''')+''|''+ISNULL(st.LastName,'''')+''|''+ISNULL(st.Birthdate,'''')+''|''+ISNULL(st.Gender,'''')+''|''+ISNULL(st.MEDICAIDNUMBER,'''')+''|''+ISNULL(st.GRADELEVELCODE,'''')+''|''+ISNULL(st.SERVICEDISTRICTCODE,'''')+''|''+ISNULL(st.SERVICESCHOOLCODE,'''')+''|''+ISNULL(st.HOMEDISTRICTCODE,'''')+''|''+ISNULL(st.HOMESCHOOLCODE,'''')+''|''+ISNULL(st.ISHISPANIC,'''')+''|''+ISNULL(st.ISAMERICANINDIAN,'''')+''|''+ISNULL(st.ISASIAN,'''')+''|''+ISNULL(st.ISBLACKAFRICANAMERICAN,'''')+''|''+ISNULL(st.ISHAWAIIANPACISLANDER,'''')+''|''+ISNULL(st.ISWHITE,'''')+''|''+ISNULL(st.DISABILITY1CODE,'''')+''|''+ISNULL(st.DISABILITY2CODE,'''')+''|''+ISNULL(st.DISABILITY3CODE,'''')+''|''+ISNULL(st.DISABILITY4CODE,'''')+''|''+ISNULL(st.DISABILITY5CODE,'''')+''|''+ISNULL(st.DISABILITY6CODE,'''')+''|''+ISNULL(st.DISABILITY7CODE,'''')+''|''+ISNULL(st.DISABILITY8CODE,'''')+''|''+ISNULL(st.DISABILITY9CODE,'''')+''|''+ISNULL(st.ESYELIG,'''')+''|''+ISNULL(st.ESYTBDDATE,'''')+''|''+ISNULL(st.EXITDATE,'''')+''|''+ISNULL(st.EXITCODE,'''')+''|''+ISNULL(st.SPECIALEDSTATUS,'''')
FROM Datavalidation.Student_LOCAL st '

SET @query  = 'WHERE (st.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM Datavalidation.'+@lookuptable+' WHERE Type = '''+@lookuptype+''') AND st.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END

IF (@islookupcolumn =1 AND @lookuptable != 'SelectLists')
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Student'',''The '+@columnname+' "''+ st.'+@columnname+'+''" does not exist in '+@lookuptable+'.csv, but it existed in '+@tablename+'.csv'',st.Line_No,ISNULL(st.StudentRefID,'''')+''|''+ISNULL(st.StudentLocalID,'''')+''|''+ISNULL(st.StudentStateID,'''')+''|''+ISNULL(st.Firstname,'''')+''|''+ISNULL(st.MiddleName,'''')+''|''+ISNULL(st.LastName,'''')+''|''+ISNULL(st.Birthdate,'''')+''|''+ISNULL(st.Gender,'''')+''|''+ISNULL(st.MEDICAIDNUMBER,'''')+''|''+ISNULL(st.GRADELEVELCODE,'''')+''|''+ISNULL(st.SERVICEDISTRICTCODE,'''')+''|''+ISNULL(st.SERVICESCHOOLCODE,'''')+''|''+ISNULL(st.HOMEDISTRICTCODE,'''')+''|''+ISNULL(st.HOMESCHOOLCODE,'''')+''|''+ISNULL(st.ISHISPANIC,'''')+''|''+ISNULL(st.ISAMERICANINDIAN,'''')+''|''+ISNULL(st.ISASIAN,'''')+''|''+ISNULL(st.ISBLACKAFRICANAMERICAN,'''')+''|''+ISNULL(st.ISHAWAIIANPACISLANDER,'''')+''|''+ISNULL(st.ISWHITE,'''')+''|''+ISNULL(st.DISABILITY1CODE,'''')+''|''+ISNULL(st.DISABILITY2CODE,'''')+''|''+ISNULL(st.DISABILITY3CODE,'''')+''|''+ISNULL(st.DISABILITY4CODE,'''')+''|''+ISNULL(st.DISABILITY5CODE,'''')+''|''+ISNULL(st.DISABILITY6CODE,'''')+''|''+ISNULL(st.DISABILITY7CODE,'''')+''|''+ISNULL(st.DISABILITY8CODE,'''')+''|''+ISNULL(st.DISABILITY9CODE,'''')+''|''+ISNULL(st.ESYELIG,'''')+''|''+ISNULL(st.ESYTBDDATE,'''')+''|''+ISNULL(st.EXITDATE,'''')+''|''+ISNULL(st.EXITCODE,'''')+''|''+ISNULL(st.SPECIALEDSTATUS,'''')
FROM Datavalidation.Student_LOCAL st '

SET @query  = ' WHERE (st.'+@columnname+' NOT IN ( SELECT '+@lookupcolumn+' FROM Datavalidation.'+@lookuptable+') AND st.'+@columnname+' IS NOT NULL)'
SET @vsql = @vsql + @query
EXEC sp_executesql @stmt=@vsql
--PRINT @vsql
END


IF (@datatype = 'int')
BEGIN

SET @vsql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT ''Student'',''The field '+@columnname+' should have integer records.'',Line_No,ISNULL(StudentRefID,'''')+''|''+ISNULL(StudentLocalID,'''')+''|''+ISNULL(StudentStateID,'''')+''|''+ISNULL(Firstname,'''')+''|''+ISNULL(MiddleName,'''')+''|''+ISNULL(LastName,'''')+''|''+ISNULL(Birthdate,'''')+''|''+ISNULL(Gender,'''')+''|''+ISNULL(MEDICAIDNUMBER,'''')+''|''+ISNULL(GRADELEVELCODE,'''')+''|''+ISNULL(SERVICEDISTRICTCODE,'''')+''|''+ISNULL(SERVICESCHOOLCODE,'''')+''|''+ISNULL(HOMEDISTRICTCODE,'''')+''|''+ISNULL(HOMESCHOOLCODE,'''')+''|''+ISNULL(ISHISPANIC,'''')+''|''+ISNULL(ISAMERICANINDIAN,'''')+''|''+ISNULL(ISASIAN,'''')+''|''+ISNULL(ISBLACKAFRICANAMERICAN,'''')+''|''+ISNULL(ISHAWAIIANPACISLANDER,'''')+''|''+ISNULL(ISWHITE,'''')+''|''+ISNULL(DISABILITY1CODE,'''')+''|''+ISNULL(DISABILITY2CODE,'''')+''|''+ISNULL(DISABILITY3CODE,'''')+''|''+ISNULL(DISABILITY4CODE,'''')+''|''+ISNULL(DISABILITY5CODE,'''')+''|''+ISNULL(DISABILITY6CODE,'''')+''|''+ISNULL(DISABILITY7CODE,'''')+''|''+ISNULL(DISABILITY8CODE,'''')+''|''+ISNULL(DISABILITY9CODE,'''')+''|''+ISNULL(ESYELIG,'''')+''|''+ISNULL(ESYTBDDATE,'''')+''|''+ISNULL(EXITDATE,'''')+''|''+ISNULL(EXITCODE,'''')+''|''+ISNULL(SPECIALEDSTATUS,'''')  FROM Datavalidation.Student_LOCAL WHERE 1 = 1 '

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

-----------------------------------------------------------------
---To check the SchoolCode and DistrictCode combination 
-----------------------------------------------------------------
INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'Student','The ServiceSchoolCode and ServiceDistrictCode combination does not exist in School file.',st.Line_No,ISNULL(st.STUDENTREFID,'')+'|'+ISNULL(st.StudentLocalID,'')+'|'+ISNULL(st.StudentStateID,'')+'|'+ISNULL(st.Firstname,'')+'|'+ISNULL(st.MiddleName,'')+'|'+ISNULL(st.LastName,'')+'|'+ISNULL(st.Birthdate,'')+'|'+ISNULL(st.Gender,'')+'|'+ISNULL(st.MEDICAIDNUMBER,'')+'|'+ISNULL(st.GRADELEVELCODE,'')+'|'+ISNULL(st.SERVICEDISTRICTCODE,'')+'|'+ISNULL(st.SERVICESCHOOLCODE,'')+'|'+ISNULL(st.HOMEDISTRICTCODE,'')+'|'+ISNULL(st.HOMESCHOOLCODE,'')+'|'+ISNULL(st.ISHISPANIC,'')+'|'+ISNULL(st.ISAMERICANINDIAN,'')+'|'+ISNULL(st.ISASIAN,'')+'|'+ISNULL(st.ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(st.ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(st.ISWHITE,'')+'|'+ISNULL(st.DISABILITY1CODE,'')+'|'+ISNULL(st.DISABILITY2CODE,'')+'|'+ISNULL(st.DISABILITY3CODE,'')+'|'+ISNULL(st.DISABILITY4CODE,'')+'|'+ISNULL(st.DISABILITY5CODE,'')+'|'+ISNULL(st.DISABILITY6CODE,'')+'|'+ISNULL(st.DISABILITY7CODE,'')+'|'+ISNULL(st.DISABILITY8CODE,'')+'|'+ISNULL(st.DISABILITY9CODE,'')+'|'+ISNULL(st.ESYELIG,'')+'|'+ISNULL(st.ESYTBDDATE,'')+'|'+ISNULL(st.EXITDATE,'')+'|'+ISNULL(st.EXITCODE,'')+'|'+ISNULL(st.SPECIALEDSTATUS,'')
FROM Datavalidation.Student_LOCAL st
LEFT JOIN (SELECT STUDENTREFID FROM Datavalidation.Student_LOCAL st JOIN School sc ON st.ServiceDistrictCode = sc.DistrictCode AND st.ServiceSchoolCode = sc.SchoolCode) stusersch ON st.STUDENTREFID = stusersch.STUDENTREFID
WHERE stusersch.STUDENTREFID IS NULL
		                 
INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
SELECT 'Student','The HomeSchoolCode and HomeDistrictCode combination does not exist in School file.',st.Line_No,ISNULL(st.STUDENTREFID,'')+'|'+ISNULL(st.StudentLocalID,'')+'|'+ISNULL(st.StudentStateID,'')+'|'+ISNULL(st.Firstname,'')+'|'+ISNULL(st.MiddleName,'')+'|'+ISNULL(st.LastName,'')+'|'+ISNULL(st.Birthdate,'')+'|'+ISNULL(st.Gender,'')+'|'+ISNULL(st.MEDICAIDNUMBER,'')+'|'+ISNULL(st.GRADELEVELCODE,'')+'|'+ISNULL(st.SERVICEDISTRICTCODE,'')+'|'+ISNULL(st.SERVICESCHOOLCODE,'')+'|'+ISNULL(st.HOMEDISTRICTCODE,'')+'|'+ISNULL(st.HOMESCHOOLCODE,'')+'|'+ISNULL(st.ISHISPANIC,'')+'|'+ISNULL(st.ISAMERICANINDIAN,'')+'|'+ISNULL(st.ISASIAN,'')+'|'+ISNULL(st.ISBLACKAFRICANAMERICAN,'')+'|'+ISNULL(st.ISHAWAIIANPACISLANDER,'')+'|'+ISNULL(st.ISWHITE,'')+'|'+ISNULL(st.DISABILITY1CODE,'')+'|'+ISNULL(st.DISABILITY2CODE,'')+'|'+ISNULL(st.DISABILITY3CODE,'')+'|'+ISNULL(st.DISABILITY4CODE,'')+'|'+ISNULL(st.DISABILITY5CODE,'')+'|'+ISNULL(st.DISABILITY6CODE,'')+'|'+ISNULL(st.DISABILITY7CODE,'')+'|'+ISNULL(st.DISABILITY8CODE,'')+'|'+ISNULL(st.DISABILITY9CODE,'')+'|'+ISNULL(st.ESYELIG,'')+'|'+ISNULL(st.ESYTBDDATE,'')+'|'+ISNULL(st.EXITDATE,'')+'|'+ISNULL(st.EXITCODE,'')+'|'+ISNULL(st.SPECIALEDSTATUS,'')
FROM Datavalidation.Student_LOCAL st
LEFT JOIN (SELECT STUDENTREFID FROM Datavalidation.Student_LOCAL st JOIN School sc ON st.HomeDistrictCode = sc.DistrictCode AND st.HomeSchoolCode = sc.SchoolCode) stuhomsch ON st.STUDENTREFID = stuhomsch.STUDENTREFID
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






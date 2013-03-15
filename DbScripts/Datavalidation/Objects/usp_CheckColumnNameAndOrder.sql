IF EXISTS (SELECT 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'CheckColumnNameAndOrder')
DROP PROC Datavalidation.CheckColumnNameAndOrder
GO

CREATE PROC Datavalidation.CheckColumnNameAndOrder
(
@tablename varchar(50)
)
AS
BEGIN 
DECLARE @format table (columnname varchar(150))

/*
Here _Local has the Customer file(Ex:District_Local).And othertable has Specifiaction structure
*/
INSERT @format
SELECT COLUMN_NAME  FROM 
(
/*
!!!Maybe we can avoid to check the OrdinalPosition!!!
Check whether the file is missing any fields and fieldorders
*/
	SELECT COLUMN_NAME FROM
   (
		SELECT COLUMN_NAME,ORDINAL_POSITION 
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = @tablename AND TABLE_SCHEMA='Datavalidation'
		EXCEPT
		SELECT COLUMN_NAME,ORDINAL_POSITION
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = @tablename+'_Local' AND TABLE_SCHEMA='Datavalidation'
    ) a
   
UNION

/*
!!!Maybe we can avoid to check the OrdinalPosition!!!
Check whether the file has any extra columns
*/
	SELECT COLUMN_NAME FROM
   (
		SELECT COLUMN_NAME,ORDINAL_POSITION 
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = @tablename+'_Local' AND TABLE_SCHEMA='Datavalidation'
		EXCEPT
		SELECT COLUMN_NAME,ORDINAL_POSITION
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = @tablename AND TABLE_SCHEMA='Datavalidation'
    ) b
   
) formatissue


DECLARE @tablesql nVARCHAR(MAX)
SET @tablesql = 'IF OBJECT_ID(''tempdb..#ValidationReport'') IS NOT NULL DROP TABLE #ValidationReport'	
EXEC sp_executesql @stmt = @tablesql

SELECT * INTO #ValidationReport FROM  @format

DECLARE @sql nVARCHAR(MAX)
DECLARE @sumsql NVARCHAR(MAX)
--Here we may insert these issues in a table and can report to customer
IF EXISTS (SELECT 1 FROM @format)
	
	BEGIN
	SET @sql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line)
	SELECT  '''+@tablename+''', ''The issue is in ''+ columnname + '' Field or in Field Order in the '+@tablename+'. Please correct this and check this column exist in specification'',''0'',''''
	FROM #ValidationReport'
	EXEC sp_executesql @stmt=@sql 
	
	SET @sumsql = 'INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
	SELECT  '''+@tablename+''', ''The issue is in ''+ columnname + '' Field or in Field Order in the '+@tablename+'.'',''1''
	FROM #ValidationReport'
	EXEC sp_executesql @stmt=@sumsql 
	RETURN 0
	END

ELSE

    BEGIN
SET @sql = 'INSERT Datavalidation.ValidationReport (TableName,ErrorMessage,LineNumber,Line) SELECT '''+@tablename+''', ''Field Names and Fields order are correct order in the '+@tablename+'.csv'',''0'','''''
	EXEC sp_executesql @stmt=@sql 
	RETURN 1
	END
	 
SET @sql = 'IF OBJECT_ID(''tempdb..#ValidationReport'') IS NOT NULL DROP TABLE #ValidationReport'	
EXEC sp_executesql @stmt = @sql   
      

END
IF EXISTS (SELECT 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'CheckColumnNameAndOrder')
DROP PROC dbo.CheckColumnNameAndOrder
GO

CREATE PROC dbo.CheckColumnNameAndOrder
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
		WHERE TABLE_NAME = @tablename AND TABLE_SCHEMA='dbo'
		EXCEPT
		SELECT COLUMN_NAME,ORDINAL_POSITION
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = @tablename+'_Local' AND TABLE_SCHEMA='dbo'
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
		WHERE TABLE_NAME = @tablename+'_Local' AND TABLE_SCHEMA='dbo'
		EXCEPT
		SELECT COLUMN_NAME,ORDINAL_POSITION
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = @tablename AND TABLE_SCHEMA='dbo'
    ) b
   
) formatissue


DECLARE @tablesql nVARCHAR(MAX)
SET @tablesql = 'IF OBJECT_ID(''tempdb..#ValidationReport'') IS NOT NULL DROP TABLE #ValidationReport'	
EXEC sp_executesql @stmt = @tablesql

SELECT * INTO #ValidationReport FROM  @format

DECLARE @sql nVARCHAR(MAX)
--Here we may insert these issues in a table and can report to customer
IF EXISTS (SELECT 1 FROM @format)
	
	BEGIN
	SET @sql = 'INSERT '+ @tablename+'_ValidationReport (Result) 
	SELECT ''The issue is in ''+ columnname + '' Field or in Field Order in the '+@tablename+' . Please correct this and check this column exist in specification''
	FROM #ValidationReport'
	EXEC sp_executesql @stmt=@sql 
	RETURN 0
	END

ELSE

    BEGIN
	SET @sql = 'INSERT '+ @tablename+'_ValidationReport (Result) SELECT ''Field Names and Fields order are correct order in the '+@tablename+'.csv'''
	
	EXEC sp_executesql @stmt=@sql 
	RETURN 1
	END
	 
SET @sql = 'IF OBJECT_ID(''tempdb..#Student'') IS NOT NULL DROP TABLE #Student'	
EXEC sp_executesql @stmt = @sql   
      

END
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'ExtractData_From_Csv')
DROP PROC x_DATAVALIDATION.ExtractData_From_Csv
GO

CREATE PROC x_DATAVALIDATION.ExtractData_From_Csv
(
@path VARCHAR(250),
@tablename VARCHAR(100)
)
AS
/*
@path - File Location
@tablename - Name of the table we stored the data in database
*/
BEGIN

BEGIN TRY 

DECLARE @sql nVARCHAR(4000)
DECLARE @sumsql nVARCHAR(4000)
DECLARE @fi_av_output int
DECLARE @chcol_output int
DBCC CHECKIDENT ('x_DATAVALIDATION.ValidationReport', RESEED, 1)
--DECLARE @stagingtablename VARCHAR(100)
--SET @stagingtablename = @tablename+'_LOCAL'

EXEC @fi_av_output= x_DATAVALIDATION.ImportDatafileToStaging @path,@tablename
IF (@fi_av_output = 1)

 BEGIN
EXEC @chcol_output = x_DATAVALIDATION.CheckColumnNameAndOrder @tablename

IF (@chcol_output =1)

    BEGIN
SET @sql  = 'x_DATAVALIDATION.Check_'+@tablename+'_specifications'
EXEC sp_executesql @stmt=@sql
RETURN 1
    END

 ELSE

    BEGIN
RETURN 0
    END

 END

ELSE 

 BEGIN
SET @sql = 'INSERT x_DATAVALIDATION.ValidationReport (TableName,ErrorMessage,LineNumber,Line) SELECT '''+@tablename+''',''The '+@tablename+'.csv doesnot exist'',''0'','''''
EXEC sp_executesql @stmt=@sql 
SET @sumsql = 'INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords) SELECT '''+@tablename+''',''The '+@tablename+'.csv doesnot exist'',''1'''
EXEC sp_executesql @stmt=@sumsql 
 END
 
END TRY

BEGIN CATCH
DECLARE @ErrorMessage NVARCHAR(4000);
SELECT @ErrorMessage = ERROR_MESSAGE()
PRINT @ErrorMessage
END CATCH

END


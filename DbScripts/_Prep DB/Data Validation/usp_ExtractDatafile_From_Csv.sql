IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'ExtractData_From_Csv')
DROP PROC dbo.ExtractData_From_Csv
GO

CREATE PROC dbo.ExtractData_From_Csv
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
DECLARE @fi_av_output int
DECLARE @chcol_output int
DECLARE @stagingtablename VARCHAR(100)

SET @stagingtablename = @tablename+'_LOCAL'

EXEC @fi_av_output=dbo.ImportDatafileToStaging @path,@stagingtablename
IF (@fi_av_output = 1)
BEGIN
EXEC @chcol_output = dbo.CheckColumnNameAndOrder @tablename
IF (@chcol_output =1)
BEGIN
--RETURN 0 IF THE FILE HAS ANY ISSUES
SET @sql  = 'dbo.Check_'+@tablename+'_specifications'
EXEC sp_executesql @stmt=@sql
RETURN 0
END

ELSE

BEGIN
--RETURN 1 IF THE FILE VALIDATED SUCCESSFULLY
RETURN 1

END
END
ELSE 
BEGIN
SET @sql = 'INSERT '+ @tablename+'_ValidationReport (Result) SELECT ''The '+@tablename+'.csv doesnot exist'''
EXEC sp_executesql @stmt=@sql 
END
END TRY

BEGIN CATCH
DECLARE @ErrorMessage NVARCHAR(4000);
select @ErrorMessage = ERROR_MESSAGE()
print @ErrorMessage
END CATCH

END


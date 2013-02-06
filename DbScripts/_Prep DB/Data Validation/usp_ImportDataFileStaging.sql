if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'dbo' and o.name = 'ImportDatafileToStaging')
DROP PROC dbo.ImportDatafileToStaging
GO

CREATE PROC dbo.ImportDatafileToStaging
(
@path nvarchar(max),
@tablename varchar(50)
)
AS
BEGIN
--declare @path NVARCHAR(MAX)

--SET @path = 'C:\Test\Student.csv'
BEGIN TRY
    DECLARE @execSQL nvarchar(max)
    DECLARE @tempstr nvarchar(max)
    DECLARE @col varchar(max)
    DECLARE @table nvarchar(max)

    -- Create a temp table to with one column to hold the first row of the csv file

  IF Object_id('tempdb..#tbl') IS NOT NULL 
       DROP TABLE #tbl 

      CREATE TABLE #tbl (line nVARCHAR(max))
       SET @execSQL = 
            'BULK INSERT #tbl  
            FROM ''' + @path + '''  
            WITH (  
                     FIELDTERMINATOR =''|'',
                     FIRSTROW = 1,  
                     ROWTERMINATOR = ''\n'',
                     LASTROW = 1 
                  )         
           ' 

       EXEC sp_executesql @stmt=@execSQL 

    --update #tbl set line = REPLACE(line,' ','_') where line like '% %'


       SET @col = ''
       SET @tempstr = (SELECT TOP 1 RTRIM(Line) FROM #tbl)
     
--select * from #tbl
       DROP TABLE #tbl

    SET @col=@col + LTRIM(RTRIM(SUBSTRING(@tempstr, 1, CHARINDEX('|',@tempstr)-1))) + ' nvarchar(max),'     
    --select @col
    SET @tempstr = SUBSTRING(@tempstr, CHARINDEX('|',@tempstr)+1, len(@tempstr))
    --select  @tempstr

       WHILE CHARINDEX('|',@tempstr) > 0
        BEGIN          

           SET @col=@col + LTRIM(RTRIM(SUBSTRING(@tempstr, 1, CHARINDEX('|',@tempstr)-1))) + ' nvarchar(max),'     

           SET @tempstr = SUBSTRING(@tempstr, CHARINDEX('|',@tempstr)+1, len(@tempstr)) 
        END
        SET @col = @col + @tempstr + ' nvarchar(max)'

		SET @table = 'IF Object_id('''+@tablename+''') IS NOT NULL 
					  DROP TABLE '+@tablename +'
					  CREATE TABLE '+@tablename+'(' +@col+ ')'

       --print @table

       EXEC sp_executesql @stmt=@table


     --Load data from csv
       SET @execSQL = 
            'BULK INSERT '+@tablename+'
            FROM ''' + @path + '''  
            WITH (  
                     FIELDTERMINATOR =''|'',
                     FIRSTROW = 2,  
                     ROWTERMINATOR = ''\n''              
                  )         
           '  

       EXEC sp_executesql @stmt=@execSQL 
       RETURN 1
END TRY

BEGIN CATCH 
DECLARE @ErrorMessage NVARCHAR(4000);
select  @ErrorMessage = ERROR_MESSAGE()
print @ErrorMessage
RETURN 0
END CATCH

END

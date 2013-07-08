IF EXISTS (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'ImportDatafileToStaging')
DROP PROC x_DATAVALIDATION.ImportDatafileToStaging
GO

CREATE PROC x_DATAVALIDATION.ImportDatafileToStaging
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
    DECLARE @no_of_field int 
    DECLARE @stagingtablename varchar(50)  --staging table to store records
    
    SET @stagingtablename = @tablename +'_LOCAL'


-- Create a temp table to with one column to hold the first row of the csv file
--==================================================================================================================
--Creating a table that is going to have Source file structre
--==================================================================================================================
  IF Object_id('tempdb..#tbl') IS NOT NULL 
       DROP TABLE #tbl 

      CREATE TABLE #tbl (Line nVARCHAR(max))
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

       SET @col = ''
       SET @tempstr = (SELECT TOP 1 RTRIM(Line) FROM #tbl)   --Header Row
       SET @no_of_field = (SELECT LEN(Line) - LEN(REPLACE(Line, '|', '')) FROM #tbl)  --to store no of delimiters in the header row
     -- select * from #tbl
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

		SET @table = 'IF Object_id(''x_DATAVALIDATION.'+@stagingtablename+''') IS NOT NULL 
					  DROP TABLE x_DATAVALIDATION.'+@stagingtablename +'
					  CREATE TABLE x_DATAVALIDATION.'+@stagingtablename+'(Line_No INT, ' +@col+ ')'

      -- print @table

       EXEC sp_executesql @stmt=@table

--================================================================================================================================
--Load the Source file to Temp table and checking whether the no of fields in header and other rows are same.
--================================================================================================================================
  IF Object_id('tempdb..#flatfile') IS NOT NULL 
       DROP TABLE #flatfile

  CREATE TABLE #flatfile(row nVARCHAR(max))

--Load data from csv
       SET @execSQL = 
            'BULK INSERT #flatfile
            FROM ''' + @path + '''  
            WITH (  
                     FIELDTERMINATOR =''|'',
                     FIRSTROW = 2,  
                     ROWTERMINATOR = ''\n''              
                  )         
           '  

       EXEC sp_executesql @stmt=@execSQL
       
       IF Object_id('tempdb..#flatfile_LineNo') IS NOT NULL 
       DROP TABLE #flatfile_LineNo
       
       CREATE TABLE #flatfile_LineNo(LINE_NO INT IDENTITY(1,1),row nVARCHAR(max))

       --Flatfile records with line numbers
       DBCC CHECKIDENT (#flatfile_LineNo, RESEED, 1)  -- May need to make identity seed as 2
              
INSERT #flatfile_LineNo
SELECT REPLACE(row,'''','''''') as row FROM #flatfile 

     --Flatfile records after validating the file rows (Checking all the rows with header row by using no of fields)  
       IF Object_id('tempdb..#flatfile_validrec') IS NOT NULL 
       DROP TABLE #flatfile_validrec
       
SELECT LINE_NO,REPLACE(row,'''','''''') as row INTO #flatfile_validrec FROM #flatfile_LineNo WHERE LEN(row) - LEN(REPLACE(row, '|', '')) = @no_of_field

INSERT x_DATAVALIDATION.ValidationSummaryReport
SELECT @tablename,'Total Records',COUNT(*)as cnt FROM #flatfile

INSERT x_DATAVALIDATION.ValidationReport
SELECT @tablename,'Number of fields in the row does not match with header',LINE_NO,REPLACE(row,'''','''''') as row FROM #flatfile_LineNo WHERE LEN(row) - LEN(REPLACE(row, '|', '')) != @no_of_field

INSERT x_DATAVALIDATION.ValidationSummaryReport 
SELECT @tablename, 'Number of fields in the row does not match with header', COUNT(*)
FROM #flatfile_LineNo WHERE LEN(row) - LEN(REPLACE(row, '|', '')) != @no_of_field
 --select * from #flatfile_validrec
 
 --(select ''''+REPLACE(row,'|',''',''')+'''' from #flatfile_validrec)
--/* 
 
--==========================================================================================================================================
--To Load Staging table 
--==========================================================================================================================================  
DECLARE @line VARCHAR(MAX)
DECLARE @line_no int

IF (SELECT CURSOR_STATUS('global','curInsertcsv')) >=0 
BEGIN
DEALLOCATE curInsertcsv
END

DECLARE curInsertcsv CURSOR FOR SELECT LINE_NO,row FROM #flatfile_validrec order by Line_no
OPEN curInsertcsv

FETCH NEXT FROM curInsertcsv INTO @line_no,@line
DECLARE @linestr VARCHAR(MAX)
DECLARE @rowrec VARCHAR(MAX)
DECLARE @sql VARCHAR(MAX)
WHILE @@fetch_status = 0

BEGIN
SET @linestr = @line
--print @line
SET @rowrec = ''''
SET @rowrec=@rowrec + LTRIM(RTRIM(SUBSTRING(@linestr, 1, CHARINDEX('|',@linestr)-1))) + ''','''     
--select @rowrec
SET @linestr = SUBSTRING(@linestr, CHARINDEX('|',@linestr)+1, len(@linestr))
WHILE CHARINDEX('|',@linestr) > 0
        BEGIN          
        SET @rowrec=(@rowrec) + LTRIM(RTRIM(SUBSTRING(@linestr, 1, CHARINDEX('|',@linestr)-1))) + ''','''     
		--print @rowrec
        SET @linestr = (SUBSTRING(@linestr, CHARINDEX('|',@linestr)+1, len(@linestr)) )
        END
        SET @rowrec = @rowrec + @linestr + ''''
		--print @rowrec
		--print @line_no
		SET @rowrec = REPLACE(@rowrec,',''''',',NULL')
		SET @sql = 'INSERT x_DATAVALIDATION.'+@stagingtablename+' SELECT '+cast(@line_no as varchar(5))+','+@rowrec
	   EXEC (@sql) 
		--print @sql
FETCH NEXT FROM curInsertcsv INTO @line_no,@line
END

CLOSE curInsertcsv
DEALLOCATE curInsertcsv

DROP TABLE #flatfile_LineNo
DROP TABLE #flatfile_validrec
DROP TABLE #flatfile
--*/
RETURN 1

END TRY

--==================================================================================================================================
--If the file is not available or any other issues we encounter during the csv import
--==================================================================================================================================
BEGIN CATCH 
DECLARE @ErrorMessage NVARCHAR(4000);
SELECT  @ErrorMessage = ERROR_MESSAGE()
PRINT @ErrorMessage

RETURN 0

END CATCH

END

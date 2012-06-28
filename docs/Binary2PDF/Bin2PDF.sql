-- this code was borrowed from 
-- http://stackoverflow.com/questions/613154/how-to-dump-all-of-our-images-from-a-varbinarymax-field-in-sql2008-to-the-file
-- and
-- http://social.msdn.microsoft.com/Forums/en/sqltools/thread/857fca64-7500-4e45-88c7-319b4166ff32 (minor modification to format file)

---- To allow advanced options to be changed.
--EXEC sp_configure 'show advanced options', 1
--GO
---- To update the currently configured value for advanced options.
--RECONFIGURE
--GO
---- To enable the feature.
--EXEC sp_configure 'xp_cmdshell', 1
--GO
---- To update the currently configured value for this feature.
--RECONFIGURE
--GO

SET NOCOUNT ON

DECLARE @IEPRefID varchar(150), @FileName VARCHAR(200), @Sqlstmt varchar(4000)

DECLARE Cursor_Image CURSOR FOR
    SELECT a.IEPRefID, 'IEP_'+LTRIM(STR(a.IEPRefID))+'.'+a.DocType FROM speddoc.dbo.IEPDoc a ORDER BY a.IEPRefID

OPEN Cursor_Image
    FETCH NEXT FROM Cursor_Image INTO @IEPRefID, @FileName

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Framing DynamicSQL for XP_CMDshell            
        SET @Sqlstmt='BCP "SELECT Content FROM SpedDoc.dbo.IEPDoc WHERE IEPRefID = ' + LTRIM(STR(@IEPRefID)) + '" QUERYOUT E:\Binary2PDF\Output\' + LTRIM(@FileName) + ' -T -fE:\Binary2PDF\Bin2PDF.fmt'
        print @FileName
        print @sqlstmt

        EXEC xp_cmdshell @sqlstmt
    FETCH NEXT FROM Cursor_Image INTO @IEPRefID, @FileName
    END

CLOSE Cursor_Image
DEALLOCATE Cursor_Image
go

/*

SQLState = S1000, NativeError = 0
Error = [Microsoft][SQL Server Native Client 10.0]Unable to open BCP host data-file




2nd query
bcp "select DOCUMENT_BODY from database.dbo.DOCUMENT where DOCUMENT_FILE_NAME = 'Document.pdf'" queryout "E:\Docs\Document.pdf" -S"server" -T -f"E:\Docs\format.fmt"

1st format
10.0
1
1       SQLIMAGE            0       0       ""   1     OriginalImage


2nd format
10.0
1
1 SQLBINARY 4 0 "" 1 DOCUMENT_BODY ""



select IEPRefID from iepdoc where IEPRefID >= 31935




*/


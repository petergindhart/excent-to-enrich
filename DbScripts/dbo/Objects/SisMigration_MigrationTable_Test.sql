IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SisMigration_MigrationTable_Test]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SisMigration_MigrationTable_Test]
GO

CREATE PROCEDURE dbo.SisMigration_MigrationTable_Test
(
	@migrationTableSource uniqueidentifier, 
	@migrationTableDest uniqueidentifier, 
	@ConstantsSql varchar(1000),
	@includeExpectedConflicts bit = 1
)
AS

SET NOCOUNT ON

DECLARE @crlf varchar(2)
SET @crlf = char(13) + char(10)

DECLARE @isCompat bit

--determine if the two tables are actually compatible, both by MigrationType and by Individual column type
-- SIS to SIS, School to School
SELECT
	@isCompat = 
		case 
			when --smty1.ID = smty2.ID AND
					sm1.TypeID = sm2.TypeID
		then 1 else 0 end
FROM
	SisMigrationTable smt1 join
	SisMigration sm1 on smt1.SisMigrationID = sm1.ID and sm1.ID = @migrationTableSource join
	sisMigrationType smty1 on smty1.ID = sm1.TypeID join
	SisMigrationTable smt2 on 1=1  join
	SisMigration sm2 on smt2.SisMigrationID = sm2.ID and sm2.ID = @migrationTableDest join
	sisMigrationType smty2 on smty2.ID = sm2.TypeID

if(@isCompat = 0)
	GOTO InCompatible

SET @ConstantsSql = ISNULL(@ConstantsSql, ' ')

DECLARE	@SourceTbl varchar(250)
DECLARE	@SourceMapTable varchar(250)
DECLARE	@SourceDestTablePK varchar(250)

DECLARE	@DestTable varchar(250)
DECLARE	@DestSourceTable varchar(250)

DECLARE @DestMapTable varchar(250)
DECLARE @DestTablePK varchar(250)
DECLARE @DestPreviewCOlumns varchar(250)
DECLARE @sql varchar(8000)

-- use the source properties from the source migration table
SELECT
	@SourceTbl = SourceTable,
	@SourceMapTable = MapTable,
	@SourceDestTablePK = DestinationTablePK
FROM	
	SisMigrationTable 
WHERE 
	ID = @migrationTableSource

-- use the destination properties from the destination migration table
SELECT
	@DestTable = DestinationTable,
	@DestSourceTable = Sourcetable,
	@DestMapTable = MapTable,
	@DestTablePK = DestinationTablePK,
	@DestPreviewCOlumns = PreviewColumns
FROM	
	SisMigrationTable 
WHERE 
	ID = @migrationTableDest

DECLARE @colCount int

SELECT @colCount = count(*)
from SisMigrationColumn 
where MigrationTableID = @migrationTableDest 

--used for no keys, one keys, and for iterating over multiple keys
DECLARE @sourceCol varchar(50)
DECLARE @destCol varchar(50)
DECLARE @previewCols varchar(2000)			

IF(@colCount = 1)
BEGIN	
	SELECT 	@sourceCol = Name FROM SisMigrationColumn WHERE MigrationTableID = @migrationTableSource  
	SELECT	@destCol = Name FROM SisMigrationColumn	WHERE MigrationTableID = @migrationTableDest 
				
	SELECT
		@previewCols = IsNull(@previewCols + ',','') + 'cast( ' + replace('dest.'+ item +' ',' ','') + ' as varchar(50)) AS #Dest_' +  replace(item,' ','')
	FROm
		dbo.Split(@DestPreviewCOlumns,',')

	SET @sql =		
		@ConstantsSql + @crlf + 		
		'SELECT IsSourceFailure= case when src.' + @sourceCol + ' is null then 1 else 0 end, src.' + @sourceCol + ' AS #Source_' + @sourceCol+  ', ' + @previewCols  + ' '+  @crlf + 
		'FROM ' + IsNull(@SourceMapTable, @SourceTbl) + ' src full outer join ' + @crlf + 
		 @DestSourceTable + ' dest on src.' + @sourceCol + ' = dest.' + @destCol + @crlf + 
		'WHERE' + @crlf + 
		@sourceCol + ' is null OR ' + @destCol + ' is null'
		
END
ELSE
BEGIN
	DECLARE @joinString varchar(500)
	DECLARE @IsNullSTring varchar(1000)
	DECLARE @isSourceFailureAgg varchar(500)

	--IF they both have non-typed columns, that means they can be joined literally, the same way it would be if they only had one column at all
	IF exists(select * from SisMigrationColumn WHERE MigrationTableID = @migrationTableSource and TypeID is null) and 
	   exists(select * from SisMigrationColumn WHERE MigrationTableID = @migrationTableDest and TypeID is null)
	BEGIN
		SET @sourceCol = null
		SET @destCol = null
		
		SELECT 	@sourceCol = Name FROM SisMigrationColumn WHERE MigrationTableID = @migrationTableSource  and TypeID is null
		SELECT	@destCol = Name FROM SisMigrationColumn	WHERE MigrationTableID = @migrationTableDest and TypeID is null

		SET @joinString = 'src.' + @sourceCol + ' = dest.' + @destCol
		SET @IsNullSTring	= IsNUll(@IsNullSTring + ' OR','') + ' src.' + @sourceCol + ' IS NULL OR  dest.' + @destCol  + ' IS NULL'
		SET @isSourceFailureAgg = @sourceCol + ' is null OR ' + @destCol + ' is null'
	END
	ELSE
	BEGIN
		SET @joinString = null		
		SET @IsNullSTring = null
		
		DECLARE @colName varchar(50)
		DECLARE @colType uniqueidentifier
		DECLARE @sourceCols varchar(1000)
		DECLARE @previewSourceCols varchar(1000)

		-- build up columns
		DECLARE Dest_TABLE_cursor CURSOR FOR 
		select Name, TypeID
		from SisMigrationColumn 
		where 
			MigrationTableID = @migrationTableDest 	AND
			TypeID is not null
	
		OPEN Dest_TABLE_cursor
	
		FETCH NEXT FROM Dest_TABLE_cursor INTO @colName, @colType
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @sourceCol = Name 
			FROm SisMigrationColumn
			WHERE MigrationTableID = @migrationTableSource AND
				TypeID = @colType

			SET @joinString = IsNUll(@joinString + ' AND','') + ' src.' + @sourceCol + ' = dest.' + @colName  
			SET @IsNullSTring = IsNUll(@IsNullSTring + ' OR','') + ' src.' + @sourceCol + ' IS NULL OR  dest.' + @colName  + ' IS NULL'
			SET @sourceCols = IsNUll(@sourceCols + ', ','') + ' src.' + @sourceCol
			SET @previewSourceCols = IsNull(@previewSourceCols + ', ','') + '  cast( ' + replace('src.'+ @sourceCol +' ',' ','') + ' as varchar(100)) AS #Source_' +  replace(@sourceCol,' ','')
			
			SET @isSourceFailureAgg = ' IsSourceFailure = case when src.' + @sourceCol + ' is null then 1 else 0 end'

			SET @sourceCol = null
			SET @destCol = null

			FETCH NEXT FROM Dest_TABLE_cursor INTO @colName, @colType
		END
		CLOSE Dest_TABLE_cursor
		DEALLOCATE Dest_TABLE_cursor		
	END

	IF(@joinString is null)
		GOTO NotJoinable

	SELECT
		@previewCols = IsNull(@previewCols + ',','') + '  cast( ' + replace('dest.'+ item +' ',' ','') + ' as varchar(50)) AS #Dest_' +  replace(item,' ','')
	FROm
		dbo.Split(@DestPreviewCOlumns,',')

	SET @sql =		
		@ConstantsSql + @crlf + 		
		'SELECT' + IsNull(@isSourceFailureAgg,'')  + ', ' + case when LEN(@previewSourceCols) > 0 then @previewSourceCols else '' end + ',' + @previewCols  + ' '+  @crlf + 
		'FROM ' + IsNull(@SourceMapTable, @SourceTbl) + ' src full outer join ' + @crlf + 
		 @DestSourceTable + ' dest on ' + @joinString +		
		IsNull(' WHERE' + @crlf + @IsNullSTring,'')
END

print @sql
exec(@sql)

RETURN 0

NotJoinable:	
	RAISERROR('An error occurred because a join could not be created during migration, ensure migration is supported between both SIS''s', 16, 1)
	RETURN 1

InCompatible:		
	RAISERROR('Tables cannot be migrated source and destination are of a different type ', 16, 1)
	RETURN 1

ErrorOccurred:	
	RAISERROR('An error occurred migrating %s into %s', 16, 1, @SourceTbl, @DestTable)
	RETURN 1
GO
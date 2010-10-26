/****** Object:  StoredProcedure [dbo].[SisMigration_MigrationTable_FindExpectedConflicts]    Script Date: 07/22/2009 11:16:15 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SisMigration_MigrationTable_FindExpectedConflicts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SisMigration_MigrationTable_FindExpectedConflicts]
GO

CREATE PROCEDURE dbo.SisMigration_MigrationTable_FindExpectedConflicts
(
	@migrationTableSource uniqueidentifier, 
	@migrationTableDest uniqueidentifier, 
	@ConstantsSql varchar(1000)	
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
from 
	SisMigrationColumn join
	SisMigrationColumnType typ on TypeID = typ.id
where MigrationTableID = @migrationTableDest and
	SystemTable is not null
group by
	typ.ID

--used for no keys, one keys, and for iterating over multiple keys
DECLARE @sourceCol varchar(50)
DECLARE @destCol varchar(50)


IF(@colCount = 1)
BEGIN	
	SELECT 	@sourceCol = col.Name FROM SisMigrationColumn col join SisMigrationColumnType typ on typ.ID = TypeID WHERE MigrationTableID = @migrationTableSource and SystemTable is not null
	SELECT	@destCol = col.Name FROM SisMigrationColumn	col join SisMigrationColumnType typ on typ.ID = TypeID WHERE MigrationTableID = @migrationTableDest and SystemTable is not null

	DECLARE @systemTable varchar(50)
	DECLARE @systemColumn varchar(50)
	DECLARE @systemGroupByColumn varchar(50)
	DECLARE @SystemWhereExpression varchar(750)
	DECLARE @SystemDisplayExpression varchar(750)
	DECLARE @SystemDisplayLabel varchar(25)

	SELECT
		@systemTable = SystemTable, @systemColumn  = systemColumn,
		@systemGroupByColumn = SystemGroupByColumn, @SystemWhereExpression = SystemWhereExpression, @SystemDisplayExpression = SystemDisplayExpression,
		@SystemDisplayLabel = SystemDisplayLabel
	from 
		sismigrationColumn col join 
		sismigrationColumnType type on col.TypeID = type.ID 
	where 
		MigrationTableID = @migrationTableDest 	and
		SystemTable is not null

     SET @sql =        
            @ConstantsSql + @crlf +             
            'SELECT ' + IsNull('''' + @SystemDisplayLabel + ''' AS Descriptor, ', '') + @SystemDisplayExpression + ' AS DataGroup, count(*) As TotalNumberOfRecords' + @crlf + 
            'FROM ' + IsNull(@SourceMapTable, @SourceTbl) + ' src left join ' + @crlf +         
            @DestSourceTable + ' dest on src.' + @sourceCol + ' = dest.' + @destCol + ' join ' + @crlf +
            @systemTable + ' systemTable on src.' + @sourceCol + ' = systemTable.' + @systemColumn + @crlf + 
            'WHERE ' + @crlf + 
            'src.' + @sourceCol + ' is not null AND dest.' + @destCol + ' is null'+ @crlf + 
            IsNull('group by ' + @crlf + @SystemGroupByColumn,'')

		
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


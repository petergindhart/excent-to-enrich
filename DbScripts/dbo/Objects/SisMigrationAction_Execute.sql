IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SisMigrationAction_Execute]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SisMigrationAction_Execute]
GO

 /*
<summary>
Executes the designated action that corresponds to the ID
</summary>
<param name="ids">Id of the action to perform</param>
<model isGenerated="false" returnType="System.Void" />
*/
CREATE PROCEDURE SisMigrationAction_Execute
( 
	@id uniqueidentifier,
	@consql varchar(4000),
	@printSql bit = 0,
	@execSql bit = 0
)
AS

SET NOCOUNT ON

DECLARE @err int

BEGIN TRAN

DECLARE @crlf varchar(2)
SET @crlf = char(13) + char(10)

DECLARE @sql varchar(8000)
SET @sql =''

DECLARE @actionType char(1)
DECLARE @targetDestinationTable varchar(100)
DECLARE @targetTableFilter varchar(2000)
DECLARE @targetMapTable varchar(2000)

select
	@actionType = a.TypeID,
	@targetDestinationTable = t.DestinationTable,
	@targetMapTable = MapTable,
	@targetTableFilter = a.Filter	
FROm
	SisMigrationAction a join
	SisMigrationTable t on a.MigrationTableID = t.ID join
	SisMigrationActionType typ on a.TypeId = typ.ID
	
IF (@actionType = 'D')
BEGIN
	SET @SQL = @consql + @crlf +
		'DELETE FROM ' +@targetDestinationTable + @crlf +
		IsNUll(' WHERE ' + @targetTableFilter,'')
END
ELSE IF (@actionType = 'M')
BEGIN
	SET @SQL = @consql + @crlf +
	'DELETE FROM ' +@targetMapTable + @crlf +
				IsNUll(' WHERE ' + @targetTableFilter,'')
END

exec @err = VC3ETL.RunSql @sql, @execSql, @printSql 
if @err <> 0 
	GOTO ErrorOccurred

COMMIT TRAN

RETURN 0

ErrorOccurred:
	ROLLBACK TRAN
	
	RAISERROR('An error occurred executing ''%s'' ', 16, 1, @actionType)
	
	RETURN 1


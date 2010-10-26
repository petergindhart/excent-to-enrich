SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Test_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Test_GetRecords]
GO


/*
<summary>
Retrieves the specified Test records.
</summary>
<param name="ids">Ids of the tests to retrieve</param>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Test_GetRecords
	@ids UNIQUEIDENTIFIERARRAY
AS
	declare @expectedRowCount int

	SELECT ID
	INTO #keys
	FROM GetIds(@ids)

	set @expectedRowCount = @@ROWCOUNT
	

	DECLARE @sql VARCHAR(8000)

	SET @sql = ' select T.*, @ID TestDefinitionID' +
		' from @tableName T join' +
		' #keys keys on keys.id = T.ID'

	EXEC TestDefinition_ExecForEach @sql
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Program_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Program_GetAllRecords]
GO

/*
<summary>
Gets all records from the Program table
</summary>
<param name="includeDeletedItems">Include deleted items</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Program_GetAllRecords]
	@includeDeletedItems bit
AS
	SELECT
		p.*
	FROM
		Program p
	WHERE 
		DeletedDate IS NULL OR
		@includeDeletedItems = 1
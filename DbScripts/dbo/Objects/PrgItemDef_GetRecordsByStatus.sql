IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItemDef_GetRecordsByStatus]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgItemDef_GetRecordsByStatus]
GO

/*
<summary>
Gets records from the PrgItemDef table
with the specified ids
</summary>
<param name="ids">Ids of the PrgStatus(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgItemDef_GetRecordsByStatus]
	@ids	uniqueidentifierarray
AS
	SELECT
		i.StatusId,
		i.*
	FROM
		PrgItemDef i INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON i.StatusId = Keys.Id 
	WHERE 
		i.DeletedDate IS NULL 
	ORDER BY 
		i.Name
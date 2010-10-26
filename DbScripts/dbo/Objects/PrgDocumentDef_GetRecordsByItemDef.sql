if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgDocumentDef_GetRecordsByItemDef]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgDocumentDef_GetRecordsByItemDef]
GO

/*
<summary>
Gets records from the PrgDocumentDef table
with the specified ids
</summary>
<param name="ids">Ids of the PrgItemDef(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgDocumentDef_GetRecordsByItemDef]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.ItemDefId,
		p.*
	FROM
		PrgDocumentDef p INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.ItemDefId = Keys.Id
	WHERE
		p.DeletedDate IS NULL

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgDocumentDef_GetRecordsByProgram]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgDocumentDef_GetRecordsByProgram]
GO

/*
<summary>
Gets records from the PrgDocumentDef table
with the specified ids
</summary>
<param name="ids">Ids of the Program(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgDocumentDef_GetRecordsByProgram]
	@ids	uniqueidentifierarray
AS
	SELECT
		i.ProgramId,
		d.*
	FROM
		PrgDocumentDef d INNER JOIN
		PrgItemDef i ON i.ID = d.ItemDefId INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON i.ProgramId = Keys.Id
	WHERE
		d.DeletedDate IS NULL
	ORDER BY 
		d.Name
GO

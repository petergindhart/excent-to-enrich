if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgDocumentDef_GetRecordsByTemplateFile]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgDocumentDef_GetRecordsByTemplateFile]
GO

/*
<summary>
Gets records from the PrgDocumentDef table
with the specified ids
</summary>
<param name="ids">Ids of the FileData(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgDocumentDef_GetRecordsByTemplateFile]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.TemplateFileId,
		p.*
	FROM
		PrgDocumentDef p INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.TemplateFileId = Keys.Id
	WHERE
		p.DeletedDate IS NULL

GO

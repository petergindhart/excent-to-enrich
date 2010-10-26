if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgDocumentDef_GetRecordsByFinalizeType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgDocumentDef_GetRecordsByFinalizeType]
GO

/*
<summary>
Gets records from the PrgDocumentDef table
with the specified ids
</summary>
<param name="ids">Ids of the PrgDocumentFinalizeType(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgDocumentDef_GetRecordsByFinalizeType]
	@ids chararray
AS
	SELECT
		p.FinalizeTypeId,
		p.*
	FROM
		PrgDocumentDef p INNER JOIN
		GetChars(@ids) Keys ON p.FinalizeTypeId = Keys.Id
	WHERE
		p.DeletedDate IS NULL

GO

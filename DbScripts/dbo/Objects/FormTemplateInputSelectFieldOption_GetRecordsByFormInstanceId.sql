if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormTemplateInputSelectFieldOption_GetRecordsByFormInstanceId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormTemplateInputSelectFieldOption_GetRecordsByFormInstanceId]
GO

/*
<summary>
Gets records from the FormTemplateInputSelectFieldOption table
with the specified ids
</summary>
<param name="ids">Ids of the FormInstance(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormTemplateInputSelectFieldOption_GetRecordsByFormInstanceId]
	@ids	uniqueidentifierarray
AS
	SELECT
		f.FormInstanceId,
		f.*
	FROM
		FormTemplateInputSelectFieldOption f INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.FormInstanceId = Keys.Id
	WHERE
		DeletedDate IS NULL
	ORDER BY
		f.Sequence
GO

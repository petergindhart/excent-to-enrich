if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormTemplateInputSelectFieldOption_GetRecordsBySelectField]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormTemplateInputSelectFieldOption_GetRecordsBySelectField]
GO

/*
<summary>
Gets records from the FormTemplateInputSelectFieldOption table
with the specified ids
</summary>
<param name="ids">Ids of the FormTemplateInputSelectField(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormTemplateInputSelectFieldOption_GetRecordsBySelectField]
	@ids	uniqueidentifierarray
AS
	SELECT
		f.SelectFieldId,
		f.*
	FROM
		FormTemplateInputSelectFieldOption f INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.SelectFieldId = Keys.Id
	WHERE
		f.FormInstanceId IS NULL and f.DeletedDate IS NULL
	ORDER BY 
		f.Sequence
GO

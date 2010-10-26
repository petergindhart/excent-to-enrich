IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputSingleSelectValue_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputSingleSelectValue_GetRecords]
GO

 /*
<summary>
Gets records from the FormInputSingleSelectValue table
	and inherited data from:FormInputValue
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputSingleSelectValue_GetRecords]
	@ids	uniqueidentifierarray
AS
	SELECT	
		f1.*,
		f.SelectedOptionId,
		IsCustom = CAST((CASE WHEN o.FormInstanceId IS NULL THEN 0 ELSE 1 END) as BIT),
		i.TypeId
	FROM
		FormInputSingleSelectValue f INNER JOIN
		FormInputValue f1 ON f.Id = f1.Id INNER JOIN
		FormTemplateInputItem i on f1.InputFieldId = i.Id INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.Id = Keys.Id LEFT OUTER JOIN
		FormTemplateInputSelectFieldOption o ON o.ID = f.SelectedOptionId
GO

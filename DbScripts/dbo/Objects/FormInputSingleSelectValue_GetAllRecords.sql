IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputSingleSelectValue_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInputSingleSelectValue_GetAllRecords]
GO

 /*
<summary>
Gets all records from the FormInputSingleSelectValue table
	and inherited data from:FormInputValue
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputSingleSelectValue_GetAllRecords]
AS
	SELECT
		f1.*,
		f.SelectedOptionId,
		IsCustom = CAST((CASE WHEN o.FormInstanceId IS NULL THEN 0 ELSE 1 END) as BIT),
		i.TypeId
	FROM
		FormInputSingleSelectValue f INNER JOIN
		FormInputValue f1 ON f.Id = f1.Id INNER JOIN
		FormTemplateInputItem i on f1.InputFieldId = i.Id LEFT OUTER JOIN
		FormTemplateInputSelectFieldOption o ON o.ID = f.SelectedOptionId
GO


IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInputValue_GetRecordsForFormInputSelectionAssociation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[FormInputValue_GetRecordsForFormInputSelectionAssociation]
GO

/*
<summary>
Gets records from the FormInputValue table for the specified association 
</summary>
<param name="ids">Ids of the FormTemplateInputSelectFieldOption(s) </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInputValue_GetRecordsForFormInputSelectionAssociation]
	@ids uniqueidentifierarray
AS
	SELECT
		ab.OptionId,
		a.*,
		i.TypeId
	FROM
		FormInputSelection ab INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON ab.OptionId = Keys.Id INNER JOIN
		FormInputValue a ON ab.ValueId = a.Id INNER JOIN
		FormTemplateInputItem i on a.InputFieldId = i.Id 
GO



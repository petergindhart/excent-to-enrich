if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormTemplateInputSelectFieldOption_DeleteRecordsForFormInputSelectionAssociation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormTemplateInputSelectFieldOption_DeleteRecordsForFormInputSelectionAssociation]
GO

/*
<summary>
Deletes records from the FormInputSelection table for the specified ids 
</summary>
<param name="valueId">The id of the associated FormInputValue</param>
<param name="ids">The ids of the FormTemplateInputSelectFieldOption's to delete</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[FormTemplateInputSelectFieldOption_DeleteRecordsForFormInputSelectionAssociation]
	@valueId uniqueidentifier, 
	@ids uniqueidentifierarray
AS
	DELETE FormInputSelection
	FROM 
		FormInputSelection ab INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON ab.OptionId = Keys.Id
	WHERE
		ab.ValueId = @valueId

	DELETE FormTemplateInputSelectFieldOption 
	FROM 
		FormTemplateInputSelectFieldOption o INNER JOIN 
		GetUniqueidentifiers(@ids) AS Keys ON o.Id = Keys.Id
	WHERE 
		o.FormInstanceId IS NOT NULL	
GO
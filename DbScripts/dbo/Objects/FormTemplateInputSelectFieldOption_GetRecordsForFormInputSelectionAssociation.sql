if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormTemplateInputSelectFieldOption_GetRecordsForFormInputSelectionAssociation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormTemplateInputSelectFieldOption_GetRecordsForFormInputSelectionAssociation]
GO

/*
<summary>
Gets records from the FormTemplateInputSelectFieldOption table for the specified association 
</summary>
<param name="ids">Ids of the FormInputValue(s) </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.[FormTemplateInputSelectFieldOption_GetRecordsForFormInputSelectionAssociation]
	@ids uniqueidentifierarray,
	@isCustom bit
AS
	SELECT
		ab.ValueId,
		a.*
	FROM
		FormInputSelection ab INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON ab.ValueId = Keys.Id INNER JOIN
		FormTemplateInputSelectFieldOption a ON ab.OptionId = a.Id
	WHERE
		(@isCustom = 1 AND a.FormInstanceId IS NOT NULL)
		OR
		(@isCustom = 0 AND a.FormInstanceId IS NULL)
	ORDER BY
		a.Sequence

GO

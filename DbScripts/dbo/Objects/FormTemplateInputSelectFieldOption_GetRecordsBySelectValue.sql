if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormTemplateInputSelectFieldOption_GetRecordsBySelectValue]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormTemplateInputSelectFieldOption_GetRecordsBySelectValue]
GO

/*
<summary>
Gets records from the FormTemplateInputSelectFieldOption table
with the specified ids
</summary>
<param name="ids">Ids of the FormInputSelectValue(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormTemplateInputSelectFieldOption_GetRecordsBySelectValue]
	@ids uniqueidentifierarray
AS
	-- NOTE:  union cannot be used on FormTemplateInputSelectFieldOption b/c of the TEXT column

	select
		ValueId = v.Id,
		o.*
	from FormTemplateInputSelectFieldOption o
		join FormInputValue v on v.InputFieldId = o.SelectFieldId
		join (
			-- Custom multi-select values
			select ValueId = keys.Id, s.OptionId
			from FormInputSelection s
				join FormTemplateInputSelectFieldOption o on o.ID = s.OptionId
				join GetUniqueidentifiers(@ids) keys ON s.ValueId = keys.Id
			where o.FormInstanceId IS NOT NULL

			union

			-- Custom single-select value
			select ValueId = keys.Id, OptionId = v.SelectedOptionId
			from FormInputSingleSelectValue v
				join FormTemplateInputSelectFieldOption o on o.ID = v.SelectedOptionId
				join GetUniqueidentifiers(@ids) keys ON v.Id = keys.Id
			where o.FormInstanceId IS NOT NULL
		) result ON result.OptionId = o.ID and result.ValueId = v.Id
	order by
		o.Sequence
GO

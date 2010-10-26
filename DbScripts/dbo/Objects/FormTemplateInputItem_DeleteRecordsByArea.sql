
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormTemplateInputItem_DeleteRecordsByArea]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormTemplateInputItem_DeleteRecordsByArea]
GO

 /*
<summary>
Deletes records from the FormTemplateInputItem table
with the specified area ids
</summary>
<param name="inputAreaId">Value to assign to the InputAreaId field of the record</param>
<model isGenerated="False" returnType="System.Guid" />
*/
CREATE PROCEDURE [dbo].[FormTemplateInputItem_DeleteRecordsByArea]	
	@inputAreaId uniqueidentifier
AS
	-- Delete dependent instance data first
	delete FormInputValue
	where InputFieldId in (select Id from FormTemplateInputItem where InputAreaId = @inputAreaId)

	-- Delete input items
	delete FormTemplateInputItem
	where InputAreaId = @inputAreaId

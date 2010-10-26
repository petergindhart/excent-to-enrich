IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateInputItem_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormTemplateInputItem_DeleteRecord]
GO

 /*
<summary>
Deletes a FormTemplateInputItem record
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[FormTemplateInputItem_DeleteRecord]
	@id uniqueidentifier
AS
	DELETE FROM
		FormInputValue
	WHERE
		InputFieldId = @id

	DELETE FROM 
		FormTemplateInputItem
	WHERE
		Id = @id


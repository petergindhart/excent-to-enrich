IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplate_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormTemplate_DeleteRecord]
GO

 /*
<summary>
Deletes a FormTemplate record
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[FormTemplate_DeleteRecord]
	@id uniqueidentifier
AS
	DELETE FROM
		FormInstance
	WHERE
		TemplateId = @id

	DELETE FROM 
		FormTemplate
	WHERE
		Id = @id
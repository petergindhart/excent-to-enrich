/****** Object:  StoredProcedure [dbo].[FormTemplateLayout_DeleteRecord]    Script Date: 06/04/2008 08:44:53 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplateLayout_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormTemplateLayout_DeleteRecord]
GO

/*
<summary>
Deletes a FormTemplateLayout record
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[FormTemplateLayout_DeleteRecord]
	@id uniqueidentifier
AS
	-- remove the old Layouts that connect to it
	UPDATE FormTemplateLayout
	SET ParentId = null
	WHERE ParentId = @id

	DELETE FROM 
		FormTemplateLayout
	WHERE
		Id = @id


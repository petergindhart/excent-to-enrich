SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Action_DeleteRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Action_DeleteRecord]
GO


/*
<summary>
Deletes an Action Record and all AcademicPlanActions that are associated with this Action. 
</summary>
<param name="id">Id of the record to delete</param>
<model isGenerated="False" returnType="System.Void" />
*/

CREATE PROCEDURE dbo.Action_DeleteRecord 
	@id uniqueidentifier
AS

	DELETE FROM AcademicPlanAction
	WHERE ActionId = @id

	DELETE FROM Action
	WHERE Id = @id


GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
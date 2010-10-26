IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItemDef_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgItemDef_DeleteRecord]
GO

/*
<summary>
Deletes a PrgItemDef record
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[PrgItemDef_DeleteRecord]
	@id uniqueidentifier
AS
	DELETE PrgActivitySchedule where ActivityDefID=@id
	DELETE PrgSectionDef where ItemDefID=@id

	DELETE FROM PrgRule 
	WHERE
		FilterID IN (SELECT ID FROM PrgFilter WHERE ActivityDefID = @id OR PlanDefID = @id) OR
		ActivityDefID = @id	
	
	DELETE FROM PrgFilter WHERE ActivityDefID = @id OR PlanDefID = @id

	DELETE FROM 
		PrgItemDef
	WHERE
		Id = @id
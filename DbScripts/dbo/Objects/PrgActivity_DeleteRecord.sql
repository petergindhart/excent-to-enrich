if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgActivity_DeleteRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgActivity_DeleteRecord]
GO

 /*
<summary>
Deletes a PrgActivity record
</summary>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[PrgActivity_DeleteRecord]
	@id uniqueidentifier
AS
	-- delete the activity record
	DELETE FROM PrgActivity WHERE Id = @id

	-- delete the item record and any dependant data
	EXEC PrgItem_DeleteRecord @id
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StudentGroup_DeleteRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[StudentGroup_DeleteRecord]
GO


/*
<summary>
Deletes a StudentGroup record
</summary>
<param name="id">Id of the record to delete</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.StudentGroup_DeleteRecord 
	@id uniqueidentifier
AS
	
	DELETE FROM StudentGroupStudent
	WHERE StudentGroupID  = @id

	DELETE FROM StudentGroup
	WHERE Id = @id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


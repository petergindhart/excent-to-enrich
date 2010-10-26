IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgResponsibility_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgResponsibility_DeleteRecord]
GO

 /*
<summary>
Deletes a PrgResponsibility record
</summary>

<model isGenerated="false" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[PrgResponsibility_DeleteRecord]
	@id uniqueidentifier
AS
	UPDATE PrgResponsibility
	SET DeletedDate = GETDATE()
	WHERE Id = @id
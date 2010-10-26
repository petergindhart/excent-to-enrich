IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'Person_DeleteRecord'
		AND type = 'P')
	DROP PROCEDURE dbo.Person_DeleteRecord

GO

/*
<summary>
Deletes a Person record
</summary>
<param name="id">Id of the record to delete</param>
<param name="@softDeletion">If the record should be soft/hard deleted</param>
<model isGenerated="false" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.Person_DeleteRecord 
	@id uniqueidentifier,
	@softDeletion bit = 1
AS

	IF(@softDeletion = 1)
	BEGIN
		UPDATE Person
		SET Deleted = getdate()
		WHERE ID=@id
	END
	ELSE
	BEGIN
		DELETE Person	
		WHERE ID = @id
	END

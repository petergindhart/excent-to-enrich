SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'UserProfile_DeleteRecord'
		AND type = 'P')
	DROP PROCEDURE dbo.UserProfile_DeleteRecord

GO

/*
<summary>
Deletes a UserProfile record
</summary>
<param name="id">Id of the record to delete</param>
<model isGenerated="false" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.UserProfile_DeleteRecord 
	@id uniqueidentifier
AS
	UPDATE UserProfile
	SET Deleted = GetDate()
	WHERE ID = @id
	
	-- Delete related records that are no longer needed
	delete Report where Owner = @id
	delete StudentGroup where OwnerID = @id
	delete ProcessRoleUserProfile where UserID = @id
	delete ReportUserRecipient where UserProfileID = @id
	delete UserProfileAlert where UserProfileID = @id
	

	-- Disassociate teachers from the deleted account
	update Teacher set UserProfileID = null where UserProfileID = @id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


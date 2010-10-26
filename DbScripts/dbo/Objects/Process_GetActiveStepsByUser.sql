IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'Process_GetActiveStepsByUser'
		AND type = 'P')
	DROP PROCEDURE dbo.Process_GetActiveStepsByUser
GO


/*
<summary>
Gets all steps for a Process that a user has access to
</summary>
<param name="id">Ids of the Process to retrieve</param>
<param name="userId">Ids of the UserProfile</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Process_GetActiveStepsByUser]
	@id	uniqueidentifier,
	@userId	uniqueidentifier
AS
SELECT	s.*
FROM	ProcessStep s JOIN
	Process p ON s.ProcessID = p.ID JOIN
	ProcessRole r ON s.AssignedRoleID = r.ID JOIN
	ProcessRoleUserProfile u ON u.RoleID = r.ID
WHERE	p.ID = @id
AND	u.UserID = @userId
AND	s.StatusID <> '899A2042-7E5E-47CC-A404-572B6B6F3600'

GO

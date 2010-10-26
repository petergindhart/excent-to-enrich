IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'Process_GetRecordsByUser'
		AND type = 'P')
	DROP PROCEDURE dbo.Process_GetRecordsByUser
GO

/*
<summary>
Gets all Process that a user has access to
</summary>
<param name="id">Id of User</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Process_GetRecordsByUser]
	@id	uniqueidentifier
AS

SELECT	distinct p.ID, p.*
FROM	Process p JOIN
	ProcessRole r ON r.ProcessID = p.ID JOIN
	ProcessRoleUserProfile u ON u.RoleID = r.ID
AND	u.UserID = @id
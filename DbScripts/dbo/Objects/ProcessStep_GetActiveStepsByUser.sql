IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'ProcessStep_GetActiveStepsByUser'
		AND type = 'P')
	DROP PROCEDURE dbo.ProcessStep_GetActiveStepsByUser
GO

/*
<summary>
Gets all steps for a Process that a user has access to
</summary>
<param name="userId">Ids of the UserProfile</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE ProcessStep_GetActiveStepsByUser
	@id uniqueidentifier,
	@stepId uniqueidentifier = NULL
AS
SELECT	s.*
FROM	ProcessStep s JOIN
	ProcessRole r ON s.AssignedRoleID = r.ID JOIN
	ProcessRoleUserProfile u ON u.RoleID = r.ID
WHERE
	u.UserID = @id AND
	s.StatusID <> '899A2042-7E5E-47CC-A404-572B6B6F3600' 
	AND s.IsNa = 0 AND
	(@stepId is null OR s.TypeID = @stepId)
GO
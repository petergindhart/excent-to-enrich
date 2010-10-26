 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserProfile_GetRecordsByRoleId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].UserProfile_GetRecordsByRoleId
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserProfile_GetRecordsBySecurityRole]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].UserProfile_GetRecordsBySecurityRole
GO

 /*
<summary>
Gets records from the UserProfile table for the specified ids 
</summary>
<param name="ids">Ids of the SecurityRole's </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.UserProfile_GetRecordsByRoleId 
	@ids uniqueidentifierarray
AS
	SELECT u.RoleID, u.*
	FROM
		UserProfileView u INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON u.RoleID = Keys.Id
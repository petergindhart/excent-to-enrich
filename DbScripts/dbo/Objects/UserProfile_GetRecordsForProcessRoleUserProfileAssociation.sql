
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserProfile_GetRecordsForProcessRoleUserProfileAssociation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UserProfile_GetRecordsForProcessRoleUserProfileAssociation]
GO

 /*
<summary>
Gets records from the UserProfile table for the specified association 
</summary>
<param name="ids">Ids of the ProcessRole(s) </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.UserProfile_GetRecordsForProcessRoleUserProfileAssociation
	@ids uniqueidentifierarray
AS
	SELECT ab.RoleId, a.*
	FROM
		ProcessRoleUserProfile ab INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON ab.RoleId = Keys.Id INNER JOIN
		UserProfileView a ON ab.UserId = a.Id
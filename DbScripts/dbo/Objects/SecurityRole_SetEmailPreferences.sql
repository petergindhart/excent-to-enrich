IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SecurityRole_SetEmailPreferences]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SecurityRole_SetEmailPreferences]
GO

 /*
<summary>
Subscribes all of the users of the specificed security zone to the alert(s)
</summary>
<param name="ids">Ids of the Alerts(s) </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[SecurityRole_SetEmailPreferences]
	@securityRoleID uniqueidentifier,
	@ids			uniqueidentifierarray
AS

-- purge all old preferences from user
DELETE UserProfileAlert
FROM 
	UserProfileAlert ale join	
	UserProfile up on ale.UserProfileID = up.ID
WHERE
	up.RoleID = @securityRoleID	

-- add new preferences
INSERT INTO UserProfileAlert
SELECT
	up.ID,
	alerts.ID
FROM
	UserProfile up cross join
	GetUniqueidentifiers(@ids) alerts
where
	up.RoleID = @securityRoleID	
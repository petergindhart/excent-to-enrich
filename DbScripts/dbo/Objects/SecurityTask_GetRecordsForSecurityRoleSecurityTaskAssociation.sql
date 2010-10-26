

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityTask_GetRecordsForSecurityRoleSecurityTaskAssociation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityTask_GetRecordsForSecurityRoleSecurityTaskAssociation]
GO

 /*
<summary>
Gets records from the SecurityTask table for the specified association 
</summary>
<param name="ids">Ids of the SecurityRole(s) </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[SecurityTask_GetRecordsForSecurityRoleSecurityTaskAssociation]
	@ids uniqueidentifierarray
AS
	SELECT ab.RoleId, a.*
	FROM
		SecurityRoleSecurityTask ab INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON ab.RoleId = Keys.Id INNER JOIN
		SecurityTaskView a ON ab.TaskId = a.Id
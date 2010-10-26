if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProcessTypeStep_GetRecordsByAssignedRoleId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ProcessTypeStep_GetRecordsByAssignedRoleId]
GO

 /*
<summary>
Gets records from the ProcessTypeStep table with the specified ids
</summary>
<param name="ids">Ids of the ProcessTypeRole(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.ProcessTypeStep_GetRecordsByAssignedRoleId
	@ids	uniqueidentifierarray
AS
	SELECT p.AssignedRoleId, p.*
	FROM
		ProcessTypeStep p INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON p.AssignedRoleId = Keys.Id
	ORDER BY [Sequence]
GO

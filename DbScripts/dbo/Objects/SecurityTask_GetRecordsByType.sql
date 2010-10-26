

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityTask_GetRecordsByType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityTask_GetRecordsByType]
GO

 /*
<summary>
Gets records from the SecurityTask table
with the specified ids
</summary>
<param name="ids">Ids of the SecurityTaskType(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[SecurityTask_GetRecordsByType]
	@ids	uniqueidentifierarray
AS
	SELECT
		s.SecurityTaskTypeId,
		s.*
	FROM
		SecurityTaskView s INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON s.SecurityTaskTypeId = Keys.Id
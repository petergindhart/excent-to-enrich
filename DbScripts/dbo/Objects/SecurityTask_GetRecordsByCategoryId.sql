

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityTask_GetRecordsByCategoryId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityTask_GetRecordsByCategoryId]
GO


 /*
<summary>
Gets records from the SecurityTask table for the specified ids 
</summary>
<param name="ids">Ids of the SecurityTaskCategory's </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[SecurityTask_GetRecordsByCategoryId] 
	@ids uniqueidentifierarray
AS
	SELECT s.CategoryID, s.*
	FROM
		SecurityTaskView s INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON s.CategoryID = Keys.Id
	ORDER BY Sequence
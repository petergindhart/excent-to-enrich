

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityTask_GetRecordsByCategory]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityTask_GetRecordsByCategory]
GO


/*
<summary>
Gets records from the SecurityTask table
with the specified ids
</summary>
<param name="ids">Ids of the SecurityTaskCategory(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.SecurityTask_GetRecordsByCategory
	@ids	uniqueidentifierarray
AS
	SELECT
		s.CategoryId,
		s.*
	FROM
		SecurityTaskView s INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON s.CategoryId = Keys.Id
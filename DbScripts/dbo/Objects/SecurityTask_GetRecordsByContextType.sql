

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityTask_GetRecordsByContextType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityTask_GetRecordsByContextType]
GO


 /*
<summary>
Gets records from the SecurityTask table
with the specified ids
</summary>
<param name="ids">Ids of the EnumValue(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[SecurityTask_GetRecordsByContextType]
	@ids	uniqueidentifierarray
AS
	SELECT
		s.ContextTypeId,
		s.*
	FROM
		SecurityTaskView s INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON s.ContextTypeId = Keys.Id
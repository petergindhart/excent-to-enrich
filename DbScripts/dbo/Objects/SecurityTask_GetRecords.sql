

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityTask_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityTask_GetRecords]
GO


 /*
<summary>
Gets records from the SecurityTask table
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.SecurityTask_GetRecords
	@ids	uniqueidentifierarray
AS
	SELECT	
		s.*		
	FROM
		SecurityTaskView s INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON s.Id = Keys.Id
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProcessTypeStep_GetRecordsByProcess]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ProcessTypeStep_GetRecordsByProcess]
GO

 /*
<summary>
Gets records from the ProcessTypeStep table with the specified ids
</summary>
<param name="ids">Ids of the ProcessType(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.ProcessTypeStep_GetRecordsByProcess
	@ids	uniqueidentifierarray
AS
	SELECT p.ProcessId, p.*
	FROM
		ProcessTypeStep p INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON p.ProcessId = Keys.Id
	ORDER BY [Sequence]
GO

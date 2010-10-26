if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProcessStep_GetRecordsByProcess]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ProcessStep_GetRecordsByProcess]
GO

 /*
<summary>
Gets records from the ProcessStep table with the specified ids
</summary>
<param name="ids">Ids of the Process(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.ProcessStep_GetRecordsByProcess
	@ids	uniqueidentifierarray
AS
	SELECT p.ProcessId, p.*
	FROM
		ProcessStep p INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON p.ProcessId = Keys.Id INNER JOIN
		ProcessTypeStep s ON p.TypeID = s.ID
	ORDER BY s.Sequence
GO

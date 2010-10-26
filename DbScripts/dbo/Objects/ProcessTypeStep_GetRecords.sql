if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProcessTypeStep_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ProcessTypeStep_GetRecords]
GO

 /*
<summary>
Gets records from the ProcessTypeStep table with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.ProcessTypeStep_GetRecords
	@ids	uniqueidentifierarray
AS
	SELECT p.*
	FROM
		ProcessTypeStep p INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON p.Id = Keys.Id
	ORDER BY [Sequence]
GO

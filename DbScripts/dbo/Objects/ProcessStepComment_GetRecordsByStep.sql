if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProcessStepComment_GetRecordsByStep]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ProcessStepComment_GetRecordsByStep]
GO

 /*
<summary>
Gets records from the ProcessStepComment table with the specified ids
</summary>
<param name="ids">Ids of the ProcessStep(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.ProcessStepComment_GetRecordsByStep
	@ids	uniqueidentifierarray
AS
	SELECT p.StepId, p.*
	FROM
		ProcessStepComment p INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON p.StepId = Keys.Id
	ORDER BY CreatedDate
GO

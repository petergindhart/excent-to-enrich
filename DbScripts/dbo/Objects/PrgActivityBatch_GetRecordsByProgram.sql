if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgActivityBatch_GetRecordsByProgram]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgActivityBatch_GetRecordsByProgram]
GO

/*
<summary>
Gets records from the PrgActivityBatch table
with the specified ids
</summary>
<param name="ids">Ids of the Program(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgActivityBatch_GetRecordsByProgram]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.ProgramId,
		p.*
	FROM
		PrgActivityBatch p INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.ProgramId = Keys.Id
	ORDER BY 
		CreatedDate DESC
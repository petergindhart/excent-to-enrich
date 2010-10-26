IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgStatus_GetRecordsByProgram]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgStatus_GetRecordsByProgram]
GO

/*
<summary>
Gets records from the PrgStatus table
with the specified ids
</summary>
<param name="ids">Ids of the Program(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgStatus_GetRecordsByProgram]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.ProgramId,
		p.*
	FROM
		PrgStatus p INNER JOIN 
		GetUniqueidentifiers(@ids) Keys ON p.ProgramId = Keys.Id INNER JOIN 
		Program prog on prog.ID = p.ProgramID 
	WHERE 
		p.DeletedDate IS NULL AND 
		prog.DeletedDate IS NULL 
	ORDER BY 
		p.Sequence
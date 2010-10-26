IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormTemplate_GetRecordsByProgram]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormTemplate_GetRecordsByProgram]
GO

 /*
<summary>
Gets records from the FormTemplate table
with the specified ids
</summary>
<param name="ids">Ids of the Program(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormTemplate_GetRecordsByProgram]
	@ids	uniqueidentifierarray
AS
	SELECT
		f.ProgramId,
		f.*
	FROM
		FormTemplate f INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.ProgramId = Keys.Id
	ORDER BY
		f.Name
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItemDef_GetRecordsByProgram]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgItemDef_GetRecordsByProgram]
GO

/*
<summary>
Gets records from the PrgItemDef table
with the specified ids
</summary>
<param name="ids">Ids of the Program(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgItemDef_GetRecordsByProgram]
	@ids	uniqueidentifierarray
AS
	SELECT
		i.ProgramId,
		i.*
	FROM
		PrgItemDef i INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON i.ProgramId = Keys.Id INNER JOIN	
		Program p on p.ID = i.ProgramID LEFT OUTER JOIN 
		PrgStatus s on s.ID = i.StatusID 
	WHERE 
		i.DeletedDate IS NULL AND 
		p.DeletedDate IS NULL AND 
		(s.ID IS NULL OR s.DeletedDate IS NULL) 
	ORDER BY 
		i.Name
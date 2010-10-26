IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgStatus_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgStatus_GetAllRecords]
GO

/*
<summary>
Gets all records from the PrgStatus table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgStatus_GetAllRecords]
AS
	SELECT
		p.*
	FROM
		PrgStatus p INNER JOIN 
		Program prog on prog.ID = p.ProgramID 
	WHERE 
		p.DeletedDate IS NULL AND 
		prog.DeletedDate IS NULL		
	ORDER BY 
		p.Sequence
GO
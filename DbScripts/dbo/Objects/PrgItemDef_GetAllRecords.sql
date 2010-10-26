IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItemDef_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgItemDef_GetAllRecords]
GO

/*
<summary>
Gets all records from the PrgItemDef table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgItemDef_GetAllRecords]
	@includeDeletedItems bit
AS
	SELECT
		i.*
	FROM
		PrgItemDef i INNER JOIN	
		Program p on p.ID = i.ProgramID LEFT OUTER JOIN 
		PrgStatus s on s.ID = i.StatusID 
	WHERE 
		@includeDeletedItems = 1 OR 
		(i.DeletedDate IS NULL AND 
		p.DeletedDate IS NULL AND 
		(s.ID IS NULL OR s.DeletedDate IS NULL)) 
	ORDER BY 
		i.Name
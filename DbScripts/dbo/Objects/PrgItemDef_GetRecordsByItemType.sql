IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItemDef_GetRecordsByItemType]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgItemDef_GetRecordsByItemType]
GO

/*
<summary>
Gets records from the PrgItemDef table
with the specified ids
</summary>
<param name="ids">Ids of the PrgItemType(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgItemDef_GetRecordsByItemType]
	@ids	uniqueidentifierarray
AS
	SELECT
		i.TypeId,
		i.*
	FROM
		PrgItemDef i INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON i.TypeId = Keys.Id INNER JOIN	
		Program p on p.ID = i.ProgramID LEFT OUTER JOIN 
		PrgStatus s on s.ID = i.StatusID 
	WHERE 
		i.DeletedDate IS NULL AND 
		p.DeletedDate IS NULL AND 
		(s.ID IS NULL OR s.DeletedDate IS NULL) 
	ORDER BY 
		(CASE WHEN s.ID IS NULL THEN 0 ELSE s.Sequence END), 
		i.Name
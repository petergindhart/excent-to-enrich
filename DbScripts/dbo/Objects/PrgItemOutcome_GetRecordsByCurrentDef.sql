if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgItemOutcome_GetRecordsByCurrentDef]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgItemOutcome_GetRecordsByCurrentDef]
GO

 /*
<summary>
Gets records from the PrgItemOutcome table
with the specified ids
</summary>
<param name="ids">Ids of the PrgItemDef(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgItemOutcome_GetRecordsByCurrentDef]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.CurrentDefId,
		p.*
	FROM
		PrgItemOutcome p INNER JOIN 
		GetUniqueidentifiers(@ids) Keys ON p.CurrentDefId = Keys.Id INNER JOIN 
		PrgItemDef cd ON cd.ID = p.CurrentDefID LEFT JOIN 
		PrgStatus cs ON cd.StatusID = cs.ID 
	WHERE 
		p.DeletedDate IS NULL AND 
		cs.DeletedDate IS NULL AND 
		cd.DeletedDate IS NULL 
	ORDER BY 
		p.Sequence

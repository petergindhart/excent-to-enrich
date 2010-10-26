if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgActivity_GetRecordsByBatch]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgActivity_GetRecordsByBatch]
GO


/*
<summary>
Gets records from the PrgActivity table
	and inherited data from:PrgItem
with the specified ids
</summary>
<param name="ids">Ids of the PrgActivityBatch(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgActivity_GetRecordsByBatch]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.BatchId,
		ItemTypeId = d.TypeId, 
		p1.*,
		p.*
	FROM
		PrgActivity p INNER JOIN
		PrgItem p1 ON p.ID = p1.ID INNER JOIN
		PrgItemDef d ON d.Id = p1.DefId INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.BatchId = Keys.Id
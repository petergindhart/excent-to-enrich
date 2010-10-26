if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgActivity_GetRecordsByItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgActivity_GetRecordsByItem]
GO

/*
<summary>
Gets records from the PrgActivity table
	and inherited data from:PrgItem
with the specified ids
</summary>
<param name="ids">Ids of the PrgItem(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgActivity_GetRecordsByItem]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.ItemId,
		p1.*,
		p.*
	FROM
		PrgActivity p INNER JOIN
		PrgItemView p1 ON p.ID = p1.ID INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.ItemId = Keys.Id
	ORDER BY 
		StartDate DESC
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgActivity_GetRecordsByParentTool]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgActivity_GetRecordsByParentTool]
GO


/*
<summary>
Gets records from the PrgActivity table
	and inherited data from:PrgItem
with the specified ids
</summary>
<param name="ids">Ids of the IntvTool(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgActivity_GetRecordsByParentTool]
	@ids	uniqueidentifierarray
AS
	SELECT
		a.ParentToolId,
		i.*,
		a.*, 
		ItemTypeId = d.TypeID 
	FROM
		PrgActivity a INNER JOIN
		PrgItem i ON a.ID = i.ID INNER JOIN 
		PrgItemDef d ON i.DefID = d.ID INNER JOIN 
		GetUniqueidentifiers(@ids) Keys ON a.ParentToolId = Keys.Id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


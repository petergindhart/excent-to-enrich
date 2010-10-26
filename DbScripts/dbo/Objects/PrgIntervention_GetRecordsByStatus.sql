SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgIntervention_GetRecordsByStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgIntervention_GetRecordsByStatus]
GO


/*
<summary>
Gets records from the PrgIntervention table
with the specified ids
</summary>
<param name="ids">Ids of the Status(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgIntervention_GetRecordsByStatus]
	@ids	uniqueidentifierarray
AS
	SELECT
		def.StatusId,
		item.*, 
		intv.*,
		ItemTypeId = def.TypeID 
	FROM
		PrgIntervention intv INNER JOIN 
		PrgItem item on intv.ID = item.ID INNER JOIN 
		PrgItemDef def on def.ID = item.DefID INNER JOIN 
		GetUniqueidentifiers(@ids) Keys ON def.StatusId = Keys.Id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


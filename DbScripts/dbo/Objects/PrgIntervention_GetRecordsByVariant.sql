SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgIntervention_GetRecordsByVariant]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgIntervention_GetRecordsByVariant]
GO


/*
<summary>
Gets records from the PrgIntervention table
with the specified ids
</summary>
<param name="ids">Ids of the Variant(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgIntervention_GetRecordsByVariant]
	@ids	uniqueidentifierarray
AS
	SELECT
		inv.VariantID, 
		item.*, 
		intv.*
	FROM
		PrgIntervention intv INNER JOIN 
		PrgItemView item on intv.ID = item.ID JOIN 
		PrgInvolvement inv ON inv.ID = item.InvolvementID INNER JOIN 
		GetUniqueidentifiers(@ids) Keys ON inv.VariantId = Keys.Id 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


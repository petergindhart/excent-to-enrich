SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgSimplePlan_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgSimplePlan_GetRecords]
GO

 /*
<summary>
Gets records from the PrgSimplePlan table
	and inherited data from:PrgItem
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="True" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.PrgSimplePlan_GetRecords
	@ids	uniqueidentifierarray
AS
	SELECT	
		ItemTypeId = d.TypeID, 
		p1.*,
		p.*		
	FROM
		PrgSimplePlan p INNER JOIN
		PrgItem p1 ON p.ID = p1.ID INNER JOIN
		PrgItemDef d on d.ID = p1.DefID INNER JOIN 
		GetUniqueidentifiers(@ids) Keys ON p.Id = Keys.Id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


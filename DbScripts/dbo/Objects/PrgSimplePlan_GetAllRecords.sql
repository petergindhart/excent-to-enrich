SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgSimplePlan_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgSimplePlan_GetAllRecords]
GO

 /*
<summary>
Gets all records from the PrgSimplePlan table
	and inherited data from:PrgItem
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="True" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.PrgSimplePlan_GetAllRecords
AS
	SELECT
		ItemTypeId = d.TypeID, 
		p1.*,
		p.*
	FROM
		PrgSimplePlan p INNER JOIN 
		PrgItem i on p.ID = i.ID INNER JOIN 
		PrgItemDef d on d.ID = i.DefID INNER JOIN 
		PrgItem p1 ON p.ID = p1.ID
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


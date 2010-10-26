SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgIntervention_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgIntervention_GetRecords]
GO

 /*
<summary>
Gets records from the PrgIntervention table
	and inherited data from:PrgItem
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.PrgIntervention_GetRecords
	@ids	uniqueidentifierarray
AS
	SELECT	
		p1.*,
		p.*
	FROM
		PrgIntervention p INNER JOIN
		PrgItemView p1 ON p.ID = p1.ID JOIN
		GetUniqueidentifiers(@ids) Keys ON p.Id = Keys.Id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


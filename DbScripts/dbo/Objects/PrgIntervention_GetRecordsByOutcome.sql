SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgIntervention_GetRecordsByOutcome]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgIntervention_GetRecordsByOutcome]
GO


/*
<summary>
Gets records from the PrgIntervention table
with the specified ids
</summary>
<param name="ids">Ids of the Outcome(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgIntervention_GetRecordsByOutcome]
	@ids	uniqueidentifierarray
AS
	SELECT
		item.ItemOutcomeID,
		item.*, 
		intv.*
	FROM
		PrgIntervention intv INNER JOIN 
		PrgItemView item on intv.ID = item.ID JOIN
		GetUniqueidentifiers(@ids) Keys ON item.ItemOutcomeID = Keys.Id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


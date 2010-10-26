SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgActivity_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgActivity_GetRecords]
GO


/*
<summary>
Gets records from the PrgActivity table
	and inherited data from:PrgItem
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgActivity_GetRecords]
	@ids	uniqueidentifierarray
AS
	SELECT	
		i.*,
		a.*
	FROM
		PrgActivity a INNER JOIN
		PrgItemView i ON a.ID = i.ID INNER JOIN 
		GetUniqueidentifiers(@ids) Keys ON a.Id = Keys.Id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


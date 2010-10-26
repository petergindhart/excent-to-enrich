SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgItem_GetRecordsByEndStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgItem_GetRecordsByEndStatus]
GO

 /*
<summary>
Gets records from the PrgItem table
with the specified ids
</summary>
<param name="ids">Ids of the PrgStatus(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.PrgItem_GetRecordsByEndStatus
	@ids	uniqueidentifierarray
AS
	SELECT
		p.EndStatusId,
		p.*
	FROM
		PrgItemView p INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.EndStatusId = Keys.Id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


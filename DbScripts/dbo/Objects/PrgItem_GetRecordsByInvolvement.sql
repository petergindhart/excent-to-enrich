SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgItem_GetRecordsByInvolvement]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgItem_GetRecordsByInvolvement]
GO

 /*
<summary>
Gets records from the PrgItem table
with the specified ids
</summary>
<param name="ids">Ids of the PrgInvolvement(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.PrgItem_GetRecordsByInvolvement
	@ids	uniqueidentifierarray
AS
	SELECT
		p.InvolvementId,
		p.*
	FROM
		PrgItemView p INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.InvolvementId = Keys.Id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


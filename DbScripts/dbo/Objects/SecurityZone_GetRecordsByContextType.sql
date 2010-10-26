SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityZone_GetRecordsByContextType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityZone_GetRecordsByContextType]
GO

 /*
<summary>
Gets records from the SecurityZone table with the specified ids
</summary>
<param name="ids">Ids of the EnumValue(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
*/
CREATE PROCEDURE dbo.SecurityZone_GetRecordsByContextType
	@ids	uniqueidentifierarray
AS
	SELECT s.ContextTypeId, s.*
	FROM
		SecurityZone s INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON s.ContextTypeId = Keys.Id
	ORDER BY s.Sequence
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgVersion_GetRecordsByItem]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgVersion_GetRecordsByItem]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgVersion_GetRecordsByItem]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
<summary>
Gets records from the PrgVersion table
with the specified ids
</summary>
<param name="ids">Ids of the PrgItem(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgVersion_GetRecordsByItem]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.ItemId,
		p.*
	FROM
		PrgVersion p INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.ItemId = Keys.Id
	ORDER BY
		p.DateCreated desc
' 
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgSection_GetRecordsByItem]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgSection_GetRecordsByItem]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
<summary>
Gets records from the PrgSection table
with the specified ids
</summary>
<param name="ids">Ids of the PrgItem(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgSection_GetRecordsByItem]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.ItemId,
		p.*,
		d.TypeID [SectionTypeID]
	FROM
		PrgSection p join
		PrgSectionDef d on p.DefID = d.ID INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.ItemId = Keys.Id
	ORDER BY
		d.Sequence

GO

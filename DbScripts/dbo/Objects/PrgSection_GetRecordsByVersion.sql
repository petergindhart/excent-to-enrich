IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgSection_GetRecordsByVersion]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgSection_GetRecordsByVersion]
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
<param name="ids">Ids of the PrgVersion(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgSection_GetRecordsByVersion]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.VersionId,
		p.*,
		d.TypeID [SectionTypeID]
	FROM
		PrgSection p join
		PrgSectionDef d on p.DefID = d.ID INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.VersionId = Keys.Id
	ORDER BY
		d.Sequence

GO

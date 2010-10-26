IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgSection_GetRecordsBySectionDef]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgSection_GetRecordsBySectionDef]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgSection_GetRecordsBySectionDef]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
<summary>
Gets records from the PrgSection table
with the specified ids
</summary>
<param name="ids">Ids of the PrgSectionDef(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgSection_GetRecordsBySectionDef]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.DefId,
		p.*,
		d.TypeID [SectionTypeID]
	FROM
		PrgSection p join
		PrgSectionDef d on p.DefID = d.ID INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.DefId = Keys.Id
' 
END
GO

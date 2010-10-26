IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgSection_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgSection_GetRecords]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgSection_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
<summary>
Gets records from the PrgSection table
with the specified id''s
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgSection_GetRecords]
	@ids	uniqueidentifierarray
AS
	SELECT	
		p.*,
		d.TypeID [SectionTypeID]		
	FROM
		PrgSection p join
		PrgSectionDef d on p.DefID = d.ID INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON p.Id = Keys.Id
' 
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgIep_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgIep_GetAllRecords]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgIep_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
<summary>
Gets all records from the PrgIep table
	and inherited data from:PrgItem
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgIep_GetAllRecords]
AS
	SELECT
		p1.*,
		p.*,
		ItemTypeId = d.TypeID
	FROM
		PrgIep p INNER JOIN
		PrgItem p1 ON p.ID = p1.ID JOIN
		PrgItemDef d on d.ID = p1.DefID
' 
END
GO

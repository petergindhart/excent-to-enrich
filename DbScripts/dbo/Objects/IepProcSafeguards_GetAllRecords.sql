IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProcSafeguards_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProcSafeguards_GetAllRecords]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 /*
<summary>
Gets all records from the IepProcSafeguards table
	and inherited data from:PrgSection
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[IepProcSafeguards_GetAllRecords]
AS
	SELECT
		i1.*,
		i.*,
		d.TypeID [SectionTypeID]
	FROM
		IepProcSafeguards i INNER JOIN
		PrgSection i1 ON i.ID = i1.ID join
		PrgSectionDef d on i1.DefID = d.ID
GO



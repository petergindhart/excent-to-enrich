IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgGoals_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgGoals_GetAllRecords]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 /*
<summary>
Gets all records from the PrgGoals table
	and inherited data from:PrgSection
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgGoals_GetAllRecords]
AS
	SELECT
		p1.*,
		p.*,
		d.TypeID [SectionTypeID]
	FROM
		PrgGoals p INNER JOIN
		PrgSection p1 ON p.ID = p1.ID join
		PrgSectionDef d on p1.DefID = d.ID
GO



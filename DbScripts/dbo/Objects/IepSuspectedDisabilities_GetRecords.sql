IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepSuspectedDisabilities_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepSuspectedDisabilities_GetRecords]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 /*
<summary>
Gets records from the IepSuspectedDisabilities table
	and inherited data from:PrgSection
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[IepSuspectedDisabilities_GetRecords]
	@ids	uniqueidentifierarray
AS
	SELECT	
		i1.*,
		i.*,
		d.TypeID [SectionTypeID]		
	FROM
		IepSuspectedDisabilities i INNER JOIN
		PrgSection i1 ON i.ID = i1.ID join
		PrgSectionDef d on i1.DefID = d.ID INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON i.Id = Keys.Id
GO



IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoals_GetRecordsByReportFrequency]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoals_GetRecordsByReportFrequency]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoals_GetRecordsByReportFrequency]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
 /*
<summary>
Gets records from the IepGoals table
	and inherited data from:PrgSection
with the specified ids
</summary>
<param name="ids">Ids of the IepProgRptFreq(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[IepGoals_GetRecordsByReportFrequency]
	@ids	uniqueidentifierarray
AS
	SELECT
		i.ReportFrequencyId,
		i1.*,
		i.*,
		d.TypeID [SectionTypeID]
	FROM
		IepGoals i INNER JOIN
		PrgSection i1 ON i.ID = i1.ID join
		PrgSectionDef d on i1.DefID = d.ID INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON i.ReportFrequencyId = Keys.Id
' 
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepPostSchoolConsiderations_GetRecordsByProjectedGradType]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepPostSchoolConsiderations_GetRecordsByProjectedGradType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepPostSchoolConsiderations_GetRecordsByProjectedGradType]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
<summary>
Gets records from the IepPostSchoolConsiderations table
	and inherited data from:PrgSection
with the specified ids
</summary>
<param name="ids">Ids of the IepGraduationType(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[IepPostSchoolConsiderations_GetRecordsByProjectedGradType]
	@ids	uniqueidentifierarray
AS
	SELECT
		i.ProjectedGradTypeId,
		i1.*,
		i.*,
		d.TypeID [SectionTypeID]
	FROM
		IepPostSchoolConsiderations i INNER JOIN
		PrgSection i1 ON i.ID = i1.ID join
		PrgSectionDef d on i1.DefID = d.ID INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON i.ProjectedGradTypeId = Keys.Id
' 
END
GO

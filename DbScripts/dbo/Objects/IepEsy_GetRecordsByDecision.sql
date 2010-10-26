IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepEsy_GetRecordsByDecision]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepEsy_GetRecordsByDecision]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepEsy_GetRecordsByDecision]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
<summary>
Gets records from the IepEsy table
	and inherited data from:PrgSection
with the specified ids
</summary>
<param name="ids">Ids of the EnumValue(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[IepEsy_GetRecordsByDecision]
	@ids	uniqueidentifierarray
AS
	SELECT
		i.DecisionId,
		i1.*,
		i.*,
		d.TypeID [SectionTypeID]		
	FROM
		IepEsy i INNER JOIN
		PrgSection i1 ON i.ID = i1.ID join
		PrgSectionDef d on i1.DefID = d.ID INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON i.DecisionId = Keys.Id
' 
END
GO

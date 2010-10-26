
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GradeGoal_GetRecordsByGradeLevelId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GradeGoal_GetRecordsByGradeLevelId]
GO


/*
<summary>
Gets records from the GradeGoal table for the specified ids 
</summary>
<param name="ids">Ids of the GradeLevel's </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.GradeGoal_GetRecordsByGradeLevelId 
	@ids uniqueidentifierarray
AS
	SELECT g.GradeLevelID, g.*
	FROM
		GradeGoal g INNER JOIN
		Subject s on g.SubjectID = s.ID JOIN
		GetUniqueidentifiers(@ids) AS Keys ON g.GradeLevelID = Keys.Id
	ORDER BY
		s.Name

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


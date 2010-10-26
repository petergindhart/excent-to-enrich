IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentGuardian_GetRecordsByStudent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentGuardian_GetRecordsByStudent]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 /*
<summary>
Gets records from the StudentGuardian table
with the specified ids
</summary>
<param name="ids">Ids of the Student(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[StudentGuardian_GetRecordsByStudent]
	@ids	uniqueidentifierarray
AS
	SELECT
		s.StudentId,
		s.*
	FROM
		StudentGuardian s INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON s.StudentId = Keys.Id
	ORDER BY
		s.Sequence
GO




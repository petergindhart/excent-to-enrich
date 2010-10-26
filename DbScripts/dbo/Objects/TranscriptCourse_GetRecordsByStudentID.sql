SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TranscriptCourse_GetRecordsByStudentID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TranscriptCourse_GetRecordsByStudentID]
GO


/*
<summary>
Gets records from the TranscriptCourse table for the specified StudentIDs 
</summary>
<param name="ids">Ids of the Student's </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.TranscriptCourse_GetRecordsByStudentID 
	@ids uniqueidentifierarray
AS
	SELECT t.StudentID, t.*
	FROM
		TranscriptCourse t INNER JOIN
		GetIds(@ids) AS Keys ON t.StudentID = Keys.Id
		LEFT JOIN RosterYear r ON t.RosterYearID = r.ID
	ORDER BY r.StartYear DESC, t.Name
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


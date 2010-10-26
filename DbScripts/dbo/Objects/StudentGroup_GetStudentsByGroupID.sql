SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StudentGroup_GetStudentsByGroupID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[StudentGroup_GetStudentsByGroupID]
GO



/*
<summary>
Gets all students that belong to a specific StudentGroup based on the groups id.
</summary>
<param name="groupID">The Guid value of the Student Group.</param>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.StudentGroup_GetStudentsByGroupID
	@groupID uniqueidentifierarray 
AS

/*
DECLARE @rosterYearID as uniqueidentifier
SET @rosterYearID = '6A550A28-7FCE-4622-857F-057C4282B55A'
*/

SELECT StudentGroupStudentView.GroupID, Student.* 
	FROM StudentGroupStudentView INNER JOIN Student ON StudentGroupStudentView.StudentID = Student.[ID]  
	INNER JOIN GetIds(@groupid) g ON StudentGroupStudentView.GroupID = g.[ID]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


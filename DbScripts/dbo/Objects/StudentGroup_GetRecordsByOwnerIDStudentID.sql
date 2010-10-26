SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StudentGroup_GetRecordsByOwnerIDStudentID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[StudentGroup_GetRecordsByOwnerIDStudentID]
GO


/*
<summary>
Gets records from the StudentGroup table for the specified OwnerID and StudentID
</summary>
<param name="owner">Id of the UserProfile's </param>
<param name="student">Id of the Student's </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.StudentGroup_GetRecordsByOwnerIDStudentID 
	@owner uniqueidentifier,
	@student uniqueidentifier
AS
SELECT StudentGroup.*
FROM  
	StudentGroup INNER JOIN
               StudentGroupStudentView ON StudentGroup.ID = StudentGroupStudentView.GroupID
WHERE 
	(StudentGroup.OwnerID = @owner) AND 
               (StudentGroupStudentView.StudentID = @student)
ORDER BY NAME
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


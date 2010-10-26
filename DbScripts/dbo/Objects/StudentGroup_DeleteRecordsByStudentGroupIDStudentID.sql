SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StudentGroup_DeleteRecordsByStudentGroupIDStudentID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[StudentGroup_DeleteRecordsByStudentGroupIDStudentID]
GO

/*
<summary>
Deletes a StudentGroupStudent record
</summary>
<param name="studentGroup">Owner Id of the record to delete</param>
<param name="ids">Student Ids of the record to delete</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.StudentGroup_DeleteRecordsByStudentGroupIDStudentID 
	@studentGroup uniqueidentifier,
	@ids uniqueidentifierarray
AS
	DELETE StudentGroupStudent
	FROM 
		StudentGroupStudent
	 	sgs INNER JOIN
		GetIds(@ids) AS Keys ON sgs.StudentID = Keys.Id
	WHERE sgs.StudentGroupID = @studentGroup
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


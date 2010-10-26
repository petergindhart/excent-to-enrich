SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StudentGroup_InsertRecordsByStudentGroupIDStudentID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[StudentGroup_InsertRecordsByStudentGroupIDStudentID]
GO

/*
<summary>
Inserts a StudentGroupStudent record
</summary>
<param name="studentGroup">Owner Id of the record to delete</param>
<param name="ids">Student Ids of the record to delete</param>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.StudentGroup_InsertRecordsByStudentGroupIDStudentID 
	@studentGroup uniqueidentifier,
	@ids uniqueidentifierarray
AS
	INSERT StudentGroupStudent
	SELECT @studentGroup as StudentGroupID,  Keys.Id as StudentID
	FROM  GetIds(@ids) AS Keys
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


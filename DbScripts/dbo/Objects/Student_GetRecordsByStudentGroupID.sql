SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Student_GetRecordsByStudentGroupID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Student_GetRecordsByStudentGroupID]
GO


/*
<summary>
Retrieves all students for the given studentgroup.
</summary>
<param name="ids">Idenifies the studentgroup to retrieve the students for</param>
<returns>Students belonging to the studentgroup.</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/

CREATE PROCEDURE dbo.Student_GetRecordsByStudentGroupID
	@ids uniqueidentifierarray
AS


SELECT sgs.StudentGroupID, s.*
FROM  
	StudentGroupStudent sgs  INNER JOIN
	GetIds(@ids) AS Keys ON sgs.StudentGroupID = Keys.Id INNER JOIN
               Student s ON sgs.StudentID = s.ID 
ORDER BY
	LastName, FirstName
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


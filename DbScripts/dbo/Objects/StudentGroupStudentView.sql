SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StudentGroupStudentView]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[StudentGroupStudentView]
GO

CREATE VIEW [dbo].[StudentGroupStudentView] 
AS 

SELECT 
	StudentGroup.[ID] As GroupID, 
	StudentGroupStudent.StudentID 
FROM 
	StudentGroup JOIN 
	StudentGroupStudent ON StudentGroup.[ID] = StudentGroupStudent.StudentGroupID 
UNION ALL
SELECT 
	ID as GroupID, TeacherID 
FROM 
	AcademicPlanStudentGroupView
UNION ALL
SELECT 
	GroupID, StudentID
FROM 
	RtiStudentGroupView
UNION ALL
SELECT 
	GroupID, StudentID
FROM 
	NonRtiProgramStudentGroupView
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AcademicPlanStudentGroupView]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[AcademicPlanStudentGroupView]
GO

/* Have to ALTER  this view seperately.
 The union combined with the function is causing
 error "Could not find database ID 102" which
 appears to be a SQL Server bug

*/
CREATE VIEW dbo.AcademicPlanStudentGroupView
AS
SELECT DISTINCT dbo.StudentTeacher.TeacherID, dbo.Student.ID
FROM         dbo.AcademicPlan INNER JOIN
                      dbo.Student ON dbo.AcademicPlan.StudentID = dbo.Student.ID INNER JOIN
                      dbo.StudentTeacher ON dbo.Student.ID = dbo.StudentTeacher.StudentID INNER JOIN
                      dbo.RosterYear ON dbo.AcademicPlan.RosterYearID = dbo.RosterYear.ID AND dbo.DateInRange(GETDATE(), dbo.RosterYear.StartDate, 
                      dbo.RosterYear.EndDate) = 1
WHERE     (dbo.StudentTeacher.CurrentClassCount > 0)


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


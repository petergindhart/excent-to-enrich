

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Transform_StudentTeacher]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[Transform_StudentTeacher]
GO
/*
Gets the active association between student and teacher for the current roster year.
Used to create a denormalized table to enhance reporting performance.
*/
create  view [dbo].[Transform_StudentTeacher]
as
select     
	TeacherId			= t.ID, 
	StudentID			= s.ID, 
	CurrentClassCount	= sum(
								case when dbo.DateInRange(getDate(),  crth.StartDate,  crth.EndDate) = 1 AND
										dbo.DateInRange(getDate(),  scrh.StartDate,  scrh.EndDate) = 1
then 1 else 0 end)
from         
	Teacher t join
	ClassRosterTeacherHistory crth on t.ID = crth.TeacherID join
	ClassRoster cr ON crth.ClassRosterID = cr.ID join
	RosterYear ry on cr.RosterYearID = ry.ID join
	StudentClassRosterHistory scrh on cr.ID = scrh.ClassRosterID join
	Student s on scrh.StudentID = s.ID
where
	dbo.DateInRange(getdate() , ry.StartDate, ry.EndDate) = 1
group by 
	t.ID, 
	s.ID
having
	sum( case when dbo.DateInRange(getDate(),  crth.StartDate,  crth.EndDate) = 1 AND
			dbo.DateInRange(getDate(),  scrh.StartDate,  scrh.EndDate) = 1 then 1 else 0 end) > 0


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Transform_StudentTeacherClassRoster]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[Transform_StudentTeacherClassRoster]

GO

-- Create view to speed up reports
create view dbo.Transform_StudentTeacherClassRoster
as
select 
	scrh.StudentID, 
	crth.TeacherID, 
	cr.SchoolID, 
	cr.RosterYearID, 
	ClassRosterID 		= cr.ID
from
	StudentClassRosterHistory scrh join
	ClassRoster cr on cr.ID = scrh.ClassRosterID join
	ClassRosterTeacherHistory crth on crth.ClassRosterID = cr.ID

GO

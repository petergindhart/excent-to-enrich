if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'RecalculateStudentSchoolAllStudents')
drop proc LEGACYSPED.RecalculateStudentSchoolAllStudents 
go

create proc LEGACYSPED.RecalculateStudentSchoolAllStudents 
as
begin
delete StudentSchool

insert StudentSchool ( StudentID, SchoolID, RosterYearID, IsCurrent )
select t.StudentID, t.SchoolID, t.RosterYearID, t.IsCurrent
from Transform_StudentSchool t
end

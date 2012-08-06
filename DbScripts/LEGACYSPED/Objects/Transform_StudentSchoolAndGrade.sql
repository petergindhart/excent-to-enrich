IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_StudentSchoolAndGrade') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_StudentSchoolAndGrade
GO

create view LEGACYSPED.Transform_StudentSchoolAndGrade
as
 select 
  StudentID = s.DestID, 
  GradeLevelID = s.CurrentGradeLevelID, 
  SchoolID = s.CurrentSchoolID, 
  RosterYearID = ry.ID, 
  ry.StartDate, 
  EndDate = cast(NULL as datetime),
  SchoolHistoryExists = case when ssh.StudentID is not null then 1 else 0 end,
  GradeLevelHistoryExists = case when sgh.StudentID is not null then 1 else 0 end,
  s.ManuallyEntered
 from LEGACYSPED.Transform_Student s cross join 
 (select ry.ID, ry.StartDate from RosterYear ry where dbo.DateInRange(getdate(), ry.StartDate, ry.EndDate) = 1) ry left join 
 StudentSchoolHistory ssh on
	s.DestID = ssh.StudentID and
	s.CurrentSchoolID = ssh.SchoolID and
	ssh.EndDate is null left join
 StudentGradeLevelHistory sgh on
	s.DestID = sgh.StudentID and
	s.CurrentGradeLevelID = sgh.GradeLevelID and
	sgh.EndDate is null
-- where s.ManuallyEntered = 1
go

--select * from StudentSchoolHistory where StudentID = '22CBCDC9-27C3-49F3-9D03-7612CF3431A8'
--select * from StudentGradeLevelHistory where StudentID = '22CBCDC9-27C3-49F3-9D03-7612CF3431A8'

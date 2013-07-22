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
 from LEGACYSPED.MAP_StudentRefID sm join
 LEGACYSPED.Transform_Student s on sm.StudentRefID = s.StudentRefID  and s.CurrentSchoolID is not null cross join -- change this to LEGACYSPED.MAP_StudentRefID ONLY 
	(select ry.ID, ry.StartDate from RosterYear ry where dbo.DateInRange(dateadd(yy, -1, getdate()), ry.StartDate, ry.EndDate) = 1) ry left join
 StudentSchoolHistory ssh on
	s.DestID = ssh.StudentID and
	s.CurrentSchoolID = ssh.SchoolID and
	ssh.EndDate is null left join
 StudentGradeLevelHistory sgh on
	s.DestID = sgh.StudentID and
	s.CurrentGradeLevelID = sgh.GradeLevelID and
	sgh.EndDate is null
where s.ManuallyEntered = 1 and s.CurrentSchoolID is not null
go


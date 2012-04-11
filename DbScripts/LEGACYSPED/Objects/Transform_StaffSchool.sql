IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_StaffSchool') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_StaffSchool
GO

CREATE VIEW LEGACYSPED.Transform_StaffSchool
as
 SELECT
  TeacherID = ISNULL(e.ID,i.ID), 
  SchoolID =  ISNULL(ts.DestID,S.ID)
 
 FROM LEGACYSPED.StaffSchool ls  JOIN
 dbo.Teacher e ON ls.StaffEmail = e.EmailAddress JOIN
 LEGACYSPED.Transform_School ts ON ls.SchoolCode = ts.SchoolCode LEFT JOIN 
 dbo.School s ON ls.SchoolCode = s.Number LEFT JOIN
 dbo.UserProfileSchool ups ON ts.DestID = ups.SchoolID  LEFT JOIN
 dbo.Teacher i ON i.ID = ups.UserProfileID
GO
-- select * from LegacySped.StaffSchool_Local
-- Select * from Teacher
-- Select * from dbo.UserProfileSchool
-- select * from School
-- Select * from LegacySped.Transform_School

USE EO_SC
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.TeamMember_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.TeamMember_EO
GO

CREATE VIEW dbo.TeamMember_EO
AS
SELECT  Line_No=Row_Number() OVER (ORDER BY (SELECT 1)),Sta.Email as StaffEmail,stu.StudentID as StudentRefID, IsCaseManager =  case mem.CaseMgr when  1 then 'Y' when  0 then 'N' ELSE '' END
FROM AccessMembers mem 
JOIN dbo.Student stu ON mem.GStudentID = stu.GStudentID
JOIN dbo.Staff sta ON sta.StaffGID = mem.StaffGID
WHERE stu.Deletedate is null


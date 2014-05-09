IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vw_TeamMember') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.vw_TeamMember
GO

CREATE VIEW dbo.vw_TeamMember
AS
SELECT  
--Line_No=Row_Number() OVER (ORDER BY (SELECT 1)),
Sta.Email as StaffEmail,stu.GStudentID as StudentRefID, IsCaseManager =  case mem.CaseMgr when  1 then 'Y' when  0 then 'N' ELSE '' END
FROM AccessMembers mem 
JOIN dbo.Student stu ON mem.GStudentID = stu.GStudentID
JOIN dbo.Staff sta ON sta.StaffGID = mem.StaffGID
WHERE stu.Deletedate is null

GO

IF  EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.TeamMember_src') AND type in (N'U'))
DROP TABLE dbo.TeamMember_src
GO

SELECT  
Line_No = IDENTITY(INT,1,1),
StaffEmail
,StudentRefID
,IsCaseManager
INTO dbo.TeamMember_src
FROM dbo.vw_TeamMember

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.TeamMember_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.TeamMember_EO
GO

CREATE VIEW dbo.TeamMember_EO
AS
SELECT  
Line_No,
StaffEmail
,StudentRefID
,IsCaseManager
FROM dbo.TeamMember_src
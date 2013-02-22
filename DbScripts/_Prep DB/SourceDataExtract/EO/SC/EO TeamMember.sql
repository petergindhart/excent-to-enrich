set nocount on;

SELECT  Sta.Email,stu.StudentID, mem.CaseMgr
FROM AccessMembers mem 
JOIN Student stu ON mem.GStudentID = stu.GStudentID
JOIN Staff sta ON sta.StaffGID = mem.StaffGID
WHERE stu.Deletedate is null
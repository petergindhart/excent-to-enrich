IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentUserProfile]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[StudentUserProfile]
GO

CREATE VIEW StudentUserProfile
AS

SELECT 
	StudentID,
	TeacherID,
	tch.UserProfileID
FROM
	StudentTeacher stcr join
	Teacher tch on stcr.TeacherID = tch.ID
where
	tch.UserProfileID is not null
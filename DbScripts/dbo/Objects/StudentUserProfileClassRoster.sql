IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentUserProfileClassRoster]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[StudentUserProfileClassRoster]
GO

CREATE VIEW StudentUserProfileClassRoster
AS

SELECT 
	StudentID,
	TeacherID,
	tch.UserProfileID,
	SchoolID,
	RosterYearID,
	ClassRosterID
FROM
	StudentTeacherClassRoster stcr join
	Teacher tch on stcr.TeacherID = tch.ID
where
	tch.UserProfileID is not null
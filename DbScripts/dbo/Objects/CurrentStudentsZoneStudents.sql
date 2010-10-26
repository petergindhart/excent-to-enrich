if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CurrentStudentsZoneStudents]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[CurrentStudentsZoneStudents]
GO

CREATE FUNCTION [dbo].[CurrentStudentsZoneStudents](@userProfileId UNIQUEIDENTIFIER, @now DATETIME)
	RETURNS TABLE
AS RETURN
(
	-- search active student/teacher assocation
	SELECT StudentID
	FROM 
		StudentTeacher	st JOIN 
		Teacher t on t.ID = st.TeacherID 
	WHERE 
		t.UserProfileID = @userProfileId AND
		CurrentClassCount > 0
	
		union 
	
	-- search active interventions (TODO: should this be plans?)
	SELECT i.StudentID
	FROM PrgItem i JOIN 
		PrgIntervention intv ON intv.ID = i.ID JOIN 
		PrgItemTeamMember t on t.ItemID = i.ID
	WHERE @userProfileid = t.PersonID and
		dbo.DateInRange(@now, i.StartDate, i.EndedDate) = 1
	GROUP BY i.StudentID
)
GO

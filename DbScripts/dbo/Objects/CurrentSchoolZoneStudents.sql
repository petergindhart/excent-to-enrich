if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CurrentSchoolZoneStudents]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[CurrentSchoolZoneStudents]
GO

CREATE FUNCTION [dbo].[CurrentSchoolZoneStudents](@userProfileID UNIQUEIDENTIFIER, @now DATETIME)
RETURNS TABLE
AS RETURN
(
	SELECT s.ID AS StudentID
	FROM	
		Student s JOIN 
		UserProfile u ON s.CurrentSchoolID = u.SchoolID
	WHERE 
		u.ID = @userProfileID
)
GO

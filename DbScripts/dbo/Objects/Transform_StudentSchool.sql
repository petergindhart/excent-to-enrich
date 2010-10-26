-- =============================================
-- Create view basic template
-- =============================================
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'Transform_StudentSchool')
    DROP VIEW dbo.Transform_StudentSchool
GO

CREATE VIEW dbo.Transform_StudentSchool
AS 

SELECT
	distinct h.StudentID, h.SchoolID, RosterYearID = ry.Id
FROM
	StudentSchoolHistory h join
	RosterYear ry on dbo.DateRangesOverlap(h.StartDate, h.EndDate, ry.StartDate, ry.EndDate, getdate())=1

GO


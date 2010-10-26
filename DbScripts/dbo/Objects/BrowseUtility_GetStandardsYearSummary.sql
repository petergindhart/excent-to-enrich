IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[BrowseUtility_GetStandardsYearSummary]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[BrowseUtility_GetStandardsYearSummary]
GO

CREATE PROCEDURE [dbo].[BrowseUtility_GetStandardsYearSummary]
	@schoolId uniqueidentifier
AS
	select 
		stuForm.RosterYearID,
		SchoolID,
		count(*) AS RecCount,
		ry.StartYear
	From 
		StudentForm stuForm join
		StudentSchool ss on stuForm.StudentID = ss.StudentID and stuForm.RosterYearId =  ss.RosterYearID join
		RosterYear ry on stuForm.RosterYearId = ry.Id
	where
		SchoolID = @schoolId
	group by
		stuForm.RosterYearID,
		SchoolID,
		ry.StartYear
	order by		
		ry.StartYear desc
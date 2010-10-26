SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BrowseUtility_GetTeacherYearSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[BrowseUtility_GetTeacherYearSummary]
GO


CREATE PROCEDURE dbo.BrowseUtility_GetTeacherYearSummary
	@schoolId uniqueidentifier
AS

select
	StartYear, RosterYearID, count(*) NumTeachers
from
	(
		select
			y.StartYear, c.RosterYearID, crth.TeacherID
		from
			RosterYear y join
			ClassRoster c on c.RosterYearID = y.ID join
			ClassRosterTeacherHistory crth on crth.ClassRosterID = c.ID join
			(
			-- last days taught
			select
				ClassRosterID, MAX(EndDate) [EndDate]
			from
				(
					select
						c.ID [ClassRosterID], isnull(crth.EndDate, y.EndDate) [EndDate]
					from
						ClassRosterTeacherHistory crth join
						ClassRoster c on crth.ClassRosterID = c.ID join
						RosterYear y on c.RosterYearID = y.ID
					where
						c.SchoolID = @schoolId
				) M
			group by ClassRosterID
			) M on 
				M.ClassRosterID = c.ID and
				M.EndDate = isnull(crth.EndDate, y.EndDate)
		group by y.StartYear, c.RosterYearID, crth.TeacherID
	) T
group by
	StartYear, RosterYearID



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


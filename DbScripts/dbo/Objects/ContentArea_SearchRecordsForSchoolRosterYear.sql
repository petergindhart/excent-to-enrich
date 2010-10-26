SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ContentArea_SearchRecordsForSchoolRosterYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ContentArea_SearchRecordsForSchoolRosterYear]
GO

CREATE PROCEDURE dbo.ContentArea_SearchRecordsForSchoolRosterYear
	@schoolId		uniqueidentifier,
	@rosterYearId	uniqueidentifier,
	@subjectId		uniqueidentifier,
	@anySubject		bit
AS

select distinct
	ca.*
from
	ClassRoster c join
	ContentArea ca on 
		c.ContentAreaID = ca.ID
where
	c.SchoolID = @schoolId and
	c.RosterYearID = @rosterYearId and
	(
		--instance
		(@subjectId is not null and ca.SubjectID = @subjectId) or
		-- any
		(@subjectId is null and @anySubject = 1) or
		-- none
		((@subjectId is null and @anySubject = 0) and ca.SubjectId is null)
	)


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


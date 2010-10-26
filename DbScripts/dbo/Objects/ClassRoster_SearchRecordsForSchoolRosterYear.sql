SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClassRoster_SearchRecordsForSchoolRosterYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ClassRoster_SearchRecordsForSchoolRosterYear]
GO

CREATE PROCEDURE dbo.ClassRoster_SearchRecordsForSchoolRosterYear
	@schoolId		uniqueidentifier,
	@rosterYearId	uniqueidentifier,
	@subjectId		uniqueidentifier,
	@contentAreaId	uniqueidentifier,
	@gradeLevelId	uniqueidentifier,
	@teacherId		uniqueidentifier,
	@anySubject		bit,
	@anyContentArea	bit,
	@anyGradeLevel	bit
AS

declare @base			table( ClassRosterID uniqueidentifier )
declare @bySubject		table( ClassRosterID uniqueidentifier )
declare @byTeacher		table( ClassRosterID uniqueidentifier )

--######################################
-- Filter by School, RosterYear, ContentArea, GradeLevel
insert @base select c.ID
from
	ClassRoster c
where
	c.SchoolID = @schoolId and
	c.RosterYearID = @rosterYearId and
	--ContentArea
	(
		--instance
		(@contentAreaId is not null and c.ContentAreaID = @contentAreaId) or
		--any
		(@contentAreaId is null and @anyContentArea = 1) or
		--none
		((@contentAreaId is null and @anyContentArea = 0) and c.ContentAreaID is null)
	) and
	--GradeLevel
	(
		--instance
		(@gradeLevelId is not null and c.GradeBitMask & (select BitMask from GradeRangeBitMask where MinGradeId = @gradeLevelId and MaxGradeId = @gradeLevelId) > 0) or
		--any
		(@gradeLevelId is null and @anyGradeLevel = 1) or
		--none
		((@gradeLevelId is null and @anyGradeLevel = 0) and c.GradeBitMask is null)
	)

--######################################
-- Filters by Subject
insert @bySubject select c.ID
from
	ClassRoster c join
	@base b on b.ClassRosterID = c.ID left join
	ContentArea ca on c.ContentAreaID = ca.ID
where
	--instance
	(@subjectId is not null and ca.SubjectID = @subjectId) or
	-- any
	(@subjectId is null and @anySubject = 1) or
	-- none
	((@subjectId is null and @anySubject = 0) and ca.SubjectId is null)

--######################################
-- Filters by Teacher
insert @byTeacher 
select c.ID
from
	ClassRoster c join
	@base b on b.ClassRosterID = c.ID join
	(
		-- last days taught
		select
			ClassRosterID, MAX(EndDate) [EndDate]
		from
			(
				select
					c.ID [ClassRosterID], isnull(crth.EndDate, y.EndDate) [EndDate]
				from
					ClassRoster c join
					RosterYear y on c.RosterYearID = y.ID left join
					ClassRosterTeacherHistory crth on crth.ClassRosterID = c.ID
				where
					c.SchoolID = @schoolId and
					c.RosterYearID = @rosterYearId
			) M
		group by ClassRosterID
	) l on l.ClassRosterID = c.ID left join
	ClassRosterTeacherHistory crth on 
		crth.ClassRosterID = c.ID and
		l.EndDate = isnull(crth.EndDate, l.EndDate)
where
	--instance
	(@teacherId is not null and crth.TeacherID = @teacherId) or
	-- any
	(@teacherId is null)
group by c.ID

--##############################################################################
-- Apply Filters
select
	*
from
	ClassRoster c join
	@base b on b.ClassRosterID = c.ID join
	@bySubject s on s.ClassRosterID = c.ID join
	@byTeacher t on t.ClassRosterID = c.ID



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


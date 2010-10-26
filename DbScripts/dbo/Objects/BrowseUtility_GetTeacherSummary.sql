SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BrowseUtility_GetTeacherSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[BrowseUtility_GetTeacherSummary]
GO

CREATE PROCEDURE dbo.BrowseUtility_GetTeacherSummary
	@schoolId uniqueidentifier,
	@rosterYearId uniqueidentifier
AS

declare @TeacherClassRoster table(
	TeacherID uniqueidentifier,
	ClassRosterID uniqueidentifier)

declare @TeacherSubject table(
	TeacherID uniqueidentifier,
	SubjectName varchar(15),
	NumSections int)

-- teacher to class
insert @TeacherClassRoster
select
	crth.TeacherID, crth.ClassRosterID
from	
	ClassRosterTeacherHistory crth join
	ClassRoster cr on crth.ClassRosterID = cr.ID join
	RosterYear y on cr.RosterYearID = y.ID join
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
					c.SchoolID = @schoolId and
					c.RosterYearID = @rosterYearId
			) M
		group by ClassRosterID
	) M on
		crth.ClassRosterID = M.ClassRosterID and
		M.EndDate = isnull(crth.EndDate, y.EndDate)

-- teacher to subject
insert @TeacherSubject
select
	TeacherID, SubjectName, count(*)
from
	(
		select
			tcr.TeacherID,
			case when s.Name is null then 'Other' else s.Name end [SubjectName]
		from
			@TeacherClassRoster tcr join
			ClassRoster cr on tcr.ClassRosterID = cr.ID left join
			ContentArea ca on cr.ContentAreaID = ca.ID left join
			Subject s on ca.SubjectID = s.ID
	) T
group by TeacherID, SubjectName

select
	T.TeacherID,
	isnull(ELA.NumSections,0) [ELA],
	isnull(MAT.NumSections,0) [MAT],
	isnull(SCI.NumSections,0) [SCI],
	isnull(SOC.NumSections,0) [SOC],
	isnull(OTH.NumSections,0) [OTH]
from
	(
	select
		T.TeacherID
	from
		@TeacherSubject T
	group by TeacherID
	) T left join
	@TeacherSubject ELA on
		T.TeacherID = ELA.TeacherID and
		ELA.SubjectName = 'Language Arts' left join
	@TeacherSubject MAT on
		T.TeacherID = MAT.TeacherID and
		MAT.SubjectName = 'Mathematics' left join
	@TeacherSubject SCI on
		T.TeacherID = SCI.TeacherID and
		SCI.SubjectName = 'Science' left join
	@TeacherSubject SOC on
		T.TeacherID = SOC.TeacherID and
		SOC.SubjectName = 'Social Studies' left join
	@TeacherSubject OTH on
		T.TeacherID = OTH.TeacherID and
		OTH.SubjectName = 'Other'




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


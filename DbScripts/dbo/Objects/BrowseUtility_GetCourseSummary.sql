if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BrowseUtility_GetCourseSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[BrowseUtility_GetCourseSummary]
GO

CREATE PROCEDURE dbo.BrowseUtility_GetCourseSummary
	@schoolId uniqueidentifier,
	@rosterYearId uniqueidentifier,
	@subjectId uniqueidentifier
AS

declare @summary table(
	ContentAreaID uniqueidentifier,
	GradeName varchar(10),
	NumCourses int)

insert @summary
select
	ca.ID [ContentAreaID],
	MAX(isnull(g.Name, 'UK')) [GradeName],
	count(*) [NumCourses]
from
	ClassRoster cr left join
	ContentArea ca on cr.ContentAreaID = ca.ID left join
	GradeRangeBitMask b on
		b.MinGradeID = b.MaxGradeID and
		cr.GradeBitMask & b.BitMask > 0 left join
	GradeLevel g on
		b.MinGradeID = g.ID
where
	cr.SchoolID = @schoolId and
	cr.RosterYearID = @rosterYearId and
	(
		(@subjectId is null and (cr.ContentAreaID is null or ca.SubjectID is null)) or
		(@subjectId is not null and ca.SubjectID = @subjectId)
	)
group by
	ca.ID, g.BitMask

select
	ca.Id [ContentAreaId],	
	isnull(gPK.NumCourses,0) [gPK],
	isnull(gK.NumCourses,0) [gK],
	isnull(g00.NumCourses,0) [g00],
	isnull(g01.NumCourses,0) [g01],
	isnull(g02.NumCourses,0) [g02],
	isnull(g03.NumCourses,0) [g03],
	isnull(g04.NumCourses,0) [g04],
	isnull(g05.NumCourses,0) [g05],
	isnull(g06.NumCourses,0) [g06],
	isnull(g07.NumCourses,0) [g07],
	isnull(g08.NumCourses,0) [g08],
	isnull(g09.NumCourses,0) [g09],
	isnull(g10.NumCourses,0) [g10],
	isnull(g11.NumCourses,0) [g11],
	isnull(g12.NumCourses,0) [g12],
	isnull(gUK.NumCourses,0) [gUK]
from
	(select ContentAreaID [Id] from @summary group by ContentAreaID) ca left join
	@summary gPK on (gPK.ContentAreaID = ca.ID or (ca.Id is null and gPK.ContentAreaID is null)) and gPK.GradeName = 'PK' left join
	@summary gK  on (gK.ContentAreaID = ca.ID  or (ca.Id is null and gK.ContentAreaID  is null)) and gK.GradeName like 'K%' left join
	@summary g00 on (g00.ContentAreaID = ca.ID or (ca.Id is null and g00.ContentAreaID is null)) and g00.GradeName = '00' left join
	@summary g01 on (g01.ContentAreaID = ca.ID or (ca.Id is null and g01.ContentAreaID is null)) and g01.GradeName = '01' left join
	@summary g02 on (g02.ContentAreaID = ca.ID or (ca.Id is null and g02.ContentAreaID is null)) and g02.GradeName = '02' left join
	@summary g03 on (g03.ContentAreaID = ca.ID or (ca.Id is null and g03.ContentAreaID is null)) and g03.GradeName = '03' left join
	@summary g04 on (g04.ContentAreaID = ca.ID or (ca.Id is null and g04.ContentAreaID is null)) and g04.GradeName = '04' left join
	@summary g05 on (g05.ContentAreaID = ca.ID or (ca.Id is null and g05.ContentAreaID is null)) and g05.GradeName like '%05' left join
	@summary g06 on (g06.ContentAreaID = ca.ID or (ca.Id is null and g06.ContentAreaID is null)) and g06.GradeName like '%06' left join
	@summary g07 on (g07.ContentAreaID = ca.ID or (ca.Id is null and g07.ContentAreaID is null)) and g07.GradeName like '%07' left join
	@summary g08 on (g08.ContentAreaID = ca.ID or (ca.Id is null and g08.ContentAreaID is null)) and g08.GradeName like '%08' left join
	@summary g09 on (g09.ContentAreaID = ca.ID or (ca.Id is null and g09.ContentAreaID is null)) and g09.GradeName = '09' left join
	@summary g10 on (g10.ContentAreaID = ca.ID or (ca.Id is null and g10.ContentAreaID is null)) and g10.GradeName = '10' left join
	@summary g11 on (g11.ContentAreaID = ca.ID or (ca.Id is null and g11.ContentAreaID is null)) and g11.GradeName = '11' left join
	@summary g12 on (g12.ContentAreaID = ca.ID or (ca.Id is null and g12.ContentAreaID is null)) and g12.GradeName = '12' left join
	@summary gUK on (gUK.ContentAreaID = ca.ID or (ca.Id is null and gUK.ContentAreaID is null)) and gUK.GradeName = 'UK'
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BrowseUtility_GetCourseYearSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[BrowseUtility_GetCourseYearSummary]
GO

CREATE PROCEDURE dbo.BrowseUtility_GetCourseYearSummary
	@schoolId uniqueidentifier
AS

declare @byGrade table(
	RosterYearID uniqueidentifier,
	GradeName varchar(10),
	NumCourses int)

insert @byGrade
select
	c.RosterYearID,
	isnull(g.Name, 'UK') [GradeName],
	count(*) [NumCourses]
from
	ClassRoster c left join
	GradeRangeBitMask b on
		b.MinGradeID = b.MaxGradeID and
		c.GradeBitMask & b.BitMask > 0 left join
	GradeLevel g on
		b.MinGradeID = g.ID
where
	c.SchoolID = @schoolID
group by
	c.RosterYearID, isnull(g.Name, 'UK')

select
	y.StartYear,
	y.ID [RosterYearID],
	isnull(gPK.NumCourses,0) [gPK],
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
	RosterYear y left join
	@byGrade gPK on gPK.RosterYearID = y.ID and gPK.GradeName = 'PK' left join
	@byGrade g00 on g00.RosterYearID = y.ID and g00.GradeName = '00' left join
	@byGrade g01 on g01.RosterYearID = y.ID and g01.GradeName = '01' left join
	@byGrade g02 on g02.RosterYearID = y.ID and g02.GradeName = '02' left join
	@byGrade g03 on g03.RosterYearID = y.ID and g03.GradeName = '03' left join
	@byGrade g04 on g04.RosterYearID = y.ID and g04.GradeName = '04' left join
	@byGrade g05 on g05.RosterYearID = y.ID and g05.GradeName = '05' left join
	@byGrade g06 on g06.RosterYearID = y.ID and g06.GradeName = '06' left join
	@byGrade g07 on g07.RosterYearID = y.ID and g07.GradeName = '07' left join
	@byGrade g08 on g08.RosterYearID = y.ID and g08.GradeName = '08' left join
	@byGrade g09 on g09.RosterYearID = y.ID and g09.GradeName = '09' left join
	@byGrade g10 on g10.RosterYearID = y.ID and g10.GradeName = '10' left join
	@byGrade g11 on g11.RosterYearID = y.ID and g11.GradeName = '11' left join
	@byGrade g12 on g12.RosterYearID = y.ID and g12.GradeName = '12' left join
	@byGrade gUK on gUK.RosterYearID = y.ID and gUK.GradeName = 'UK'
where
	y.StartYear >= (select min(a.StartYear) from RosterYear a join @byGrade b on a.ID = b.RosterYearID) and
	y.StartYear <= (select max(a.StartYear) from RosterYear a join @byGrade b on a.ID = b.RosterYearID)




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


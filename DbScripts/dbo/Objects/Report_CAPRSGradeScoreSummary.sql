IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[Report_CAPRSGradeScoreSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Report_CAPRSGradeScoreSummary]
GO

create Procedure [dbo].[Report_CAPRSGradeScoreSummary]
	@group uniqueidentifier
AS

if @group is null
	set @group = '467CEE2A-D032-47E9-8C3A-990D0FB80DA6'

declare @courseCode varchar(50)
declare @sql varchar(8000)
declare @year varchar(10)
declare @courseSection varchar(50)
declare @school uniqueidentifier
declare @rosterYear uniqueidentifier

select
	@year = year(ry.EndDate),
	@courseCode = cr.CourseCode,
	@courseSection = cr.SectionName,
	@school = cr.SchoolID,
	@rosterYear = cr.RosterYearID
from
	ClassRoster cr  join
	RosterYear ry on cr.RosterYearID = ry.ID
where
	cr.id= @group


set @sql ='
select 
	' + @year + ' as Year,
	groupings.InSchool,
	groupings.InClass,
	groupings.Grade,
	Count = isnull(tests.Count, 0)
from
	(	select x.InSchool, x.InClass, ScoreID = rcgs.Id, Grade = rcgs.Grade
		from
			(
				select *
				from
				(
					select InSchool = cast(1 as bit), InClass = cast(1 as bit) union all
					select InSchool = cast(1 as bit), InClass = cast(0 as bit) union all
					select InSchool = cast(0 as bit), InClass = cast(0 as bit)
				) x
			) x	 cross join
			ReportCardGradeScale rcgs
	) groupings left join
	(
		select
			InSchool = case when cr.SchoolID = ''' + cast(@school as varchar(36)) + ''' then 1 else 0 end,
			InClass = case when cr.Id = ''' + cast(@group as varchar(36)) + ''' then 1 else 0 end,
			Grade = rcgs.Grade,
			count(*) as Count
		from 
			ClassRoster cr join
			StudentClassRosterHistory scrh on cr.ID = scrh.ClassRosterID join
			Student stu on scrh.StudentID = stu.ID join
			ReportCardScore rcs on rcs.ClassRoster = cr.ID AND rcs.Student = stu.ID join
			ReportCardItem rci on rcs.ReportCardItem = rci.ID join
			ReportCardGradeScale rcgs on (rcs.PercentageScore >= rcgs.LowScore) and (rcs.PercentageScore < rcgs.HighScore or rcgs.HighScore is null)
		where 	
			cr.CourseCode = ''' + @courseCode + ''' AND 
			cr.RosterYearID = ''' + cast(@rosterYear as varchar(36)) + ''' AND
			rci.IsFinal = 1
		group by
			case when cr.SchoolID = ''' + cast(@school as varchar(36)) + ''' then 1 else 0 end,
			case when cr.Id = ''' + cast(@group as varchar(36)) + ''' then 1 else 0 end,
			rcgs.Grade
	) tests on
			tests.Grade = groupings.Grade and
			tests.InSchool = groupings.InSchool and
			tests.InClass = groupings.InClass
'

print(@sql)
exec(@sql)



--exec Report_CAPRSGradeScoreSummary 'baa0ceb8-5936-45a8-b5e5-92de5fa159f9'

--exec Report_CAPRSGradeScoreSummary '976c7796-bb30-4958-aca2-753de8cfb1e4'

--exec Report_CAPRSTestScoreSummary 'baa0ceb8-5936-45a8-b5e5-92de5fa159f9', 1




IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Report_ProbeGoalPreview]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Report_ProbeGoalPreview]

GO
 CREATE PROCEDURE [dbo].[Report_ProbeGoalPreview]
	@student uniqueidentifier,
	@probeType uniqueidentifier,
	@baselineDate datetime,
	@baselineScore real,
	@goalDate datetime,
	@goalScore real = null,
	@comparisionGoal uniqueidentifier = null,
	@showStudentHistory bit = 1
AS
	declare @crlf varchar(2); set @crlf = char(13) +  char(10);

	declare @zoomToSchoolYear bit

	select 
		@zoomToSchoolYear = case when GoalDefinitionID = 'D7C3ECB1-8FAD-4CCB-A46C-82E37783385C' then 1 else 0 end -- Target score
	from ProbeStandard
	where ID = @comparisionGoal


	-- Get calendar info
	declare @calendar uniqueidentifier
	declare @calendarStart datetime
	declare @calendarEnd datetime

	if @zoomToSchoolYear = 1
	select
		@calendar = c.ID,
		@calendarStart = c.FirstDate,
		@calendarEnd = c.LastDate
	from
		Student s join
		SchoolCalendar sc on s.CurrentSchoolID = sc.SchoolID join
		Calendar c on c.ID = sc.CalendarID
	where
		s.ID = @student and dbo.DateInRange(@baselineDate, c.FirstDate, c.LastDate) = 1


	-- There should be a calender for every school, but just in case,
	-- default to the roster year rather than showing no data
	if @calendarStart is null
		select
			@calendarStart = ry.StartDate,
			@calendarEnd = ry.EndDate
		from RosterYear ry
		where dbo.DateInRange(@baselineDate, ry.StartDate, ry.EndDate) = 1

--	-- Return chart data
	select SeriesSequence=0, SeriesName = 'Range', SeriesLabel = 'Range', DateTaken = @calendarStart, Score = 0, PointLabel = null 
	where @goalScore is null and @zoomToSchoolYear=1
	union all
	select SeriesSequence=0, SeriesName = 'Range', SeriesLabel = 'Range', DateTaken = @calendarEnd, Score = 0, PointLabel = null
	where @goalScore is null and @zoomToSchoolYear=1

	union all
	select SeriesSequence=0, SeriesName = 'Goal', SeriesLabel = 'Goal', DateTaken = @baselineDate, Score = @baselineScore, PointLabel = null
	where @goalScore is not null
	union all
	select SeriesSequence=0, SeriesName = 'Goal', SeriesLabel = 'Goal', DateTaken = @goalDate, Score = @goalScore, PointLabel = 'Goal (' + cast(round(@goalScore, 2) as varchar(20)) + ')'
	where @goalScore is not null

	union all
	select
		SeriesSequence=0, SeriesName = 'History', SeriesLabel = 'History', DateTaken = pt.DateTaken, Score = ps.NumericValue, PointLabel = null
	from
		ProbeScore ps join
		ProbeTime pt on ps.ProbeTimeID = pt.ID
	where
		pt.ProbeTypeID = @probeType and
		pt.StudentID = @student and
		dbo.DateInRange( pt.DateTaken, @calendarStart, @baselineDate+1) = 1 and
		@showStudentHistory = 1

	union all
	select
		SeriesSequence=1,
		SeriesName = pg.Name,
		SeriesLabel = pgl.Name,
		DateTaken = cd.Date,
		Score = pgv.Value,
		PointLabel = case when lastDayOffset.Name is null then null else pgl.Name + ' (' + cast(pgv.Value as varchar(10)) + ')' end
	from
		ProbeStandardValue pgv join
		ProbeStandardLevel pgl on pgl.ID = pgv.LevelID join
		ProbeStandard pg on pg.ID = pgl.StandardID join
		Student stu on stu.CurrentGradeLevelID = pgv.GradeLevelID or pgv.GradeLevelID is null join
		CalendarDate cd on cd.CalendarID = @calendar and cd.ElapsedSchoolDays = pgl.DayOffset and cd.IsSchoolDay = 1 left join
		(
			select Name, DayOffset = max(DayOffset)
			from ProbeStandardLevel
			where StandardID = @comparisionGoal
			group by Name
		) lastDayOffset on lastDayOffset.Name = pgl.Name and lastDayOffset.DayOffset = pgl.DayOffset
	where
		pg.GoalDefinitionID = 'D7C3ECB1-8FAD-4CCB-A46C-82E37783385C' and -- Target score
		pg.ID = @comparisionGoal and
		stu.ID = @student
	
	union all
	select
		SeriesSequence=1,
		SeriesName = pg.Name,
		SeriesLabel = pgl.Name,
		DateTaken = x.Date,
		Score = @baselineScore + (pgv.Value / pgv.GrowthDays) * cast(x.Offset as real),
		PointLabel = case when Offset=0 then null else pgl.Name + ' (' + cast(round(@baselineScore + (pgv.Value / pgv.GrowthDays) * cast(x.Offset as real), 0) as varchar(10)) + ')' end
	from
		(
			select	Date=@baselineDate, Offset=0 union all 
			select Date=@goalDate, Offset=datediff(d, @baselineDate, @goalDate)
		) x cross join
		ProbeStandardValue pgv join
		ProbeStandardLevel pgl on pgl.ID = pgv.LevelID join
		ProbeStandard pg on pg.ID = pgl.StandardID join
		Student stu on stu.CurrentGradeLevelID = pgv.GradeLevelID or pgv.GradeLevelID is null
	where
		pg.GoalDefinitionID = 'A8DD7BEA-2897-436F-8D85-648A3EBCFF9C' and -- Target growth
		pg.ID = @comparisionGoal and
		stu.ID = @student
GO

--exec Report_ProbeGoalPreview @student='EFE0188D-FFD6-45BA-B297-0057800B7CC2', @probeType='43B058D0-85C9-4DBA-8872-3FB76717154C', @baselineDate='3/11/2009', @baselineScore=10,  @goalDate='6/9/2009', @goalScore=50, @comparisionGoal='355CA94C-A258-4F04-B96E-C3B903DEC6A3'
--exec Report_ProbeGoalPreview @student='EFE0188D-FFD6-45BA-B297-0057800B7CC2', @probeType='43B058D0-85C9-4DBA-8872-3FB76717154C', @baselineDate='3/11/2009', @baselineScore=10,  @goalDate='6/9/2009', @goalScore=50, @comparisionGoal='56296F1A-E607-4585-A3A8-9757B173282A'

--select * from ProbeType
--select * from student where currentgradelevelid=(select id from gradelevel where name='03')


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Report_StudentInterventionProbes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Report_StudentInterventionProbes]


GO
 CREATE PROCEDURE [dbo].[Report_StudentInterventionProbes]
	@interventionGoal uniqueidentifier = null,
	@showProjection bit = 1
AS

declare @PROJECTION_MIN_POINTS int;					set @PROJECTION_MIN_POINTS = 3
declare @PROJECTION_HILOW_MAX_FORCAST_IN_WEEKS int;	set @PROJECTION_HILOW_MAX_FORCAST_IN_WEEKS = 4

declare @intervention uniqueidentifier
declare @student uniqueidentifier
declare @interventionStartDate datetime
declare @plannedEndDate datetime
declare @actualEndDate datetime
declare @trendEndDate datetime

select
	@intervention = intv.ID,
	@interventionStartDate = i.StartDate,
	@plannedEndDate = i.PlannedEndDate,
	@actualEndDate = i.EndDate,
	@student = i.StudentID
from
	PrgIntervention intv JOIN 
	PrgItem i ON i.ID = intv.ID JOIN 
	IntvGoal ig on ig.InterventionID = i.ID JOIN
	ProbeType pt on pt.ID = ig.ProbeTypeID
where
	ig.ID = @interventionGoal



-- probability = 80%
declare @tinv table(df int primary key, t real)
insert into @tinv values(1,3.07768353661034)
insert into @tinv values(2,1.88561808263157)
insert into @tinv values(3,1.63774435226741)
insert into @tinv values(4,1.53320627259495)
insert into @tinv values(5,1.47588403711822)
insert into @tinv values(6,1.43975574749764)
insert into @tinv values(7,1.41492392785393)
insert into @tinv values(8,1.3968153099516)
insert into @tinv values(9,1.38302873860126)
insert into @tinv values(10,1.37218364130304)
insert into @tinv values(11,1.36343031819663)
insert into @tinv values(12,1.35621733418116)
insert into @tinv values(13,1.3501712889202)
insert into @tinv values(14,1.34503037457815)
insert into @tinv values(15,1.34060560795885)
insert into @tinv values(16,1.33675716742218)
insert into @tinv values(17,1.33337938980448)
insert into @tinv values(18,1.33039094364212)
insert into @tinv values(19,1.32772820908958)
insert into @tinv values(20,1.3253407070395)
insert into @tinv values(21,1.32318787391225)
insert into @tinv values(22,1.32123674165386)
insert into @tinv values(23,1.31946023985082)
insert into @tinv values(24,1.31783593370257)
insert into @tinv values(25,1.31634507269862)
insert into @tinv values(26,1.31497186429109)
insert into @tinv values(27,1.31370291284603)
insert into @tinv values(28,1.31252678160602)
insert into @tinv values(29,1.31143364731179)
insert into @tinv values(30,1.31041502539883)
insert into @tinv values(31,1.30946354949953)
insert into @tinv values(32,1.30857279313206)
insert into @tinv values(33,1.3077371244513)
insert into @tinv values(34,1.30695158712489)
insert into @tinv values(35,1.30621180201271)
insert into @tinv values(36,1.30551388553128)
insert into @tinv values(37,1.30485438149113)
insert into @tinv values(38,1.30423020388261)
insert into @tinv values(39,1.30363858861209)
insert into @tinv values(40,1.30307705259685)

declare @probeDesc table(
	series uniqueidentifier primary key,
	baselineDate datetime,
	baselineScore real,
	goalScore real,
	n_all int,
	n_recent int,
	first_all datetime,
	first_recent datetime,
	last datetime,
	slope real,
	intercept real,
	slope_ci real,
	hiLowEndDate datetime
)

declare @goalTimeMap table(
	IntvGoalID uniqueidentifier,
	ProbeTimeID uniqueidentifier	
)

insert @goalTimeMap
select g.ID, t.ID
from
	IntvGoal g join
	PrgItem i on g.InterventionID = i.ID join
	ProbeType p on g.ProbeTypeID = p.ID join
	ProbeTime t on
		t.ProbeTypeID = p.ID and
		t.StudentID = i.StudentID and
		dbo.DateInRange(t.DateTaken, i.StartDate, isnull(i.EndDate, i.PlannedEndDate)) = 1
where g.ID = @interventionGoal
union
select g.ID, s.ProbeTimeID
from
	IntvGoal g join
	ProbeScore s on s.ID = g.BaselineScoreID
where g.ID = @interventionGoal


insert into @probeDesc(series, baselineDate, baselineScore, goalScore, first_all, n_all, last, hiLowEndDate)
select
	series			= ig.ID,
	baselineDate	= blt.DateTaken,
	baselineScore	= bl.Value,
	goalScore		= case when GrowthDays is null then ig.Target else bl.Value + ((ig.Target / ig.GrowthDays) * DateDiff(d, blt.DateTaken, i.PlannedEndDate)) end,
	first_all		= dbo.DateMin(min(pt.DateTaken), blt.DateTaken),
	n_all			= count(*),
	last			= max(pt.DateTaken),
	hiLowEndDate	= dateadd(d, 7*@PROJECTION_HILOW_MAX_FORCAST_IN_WEEKS, max(pt.DateTaken))
from
	ProbeScore ps join
	ProbeTime pt on ps.ProbeTimeID = pt.ID join
	@goalTimeMap gtm on gtm.ProbeTimeID = pt.ID join
	IntvGoalView ig on ig.ID = gtm.IntvGoalID join
	PrgItem i on i.ID = ig.InterventionID left join
	ProbeScoreView bl ON bl.ID = ig.BaselineScoreID left join
	ProbeTime blt ON blt.ID = bl.ProbeTimeID
where
	ig.ID = @interventionGoal
group by
	ig.ID, bl.Value,blt.DateTaken, ig.Target, ig.GrowthDays, i.PlannedEndDate

if @showProjection = 1
begin
	declare @regression_records table (Id uniqueidentifier primary key)
	
	-- determine the probes to run the regression against
	insert into @regression_records
	select top 5 
		ps.Id 
	from
		@probeDesc pd join
		@goalTimeMap gtm on pd.series = gtm.IntvGoalID join
		ProbeTime pt on gtm.ProbeTimeID = pt.ID join
		ProbeScore ps on ps.ProbeTimeID = pt.ID
	where
		pt.DateTaken > @interventionStartDate
	order by
		DateTaken desc
		
	-- narrow the dataset to input into the projection calculation
	update @probeDesc
	set
		n_recent = x.n_recent,
		first_recent = x.first_recent
	from (
		select
			n_recent		= count(*),
			first_recent	= min(DateTaken)
		from
			@regression_records rec join
			ProbeScore ps on ps.ID = rec.ID join
			ProbeTime pt on pt.ID = ps.ProbeTimeID
	) x
	
	if (select n_recent from @probeDesc) >= @PROJECTION_MIN_POINTS
	begin
		-- Calculate best fit line using a linear regression
		/*
		Suppose the weights are w1, w2, ... the independent values are x1, x2,
		... and the dependent values are y1, y2, .... Form the following sums:
		I = the sum of the weights, II = the sum of the weights times the x's
		(w1*x1+w2*x2+...), III = the sum of the weights times the squares of
		the x's (w1*x1^2+w2*x2^2+...), IV = the sum of the weights times the
		y's (w1*y1+w2*y2+...), V = the sum of the weights times the x's times
		the y's (w1*x1*y1+w2*x2*y2+...). If m = the slope of the line and b =
		its intercept, then they are the solutions to the following two
		equations:
		
		I*b + II*m = IV and
		II*b + III*m = V.
		
		The solution to these two equations is the following:
		
		Let D = I*III-II^2. Then b = [III*IV - II*V ]/D and m = [I*V - II*IV]/D.
		*/
		declare @regression_input table(series uniqueidentifier, x real, y real, w real)
		
		insert into @regression_input
		select top 5 /*= max regression pts*/
			series = pd.series,
			x = datediff(d, first_recent, DateTaken),
			y = cast(Value as real),
			w = 1 --1+cast(datediff(d, @first_recent, DateTaken) as float)
		from
			@probeDesc pd cross join
			ProbeScoreView ps join
			ProbeTime pt on pt.ID = ps.ProbeTimeID
		where
			ps.ID in (select Id from @regression_records)
		order by
			DateTaken desc

		update pd
		set
			slope = (I*V - II*IV)/(I*III - II*II),
			intercept = (III*IV - II*V)/(I*III - II*II)
		from
			@probeDesc pd join
			(
				select
					series,
					I = sum(w),
					II = sum(w*x),
					III = sum(w*x*x),
					IV = sum(w*y),
					V = sum(w*x*y)
				from
					@regression_input data
				group by
					series
			) sums on sums.series = pd.series
	
	
		-- calculate slope confidence interval
		-- http://learning.mazoo.net/archives/000930.html
		-- estimate variance = sum(power(y - (@slope*x + @intercept), 2)) / (@n_recent - 2)
		update pd
		set
			slope_ci = calc.slope_ci
		from
			@probeDesc pd join
			(
				select
					pd.series,
					slope_ci = sqrt(
							(n_recent * (sum(power(y - (slope*x + intercept), 2)) / (n_recent - 2)) ) /
							((n_recent * sum(x*x)) - (sum(x)*sum(x)))) * (select t from @tinv where df = n_recent - 2
						)
				from
					@probeDesc pd join
					@regression_input data on data.series = pd.series
				group by
					pd.series, n_recent, slope, intercept
			) calc on calc.series = pd.series
	end
end -- @showProjection


declare @x_min datetime
declare @x_max datetime

select
	@x_min = StartDate,
	@x_max = EndDate,
	@trendEndDate = @x_max
from
	dbo.GetInterventionTimeframe(@intervention)

--
-- Return chart data
--
declare @chart table(Goal varchar(36), SeriesSequence int, SeriesName varchar(50), SeriesLabel varchar(50), DateTaken datetime, Score real, PointLabel varchar(50))


insert into @chart
select cast(pd.series as varchar(36)), 10, 'Probes', p.Name, t.DateTaken, s.Value, PointLabel = s.ValueShortDescription
from
	@probeDesc pd join
	@goalTimeMap gtm on pd.series = gtm.IntvGoalID join
	ProbeTime t on gtm.ProbeTimeID = t.ID join
	ProbeType p on t.ProbeTypeID = p.ID join
	ProbeScoreView s on s.ProbeTimeID = t.ID


-- Recent trend line
insert into @chart
select cast(series as varchar(36)), 5, 'Projection', 'Recent Trend', first_recent, intercept, PointLabel = null
from @probeDesc pd
where slope is not null

insert into @chart
select cast(series as varchar(36)), 5, 'Projection', 'Recent Trend', @trendEndDate, intercept + (datediff(d, first_recent, @trendEndDate) * slope), PointLabel = null
from @probeDesc
where slope is not null


-- Low projection
insert into @chart
select cast(series as varchar(36)), 3, 'Projection (Low)', 'Projection (Low)', t.DateTaken, s.NumericValue, PointLabel = null
from
	ProbeScore s join
	ProbeTime t on t.ID = s.ProbeTimeID join
	@goalTimeMap gtm on gtm.ProbeTimeID = t.ID join
	@probeDesc pd on gtm.IntvGoalID = pd.series
where
	t.DateTaken = last and
	pd.slope is not null

insert into @chart
select cast(series as varchar(36)), 3, 'Projection (Low)', 'Projection (Low)', hiLowEndDate, intercept + (datediff(d, first_recent, hiLowEndDate) * (slope - slope_ci)), PointLabel = null
from
	@probeDesc pd
where
	slope is not null


-- High projection
insert into @chart
select cast(series as varchar(36)), 4, 'Projection (High)', 'Projection (High)', t.DateTaken, s.NumericValue, PointLabel = null
from
	ProbeScore s join
	ProbeTime t on t.ID = s.ProbeTimeID join
	@goalTimeMap gtm on gtm.ProbeTimeID = t.ID join
	@probeDesc pd on gtm.IntvGoalID = pd.series
where
	t.DateTaken = last and
	slope is not null

insert into @chart
select cast(series as varchar(36)), 4, 'Projection (High)', 'Projection (High)', hiLowEndDate, intercept + (datediff(d, first_recent, hiLowEndDate) * (slope + slope_ci)), PointLabel = null
from
	@probeDesc pd
where
	slope is not null

-- Goal line
if @plannedEndDate is not null AND (select baselineScore from @probeDesc) is not null
begin
	-- with goal date
	insert into @chart
	select cast(series as varchar(36)), 1, 'Goal', 'Goal', baselineDate, baselineScore, PointLabel = NULL
	from @probeDesc

	insert into @chart
	select cast(series as varchar(36)), 1, 'Goal', 'Goal', @plannedEndDate, goalScore, PointLabel = NULL
	from @probeDesc
	where goalScore is not null
end
else
begin
	-- without goal date
	insert into @chart
	select cast(series as varchar(36)), 1, 'Goal', 'Goal', isnull(baselineDate, @interventionStartDate), goalScore, PointLabel = NULL
	from @probeDesc

	insert into @chart
	select cast(series as varchar(36)), 1, 'Goal', 'Goal', isnull(@plannedEndDate, @x_max), goalScore, PointLabel = NULL
	from @probeDesc
	where goalScore is not null
end

-- Special events
insert into @chart
select cast(series as varchar(36)), SeriesSequence=2, SeriesName = 'Range', SeriesLabel = 'Range', @interventionStartDate, 0, PointLabel = 'Start Intervention'
from @probeDesc

insert into @chart
select cast(series as varchar(36)), SeriesSequence=2, SeriesName = 'Range', SeriesLabel = 'Range', @actualEndDate, 0, PointLabel = case when @actualEndDate <> @plannedEndDate then 'Actual End' else 'Planned & Actual End' end
from @probeDesc
where @actualEndDate is not null

insert into @chart
select cast(series as varchar(36)), SeriesSequence=2, SeriesName = 'Range', SeriesLabel = 'Range', @plannedEndDate, 0, PointLabel = 'Planned End'
from @probeDesc
where @plannedEndDate is not null AND (@actualEndDate is null OR @actualEndDate <> @plannedEndDate)



-- lastly, ensure that the chart range matches the ranges of the event charts so their x-axes all line up
if (select min(DateTaken) from @chart) > @x_min
	insert into @chart
	select cast(series as varchar(36)), SeriesSequence=2, SeriesName = 'Range', SeriesLabel = 'Range', @x_min, 0, PointLabel = null
	from @probeDesc

if (select max(DateTaken) from @chart) < @x_max
	insert into @chart
	select cast(series as varchar(36)), SeriesSequence=2, SeriesName = 'Range', SeriesLabel = 'Range', @x_max, 0, PointLabel = null
	from @probeDesc


-- cleanup any stray lines that may mess up the chart's scale
-- by limiting the x and y
declare @limit_high real
declare @limit_low real
set @limit_high = 1.10 * (select max(Score) from @chart where SeriesName not in ('Projection (High)', 'Projection (Low)', 'Projection'))
set @limit_low = 0

	
update p1
set
	-- note: use 'hours' as the units of the x-axis rather days to prevent rounding errors
	DateTaken = case
				when p1.Score > @limit_high then dateadd(hh, (@limit_high - p0.Score) * (datediff(hh, p0.DateTaken, p1.DateTaken) / (p1.Score - p0.Score)), p0.DateTaken)
				when p1.Score < @limit_low then dateadd(hh, (p0.Score - @limit_low) * (datediff(hh, p0.DateTaken, p1.DateTaken) / (p0.Score - p1.Score)), p0.DateTaken)
				else p1.DateTaken
				end,
	
	Score =		case
				when p1.Score > @limit_high then @limit_high
				when p1.Score < @limit_low then @limit_low
				else p1.Score
				end

from
	(
		select SeriesName, x_min = min(DateTaken), x_max = max(DateTaken)
		from @chart
		group by SeriesName
	) series join
	@chart p0 on p0.DateTaken = series.x_min and series.SeriesName = p0.SeriesName join
	@chart p1 on p1.DateTaken = series.x_max and series.SeriesName = p1.SeriesName
where
	series.SeriesName in ('Projection (High)', 'Projection (Low)', 'Projection') and
	p0.Score != p1.Score
	

select
	Goal, SeriesSequence,
	SeriesName,
	SeriesLabel, 
	-- In SQL 2008 the goal line does not appear if the dates fall on the same data as other data.  As a fix,
	-- update the seconds part based on which series the data belongs to of each date so that the x values are unique.
	DateTaken = dateAdd(S, SeriesSequence, DateTaken), Score, PointLabel
from @chart

GO


/*

select t.Name, 'http://localhost/VC3.TestView.SpecEd.WebUI/Interventions/ViewIntervention.aspx?s=' + cast(studentid as varchar(36)) + '&i=' + cast(i.ID as varchar(36)), g.ID, stu.FirstName + ' ' + stu.LastName
from
	ProbeType t join
	intvgoal g on g.ProbeTypeID = t.ID join
	prgItem i on i.ID = g.InterventionID join
	Student stu on stu.Id = i.StudentID
where firstname like 'char%'
order by stu.FirstName + ' ' + stu.LastName

exec [Report_StudentInterventionProbes] 'D1641DFD-E5E3-4654-A5F2-990781121F87'
exec [Report_StudentInterventionProbes] '3320B977-0FDB-4624-9125-6CBAB45639DA'
exec [Report_StudentInterventionProbes] '7998D3C7-E480-40F7-B2B4-89D9DBAEE347'

select * from interventiongoal where interventionid='EAC9C718-7B71-4803-85FC-D829DD37EEF0'



exec [Report_StudentInterventionProbes] 'B6096816-97BD-452D-9411-CE52BEF3B479'

select i.ID, Name = s.FirstName + ' ' + s.LastName + ' ' + cast(i.StartDate as varchar(20))
from
	Student s join
	Intervention i on i.StudentID = s.ID
where
	exists(select * from ProbeScore where InterventionID = i.ID)
order by
	i.StartDate
*/



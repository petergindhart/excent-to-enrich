IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Report_StudentNonInterventionEvents]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Report_StudentNonInterventionEvents]
GO

CREATE PROCEDURE [dbo].[Report_StudentNonInterventionEvents]
	@student	uniqueidentifier,
	@rosterYear uniqueidentifier,
	@showDiscipline bit,
	@showAbsences	bit
AS

DECLARE @startDate datetime
DECLARE @endDate datetime

SELECT
	@startDate = COALESCE(c.FirstDate,startDate),
	@endDate = COALESCE(c.LastDate,EndDate)
FROm
	RosterYear ry left join
	Student stu on stu.ID = @student left join
	School sch on stu.CurrentSchoolID = sch.ID left join
	SchoolCalendar sc on sch.ID = sc.SchoolID LEFT join
	Calendar c on sc.CalendarID = c.ID and c.RosterYearID = @rosterYear
WHERE 	
	ry.ID= @rosterYear

--ATTEMPTED to create common logic between intervention and non intervention reports however it was more problematic than first thought
--EXEC dbo.[Report_StudentEventsInternal] @student, @rosterYear, null, @showDiscipline, @showAbsences, 0, @startDate, @endDate

declare @data table(SeriesSequence int, SeriesName varchar(100), SeriesLabel varchar(100), PointLabel varchar(100), PointID uniqueidentifier, PointUrl varchar(500), Status char(1), Date datetime)

insert into @data
	select
		SeriesSequence=10, SeriesName = 'Absences', SeriesLabel = 'Absences' ,
		PointLabel = ar.Name + case when arGroup.reasonCount is not null then ' (' + cast(reasonCount as varchar(5)) + ')' else '' end,
		PointID = a.ID,
		PointUrl = '#Absence:' + cast(a.ID as varchar(36)),
		Status = 'B',
		a.Date
	from
		Absence a join
		AbsenceReason ar on ar.ID = a.ReasonID left join
		(
			SELECT
				arInner.ID AS reasonID,
				count(*) AS reasonCount
			FROm
				Absence aInner join
				AbsenceReason arInner on arInner.ID = aInner.ReasonID
			WHERE
				aInner.RosterYearId = @rosterYear AND
				aInner.StudentID = @student
			group by
				arInner.ID
		) arGroup on arGroup.reasonID = ar.ID
	where		
		@showAbsences = 1 AND
		a.RosterYearId = @rosterYear AND
		a.StudentID = @student

	union all

	select
		SeriesSequence=10, SeriesName = 'Discipline', SeriesLabel = 'Discipline',
		PointLabel = isnull(isnull(dc.DisplayValue, ' '), ' ') + case when dGroup.discCount is not null then ' (' + cast(discCount as varchar(5)) + ')' else '' end,
		PointID = di.ID,
		PointUrl = '#Discipline:' + cast(di.ID as varchar(36)),
		Status = 'W',
		di.Date
	from
		DisciplineIncident di left join
		EnumValue dc on dc.ID = di.DispositionCodeID left join
		(
			SELECT
				dInner.DispositionCodeID,
				count(*) AS discCount
			FROm
				DisciplineIncident dInner
			WHERE
				dInner.studentID = @student AND
				dInner.RosterYearID = @rosterYear
			group by
				dInner.DispositionCodeID
		) dGroup on dGroup.DispositionCodeID = di.DispositionCodeID
	where
		@showDiscipline = 1 AND
		di.studentID = @student AND
		di.RosterYearID = @rosterYear

---- return all results
select *, DateNumber = datediff(d, @startDate, Date)
from
(
	select *, IsRange=cast(0 as bit) from @data d
	union all
	select ser.SeriesSequence, ser.SeriesName, ser.SeriesLabel, ser.PointLabel, PointID=null, PointUrl=null, Status=' ', range.Date, IsRange=cast(1 as bit)
	from
		(
			select SeriesSequence, SeriesName, SeriesLabel, PointLabel, MinDate=min(Date), MaxDate=max(Date)
			from @data
			group by SeriesSequence, SeriesName, SeriesLabel, PointLabel
		) ser join
		(
			select Date=@startDate
			union all
			select Date=@endDate
		) range on range.Date not in (ser.MinDate, ser.MaxDate)
) d
order by 
	SeriesSequence, SeriesName, PointLabel, Date
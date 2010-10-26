
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Report_StudentInterventionEvents]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Report_StudentInterventionEvents]

GO
 CREATE PROCEDURE [dbo].[Report_StudentInterventionEvents]
	@intervention uniqueidentifier,
	@showDiscipline bit = 1,
	@showAbsences	bit = 1,
	@viewActivityUrl varchar(255) = '..\Programs\ViewActivity.aspx'
AS

declare @student uniqueidentifier
declare @startDate datetime 
declare @endDate datetime	

select @student = StudentID
from PrgItem 
where ID = @intervention

select
	@startDate = StartDate,
	@endDate = EndDate
from
	dbo.GetInterventionTimeframe(@intervention)

--
-- Build list of events
--

declare @data table(SeriesSequence int, SeriesName varchar(100), SeriesLabel varchar(100), PointLabel varchar(100), PointID uniqueidentifier, PointUrl varchar(500), Status char(1), Date datetime)

insert into @data
	select
		SeriesSequence=10, SeriesName = 'Absences', SeriesLabel = 'Absences',
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
				aInner.StudentID = @student AND
				aInner.Date >= @startDate and aInner.Date <= @endDate				
			group by
				arInner.ID
		) arGroup on arGroup.reasonID = ar.ID
	where
		@showAbsences = 1 AND
		a.Date >= @startDate and a.Date <= @endDate and
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
				dInner.Date >= @startDate and dInner.Date <= @endDate
			group by
				dInner.DispositionCodeID
		) dGroup on dGroup.DispositionCodeID = di.DispositionCodeID
	where
		di.Date >= @startDate and di.Date <= @endDate and
		di.StudentID = @student

	union all

	select
		SeriesSequence=11, SeriesName = 'Actions', SeriesLabel = 'Actions',
		PointLabel = d.Name,
		PointID = a.ID,
		PointUrl = @viewActivityUrl + '?s=' + cast(@student as varchar(36)) + '&a=' + cast(a.ID as varchar(36)),
		Status = 'N',
		isnull(i.EndDate, i.StartDate)
	from
		PrgActivity a JOIN 
		PrgItem i on i.ID = a.ID JOIN 
		PrgItemDef d on d.ID = i.DefID 
	where
		isnull(i.EndDate, i.StartDate) >= @startDate and
		isnull(i.EndDate, i.StartDate) <= @endDate and
		i.StudentID = @student and
		(a.ItemID is null OR a.ItemID = @intervention)


-- return all results
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

GO


/*
exec [Report_StudentInterventionEvents] @intervention='24322742-7631-43EA-A6B2-B3CB3F2457E9'
exec [Report_StudentInterventionEvents] @intervention='AD6C33AA-B685-475E-938B-1D804FCE8EDF'


exec [Report_StudentInterventionEvents] @intervention='B6096816-97BD-452D-9411-CE52BEF3B479'


*/



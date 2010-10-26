/****** Object:  StoredProcedure [dbo].[Report_StudentEventsInternal]    Script Date: 09/11/2009 09:50:08 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Report_StudentEventsInternal]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Report_StudentEventsInternal]
GO

CREATE PROCEDURE [dbo].[Report_StudentEventsInternal]
	@student	uniqueidentifier,
	@rosterYear uniqueidentifier,
	@intervention uniqueidentifier,
	@showDiscipline bit,
	@showAbsences	bit,
	@showReview		bit,
	@startDate		datetime,
	@endDate		datetime
AS 

declare @data table(SeriesSequence int, SeriesName varchar(100), SeriesLabel varchar(100), PointLabel varchar(100), PointID uniqueidentifier, PointUrl varchar(500), Status char(1), Date datetime)

insert into @data
	select
		SeriesSequence=10, SeriesName = 'Absences', SeriesLabel = 'Absences (' + (select cast(DaysAbsent as varchar(3))from StudentRosterYear where StudentID = @student and RosterYearID= @rosterYear) + ')' ,
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
		SeriesSequence=10, SeriesName = 'Discipline', SeriesLabel = 'Discipline (' + (select cast(DisciplineReferrals as varchar(3)) from StudentRosterYear where StudentID = @student and RosterYearID= @rosterYear) + ')',
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
		
	union all

	select
		SeriesSequence=11, SeriesName = 'Actions', SeriesLabel = 'Actions',
		PointLabel = d.Name,
		PointID = a.ID,
		PointUrl = 'ViewReview.aspx?s=' + cast(@student as varchar(36)) + '&a=' + cast(a.ID as varchar(36)),
		Status = 'N',
		isnull(i.EndDate, i.StartDate)
	from
		PrgActivity a JOIN 
		PrgItem i on i.ID = a.ID JOIN 
		PrgItemDef d on d.ID = i.DefID 
	where
		@showReview =1 AND
		isnull(i.EndDate, i.StartDate) >= @startDate and
		isnull(i.EndDate, i.StartDate) <= @endDate and
		i.StudentID = @student and
		(a.ItemID is null OR a.ItemID = @intervention)

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

IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Teacher_GetRecordsByStudent' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.Teacher_GetRecordsByStudent
GO

/*
<summary>
Gets the teachers that taught a student during the specified date range
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.Teacher_GetRecordsByStudent
	@student		uniqueidentifier,
	@startDate		datetime,
	@endDate		datetime
AS
	declare @now datetime
	set @now = getdate()

	select t.* 
	from
		Teacher t join
		(
			select distinct TeacherID
			from
				StudentClassRosterHistory scrh join
				ClassRosterTeacherHistory crth on
					scrh.ClassRosterID = crth.ClassRosterID
			where
				StudentID = @student and
				dbo.DateRangesOverlap(scrh.StartDate, scrh.EndDate, crth.StartDate, crth.EndDate, @now) = 1 and
				dbo.DateRangesOverlap(@startDate, @endDate, scrh.StartDate, scrh.EndDate, @now) = 1 and
				dbo.DateRangesOverlap(@startDate, @endDate, crth.StartDate, crth.EndDate, @now) = 1
		) th on th.TeacherID = t.Id
GO
	


IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Student_GetRecordsByClassRoster' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.Student_GetRecordsByClassRoster
GO

/*
<summary>

</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.Student_GetRecordsByClassRoster 
	@classroster uniqueidentifier,
	@startDate dateTime,
	@endDate dateTime
AS
	declare @now datetime
	set @now = getdate()

	SELECT s.*
	from
		Student s join
		StudentClassRosterHistory scrh on scrh.StudentID = s.Id
	where
		scrh.ClassRosterID = @classRoster and
		dbo.DateRangesOverlap(@startDate, @endDate, scrh.StartDate, scrh.EndDate, @now) = 1
GO

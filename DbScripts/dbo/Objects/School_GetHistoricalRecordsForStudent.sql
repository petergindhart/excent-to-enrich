
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'School_GetHistoricalRecordsForStudent' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.School_GetHistoricalRecordsForStudent
GO

/*
<summary>

</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.School_GetHistoricalRecordsForStudent
	@studentId			uniqueidentifier,
	@startDate				datetime,
	@endDate				datetime
AS

if @startDate = @endDate
begin
	-- OPTIMIZATION: Search for exact date if possible
	select *
	from School
	where Id in
		(
			select h.SchoolID
			from StudentSchoolHistory h
			where
				h.StudentID = @studentId and
				dbo.DateInRange(@startDate, h.StartDate, h.EndDate) = 1
		)
end
else
begin
	-- Must check overlapping ranges
	select *
	from School
	where Id in
		(
			select h.SchoolID
			from StudentSchoolHistory h
			where
				h.StudentID = @studentId and
				dbo.DateRangesOverlap(@startDate, @endDate, h.StartDate, h.EndDate, getdate()) = 1
		)

end

GO



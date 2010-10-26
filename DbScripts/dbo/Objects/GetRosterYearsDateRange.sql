-- =============================================
-- Create inline function (IF)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'GetRosterYearsDateRange')
	DROP FUNCTION dbo.GetRosterYearsDateRange
GO

/*
Gets a date range for a range of roster years
*/
CREATE FUNCTION dbo.GetRosterYearsDateRange (
	@baseDate datetime,
	@startDateOffset int,
	@endDateOffset int)
RETURNS TABLE 
AS RETURN

-- get the current roster year start and end date
SELECT
	StartDate		= min(range.StartDate),
	EndDate			= max(range.EndDate)
FROM 
	RosterYear range JOIN
	(
		SELECT StartYear 
		FROM RosterYear
		WHERE
			dbo.DateInRange(@baseDate, StartDate, EndDate) = 1
	) base on range.StartYear - base.StartYear BETWEEN @startDateOffset AND @endDateOffset

GO
/*
select * from dbo.GetRosterYearsDateRange('1/1/2005', -1, 3)
*/




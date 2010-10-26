-- =============================================
-- Create inline function (IF)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'GetRosterYearsRange')
	DROP FUNCTION dbo.GetRosterYearsRange
GO

/*
Gets a date range for a range of roster years
*/
CREATE FUNCTION dbo.GetRosterYearsRange (
	@baseDate datetime,
	@lowerOffset int,
	@upperOffset int)
RETURNS TABLE 
AS RETURN

-- get the current roster year start and end date
SELECT
	range.Id
FROM 
	RosterYear range JOIN
	(
		SELECT StartYear 
		FROM RosterYear
		WHERE dbo.DateInRange(@baseDate, StartDate, EndDate) = 1
	) base on range.StartYear - base.StartYear BETWEEN @lowerOffset AND @upperOffset

GO
/*
select * from dbo.GetRosterYearsRange('1/1/2005', 0, 0)
*/




-- =============================================
-- Create procedure basic template
-- =============================================
-- creating the store procedure
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'RosterYear_SetDateRange' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.RosterYear_SetDateRange
GO

CREATE PROCEDURE dbo.RosterYear_SetDateRange 
	@rosterYear uniqueidentifier,
	@startDate datetime,
	@endDate datetime
AS

if @startDate >= @endDate
begin
	RAISERROR( '@startDate must be before @endDate', 18, 1)
	RETURN 1
end

declare @startYear int
declare @addStartDays int
declare @addEndDays int

select 
	@startYear 		= StartYear,
	@addStartDays 	= DateDiff(d, StartDate, @startDate),
	@addEndDays 	= DateDiff(d, EndDate, @endDate)
from RosterYear
where ID = @rosterYear

-- Adjust startDates for all earlier years
update RosterYear
set 
	StartDate = DateAdd(d, @addStartDays, StartDate),
	EndDate = DateAdd(d, @addStartDays, EndDate)
where StartYear < @startYear

-- Adjust startDates for all later years
update RosterYear
set 
	StartDate = DateAdd(d, @addEndDays, StartDate),
	EndDate = DateAdd(d, @addEndDays, EndDate)
where StartYear > @startYear


-- Adjust start and end dates for this year
update RosterYear
set 
	StartDate = DateAdd(d, @addStartDays, StartDate),
	EndDate = DateAdd(d, @addEndDays, EndDate)
where StartYear = @startYear

GO

-- =============================================
-- example to execute the store procedure
-- =============================================


GO


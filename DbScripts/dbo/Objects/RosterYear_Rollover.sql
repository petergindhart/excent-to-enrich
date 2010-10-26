-- ==================================================================
-- Procedure used to rollover the roster year in TestView. It does 
-- the following three things: 
-- 1)  Determine current year 
-- 2)  Set current year end date to current time
-- 3)  Set current year + 1 start date to current time
-- ==================================================================

IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'RosterYear_Rollover'
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.RosterYear_Rollover
GO

CREATE PROCEDURE dbo.RosterYear_Rollover 
	@thisYear int = null
AS

DECLARE
	@rolloverTime DATETIME, 
	@currentRosterYearID uniqueidentifier 

-- Use the CURRENT_TIMESTAMP to get the current time
SELECT @rolloverTime = CURRENT_TIMESTAMP
SELECT @currentRosterYearID = dbo.GetRosterYear(@rolloverTime)
IF @thisYear IS null
	SELECT @thisYear = StartYear FROM dbo.RosterYear WHERE ID = @currentRosterYearID

UPDATE dbo.RosterYear SET EndDate = @rolloverTime WHERE StartYear = @thisYear
UPDATE dbo.RosterYear SET StartDate = @rolloverTime WHERE StartYear = @thisYear + 1

SELECT * FROM dbo.RosterYear WHERE StartYear in (@thisYear, @thisYear + 1) ORDER BY StartYear
GO 

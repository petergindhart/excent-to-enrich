IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItem_DisciplineReferralChange]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[PrgItem_DisciplineReferralChange]
GO

CREATE FUNCTION PrgItem_DisciplineReferralChange(@startPointID uniqueidentifier, @endPointID uniqueidentifier, @daysSurroundingTimeRange int, @dispositionID uniqueidentifier)
RETURNS TABLE
AS
RETURN 
SELECT c.*, @dispositionID AS DispositionID, @daysSurroundingTimeRange as DaysSurroundingTimeRange,
	c.ChangePerDay*7 AS ChangePerWeek,
	c.ChangePerDayPercent*7 AS ChangePerWeekPercent
FROM
	(SELECT c.*,
		CASE 
			WHEN c.DaysInTimeRange = 0 THEN c.Change
			ELSE c.Change/c.DaysInTimeRange
		END AS ChangePerDay,
		CASE 
			WHEN c.DaysInTimeRange = 0 THEN c.ChangePercent
			ELSE c.ChangePercent/c.DaysInTimeRange
		END AS ChangePerDayPercent
	FROM
		(SELECT c.*,
			c.ReferralsAfterTimeRange - c.ReferralsBeforeTimeRange AS Change,
			CASE
			WHEN ReferralsBeforeTimeRange = 0 THEN NULL
				ELSE (c.ReferralsAfterTimeRange - c.ReferralsBeforeTimeRange)/CAST(c.ReferralsBeforeTimeRange AS FLOAT)*100
			END AS ChangePercent
		FROM 
			(SELECT c.*,
				c.ReferralsPerDayBeforeTimeRange*7 AS ReferralsPerWeekBeforeTimeRange,
				c.ReferralsPerDayInTimeRange*7 AS ReferralsPerWeekInTimeRange,
				c.ReferralsPerDayAfterTimeRange*7 AS ReferralsPerWeekAfterTimeRange
			FROM
			(SELECT c.*,
				CASE
					WHEN @daysSurroundingTimeRange = 0 THEN c.ReferralsBeforeTimeRange
					ELSE c.ReferralsBeforeTimeRange / CAST(@daysSurroundingTimeRange AS FLOAT)
				END AS ReferralsPerDayBeforeTimeRange,
				CASE
					WHEN c.DaysInTimeRange = 0 THEN 0
					ELSE c.ReferralsInTimeRange / CAST(c.DaysInTimeRange AS FLOAT)
				END AS ReferralsPerDayInTimeRange,
				CASE
					WHEN @daysSurroundingTimeRange = 0 THEN c.ReferralsAfterTimeRange
					ELSE c.ReferralsAfterTimeRange / CAST(@daysSurroundingTimeRange AS FLOAT)
				END AS ReferralsPerDayAfterTimeRange,
				DaysInTimeRange/7 AS WeeksInTimeRange
			FROM
				(SELECT c.*, 
					CAST(DATEDIFF(DAY,c.StartDateOfTimeRange,c.EndDateOfTimeRange)+1 AS FLOAT) AS DaysInTimeRange
				FROM
					(SELECT i.ID AS ItemID,  
					SUM(CASE
							WHEN di.Date < ISNULL(DATEADD(DAY, sp.Value, i.StartDate), i.EndDate) THEN 1
							ELSE 0 
						END) AS ReferralsBeforeTimeRange,
					sp.ID as StartPointID, 
					ISNULL(ISNULL(DATEADD(DAY, sp.Value, i.StartDate), i.EndDate),i.PlannedEndDate) AS StartDateOfTimeRange,
					SUM(CASE
						WHEN di.Date >= ISNULL(DATEADD(DAY, sp.Value, i.StartDate), i.EndDate) AND
							di.Date <= ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.EndDate) THEN 1
						ELSE 0 
					END) AS ReferralsInTimeRange,
					ep.ID as EndPointId,
					ISNULL(ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.EndDate),i.PlannedEndDate) AS EndDateOfTimeRange,
					SUM(CASE
							WHEN di.Date > ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.EndDate) THEN 1
							ELSE 0 
						END) AS ReferralsAfterTimeRange
					FROM 
						PrgItem i JOIN
						ReportTimePoint sp ON sp.ID = @startPointID JOIN
						ReportTimePoint ep ON ep.ID = @endPointID LEFT JOIN
						DisciplineIncident di ON di.StudentID = i.StudentID AND 
							(@dispositionID IS NULL OR di.DispositionCodeID = @dispositionID) AND
								NOT(i.EndDate IS NULL AND (sp.Value IS NULL OR ep.Value IS NULL)) AND
								(i.EndDate IS NULL OR sp.Value IS NULL OR DATEADD(DAY, sp.Value, i.StartDate) <= i.EndDate) AND
								(i.EndDate IS NULL OR ep.Value IS NULL OR DATEADD(DAY, ep.Value, i.StartDate) <= i.EndDate) AND
								di.Date >= DATEADD(DAY, -@daysSurroundingTimeRange, ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.StartDate)) AND
								(i.EndDate IS NULL OR di.Date <= DATEADD(DAY, @daysSurroundingTimeRange, ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.EndDate)))
					WHERE ep.Value IS NULL OR 
						sp.Value <= ep.Value 	
					GROUP BY i.ID, i.StartDate, i.EndDate, i.PlannedEndDate, sp.ID, sp.Value, ep.ID, ep.Value)c )c )c) c) c) c
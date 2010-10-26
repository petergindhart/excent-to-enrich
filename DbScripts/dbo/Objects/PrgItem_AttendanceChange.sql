IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItem_AttendanceChange]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[PrgItem_AttendanceChange]
GO

CREATE FUNCTION PrgItem_AttendanceChange(@startPointID uniqueidentifier, @endPointID uniqueidentifier, @daysSurroundingTimeRange int, @absenceReasonID uniqueidentifier)
RETURNS TABLE
AS
RETURN 
SELECT c.*, @absenceReasonID AS AbsenceReasonID, @daysSurroundingTimeRange as DaysSurroundingTimeRange,
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
			c.AbsencesAfterTimeRange - c.AbsencesBeforeTimeRange AS Change,
			CASE
			WHEN c.AbsencesBeforeTimeRange = 0 THEN NULL
				ELSE (c.AbsencesAfterTimeRange - c.AbsencesBeforeTimeRange)/CAST(c.AbsencesBeforeTimeRange AS FLOAT)*100
			END AS ChangePercent
		FROM  
			(SELECT c.*,
				c.AbsencesPerDayBeforeTimeRange*7 AS AbsencesPerWeekBeforeTimeRange,
				c.AbsencesPerDayInTimeRange*7 AS AbsencesPerWeekInTimeRange,
				c.AbsencesPerDayAfterTimeRange*7 AS AbsencesPerWeekAfterTimeRange
			FROM
				(SELECT c.*,
					CASE
						WHEN @daysSurroundingTimeRange = 0 THEN c.AbsencesBeforeTimeRange
						ELSE c.AbsencesBeforeTimeRange / CAST(@daysSurroundingTimeRange AS FLOAT)
					END AS AbsencesPerDayBeforeTimeRange,
					CASE
						WHEN c.DaysInTimeRange = 0 THEN c.AbsencesInTimeRange
						ELSE c.AbsencesInTimeRange / CAST(c.DaysInTimeRange AS FLOAT)
					END AS AbsencesPerDayInTimeRange,
					CASE
						WHEN @daysSurroundingTimeRange = 0 THEN c.AbsencesAfterTimeRange
						ELSE c.AbsencesAfterTimeRange / CAST(@daysSurroundingTimeRange AS FLOAT)
					END AS AbsencesPerDayAfterTimeRange,
					DaysInTimeRange/7 AS WeeksInTimeRange
				FROM
					(SELECT c.*, 
						CAST(DATEDIFF(DAY,c.StartDateOfTimeRange,c.EndDateOfTimeRange)+1 AS FLOAT) AS DaysInTimeRange
					FROM
						(SELECT i.ID AS ItemID,  
						SUM(CASE
								WHEN a.Date < ISNULL(DATEADD(DAY, sp.Value, i.StartDate), i.EndDate) THEN 1
								ELSE 0 
							END) AS AbsencesBeforeTimeRange,
						sp.ID as StartPointID, 
						ISNULL(ISNULL(DATEADD(DAY, sp.Value, i.StartDate), i.EndDate),i.PlannedEndDate) AS StartDateOfTimeRange,
						SUM(CASE
							WHEN a.Date >= ISNULL(DATEADD(DAY, sp.Value, i.StartDate), i.EndDate) AND
								a.Date <= ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.EndDate) THEN 1
							ELSE 0 
						END) AS AbsencesInTimeRange,
						ep.ID as EndPointId,
						ISNULL(ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.EndDate),i.PlannedEndDate) AS EndDateOfTimeRange,
						SUM(CASE
								WHEN a.Date > ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.EndDate) THEN 1
								ELSE 0 
							END) AS AbsencesAfterTimeRange
						FROM PrgItem i JOIN
							ReportTimePoint sp ON sp.ID = @startPointID JOIN
							ReportTimePoint ep ON ep.ID = @endPointID LEFT JOIN
							Absence a ON a.StudentID = i.StudentID AND 
								(@absenceReasonID IS NULL OR a.ReasonID = @absenceReasonID) AND
								NOT(i.EndDate IS NULL AND (sp.Value IS NULL OR ep.Value IS NULL)) AND
								(i.EndDate IS NULL OR sp.Value IS NULL OR DATEADD(DAY, sp.Value, i.StartDate) <= i.EndDate) AND
								(i.EndDate IS NULL OR ep.Value IS NULL OR DATEADD(DAY, ep.Value, i.StartDate) <= i.EndDate) AND
								a.Date >= DATEADD(DAY, -@daysSurroundingTimeRange, ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.StartDate)) AND
								(i.EndDate IS NULL OR a.Date <= DATEADD(DAY, @daysSurroundingTimeRange, ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.EndDate)))
						WHERE ep.Value IS NULL OR 
						sp.Value <= ep.Value 				
						GROUP BY i.ID, i.StartDate, i.EndDate, i.PlannedEndDate, sp.ID, sp.Value, ep.ID, ep.Value) c) c) c) c) c) c
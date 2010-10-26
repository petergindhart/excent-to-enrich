IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItem_ProbeScoreChange]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[PrgItem_ProbeScoreChange]
GO

CREATE FUNCTION PrgItem_ProbeScoreChange(@startPointID uniqueidentifier, @endPointID uniqueidentifier, @probeTypeID uniqueidentifier)
RETURNS TABLE
AS
RETURN 
SELECT c.*,
	c.ChangePerDay*7 AS ChangePerWeek,
	c.ChangePerDayPercent*7 AS ChangePerWeekPercent
FROM
	(SELECT c.*,
		CASE 
			WHEN c.DaysBetweenScores = 0 THEN c.Change
			ELSE c.Change/c.DaysBetweenScores
		END AS ChangePerDay,
		CASE 
			WHEN c.DaysBetweenScores = 0 THEN c.ChangePercent
			ELSE c.ChangePercent/c.DaysBetweenScores
		END AS ChangePerDayPercent,
		DaysBetweenScores/7 AS WeeksBetweenScores	
	FROM
		(SELECT c.*,
			CAST(ABS(DATEDIFF(DAY,t1.DateTaken,c.StartDateOfTimeRange))+1 AS FLOAT) AS DaysBetweenStartPointAndScore,
			CAST(ABS(DATEDIFF(DAY,t2.DateTaken,c.EndDateOfTimeRange))+1 AS FLOAT) AS DaysBetweenEndPointAndScore,
			CAST(ABS(DATEDIFF(DAY,t1.DateTaken,t2.DateTaken))+1 AS FLOAT) AS DaysBetweenScores,
			ty.IncreaseIsBetter AS ScoreIncreaseIsBetter,
			CASE
				WHEN s1.RubricValueID IS NOT NULL AND s2.RubricValueID IS NOT NULL THEN CAST(r2.Sequence - r1.Sequence AS FLOAT)
				WHEN s1.NumericValue IS NOT NULL AND s2.NumericValue IS NOT NULL THEN CAST(s2.NumericValue - s1.NumericValue AS FLOAT)
				WHEN s1.RatioPartValue IS NOT NULL AND s1.RatioOutOfValue IS NOT NULL 
					THEN (s2.RatioPartValue/CAST(s2.RatioOutOfValue AS FLOAT))-(s1.RatioPartValue/CAST(s1.RatioOutOfValue AS FLOAT))
			END AS Change,
			CASE
				WHEN s1.RubricValueID IS NOT NULL AND s2.RubricValueID IS NOT NULL THEN CAST((r2.Sequence + 1) - (r1.Sequence +1) AS FLOAT)/(r1.Sequence+1)*100 --Accounts for zero based index
				WHEN s1.NumericValue IS NOT NULL AND s2.NumericValue IS NOT NULL AND s1.NumericValue <> 0 THEN CAST(s2.NumericValue - s1.NumericValue AS FLOAT)/s1.NumericValue*100
				WHEN s1.RatioPartValue IS NOT NULL AND s1.RatioOutOfValue IS NOT NULL AND s1.RatioPartValue/CAST(s1.RatioOutOfValue AS FLOAT) <> 0
					THEN ((s2.RatioPartValue/CAST(s2.RatioOutOfValue AS FLOAT))-(s1.RatioPartValue/CAST(s1.RatioOutOfValue AS FLOAT)))
						/(s1.RatioPartValue/CAST(s1.RatioOutOfValue AS FLOAT))
						*100
				ELSE NULL
			END AS ChangePercent,
			t1.DateTaken AS StartScoreDate,
			CASE
				WHEN s1.RubricValueID IS NOT NULL THEN r1.Name
				WHEN s1.NumericValue IS NOT NULL THEN CAST(s1.NumericValue AS VARCHAR)
				WHEN s1.RatioPartValue IS NOT NULL AND s1.RatioOutOfValue IS NOT NULL THEN (CAST(s1.RatioPartValue AS VARCHAR) + ' out of ' + CAST(s1.RatioOutOfValue AS VARCHAR))
			END AS StartScore,
			CASE
				WHEN s1.RubricValueID IS NOT NULL THEN r1.Sequence +1
				WHEN s1.NumericValue IS NOT NULL THEN s1.NumericValue
				WHEN s1.RatioPartValue IS NOT NULL AND s1.RatioOutOfValue IS NOT NULL THEN (s1.RatioPartValue/CAST(s1.RatioOutOfValue AS FLOAT)) 
			END AS StartScoreValue,
			t2.DateTaken AS EndScoreDate,
			CASE
				WHEN s2.RubricValueID IS NOT NULL THEN r2.Name
				WHEN s2.NumericValue IS NOT NULL THEN CAST(s2.NumericValue AS VARCHAR)
				WHEN s2.RatioPartValue IS NOT NULL AND s2.RatioOutOfValue IS NOT NULL THEN (CAST(s2.RatioPartValue AS VARCHAR) + ' out of ' + CAST(s2.RatioOutOfValue AS VARCHAR))
			END AS EndScore,
			CASE
				WHEN s2.RubricValueID IS NOT NULL THEN r2.Sequence +1
				WHEN s2.NumericValue IS NOT NULL THEN s2.NumericValue
				WHEN s2.RatioPartValue IS NOT NULL AND s2.RatioOutOfValue IS NOT NULL THEN (s2.RatioPartValue/CAST(s2.RatioOutOfValue AS FLOAT))
			END AS EndScoreValue
		FROM
			(SELECT i.ID AS ItemID, @probeTypeID as ProbeTypeID, sp.ID as StartPointID, ep.ID as EndPointID,
			ISNULL(ISNULL(DATEADD(DAY, sp.Value, i.StartDate), i.EndDate),i.PlannedEndDate) AS StartDateOfTimeRange,
			ISNULL(ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.EndDate),i.PlannedEndDate) AS EndDateOfTimeRange,
			(SELECT TOP 1 s.ID
					FROM ProbeScore s JOIN 
					ProbeTime t ON t.ID = s.ProbeTimeID AND 
						t.StudentID = i.StudentID AND
						t.ProbeTypeID = @probeTypeID LEFT JOIN
					ProbeRubricValue r ON r.ID = s.RubricValueID 
					WHERE (ep.Value IS NULL AND i.EndDate IS NULL AND i.PlannedEndDate IS NULL) OR
						t.DateTaken <= ISNULL(ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.EndDate),i.PlannedEndDate) --Start Score Should not come after end point
					ORDER BY ABS(DATEDIFF(DAY,t.DateTaken,ISNULL(ISNULL(DATEADD(DAY, sp.Value, i.StartDate), i.EndDate),i.PlannedEndDate))) ASC,
						CASE
							WHEN sp.Value IS NULL AND i.EndDate IS NULL AND i.PlannedEndDate IS NULL THEN DateTaken
							ELSE 0
						END DESC,
						CASE
							WHEN t.DateTaken > ISNULL(ISNULL(DATEADD(DAY, sp.Value, i.StartDate), i.EndDate),i.PlannedEndDate) THEN s.Sequence * -1
							ELSE s.Sequence		
						END DESC,
						CASE
							WHEN RubricValueID IS NOT NULL THEN r.Sequence
							WHEN s.NumericValue IS NOT NULL THEN s.NumericValue
							WHEN s.RatioPartValue IS NOT NULL AND s.RatioOutOfValue IS NOT NULL THEN s.RatioPartValue/CAST(s.RatioOutOfValue AS FLOAT)
							ELSE s.Sequence
						END ASC) as StartScoreID,
			(SELECT TOP 1 s.ID
					FROM ProbeScore s JOIN 
					ProbeTime t ON t.ID = s.ProbeTimeID AND 
						t.StudentID = i.StudentID AND
						t.ProbeTypeID = @probeTypeID LEFT JOIN
					ProbeRubricValue r ON r.ID = s.RubricValueID 
					WHERE (sp.Value IS NULL AND i.EndDate IS NULL AND i.PlannedEndDate IS NULL) OR
						t.DateTaken >= ISNULL(ISNULL(DATEADD(DAY, sp.Value, i.StartDate), i.EndDate),i.PlannedEndDate) --End Score Should not come before start point
					ORDER BY ABS(DATEDIFF(DAY,t.DateTaken,ISNULL(ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.EndDate),i.PlannedEndDate))) ASC,
						CASE
							WHEN ep.Value IS NULL AND i.EndDate IS NULL AND i.PlannedEndDate IS NULL THEN t.DateTaken
							ELSE 0
						END DESC,
						CASE
							WHEN t.DateTaken > ISNULL(ISNULL(DATEADD(DAY, ep.Value, i.StartDate), i.EndDate),i.PlannedEndDate) THEN s.Sequence * -1
							ELSE s.Sequence		
						END DESC,
						CASE
							WHEN RubricValueID IS NOT NULL THEN r.Sequence
							WHEN s.NumericValue IS NOT NULL THEN s.NumericValue
							WHEN s.RatioPartValue IS NOT NULL AND s.RatioOutOfValue IS NOT NULL THEN s.RatioPartValue/CAST(s.RatioOutOfValue AS FLOAT)
							ELSE s.Sequence
						END DESC) as EndScoreID	
			FROM 
				PrgItem i JOIN
				ReportTimePoint sp ON sp.ID = @startPointID JOIN
				ReportTimePoint ep ON ep.ID = @endPointID
			WHERE ep.Value IS NULL OR 
				sp.Value <= ep.Value) c JOIN
		ProbeType ty ON ty.ID = @probeTypeID LEFT JOIN
		ProbeScore s1 ON s1.ID = c.StartScoreID LEFT JOIN
		ProbeTime t1 on t1.ID = s1.ProbeTimeID LEFT JOIN
		ProbeRubricValue r1 ON r1.ID = s1.RubricValueID LEFT JOIN
		ProbeScore s2 ON s2.ID = c.EndScoreID LEFT JOIN
		ProbeTime t2 on t2.ID = s2.ProbeTimeID LEFT JOIN
		ProbeRubricValue r2 ON r2.ID = s2.RubricValueID) c) c 
IF OBJECT_ID(N'dbo.IntvGoalView', 'V') IS NOT NULL
	DROP VIEW dbo.IntvGoalView
GO

CREATE VIEW IntvGoalView
AS
SELECT g.*, 
	LastProbeDate,
	ProbeDueDate,
	CASE
		WHEN g.RubricTargetID IS NOT NULL THEN r.Sequence +1
		WHEN g.NumericTarget IS NOT NULL THEN g.NumericTarget
		WHEN g.RatioPartTarget IS NOT NULL AND g.RatioOutOfTarget IS NOT NULL AND g.RatioOutOfTarget <> 0 THEN (g.RatioPartTarget/CAST(g.RatioOutOfTarget AS FLOAT)) 
	END AS Target,
	CASE
		WHEN g.RubricTargetID IS NOT NULL THEN r.Name
		WHEN g.NumericTarget IS NOT NULL THEN CAST(g.NumericTarget AS VARCHAR)
		WHEN g.RatioPartTarget IS NOT NULL AND g.RatioOutOfTarget IS NOT NULL THEN (CAST(g.RatioPartTarget AS VARCHAR) + ' out of ' + CAST(g.RatioOutOfTarget AS VARCHAR))
		WHEN g.Description IS NOT NULL THEN g.Description
	END AS TargetDescription 
FROM
	(SELECT
		gb.ID,
		LastProbeDate,
		CASE
			WHEN DaysBetweenProbes IS NULL OR DaysBetweenProbes <= 0 OR	EndDate IS NOT NULL THEN NULL 
			WHEN LastProbeDate IS NULL THEN StartDate
			WHEN PlannedEndDate IS NOT NULL AND DATEADD(d, DaysBetweenProbes, LastProbeDate) > PlannedEndDate THEN NULL
			ELSE DATEADD(d, DaysBetweenProbes, LastProbeDate) 
		END AS ProbeDueDate
	FROM
		(SELECT
			g.ID,
			g.DaysBetweenProbes,
			ii.StartDate,
			ii.PlannedEndDate, 
			ii.EndDate,
			CASE
				WHEN MAX(t.DateTaken) IS NULL THEN NULL
				WHEN MAX(t.DateTaken) > ii.StartDate THEN MAX(t.DateTaken)
				ELSE ii.StartDate 
			END AS LastProbeDate
		FROM
			PrgItem ii JOIN
			PrgIntervention intv ON intv.ID = ii.ID JOIN
			IntvGoal g ON g.InterventionID = ii.ID LEFT JOIN
			ProbeScore bl on bl.ID = g.BaselineScoreID LEFT JOIN
			ProbeTime bt on bt.ID = bl.ProbeTimeID LEFT JOIN
			ProbeTime t ON 
				(t.ProbeTypeID = g.ProbeTypeID AND 
				t.StudentID = ii.StudentID AND
				(
					(bt.DateTaken IS NOT NULL AND 
					bt.DateTaken < ii.StartDate AND 
					dbo.DateInRangeAdvanced(t.DateTaken,bt.DateTaken,ii.EndDate,1) = 1)
				OR
					((bt.DateTaken IS NULL OR 
						bt.DateTaken >= ii.StartDate) AND 
					dbo.DateInRangeAdvanced(t.DateTaken,ii.StartDate,ii.EndDate,1) = 1)
				))
		GROUP BY g.ID, g.DaysBetweenProbes, ii.StartDate, ii.PlannedEndDate, ii.EndDate) gb) gb JOIN
		IntvGoal g ON g.ID = gb.ID LEFT JOIN
		ProbeRubricValue r ON r.ID = g.RubricTargetID
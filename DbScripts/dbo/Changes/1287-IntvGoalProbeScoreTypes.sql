EXEC sp_RENAME 'IntvGoal.Value', 'NumericTarget', 'COLUMN'

ALTER TABLE IntvGoal
ALTER COLUMN NumericTarget FLOAT

ALTER TABLE IntvGoal
ADD RubricTargetID UNIQUEIDENTIFIER

ALTER TABLE IntvGoal
ADD RatioPartTarget FLOAT

ALTER TABLE IntvGoal
ADD RatioOutOfTarget FLOAT

ALTER TABLE IntvGoal ADD CONSTRAINT
	FK_IntvGoal#RubricTarget# FOREIGN KEY
	(
		RubricTargetID
	) 
	REFERENCES ProbeRubricValue
	(
		ID
	)
	
ALTER TABLE IntvGoal
ADD BaselineScoreID UNIQUEIDENTIFIER

ALTER TABLE IntvGoal ADD CONSTRAINT
	FK_IntvGoal#BaselineScore#Goals FOREIGN KEY
	(
		BaselineScoreID
	) 
	REFERENCES ProbeScore
	(
		ID
	)
GO

UPDATE g
SET g.BaselineScoreID = 
	(SELECT TOP 1 s.ID
	FROM ProbeScore s JOIN
		ProbeTime t ON t.ID = s.ProbeTimeID
	WHERE t.StudentID = i.StudentID AND
		t.DateTaken = g.BaselineDate AND
		s.NumericValue IS NOT NULL
	ORDER BY ABS(g.BaselineScore - s.NumericValue), s.ID)
FROM IntvGoal g JOIN
	PrgItem i ON i.ID = g.InterventionID
WHERE g.BaselineScore IS NOT NULL AND
g.BaselineDate IS NOT NULL
GO
	
ALTER TABLE IntvGoal
DROP COLUMN BaselineScore

ALTER TABLE IntvGoal
DROP COLUMN BaselineDate
GO

UPDATE IndSource
SET SqlText = 
	'SELECT
			[Instance] = g.ID,
			[Date] = t.DateTaken, 
			[EndedDate] = i.EndedDate, 
			[Target] = g.Target,
			[Score] = s.NumericValue, 
			[Value] = s.NumericValue - 
						(((g.Target - bl.Value) / (CAST(i.PlannedEndDate AS INT) - CAST(blt.DateTaken AS INT))) 
							* (CAST(t.DateTaken AS INT) - CAST(blt.DateTaken AS INT)) 
							+ bl.Value)
		FROM
			IntvGoalView g JOIN
			PrgItem i ON i.ID = g.InterventionID JOIN 
			ProbeScoreView bl ON g.BaselineScoreID = bl.ID JOIN
			ProbeTime blt on blt.ID = bl.ProbeTimeID JOIN
			ProbeTime t ON 
				g.ProbeTypeID = t.ProbeTypeID AND
				t.StudentID = i.StudentID AND
				t.DateTaken >= dbo.DateMin(blt.DateTaken, i.StartDate) AND
				(i.EndDate is null OR t.DateTaken <= i.EndDate)
			JOIN
			ProbeScoreView s ON s.ProbeTimeID = t.ID'
WHERE ID = 'CEB90D38-4868-4DF6-8548-649CAA8FBA3E'

ALTER TABLE IntvGoal
ALTER COLUMN RatioPartTarget INT

ALTER TABLE IntvGoal
ALTER COLUMN RatioOutOfTarget INT
GO
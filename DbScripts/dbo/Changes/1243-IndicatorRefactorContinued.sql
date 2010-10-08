

update IndTarget set ColumnName='g.ID' where ID='28D8F558-8C27-42BA-807C-57E005355659'


UPDATE IndSource
SET SqlText = 
	'SELECT
		[Instance] = g.ID,
		[Date] = t.DateTaken, 
		[EndedDate] = i.EndedDate, 
		[Target] = g.Value,
		[Score] = s.NumericValue, 
		[Value] = s.NumericValue - 
					(((g.Value - g.BaselineScore) / (CAST(i.PlannedEndDate AS INT) - CAST(g.BaselineDate AS INT))) 
						* (CAST(t.DateTaken AS INT) - CAST(g.BaselineDate AS INT)) 
						+ g.BaselineScore)
	FROM
		IntvGoal g JOIN
		PrgItem i ON i.ID = g.InterventionID JOIN 
		ProbeTime t ON 
			g.ProbeTypeID = t.ProbeTypeID AND
			t.StudentID = i.StudentID AND
			t.DateTaken >= dbo.DateMin(g.BaselineDate, i.StartDate) AND
			(i.EndDate is null OR t.DateTaken <= i.EndDate)
		JOIN
		ProbeScore s ON s.ProbeTimeID = t.ID 
	{filters}'
WHERE ID = 'CEB90D38-4868-4DF6-8548-649CAA8FBA3E'
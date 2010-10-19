
update IndSource 
set SqlText =
'SELECT
	[Instance] = g.ID,
	[Date] = t.DateTaken, 
	[EndedDate] = i.EndedDate, 
	[Target] = (case when ptype.IncreaseIsBetter = 1 then 1.0 else -1.0 end) * g.Target,
	[Score] = (case when ptype.IncreaseIsBetter = 1 then 1.0 else -1.0 end) * s.Value, 
	[Value] = (case when ptype.IncreaseIsBetter = 1 then 1.0 else -1.0 end) *  
				(s.Value - 
				(((g.Target - bl.Value) / (CAST(i.PlannedEndDate AS INT) - CAST(blt.DateTaken AS INT))) 
					* (CAST(t.DateTaken AS INT) - CAST(blt.DateTaken AS INT)) 
					+ bl.Value))
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
	ProbeScoreView s ON s.ProbeTimeID = t.ID JOIN
	ProbeType ptype on ptype.ID = t.ProbeTypeID
{filters}'
where ID='CEB90D38-4868-4DF6-8548-649CAA8FBA3E'


update IndType set Name='Consecutive Probes Meet Target',				DisplayFormat='{Value} scores meet target' where id='66F53F04-7032-4336-B427-095892F4DAD0'
update IndType set Name='Consecutive Probes Exceed Goal Line',			DisplayFormat='{Value} scores exceed goal line' where  id='D50F69D9-02B5-4CF0-AF3B-C179F859F42E'
update IndType set Name='Consecutive Probes Fall Short Of Goal Line',	DisplayFormat='{Value} scores fall short of goal line' where id='590DB328-FBBD-4263-BB01-6FF752ED5C81'

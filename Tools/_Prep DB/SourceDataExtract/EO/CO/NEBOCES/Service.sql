declare @g uniqueidentifier ; select @g = GSTudentID from Student where StudentID = '1170699031'
select -- s.Firstname, s.Lastname,
	s.StudentID, v.ProvDesc, 
	ServDesc = v.SpecInstruction,
	StartDate = convert(varchar, v.StartDate, 101), EndDate = convert(varchar, v.EndDate, 101), -- v.IndirectTime, v.IndirectPer, v.DirInsideTime, v.DirInsidePer, v.DirOutTime, v.DirOutPer, v.TotalTime, v.TotalPer, v.ServFreqType 
	Direct = cast(case ServFreqType when 1 then 1 else 0 end as bit), 
	Frequency = DirInsidePer,
	ServiceTime = DirInsideTime,
	Hrs = cast(DirInsideTime/60 as int),
	Mins = DirInsideTime%60,
	Sequence = ServOrder
from ServiceTbl v
join Student s on v.GStudentID = s.GStudentID
join IEPTbl i on s.GStudentID = i.GStudentID and i.IEPComplete = 'IEPComplete'
where 1=1
-- and v.ServFreqType = 2
-- and v.EndDate > getdate()
and s.SpedStat = 1
and s.GStudentID = @g
order by ServOrder






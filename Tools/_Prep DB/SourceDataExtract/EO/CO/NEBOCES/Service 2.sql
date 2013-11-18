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





	-- special ed services 
	select 
	   		LookupOrder = cast(7 as int),
			Type = 'Service', 
			SubType = 'SpecialEd', 
			Code = SpecInstruction,
			Label = SpecInstruction,
			StateCode = '',
			Sequence = cast(0 as int) 
	from ServiceTbl 
	where SpecInstruction is not null
	and enddate > getdate()
	and (ProvDesc like 'Special Education%Teacher%' or ProvDesc in ('Aide', 'Resource')) -- these servprovs provide sped services, not related
	group by SpecInstruction
	having count(*) > 2

	UNION ALL

	-- related services 
	select 
	   		LookupOrder = cast(8 as int),
			Type = 'Service', 
			SubType = 'Related', 
			Code = SpecInstruction,
			Label = SpecInstruction,
			StateCode = '',
			Sequence = cast(0 as int) 	
	from ServiceTbl 
	where SpecInstruction is not null
	and enddate > getdate()
	and ProvDesc not like 'Special Education%Teacher%' and ProvDesc not in ('Aide', 'Resource') -- these servprovs provide sped services, not related
	group by SpecInstruction
	having count(*) > 2 -- pick a reasonable number to trim the number of rows returned.  services not in this list will be listed as 





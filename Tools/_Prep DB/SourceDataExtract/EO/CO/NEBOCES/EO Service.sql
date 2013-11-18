set nocount on;
set ansi_warnings off;

declare @i table (IEPSeqNum int not null primary key, MeetDate datetime not null)
declare @p table (Code varchar(100) not null, Label varchar(100) not null)
declare @t table (StaffID varchar(50), email varchar(100))

insert @p
select distinct k.LookupDesc, k.LookupDesc from @i i join ICServiceTbl v on i.IEPSeqNum = v.IEPComplSeqNum join DescLook k on v.ProvDesc = k.LookupDesc where k.UsageID = 'Title'

insert @i
select x.IEPSeqNum, x.MeetDate from SpecialEdStudentsAndIEPs x

insert @t
select StaffID, StaffEmail = isnull(t.Email,'') from Staff t where isnull(t.email,'') <> ''
and t.email not in (select de.email from staff de where isnull(de.del_flag,0)=0 group by de.email having count(*) > 1)
and isnull(t.del_flag,0)= (
	select min(isnull(convert(tinyint,delmin.del_flag),0))
	from Staff delmin
	where t.email = delmin.email 
	and delmin.staffgid = (
		select min(convert(varchar(36), stmin.staffgid))
		from Staff stmin
		where delmin.email = stmin.email 
		)
	)
and isnull(t.del_flag,0)= (
	select min(isnull(convert(tinyint,delmin.del_flag),0))
	from Staff delmin
	where t.staffid = delmin.staffid
	and delmin.staffgid = (
		select min(convert(varchar(36), stmin.staffgid))
		from Staff stmin
		where delmin.staffid = stmin.staffid
		)
	)


--select * from (
--	select 
--		Seq = cast(1 as int),
--		ServiceRefID = ServSeqNum, 
--		IEPRefID = IEPComplSeqNum,
--		Type = 'SpecialEd', 
--		ServiceDefinitionCode = isnull(SpecInstruction,'')
--	from ICServiceTbl 
--	where enddate > getdate()
--	and (ProvDesc like 'Special Education%Teacher%' or ProvDesc in ('Aide', 'Resource')) -- these servprovs provide sped services, not related
--	and isnull(del_flag,0)=0 
--	UNION ALL
--	-- related services 
--	select 
--		Seq = 2,
--		ServiceRefID = ServSeqNum, 
--		IEPComplSeqNum,
--		Type = 'Related', 
--		ServiceDefinitionCode = isnull(SpecInstruction,'')
--	from ICServiceTbl 
--	where enddate > getdate()
--	and ProvDesc not like 'Special Education%Teacher%' and ProvDesc not in ('Aide', 'Resource') -- these servprovs provide sped services, not related
--	and isnull(del_flag,0)=0 
--) t where ServiceRefID = 7263

	--s.StudentID, v.ProvDesc, 
	--ServDesc = v.SpecInstruction,
	--StartDate = convert(varchar, v.StartDate, 101), EndDate = convert(varchar, v.EndDate, 101), -- v.IndirectTime, v.IndirectPer, v.DirInsideTime, v.DirInsidePer, v.DirOutTime, v.DirOutPer, v.TotalTime, v.TotalPer, v.ServFreqType 
	--Direct = cast(case ServFreqType when 1 then 1 else 0 end as bit), 
	--Frequency = DirInsidePer,
	--ServiceTime = DirInsideTime,
	--Hrs = cast(DirInsideTime/60 as int),
	--Mins = DirInsideTime%60,
	--Sequence = ServOrder

--select top 1 * from ICServiceTbl

select 
	ServiceType = v.Type, 
	x.ServiceRefId, 
	x.IEPRefID,
	x.ServiceDefinitionCode, 
	BeginDate = convert(varchar, v.StartDate, 101), 
	EndDate = convert(varchar, v.EndDate, 101), 
	IsRelated = case when x.Type = 'Related' then 1 else 0 end,
	IsDirect = cast(case v.ServFreqType when 1 then 1 else 0 end as bit), 
	ExcludesFromGenEd = cast(0 as bit), 
	ServiceLocationCode = 'ZZZ', 
	Sequence = ServOrder, 
	IsEsy = cast(0 as bit), 
	ServiceTime = cast(v.DirInsideTime as int), 
	ServiceFrequencyCode = isnull(sf.Code,'ZZZ'), 
	ServiceAreaText = isnull(v.SpecInstruction,''),
	ServiceProviderTitleCode = v.ProvDesc,
	StaffEmail = isnull(t.email,'') --------------------------- we did not get any providers for NE BOCES
from @i i 
JOIN  (
	-- special ed services
	select 
		Seq = cast(1 as int),
		ServiceRefID = ServSeqNum, 
		IEPRefID = IEPComplSeqNum,
		Type = 'SpecialEd', 
		ServiceDefinitionCode = isnull(SpecInstruction,'')
	from ICServiceTbl 
	where enddate > getdate()
	and (ProvDesc like 'Special Education%Teacher%' or ProvDesc in ('Aide', 'Resource')) -- these servprovs provide sped services, not related
	and isnull(del_flag,0)=0 
	UNION ALL
	-- related services 
	select 
		Seq = 2,
		ServiceRefID = ServSeqNum, 
		IEPComplSeqNum,
		Type = 'Related', 
		ServiceDefinitionCode = isnull(SpecInstruction,'')
	from ICServiceTbl 
	where enddate > getdate()
	and ProvDesc not like 'Special Education%Teacher%' and ProvDesc not in ('Aide', 'Resource') -- these servprovs provide sped services, not related
	and isnull(del_flag,0)=0 
	-- 1233 for the union query
	) x on i.IEPSeqNum = x.IEPRefID
JOIN ICServiceTbl v on x.IEPRefID = v.IEPComplSeqNum and x.ServiceRefID = v.ServSeqNum 
LEFT JOIN CodeDescLook sf on v.DirInsidePer = sf.LookDesc and sf.UsageID = 'ServPer'
LEFT JOIN @t t on v.ProvCode = t.StaffId
-- 

--select StartDate, ProvCode from ServiceTbl order by StartDate desc
--select * from ServiceTbl order by StartDate desc

--select * from ServiceTbl order by ServSeqNum desc




---- special ed services 
--select 
--	ServiceRefID = ServSeqNum, 
--	IepRefID = IEPComplSeqNum,
--	Type = 'SpecialEd', 
--	ServiceDefinitionCode = isnull(SpecInstruction,'')
--from ICServiceTbl 
--where enddate > getdate()
--and (ProvDesc like 'Special Education%Teacher%' or ProvDesc in ('Aide', 'Resource')) -- these servprovs provide sped services, not related
--UNION ALL
---- related services 
--select 
--	ServiceRefID = ServSeqNum, 
--	IepRefID = IEPComplSeqNum,
--	Type = 'Related', 
--	ServiceDefinitionCode = isnull(SpecInstruction,'')
--from ICServiceTbl 
--where enddate > getdate()
--and ProvDesc not like 'Special Education%Teacher%' and ProvDesc not in ('Aide', 'Resource') -- these servprovs provide sped services, not related







-----  prov


--select 
--	   	LookupOrder = cast(13 as int),
--		Type = 'ServProv', 
--		SubType = '', 
--		Code = ProvDesc,
--		Label = ProvDesc,
--		StateCode = '',
--		Sequence = cast(0 as int) 	
--from ServiceTbl 
--where SpecInstruction is not null
--and enddate > getdate()
---- and ProvDesc not like 'Special Education%Teacher%' and ProvDesc not in ('Aide', 'Resource') -- these servprovs provide sped services, not related
--group by ProvDesc 
--having count(*) > 2 -- pick a reasonable number to trim the number of rows returned.  services not in this list will be listed as 










--select 	distinct
--	ServiceType = v.Type, 
--	v.ServiceRefId, 
--	v.IEPRefID,
--	v.ServiceDefinitionCode, 
--	BeginDate = convert(varchar, v.BeginDate, 101), 
--	EndDate = convert(varchar, v.EndDate, 101), 
--	IsRelated = case when v.IsRelated = 1 then 'Y' else 'N' end, 
--	IsDirect = case when v.IsDirect = 1 then 'Y' else 'N' end, 
--	ExcludesFromGenEd = case when v.ExcludesFromGenEd = 1 then 'Y' else 'N' end, 
--	ServiceLocationCode = case isnull(v.ServiceLocationCode,'') when '' then 'ZZZ' else v.ServiceLocationCode end, 
--	ServiceProviderTitleCode = isnull(v.ProvDesc,''), 
--	Sequence = isnull(v.Sequence,0), 
--	IsESY = case when v.IsEsy = 1 then 'Y' else 'N' end, 
--	v.ServiceTime, 
--	ServiceFrequencyCode = v.ServiceFrequencyCode,
--	ServiceProviderSSN = '', 
--	StaffEmail = isnull(v.StaffEmail, ''),
--	-- v.ServiceAreaCode, 
--	ServiceAreaText = isnull(convert(varchar(254), v.ServiceAreaText),'') -- v.ServiceProviderRefId, v.ServiceProviderCode, v.ServiceProviderSSN
--from (
--	select 
--		Type = 'SpecialEd',
--		ServiceRefID = v.ServSeqNum, 
--		IepRefID = v.IEPComplSeqNum, 
--		ServiceDefinitionCode = 'ZZZ', 
--		BeginDate = isnull(v.StartDate, dateadd(dd, 1, i.MeetDate)), -- select top 10 * from ServiceTbl where gstudentid = '0D2173AE-A416-4C12-A5F8-D6D4B016EFF2' -- select * from student where gstudentid = '0D2173AE-A416-4C12-A5F8-D6D4B016EFF2'
--		EndDate = isnull(v.EndDate, dateadd(dd, -1, dateadd(yy, 1, i.MeetDate))),
--		IsRelated = cast(0 as bit), -- there are no related services in EO CO Poudre
--		IsDirect = v.ServFreqType, 
--		ExcludesFromGenEd = cast(0 as bit), 
--		ServiceLocationCode = '', 
--		Sequence = ServOrder, 
--		IsEsy = cast(0 as bit), 
--		ServiceTime = cast(v.DirInsideTime as int), 
--		ServiceFrequencyCode = isnull(sf.Code,'ZZZ'), 
--		ServiceAreaText = v.SpecInstruction,
--		StaffTypeCode = p.Code,
--		StaffEmail = t.email
--from	@i i 
--		JOIN ICServiceTbl v on i.IEPSeqNum = v.IEPComplSeqNum  and isnull(v.del_flag,0)=0 
---- 		LEFT JOIN ServiceTimeUnit tu on v.ServiceTimeUnitCode = tu.ServiceTimeUnitCode 
--		LEFT JOIN CodeDescLook sf on v.DirInsidePer = sf.LookDesc and sf.UsageID = 'ServPer'
--		--LEFT JOIN @p p on v.ProvDesc = p.Label 
--		--LEFT JOIN @t t on v.ProvCode = t.StaffId
--) v
--order by v.IepRefID, v.Type, v.Sequence

--select v.iepcomplseqnum, v.servseqnum, count(*) tot
--from iepcompletetbl i join
--icservicetbl v on i.IEPSeqNum = v.IEPComplSeqNum
--where isnull(i.del_flag,0)=0
--group by v.iepcomplseqnum, v.servseqnum
--having count(*) > 1



---- special ed services 
--select 
--	ServiceRefID = ServSeqNum, 
--	IepRefID = IEPComplSeqNum,
--	Type = 'SpecialEd', 
--	ServiceDefinitionCode = isnull(SpecInstruction,'')
--from ICServiceTbl 
--where enddate > getdate()
--and (ProvDesc like 'Special Education%Teacher%' or ProvDesc in ('Aide', 'Resource')) -- these servprovs provide sped services, not related



--UNION ALL





---- related services 
--select 
--	LookupOrder = cast(8 as int),
--	Type = 'Service', 
--	SubType = 'Related', 
--	Code = SpecInstruction,
--	Label = SpecInstruction,
--	StateCode = '',
--	Sequence = cast(0 as int) 	
--from ServiceTbl 
--where SpecInstruction is not null
--and enddate > getdate()
--and ProvDesc not like 'Special Education%Teacher%' and ProvDesc not in ('Aide', 'Resource') -- these servprovs provide sped services, not related
--group by SpecInstruction
--having count(*) > 2 -- pick a reasonable number to trim the number of rows returned.  services not in this list will be listed as 




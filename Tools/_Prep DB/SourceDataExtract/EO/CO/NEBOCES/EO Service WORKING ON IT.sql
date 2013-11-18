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

-- select ServiceType, count(*) from (
select 
	ServiceType = x.SubType, 
	x.ServiceRefId, 
	x.IEPRefID,
	ServiceDefinitionCode = isnull(k.LegacySpedCode, 'ZZZ'), 
	BeginDate = convert(varchar, v.StartDate, 101), 
	EndDate = convert(varchar, v.EndDate, 101), 
	IsRelated = case when x.SubType = 'Related' then 1 else 0 end,
	IsDirect = cast(case v.ServFreqType when 1 then 1 else 0 end as bit), 
	ExcludesFromGenEd = cast(0 as bit), 
	ServiceLocationCode = 'ZZZ', 
	ServiceProviderTitleCode = isnull(p.LegacySpedCode, 'ZZZ'),
	Sequence = ServOrder, 
	IsEsy = cast(0 as bit), 
	ServiceTime = cast(v.DirInsideTime as int), 
	ServiceFrequencyCode = isnull(v.DirInsidePer,'ZZZ'), 
	ServiceProviderSSN = '',
	StaffEmail = isnull(t.email,''), --------------------------- we did not get any providers for NE BOCES
	ServiceAreaText = isnull(v.SpecInstruction,'')
from @i i 
JOIN  (
	-- special ed services
	select 
		Seq = cast(1 as int),
		ServiceRefID = ServSeqNum, 
		IEPRefID = IEPComplSeqNum,
		SubType = 'SpecialEd', 
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
		SubType = 'Related', 
		ServiceDefinitionCode = isnull(SpecInstruction,'')
	from ICServiceTbl 
	where enddate > getdate()
	and ProvDesc not like 'Special Education%Teacher%' and ProvDesc not in ('Aide', 'Resource') -- these servprovs provide sped services, not related
	and isnull(del_flag,0)=0 
	-- 1233 for the union query
	) x on i.IEPSeqNum = x.IEPRefID
JOIN ICServiceTbl v on x.IEPRefID = v.IEPComplSeqNum and x.ServiceRefID = v.ServSeqNum 
--LEFT JOIN CodeDescLook sf on v.DirInsidePer = sf.LookDesc and sf.UsageID = 'ServPer' --- select * from CodeDescLook where UsageID = 'ServPer' 
LEFT JOIN @t t on v.ProvCode = t.StaffId
left join EnrichSelectLists k on x.ServiceDefinitionCode = k.LegacySpedCode and k.type = 'Service' and x.SubType = k.SubType
left join EnrichSelectLists p on v.ProvDesc = p.LegacySpedCode and p.type = 'ServProv'
-- 
--) y group by ServiceFrequencyCode
--where x.ServiceDefinitionCode = 'Language Skills'
--) y group by ServiceType


-- select * from EnrichSelectLists where Type = 'Service' and SubType = 'Related' and EnrichLabel like '%Lang%'

-- select * from ICServiceTbl order by ServSeqNum desc



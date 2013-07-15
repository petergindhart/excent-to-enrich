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

select 	distinct
	ServiceType = v.Type, 
	v.ServiceRefId, 
	v.IEPRefID,
	v.ServiceDefinitionCode, 
	BeginDate = convert(varchar, v.BeginDate, 101), 
	EndDate = convert(varchar, v.EndDate, 101), 
	IsRelated = case when v.IsRelated = 1 then 'Y' else 'N' end, 
	IsDirect = case when v.IsDirect = 1 then 'Y' else 'N' end, 
	ExcludesFromGenEd = case when v.ExcludesFromGenEd = 1 then 'Y' else 'N' end, 
	ServiceLocationCode = case isnull(v.ServiceLocationCode,'') when '' then 'ZZZ' else v.ServiceLocationCode end, 
	ServiceProviderTitleCode = case isnull(v.StaffTypeCode,'') when '' then 'ZZZ' else v.StaffTypeCode end, 
	Sequence = isnull(v.Sequence,0), 
	IsESY = case when v.IsEsy = 1 then 'Y' else 'N' end, 
	v.ServiceTime, 
	ServiceFrequencyCode = v.ServiceFrequencyCode,
	ServiceProviderSSN = '', 
	StaffEmail = isnull(v.StaffEmail, ''),
	-- v.ServiceAreaCode, 
	ServiceAreaText = isnull(convert(varchar(8000), v.ServiceAreaText),'') -- v.ServiceProviderRefId, v.ServiceProviderCode, v.ServiceProviderSSN
from (
	select 
		Type = 'SpecialEd',
		ServiceRefID = v.ServSeqNum, 
		IepRefID = v.IEPComplSeqNum, 
		ServiceDefinitionCode = 'ZZZ', 
		BeginDate = isnull(v.StartDate, dateadd(dd, 1, i.MeetDate)), -- select top 10 * from ServiceTbl where gstudentid = '0D2173AE-A416-4C12-A5F8-D6D4B016EFF2' -- select * from student where gstudentid = '0D2173AE-A416-4C12-A5F8-D6D4B016EFF2'
		EndDate = isnull(v.EndDate, dateadd(dd, -1, dateadd(yy, 1, i.MeetDate))),
		IsRelated = cast(0 as bit), -- there are no related services in EO CO Poudre
		IsDirect = v.ServFreqType, 
		ExcludesFromGenEd = cast(0 as bit), 
		ServiceLocationCode = '', 
		Sequence = ServOrder, 
		IsEsy = cast(0 as bit), 
		ServiceTime = cast(v.DirInsideTime as int), 
		ServiceFrequencyCode = isnull(sf.Code,'ZZZ'), 
		ServiceAreaText = v.SpecInstruction,
		StaffTypeCode = p.Code,
		StaffEmail = t.email
from	@i i 
		JOIN ICServiceTbl v on i.IEPSeqNum = v.IEPComplSeqNum  and isnull(v.del_flag,0)=0 
-- 		LEFT JOIN ServiceTimeUnit tu on v.ServiceTimeUnitCode = tu.ServiceTimeUnitCode 
		LEFT JOIN CodeDescLook sf on v.DirInsidePer = sf.LookDesc and sf.UsageID = 'ServPer'
		LEFT JOIN @p p on v.ProvDesc = p.Label 
		LEFT JOIN @t t on v.ProvCode = t.StaffId
) v
order by v.IepRefID, v.ServiceType, v.Sequence

--select v.iepcomplseqnum, v.servseqnum, count(*) tot
--from iepcompletetbl i join
--icservicetbl v on i.IEPSeqNum = v.IEPComplSeqNum
--where isnull(i.del_flag,0)=0
--group by v.iepcomplseqnum, v.servseqnum
--having count(*) > 1


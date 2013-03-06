USE EO_SC
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Staff_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.Staff_EO
GO

CREATE VIEW dbo.Staff_EO
AS
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
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Service_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.Service_EO
GO

CREATE VIEW dbo.Service_EO
AS	
SELECT Line_No=Row_Number() OVER (ORDER BY (SELECT 1)),service.ServiceType,service.ServiceRefID,service.IepRefID, service.ServiceDefinitionCode,service.BeginDate,service.EndDate,service.IsRelated,service.IsDirect,service.ExcludesFromGenEd,service.ServiceLocationCode,service.ServiceProviderTitleCode,service.Sequence,service.IsESY,service.ServiceTime,service.ServiceFrequencyCode,service.ServiceProviderSSN,service.StaffEmail,service.ServiceAreaText
FROM (
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
	ServiceProviderSSN = NULL, 
	StaffEmail = v.StaffEmail, 
	-- v.ServiceAreaCode, 
	ServiceAreaText = convert(varchar(8000), v.ServiceAreaText)-- v.ServiceProviderRefId, v.ServiceProviderCode, v.ServiceProviderSSN
FROM (
	select 
		Type = CASE WHEN v.Type = 'S' THEN 'SpecialEd' ELSE 'Related' END,
		ServiceRefID = v.ServSeqNum, 
		IepRefID = v.IEPComplSeqNum, 
		ServiceDefinitionCode = ISNULL(v.ServCode,'ZZZ'), 
		BeginDate = isnull(v.InitDate, dateadd(dd, 1, i.MeetDate)), -- select top 10 * from ServiceTbl where gstudentid = '0D2173AE-A416-4C12-A5F8-D6D4B016EFF2' -- select * from student where gstudentid = '0D2173AE-A416-4C12-A5F8-D6D4B016EFF2'
		EndDate = isnull(v.EndDate, dateadd(dd, -1, dateadd(yy, 1, i.MeetDate))),
		IsRelated = cast(0 as bit), -- there are no related services in EO CO Poudre
		IsDirect = cast(0 as bit),
		ExcludesFromGenEd = cast(0 as bit), 
		ServiceLocationCode = ISNULL(sfloc.code, 'ZZZ'),
		Sequence = ServOrder, 
		IsEsy = cast(0 as bit), 
		ServiceTime = cast(isnull(v.DirHr,0) as int), 
		ServiceFrequencyCode = isnull(sffreq.Code,'ZZZ'), 
		ServiceAreaText = NULL,--v.SpecInstruction,
		StaffTypeCode = p.Code,
		StaffEmail = t.StaffEmail
from	( select x.IEPSeqNum, x.MeetDate from SpecialEdStudentsAndIEPs x) i 
		JOIN ICServiceTbl v on i.IEPSeqNum = v.IEPComplSeqNum  and isnull(v.del_flag,0)=0 
-- 		LEFT JOIN ServiceTimeUnit tu on v.ServiceTimeUnitCode = tu.ServiceTimeUnitCode 
		LEFT JOIN CodeDescLook sf on v.ServDesc = sf.LookDesc and sf.UsageID = 'ServPer'
		LEFT JOIN CodeDescLook sfloc on v.LocationDesc = sfloc.LookDesc and sfloc.UsageID = 'SLogPlace'
		LEFT JOIN CodeDescLook sffreq on v.Frequency = sffreq.LookDesc and sffreq.UsageID = 'SuppFrequency'
		LEFT JOIN (select distinct k.LookupDesc as code, k.LookupDesc as label from (select x.IEPSeqNum, x.MeetDate from SpecialEdStudentsAndIEPs x) i join ICServiceTbl v on i.IEPSeqNum = v.IEPComplSeqNum join DescLook k on v.ProvDesc = k.LookupDesc where k.UsageID = 'Title'
) p on v.ProvDesc = p.Label 
		LEFT JOIN dbo.Staff_EO t on v.ProvCode = t.StaffId
) v  ) service


--select v.iepcomplseqnum, v.servseqnum, count(*) tot
--from iepcompletetbl i join
--icservicetbl v on i.IEPSeqNum = v.IEPComplSeqNum
--where isnull(i.del_flag,0)=0
--group by v.iepcomplseqnum, v.servseqnum
--having count(*) > 1

--select * from ICServiceTbl
--select * from CodeDescLook 
--where UsageID = 'IEPServiceSC'

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Staff_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.Staff_EO
GO

CREATE VIEW dbo.Staff_EO
AS
select StaffID, StaffEmail = isnull(t.Email,'') from Staff t where isnull(t.email,'') <> ''
and t.email  in (select de.email from staff de where isnull(de.del_flag,0)=0 group by de.email having count(*) = 1)
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
	ServiceFrequencyCode = case isnull(v.ServiceFrequencyCode,'') when '' then 'ZZZ' else v.ServiceFrequencyCode end,
	ServiceProviderSSN = NULL, 
	StaffEmail = v.StaffEmail, 
	-- v.ServiceAreaCode, 
	ServiceAreaText = convert(varchar(8000), v.ServiceAreaText)-- v.ServiceProviderRefId, v.ServiceProviderCode, v.ServiceProviderSSN
FROM (
	select
	Type = CASE v.Type when 'S' THEN 'SpecialEd' when 'R' then 'Related' else '' END,
	ServiceRefID = v.ServSeqNum, 
	IepRefID = v.IEPComplSeqNum, 
	ServiceDefinitionCode = vd.ServCode,
	BeginDate = x.StartDate, -- SC does not use ServiceTbl for this
	EndDate = x.EndDate, -- SC does not use ServiceTbl for this
	IsRelated = case when v.Type = 'R' then 1 else 0 end,
	IsDirect = case when v.Type = 'S' then isnull(v.Include1,0) else 1 end,
	ExcludesFromGenEd = cast(0 as bit), -- derive this from location?
	ServiceLocationCode = vl.LocationCode,
	Sequence = v.ServOrder, 
	IsEsy = cast(0 as bit), -- not available in SC
	ServiceTime = vm.Amount, ---------------------  this is approximated!!
	ServiceFrequencyCode = vf.FrequencyCode, 
	ServiceAreaText = v.ServDesc, -- perhaps put the original values that were parsed in this place !!!!!!!!!
	StaffTypeCode = cast('ZZZ' as varchar(150)),
	StaffEmail = cast(NULL as varchar(100))
from SpecialEdStudentsAndIEPs x
join DataConvICServiceTbl v on x.IEPSeqNum = v.IEPComplSeqNum
left join DataConversionServiceMinutesView vm on v.IEPComplSeqNum = vm.IEPComplSeqNum and v.ServSeqNum = vm.ServSeqNum
left join DataConversionFrequencyCodeView vf on v.IEPComplSeqNum = vf.IEPComplSeqNum and v.ServSeqNum = vf.ServSeqNum
left join DataConversionServiceDefCodeView vd on v.IEPComplSeqNum = vd.IEPComplSeqNum and v.ServSeqNum = vd.ServSeqNum
left join DataConversionLocationCodeView vl on v.IEPComplSeqNum = vl.IEPComplSeqNum and v.ServSeqNum = vl.ServSeqNum

) v  ) service


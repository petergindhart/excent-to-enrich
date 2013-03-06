set nocount on;
set ansi_warnings off;

declare @gtbl table (gstudentid uniqueidentifier not null primary key, iepseqnum int)
insert @gtbl 
select distinct gstudentid, iepseqnum from SpecialEdStudentsAndIEPs

select 	
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
		Type = 
			case v.Type -- SpEd, RelServ, Personnel, Aids
				when 'SpEd' then 'SpecialEd'
				when 'RelServ' then 'Related'
				when 'Personnel' then 'Support'
				when 'Aids' then 'Supplementary'
				else ''
			end,
		ServiceRefID = v.ServSeqNum, 
		IepRefID = v.IEPComplSeqNum, 
		-- Polk had some duplicates with different codes.  Here we combine them.  For ServCode 18 we change to 20 because 18 used to be Speech Therapy, but now 20 is used.
		ServiceDefinitionCode = 
				isnull(
					case v.Type 
						when 'SpEd' then case isnull(v.ServCode,'') when '39' then '12' when '40' then '13' when '41' then '14' when '18' then '20' when '' then 'ZZZ' else v.ServCode end
						-- when 'RelServ' then 'xxx' else v.ServCode end 
						when 'Aids' then case isnull(v.ServCode,'') when '' then 'ZZZ' else v.ServCode end -- At Polk there are some Supplementary Services with '' for ServCode
						else v.ServCode
					end, 'ZZZ'), 
ServDesc,
		BeginDate = isnull(v.InitDate, dateadd(dd, 1, i.InitDate)), -- select top 10 * from ServiceTbl where gstudentid = '0D2173AE-A416-4C12-A5F8-D6D4B016EFF2' -- select * from student where gstudentid = '0D2173AE-A416-4C12-A5F8-D6D4B016EFF2'
		EndDate = isnull(v.EndDate, dateadd(dd, -1, dateadd(yy, 1, isnull(v.InitDate, dateadd(dd, 1, i.InitDate))))),
		IsRelated = cast(0 as bit), -- select top 10 * from ieptbl
		IsDirect = cast(1 as bit), 
		ExcludesFromGenEd = cast(0 as bit), 
		ServiceLocationCode = 
			case 
				when k.Code is not null then case k.Code when '24' then '10' else k.Code end
				when isnull(v.LocationCode, k.Code) is null then ''
				when k.LookDesc = v.LocationDesc then 
					-- At Polk 24 is a duplicate of 10 (Home)
					case k.Code when '24' then '10' else k.Code end  -- should be last because it is most accurate
			end,
		Sequence = ServOrder, 
		-- IsEsy = cast(isnull(v.ESY,0) as bit), 
		IsESY = cast(case when v.AntDuration like 'ESY%' then 1 else 0 end as bit),
		ServiceTime = 
			cast(
			cast(
				case when v.Frequency like '%$%' then 
					right(
						v.Frequency, 
						patindex(
							'%$%', reverse(rtrim(v.Frequency)
							)
						)-1
					)
				else 
					'0'
				end 
			as numeric(9,2))
			as int)
			, -- service time is provided in hours, but we need minutes
		ServiceFrequencyCode = 
			case 
				when v.Frequency like '%year%' then 'year'
				when v.Frequency like '%quarter%' then 'quarter'
				when (v.Frequency like '%month%' or v.Frequency = 'Biweekly') then 'month'
				when ((v.Frequency like '%week%' or v.Frequency like '%Wk%') and v.Frequency <> 'Biweekly') then 'week'
				when (v.Frequency like '%day%' or v.Frequency like '%daily%' or v.Frequency like '%Continuous%') then 'day'		-- note:  use this same case statement when extracting data from this text field
				else 'ZZZ'
			end,
		ServiceAreaText = v.ServDesc,
		StaffTypeCode = '', --p.Code,
		StaffEmail = t.email
	from 
		@gtbl x 
		JOIN IEPCompleteTbl i on x.IEPSeqNum = i.IEPSeqNum 
		JOIN ICServiceTbl v on i.IEPSeqNum = v.IEPComplSeqNum and isnull(v.del_flag,0)=0 -- select top 10 * from ServiceTbl
		-- note:  at Polk there are 2 locations named "Home" with different codes - 10 and 24.
		LEFT JOIN CodeDescLook k on case when v.LocationDesc = 'Home' then v.LocationCode else v.LocationDesc end = case when k.LookDesc = 'Home' then k.Code else k.LookDesc end
			and UsageID = 'Location'
		LEFT JOIN Staff t on v.ProvCode = t.StaffId -- select * from ServiceTbl where ServProv is not null -- select top 100 * from ICServiceTbl where Teacher is not null
	where 
		v.Type in (
	'SpEd', 
		'RelServ', 
			-- 'Personnel',  -- support 
		'Aids')
) v
-- where Type = 'Related' and ServiceDefinitionCode = '17'
-- group by Type, ServiceDefinitionCode, ServDesc order by ServDesc
order by v.IepRefID, v.ServiceType, v.Sequence

--select v.iepcomplseqnum, v.servseqnum, count(*) tot
--from iepcompletetbl i join
--icservicetbl v on i.IEPSeqNum = v.IEPComplSeqNum
--where isnull(i.del_flag,0)=0
--group by v.iepcomplseqnum, v.servseqnum
--having count(*) > 1
-- 
-- select * from ICServiceTbl where Type = 'RelServ'
-- 
-- select * from CodeDescLook where LookDesc like '%Transportation%'
-- 
-- select Code, LookDesc from CodeDescLook where UsageID = 'RelatedService' and code in ('03', '17', '29') order by Code
-- 03	Interpreter (asst tech 1, interp 30)
-- 17	Assistive Technology (asst tech 206)
-- 29	Assistive listening device (asst listening device 8 asst tech 34)






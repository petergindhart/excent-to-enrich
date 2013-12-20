set nocount on;
set ansi_warnings off;

/****** Object:  View [dbo].[EnrichSelectLists]    Script Date: 12/9/2013 2:00:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*

select Agegroup, LREPlacement, PlacementDesc-- , count(*) tot 
into LK_LREPlacement
from (
select L.GStudentID, L.IEPLRESeqNum,
	CASE WHEN isnull(priminstsetcode, isnull(schpriminstrcode,0) )  between 001 and 199 THEN 'INF'
		WHEN isnull(priminstsetcode, isnull(schpriminstrcode,0) )  between 200 and 299 THEN 'PK'
		WHEN isnull(priminstsetcode, isnull(schpriminstrcode,0) )  between 300 and 399 then 'K12'
		ELSE 'Invalid AgeGroup' END as AgeGroup, -- check ICIEPLRETbl PrimInstSetCode and SchInstSetCode
	ltrim(isnull(priminstsetcode, schpriminstrcode)) LREPlacement,
	isnull(priminstset, schpriminstr) PlacementDesc,
	I.IEPSeqNum, I.MeetDate, I.IEPComplete
From ICIEPLRETbl L
Join IEPCompleteTbl I on L.GStudentID = I.GStudentID and L.IEPComplSeqNum = I.IEPSeqNum
where isnull(L.del_flag,0)!=1 AND isnull(I.Del_flag,0)!=1 AND (isnumeric(priminstsetcode) = 1 or isnumeric(schpriminstrcode) = 1)
	-- AND isnull(priminstsetcode, schpriminstrcode) < '61' -- exclude invalid values
	and meetdate > '1/1/2011'
) p
where len(LREPlacement) = 3
group by Agegroup, LREPlacement, PlacementDesc
order by LREPlacement


*/


CREATE view [dbo].[EnrichSelectLists]
as
select Type, SubType, EnrichID = '', StateCode, LegacySpedCode = Code, EnrichLabel = Label -- or LegacySpedCode = Code
from (
-- *************** Ethnicity *****************************************************          
    select 
		LookupOrder = cast(1 as int),
		Type = 'Race', 
		SubType = '', 
		Code,
		Label = LookDesc, 
		StateCode = isnull(StateCode,''),
		Sequence = cast(0 as int) 
    from CodeDescLook 
    where UsageID = 'Ethnicity'
    
-- *************** GradeLevel *****************************************************          
UNION ALL
    select							-- these need to be mapped with the grades in the database
		LookupOrder = cast(2 as int),
		Type = 'Grade', 
		SubType = '', 
		Code = OldGrade, 
		Label = OldDesc, 
		StateCode = OldGrade, 
		Sequence = 0
	from Grade -- select * from Grade

-- *************** Gender *****************************************************          
UNION ALL
	select 
		LookupOrder = cast(3 as int),
		co.Type, 
		SubType = '', 
		Code = Convert(char(1), StateLabel), -- it works in this case, but won't in CO
		Label = cast(co.StateLabel as varchar(254)), 
		StateCode = cast(co.StateCode as varchar(10)), 
		Sequence = 0
	--from @FL fl
	--where Type = 'Gender'
	from (select LookupOrder = 3, Type = 'Gender', SubType = '', Code = 'M', StateLabel = 'Male', StateCode = '02' union all select LookupOrder = 3, Type = 'Gender', SubType = '', Code = 'F', StateLabel = 'Female', StateCode = '01') co

-- *************** Exceptionality =** Disability *****************************************************          
UNION ALL
    select 
		LookupOrder = cast(4 as int),
		Type = 'Disab', 
		SubType = '', 
		d.DisabilityID,
		Label = d.DisabDesc, 
		StateCode = isnull(d.DisabilityID,''),
		Sequence = cast(0 as int) 
	From DisabilityLook d 
	where d.DisabilityID <> 'NA'

---- *************** SpedExitReason *****************************************************           We will not be bringing in exited students any more.  This select list value is unnecessary
--UNION ALL
--    select 
--		LookupOrder = cast(5 as int),
--		Type = 'Exit', 
--		SubType = '', 
--		Code,
--		Label = LookDesc, 
--		StateCode = isnull(k.StateCode, ''),
--		Sequence = cast(0 as int) 
--	from CodeDescLook k 
--	where UsageID = 'SpEdReas'

-- *************** LRE *****************************************************          
UNION ALL

-- select * into x_NEBOCES_EO_20131206.dbo.LK_LREPlacement from x_NEBOCES_EO_20131125.dbo.LK_LREPlacement
-- select * from x_NEBOCES_EO_20131206.dbo.LK_LREPlacement



    select
		LookupOrder = cast(6 as int),
		Type = 'LRE',		---  NOTE that Pete probably already mapped these
		SubType = lre.AgeGroup,
		Code = lre.LREPlacement,
		Label = lre.PlacementDesc,
		StateCode = lre.LREPlacement,
		Sequence = cast(0 as int) 
	from LK_LREPlacement lre

-- *************** Service *****************************************************  CO EO services do not have codes.  We are extracting some descriptions from the service table as if they were codes
UNION ALL

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

 	--	Add some to map to services that do not have a service definition code because the service definition text was manually entered.  provide one for each Service SubType (Service Category in Enrich)
    select 
    	LookupOrder = cast(7 as int),
		Type = 'Service', 
		SubType = 'SpecialEd', 
		Code = 'ZZZ',
		Label = 'Manually Entered Service Description',
		StateCode = '',
		Sequence = cast(0 as int) 
	
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

	UNION ALL
	
   select 
    	LookupOrder = cast(8 as int),
		Type = 'Service', 
		SubType = 'Related', 
		Code = 'ZZZ',
		Label = 'Manually Entered Service Description',
		StateCode = '',
		Sequence = cast(0 as int) 

	UNION ALL

-- *************** Service Frequency Code *****************************************************          
	select 
    		LookupOrder = cast(11 as int),
			Type = 'ServFreq',  -- these are already in the database but we need to map to them
			SubType = '', 
			Code = DirInsidePer,
			Label = DirInsidePer, 
			StateCode = '',
			Sequence = cast(0 as int) 
	from ICServiceTbl v
	join Student s on v.GStudentID = s.GStudentID and s.SpedStat = 1 
	where 1=1
	and s.SpedStat = 1
	and DirInsidePer is not null
	group by DirInsidePer

Union ALL	
    select 
    	LookupOrder = cast(11 as int),
		Type = 'ServFreq', 
		SubType = '', 
		Code = 'ZZZ',
		Label = 'Unknown',
		StateCode = '',
		Sequence = cast(0 as int) 


-- *************** ServiceLocationCode *****************************************************          
 UNION ALL
    select 
		LookupOrder = 12,
		Type = 'ServLoc', 
		SubType = '', 
		Code,
		Label = LookDesc, 
		StateCode = isnull(StateCode,''),
		Sequence = cast(0 as int) 
	from CodeDescLook
	where UsageID = 'Location'
	and Code <> '24' -- Duplicate of 10 (Home)
	
 UNION ALL
	select 
		LookupOrder = 12,
		Type = 'ServLoc',
		SubType = '',
		Code = 'ZZZ',
		Label = 'Manually Entered Location',
		StateCode = '',
		Sequence = cast(0 as int)

-- *************** Provider *****************************************************          not captured in FL
UNION ALL

	select 
	   		LookupOrder = cast(13 as int),
			Type = 'ServProv', 
			SubType = '', 
			Code = ProvDesc,
			Label = ProvDesc,
			StateCode = '',
			Sequence = cast(0 as int) 	
	from ServiceTbl 
	where SpecInstruction is not null
	and enddate > getdate()
	-- and ProvDesc not like 'Special Education%Teacher%' and ProvDesc not in ('Aide', 'Resource') -- these servprovs provide sped services, not related
	group by ProvDesc 
	having count(*) > 2 -- pick a reasonable number to trim the number of rows returned.  services not in this list will be listed as 

UNION ALL

    select 
    	LookupOrder = cast(13 as int),
		Type = 'ServProv', 
		SubType = '', -- Jeanne indicated that all services in the EO db are SpEd, no related
		Code = 'ZZZ',
		Label = 'Not available', 
		StateCode = '',
		Sequence = cast(0 as int) 

-- *************** GoalArea *****************************************************          -- I don't understand goals
UNION ALL

select distinct --- g.GStudentID, g.GoalSeqNum, g.GoalOrder, g.GoalDesc, g.BankDesc, g.PostSchAreaEd, g.PostSchAreaEmp, g.PostSchAreaInd, 
   	LookupOrder = cast(15 as int),
	Type = 'GoalArea', 
	SubType = '', 
	Code = 
		case left(g.bankdesc, 4)
			when 'Read' then 'Read' 
			when 'Math' then 'Math' 
			when 'Writ' then 'Writ' 
			when 'Lang' then 'Comm' 
			when 'Spee' then 'Comm' 
			else 'ZZZ' 
		end,
	Label = 
		case left(g.bankdesc, 4)
			when 'Read' then 'Reading' 
			when 'Math' then 'Math' 
			when 'Writ' then 'Writing' 
			when 'Lang' then 'Communication' 
			when 'Spee' then 'Communication' 
			else 'Not Provided' 
		end,
	StateCode = '',
	Sequence = cast(0 as int) 
from IEPCompleteTbl i 
join GoalTbl g on i.IEPSeqNum = g.IEPComplSeqNum
where i.ReviewMeet > getdate()
and g.IEPStatus = 1
and isnull(g.del_flag,0)!=1
and isnull(g.BankDesc, '') <> ''
-- group by left(g.bankdesc, 4) -- 58 total



union

select distinct 
  	LookupOrder = cast(15 as int),
	Type = 'GoalArea', 
	SubType = '', 
	Code = k.Code,
	Label = k.LookDesc,
	StateCode = '',
	Sequence = cast(0 as int) 
from (select distinct IEPRefID = x.IEPSeqNum, x.GStudentID, IEPComplete = isnull(i.IEPComplete, 'Draft')
from SpecialEdStudentsAndIEPs x 
join IEPTbl i on x.GStudentID = i.GStudentID 
	and	i.iepseqnum = (
		select min(imin.IEPSeqNum)
		from IEPTbl imin 
		where i.GStudentID = imin.GStudentID
		and isnull(imin.del_flag,0)=0
		)) i 
join GoalTbl g on i.gstudentid = g.gstudentid and i.IEPRefID = g.iepcomplseqnum
left join CodeDescLook k on g.BankDesc = k.LookDesc and k.UsageID = 'Banks'
	and k.Code = (
		select min(mink.Code)
		from CodeDescLook mink 
		where mink.UsageID = k.UsageID
		and k.LookDesc = mink.LookDesc
		)
where (
	(i.IEPComplete = 'Draft' and g.IEPStatus = 2 and g.del_flag=1) 
	or
	(i.IEPComplete = 'IEPComplete' and g.IEPStatus = 1 and isnull(g.del_flag,0)=0) 
	or
	(i.IEPComplete = 'IEPComplete' and g.IEPStatus = 3 and g.del_flag=1)
	)
and k.code is not null

) t


GO


set nocount on;

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

select * 
from [dbo].[EnrichSelectLists]
where LegacySpedCode in (
--'Reading and Math Intervention',
--'Academic Monitoring',
--'Reading skills',
--'School Audiologist',
--'Reading & Math Skills',
--'Speech',
--'soc_stud',
--'SELFDMS' 
'Math and Transition' ,
'Math Learning Lab' 
)




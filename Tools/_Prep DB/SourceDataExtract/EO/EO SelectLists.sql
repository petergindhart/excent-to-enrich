
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
		Label = OldGrade, 
		StateCode = OldGrade, 
		Sequence = 0
	from Grade

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

-- *************** SpedExitReason *****************************************************          
UNION ALL
    select 
		LookupOrder = cast(5 as int),
		Type = 'Exit', 
		SubType = '', 
		Code,
		Label = LookDesc, 
		StateCode = isnull(k.StateCode, ''),
		Sequence = cast(0 as int) 
	from CodeDescLook k 
	where UsageID = 'SpEdReas'

-- *************** LRE *****************************************************          
UNION ALL

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

select
  	LookupOrder = cast(15 as int),
	Type = 'GoalArea', 
	SubType = '', 
	Code = k.Code,
	Label = k.LookDesc,
	StateCode = '',
	Sequence = cast(0 as int) 
from (
	select g.GoalAreaCode
	from Enrich_DC4_CO_NEBOCES.LEGACYSPED.Goal g
	where g.GoalAreaCode <> 'ZZZ'
	group by g.GoalAreaCode
) ga
join CodeDescLook k on ga.GoalAreaCode = k.Code and k.UsageID = 'Banks'





	
-- *************** PostSchoolGoalArea *****************************************************         
	--UNION ALL
	--	select 
 --   		LookupOrder = cast(16 as int),
	--		Type = 'PostSchArea', 
	--		SubType = '', 
	--		Code,
	--		Label, 
	--		StateCode = '',
	--		Sequence = cast(0 as int) 
	--	from (
	--		select cast('PSInstruction' as varchar(20)) Code, cast('Instruction' as varchar(50)) Label union all 
	--		select 'PSCommunity', 'Community Experiences' union all 
	--		select 'PSAdult', 'Post-School Adult Living' union all 
	--		select 'PSVocational', 'Functional Vocational Education' union all 
	--		select 'PSRelated', 'Related Services' union all 
	--		select 'PSEmployment', 'Employment' union all 
	--		select 'PSDailyLiving', 'Daily Living Skills' 
	--		) ps
) t
order by LookupOrder, SubType, Code







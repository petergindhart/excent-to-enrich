--#################################################################
set nocount on;


-- select Type, count(*) from (

-- select Type, SubType, Code, Label, StateCode, Sequence
select Type, SubType, StateCode, Code, Label, Sequence, case StateCode when '' then 'N' else 'Y' end DisplayInUI
from (
-- *************** Ethnicity *****************************************************          
    select 
		LookupOrder = cast(1 as int),
		Type = 'Ethnic', 
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
		Type = cast('Gender' as varchar(10)), 
		SubType = '', 
		Code = cast(Code as varchar(10)), 
		Label = cast(Label as varchar(254)), 
		StateCode = cast(StateCode as varchar(10)), 
		Sequence = 0
	from (
		select 'M' Code, 'Male' Label, '01' StateCode
		union all
		select 'F', 'Female', '02'
		) g

-- *************** Exceptionality =** Disability *****************************************************          
UNION ALL
    select 
		LookupOrder = cast(4 as int),
		Type = 'Disab', 
		SubType = '', 
		DisabilityID,
		Label = DisabDesc, 
		StateCode = DisabilityID,
		Sequence = cast(0 as int) 
	From DisabilityLook
	where DisabilityID <> 'NA'

-- *************** SpedExitReason *****************************************************          
UNION ALL
    select 
		LookupOrder = cast(5 as int),
		Type = 'Exit', 
		SubType = '', 
		Code,
		Label = LookDesc, 
		StateCode = isnull(StateCode, ''),
		Sequence = cast(0 as int) 
	from CodeDescLook
	where UsageID = 'SpEdReas'

-- *************** LRE *****************************************************          
UNION ALL
    select			---------------------- narrow this down to only those LREs we are importing
		LookupOrder = cast(6 as int),
		Type = 'LRE',		---  NOTE that Pete probably already mapped these
		SubType = case 
			when Code between '100' and '199' then 'Infant'
			when Code between '200' and '299' then 'PK'
			when Code between '300' and '399' then 'K12'
			-- else ''
		end,
		Code,
		Label = LookDesc, 
		StateCode = isnull(Code,''),
		Sequence = cast(0 as int) 
	from CodeDescLook
	where UsageID = 'LRESetting'
	and Code between '100' and '399'

-- *************** Service *****************************************************          
UNION ALL
 --   select 
 --   	LookupOrder = cast(7 as int),
	--	Type = 'Service', 
	--	SubType = 'SpecialEd', -- Jeanne indicated that all services in the EO db are SpEd, no related
	--	Code,
	--	Label = LookDesc, 
	--	StateCode = isnull(StateCode,''),
	--	Sequence = cast(0 as int) 
	--from CodeDescLook 
	--where UsageID = 'SpecInst'
	
    select 
    	LookupOrder = cast(7 as int),
		Type = 'Service', 
		SubType = 'SpecialEd', 
		Code = 'ZZZ',
		Label = 'Manually Entered Service', 
		StateCode = '',
		Sequence = cast(0 as int) 

-- *************** ServiceLocationCode *****************************************************          
-- UNION ALL
 --   select 
	--	Type = 'ServLoc', 
	--	SubType = '', 
	--	DisabilityID,
	--	Label = DisabDesc, 
	--	StateCode = isnull(StateCode,''),
	--	Sequence = cast(0 as int) 
	--from 
-- *************** Provider *****************************************************          
UNION ALL
    select 
    	LookupOrder = cast(8 as int),
		Type = 'ServProv', 
		SubType = '', -- Jeanne indicated that all services in the EO db are SpEd, no related
		Code,
		Label, 
		StateCode = '',
		Sequence = cast(0 as int) 
	from -- select top 10 * from servicetbl -- select * from ProviderTbl -- select * from staff
	(select distinct Code = k.LookupDesc, Label = k.LookupDesc from SpecialEdStudentsAndIEPs i join ServiceTbl v on i.gstudentid = v.gstudentid join DescLook k on v.ProvDesc = k.LookupDesc where k.UsageID = 'Title') t
-- *************** ServiceFrequency *****************************************************          
UNION ALL
    select 
    	LookupOrder = cast(9 as int),
		Type = 'ServFreq',  -- these are already in the database but we need to map to them
		SubType = '', 
		Code,
		Label = LookDesc, 
		StateCode = isnull(StateCode,''),
		Sequence = cast(0 as int) 
	from CodeDescLook 
	where UsageID = 'ServPer'


-- *************** GoalArea *****************************************************          
UNION ALL
    select 
    	LookupOrder = cast(10 as int),
		Type = 'GoalArea', 
		SubType = '', 
		Code,
		Label = LookDesc, 
		StateCode = isnull(StateCode,''),
		Sequence = cast(0 as int) 
	from CodeDescLook 
	where UsageID = 'Banks'
	and Code in (select distinct GoalCode from SpecialEdStudentsAndIEPs i join GoalTbl g on i.gstudentid = g.gstudentid where g.IEPStatus = 1 and isnull(g.del_flag,0)=0)
) t
order by LookupOrder, Code







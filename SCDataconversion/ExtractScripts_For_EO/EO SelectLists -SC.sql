IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.SelectLists_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.SelectLists_EO
GO

CREATE VIEW dbo.SelectLists_EO
AS

-- select Type, count(*) from (
-- select Type, SubType, Code, Label, StateCode, Sequence
select Line_No=Row_Number() OVER (ORDER BY (SELECT 1)),Type, SubType, EnrichID = NULL, StateCode, LegacySpedCode = Code, EnrichLabel = Label
FROM (
-- *************** Ethnicity *****************************************************          
    select 
		LookupOrder = cast(1 as int),
		Type = 'Ethnic', 
		SubType = NULL, 
		Code,
		Label = LookDesc, 
		StateCode = StateCode,
		Sequence = cast(0 as int) 
    from CodeDescLook 
    where UsageID = 'Ethnicity'
    
-- *************** GradeLevel *****************************************************          
UNION ALL
    select	Distinct						-- these need to be mapped with the grades in the database
		LookupOrder = cast(2 as int),
		Type = 'Grade', 
		SubType = NULL, 
		Code = OldGrade, 
		Label = OldDesc, 
		StateCode = OldGrade, 
		Sequence = 0
	from Grade

-- *************** Gender *****************************************************          
UNION ALL
	select 
		LookupOrder = cast(3 as int),
		Type = cast('Gender' as varchar(10)), 
		SubType = NULL, 
		Code = cast(Code as varchar(10)), 
		Label = cast(Label as varchar(254)), 
		StateCode = cast(StateCode as varchar(10)), 
		Sequence = 0
	from (
		select 'M' Code, 'Male' Label, '02' StateCode
		union all
		select 'F', 'Female', '01'
		) g

-- *************** Exceptionality =** Disability *****************************************************          
UNION ALL
    select 
		LookupOrder = cast(4 as int),
		Type = 'Disab', 
		SubType = NULL, 
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
		SubType = NULL, 
		Code,
		Label = LookDesc, 
		StateCode = StateCode,
		Sequence = cast(0 as int) 
	from CodeDescLook
	where UsageID = 'SpEdReas'

-- *************** LRE *****************************************************          
UNION ALL
    select			---------------------- narrow this down to only those LREs we are importing
		LookupOrder = cast(6 as int),
		Type = 'LRE',		---  NOTE that Pete probably already mapped these
		SubType = 'K12',
		
		--case 
		--	when Code between '100' and '199' then 'Infant'
		--	when Code between '200' and '299' then 'PK'
		--	when Code between '300' and '399' then 'K12'
		--	else ''
		--end,
		Code,
		Label = LookDesc, 
		StateCode = Code,
		Sequence = cast(0 as int) 
	from CodeDescLook
	where usageid like 'LREplace' and LookDesc is not null
	--and Code between '100' and '399'
UNION ALL
 select			---------------------- narrow this down to only those LREs we are importing
		LookupOrder = cast(6 as int),
		Type = 'LRE',		---  NOTE that Pete probably already mapped these
		SubType = 'PK',
		
		--case 
		--	when Code between '100' and '199' then 'Infant'
		--	when Code between '200' and '299' then 'PK'
		--	when Code between '300' and '399' then 'K12'
		--	else ''
		--end,
		Code,
		Label = LookDesc, 
		StateCode = Code,
		Sequence = cast(0 as int) 
	from CodeDescLook
	where usageid like 'LREplacePK' and LookDesc is not null
UNION ALL
SELECT LookupOrder = cast (6 as int), 'LRE', NULL, 'ZZZ', 'Not specified', 'ZZZ', 0
-- *************** Service *****************************************************          
UNION ALL
    select 
    	LookupOrder = cast(7 as int),
		Type = 'Service', 
		SubType = 'SpecialEd', -- Jeanne indicated that all services in the EO db are SpEd, no related
		Code,
		Label = LookDesc, 
		StateCode = StateCode,
		Sequence = cast(0 as int) 
	from CodeDescLook 
	where UsageID = 'IEPServiceSC'
	UNION ALL
    select 
    	LookupOrder = cast(7 as int),
		Type = 'Service', 
		SubType = NULL, 
		Code = 'ZZZ',
		Label = 'Manually Entered Service', 
		StateCode = 'ZZZ',
		Sequence = cast(0 as int) 

-- *************** ServiceLocationCode *****************************************************          
 UNION ALL
    select 
        LookupOrder = cast(11 as int),
		Type = 'ServLoc', 
		SubType = NULL, 
		code,
		Label = LookDesc, 
		StateCode = StateCode,
		Sequence = cast(0 as int) 
	from CodeDescLook 
	where UsageID = 'SLogPlace'
	
 UNION ALL
 select 
    	LookupOrder = cast(11 as int),
		Type = 'ServLoc', 
		SubType =NULL, 
		Code = 'ZZZ',
		Label = 'Manually Entered Service', 
		StateCode = 'ZZZ',
		Sequence = cast(0 as int) 
-- *************** Provider *****************************************************          
UNION ALL
    select 
    	LookupOrder = cast(8 as int),
		Type = 'ServProv', 
		SubType = NULL, -- Jeanne indicated that all services in the EO db are SpEd, no related
		Code,
		Label, 
		StateCode = NULL,
		Sequence = cast(0 as int) 
	from -- select top 10 * from servicetbl -- select * from ProviderTbl -- select * from staff
	(select distinct Code = k.LookupDesc, Label = k.LookupDesc from SpecialEdStudentsAndIEPs i join ServiceTbl v on i.gstudentid = v.gstudentid join DescLook k on v.ProvDesc = k.LookupDesc where k.UsageID = 'Title') t
    union all
    select LookupOrder = cast (8 as int), 'ServProv', NULL, 'ZZZ', 'Not specified', 'ZZZ', 0
-- *************** ServiceFrequency *****************************************************          
UNION ALL
    select 
    	LookupOrder = cast(9 as int),
		Type = 'ServFreq',  -- these are already in the database but we need to map to them
		SubType = NULL, 
		Code,
		Label = LookDesc, 
		StateCode = StateCode,
		Sequence = cast(0 as int) 
	from CodeDescLook 
	where UsageID = 'ServPer'
    union all
    select LookupOrder = cast (9 as int), 'ServFreq', NULL, 'ZZZ', 'Not specified', 'ZZZ', 0

-- *************** GoalArea *****************************************************          
UNION ALL
    select 
    	LookupOrder = cast(10 as int),
		Type = 'GoalArea', 
		SubType = NULL, 
		Code,
		Label = isnull(LookDesc, Code), 
		StateCode = StateCode,
		Sequence = cast(0 as int) 
	from CodeDescLook 
	where UsageID = 'Banks'
	--and Code in (select distinct GoalCode from SpecialEdStudentsAndIEPs i join GoalTbl g on i.gstudentid = g.gstudentid where g.IEPStatus = 1 and isnull(g.del_flag,0)=0)
    union all
    select LookupOrder = cast (10 as int), 'GoalArea', NULL, 'ZZZ', 'Not specified', NULL, 0

) t
--order by LookupOrder, Code

-- select * from codedesclook where usageid like 'IEPServiceSC'
--select * from Lookup
--select * from MemoLook where UsageID = 'IEPFrequencySC'
--select * from MemoLook where UsageID = 'ServDesc'






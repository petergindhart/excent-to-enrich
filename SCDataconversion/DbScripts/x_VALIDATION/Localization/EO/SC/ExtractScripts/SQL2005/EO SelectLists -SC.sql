IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.SelectLists_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.SelectLists_EO
GO

CREATE VIEW dbo.SelectLists_EO
AS

select Line_No=Row_Number() OVER (ORDER BY (SELECT 1)),Type, SubType, EnrichID = NULL, StateCode, LegacySpedCode = Code, EnrichLabel = Label
FROM (
-- *************** GradeLevel *****************************************************          
    select	Distinct						-- these need to be mapped with the grades in the database
		LookupOrder = cast(2 as int),
		Type = 'Grade', 
		SubType = NULL, 
		-- always force KG.  The same should happen in Student extract
		Code = case when OldGrade in ('K', '00') then 'KG' else OldGrade end,
		StateCode = case when OldGrade in ('K', '00') then 'KG' else OldGrade end, 
		Label = OldDesc, 
		Sequence = 0
	from Grade g
	WHERE case when g.OldGrade in ('00', 'K') then 'KG' else g.OldGrade end = (
		select max(case when OldGrade in ('00', 'K') then 'KG' else OldGrade end)
		from Grade x
		where g.OldGrade = x.OldGrade
		)
-- *************** Gender *****************************************************          
UNION ALL
	select 
		LookupOrder = cast(3 as int),
		Type = cast('Gender' as varchar(10)), 
		SubType = NULL, 
		Code = cast(Code as varchar(10)), 
		StateCode = cast(StateCode as varchar(10)), 
		Label = cast(Label as varchar(254)), 
		Sequence = 0
	from (
		select 'M' Code, 'Male' Label, 'M' StateCode -- changed to M from 02
		union all
		select 'F', 'Female', 'F' -- changed to F from 01
		) g

-- *************** Exceptionality =** Disability *****************************************************          
UNION ALL
    select 
		LookupOrder = cast(4 as int),
		Type = 'Disab', 
		SubType = NULL, 
		DisabilityID,
		StateCode = DisabilityID,
		Label = DisabDesc, 
		Sequence = cast(0 as int) 
	From DisabilityLook
	where DisabilityID like 'SDE%'

-- *************** SpedExitReason *****************************************************          
UNION ALL
    select 
		LookupOrder = cast(5 as int),
		Type = 'Exit', 
		SubType = NULL, 
		Code,
		StateCode = StateCode,
		Label = LookDesc, 
		Sequence = cast(0 as int) 
	from CodeDescLook
	where UsageID = 'SpEdReas'
	and Code like 'SDE%'
-- *************** LRE *****************************************************          
UNION ALL
    select 
        LookupOrder = cast(11 as int),
		Type = 'LRE', 
		SubType = AgeGroup, 
		v.Placement,
		StateCode = v.Placement,
		Label = v.PlacementDesc, 
		Sequence = cast(0 as int) 
	from DataConversionLREPlacementView v
	where v.PlacementDesc is not null
	group by v.AgeGroup, v.Placement, v.PlacementDesc

-- *************** Service *****************************************************          
UNION ALL
	select 
		LookupOrder = cast(7 as int),
		Type = 'Service',
		SubType = 
			case v.Type 
				when 'R' then 'Related' 
				when 'S' then 'SpecialEd' 
				when 'U' then 'Supplemental'
			end,
		Code = v.ServCode, 
		StateCode = case when (v.ServCode like 'SDE[0-9][0-9]' or v.ServCode like 'SES[0-9][0-9]') then v.ServCode else '' end, 
		Label = LEFT(v.ServDesc,250),
		Sequence = 0
	from DataConversionServiceDefCodeView v
	group by v.Type, v.ServCode, v.ServDesc
-- *************** ServiceLocationCode *****************************************************          
 UNION ALL
    select 
        LookupOrder = cast(11 as int),
		Type = 'ServLoc', 
		SubType = NULL, 
		Code= LEFT(v.LocationCode,150),
		StateCode = LEFT(v.LocationCode,10),
		Label = LEFT(v.LocationDesc,250), 
		Sequence = cast(0 as int) 
	from DataConversionLocationCodeView v
	group by v.LocationCode, v.LocationDesc

-- *************** Provider *****************************************************          
UNION ALL
    select 
    	LookupOrder = cast(8 as int),
		Type = 'ServProv', 
		SubType = NULL, 
		Code = 'ZZZ',
		StateCode = NULL,
		Label = 'Not specified', 
		Sequence = cast(0 as int) 
-- *************** ServiceFrequency *****************************************************          
UNION ALL
    select 
    	LookupOrder = cast(9 as int),
		Type = 'ServFreq', 
		SubType = NULL, 
		Code = LEFT(FrequencyCode,150),
		StateCode = LEFT(FrequencyCode,10),
		Label = LEFT(FrequencyDesc,250), 
		Sequence = cast(0 as int) 
	from DataConversionFrequencyCodeView 
	group by FrequencyCode, FrequencyDesc

-- *************** GoalArea *****************************************************          
UNION ALL
    select 
    	LookupOrder = cast(10 as int),
		Type = 'GoalArea', 
		SubType = NULL, 
		Code = LEFT(GoalAreaCode,150),
		StateCode = LEFT(GoalAreaCode,10),
		Label = LEFT(GoalAreaDesc,250),
		Sequence = cast(0 as int) 
	from DataConversionGoalAreaCodeCodeView
	group by GoalAreaCode, GoalAreaDesc

) t





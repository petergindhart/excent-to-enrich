--#################################################################

-- note:  Florida EO LREs did not align with the state LREs.  They were also hard-coded in to the C# code of Excent Online.  Go figure.
declare @LRE table (Subtype varchar(5), Code varchar(1), Label varchar(300))
set nocount on;
insert @LRE (SubType, Code, Label) values ('PK', '1', 'Regular Class (more than 79% with non-ESE)')
insert @LRE (SubType, Code, Label) values ('PK', '2', 'Resource (more than 40% but less than 79% with non-ESE)')
insert @LRE (SubType, Code, Label) values ('PK', '3', 'Separate Class (less than or equal to 40% with non-ESE)') 
insert @LRE (SubType, Code, Label) values ('PK', '4', 'Hospital/Homebound')
insert @LRE (SubType, Code, Label) values ('PK', '5', 'Separate Day School/Center School')
insert @LRE (SubType, Code, Label) values ('PK', '6', 'Residential Facility')
insert @LRE (SubType, Code, Label) values ('PK', '8', 'Not Yet Selected')
insert @LRE (SubType, Code, Label) values ('PK', '9', 'Home Instruction')
 
insert @LRE (SubType, Code, Label) values ('K12', '1', 'Regular Class (more than 79% with non-ESE)')
insert @LRE (SubType, Code, Label) values ('K12', '2', 'Resource (more than 40% but less than 79% with non-ESE)')
insert @LRE (SubType, Code, Label) values ('K12', '3', 'Separate Class (less than or equal to 40% with non-ESE)')
insert @LRE (SubType, Code, Label) values ('K12', '4', 'Hospital/Homebound')
insert @LRE (SubType, Code, Label) values ('K12', '5', 'Separate Day School/Center School')
insert @LRE (SubType, Code, Label) values ('K12', '6', 'Residential Facility')
insert @LRE (SubType, Code, Label) values ('K12', '8', 'Not Yet Selected') 
insert @LRE (SubType, Code, Label) values ('K12', '9', 'Home Instruction')





/*

	consider combining hard-coded values into a @HardCodedLookups table variable.  LRE, GoalArea and PostSchoolArea are all candidates for that table in FL

    select 
    	LookupOrder = cast(15 as int),
		Type = 'GoalArea', 
		SubType = '', 
		Code = Code,
		Label = Label, 
		StateCode = '',
		Sequence = cast(0 as int) 
	from (
		select cast('GAReading' as varchar(20)) Code, cast('Reading' as varchar(50)) Label union all 
		select 'GAWriting', 'Writing' union all 
		select 'GAMath', 'Math' union all 
		select 'GAOther', 'Other' union all 
		select 'GAEmotional', 'Social Emotional Behavior' union all 
		select 'GAIndependent', 'Independent Functioning' union all 
		select 'GAHealth', 'Health Care' union all 
		select 'GACommunication', 'Communication'
		) ga
	
-- *************** PostSchoolGoalArea *****************************************************          -- I don't understand goals
	UNION ALL
		select 
    		LookupOrder = cast(16 as int),
			Type = 'PostSchoolArea', 
			SubType = '', 
			Code,
			Label, 
			StateCode = '',
			Sequence = cast(0 as int) 
		from (
			select cast('PSInstruction' as varchar(20)) Code, cast('Instruction' as varchar(50)) Label union all 
			select 'PSCommunity', 'Community Experiences' union all 
			select 'PSAdult', 'Post-School Adult Living' union all 
			select 'PSVocational', 'Functional Vocational Education' union all 
			select 'PSRelated', 'Related Services' union all 
			select 'PSEmployment', 'Employment' union all 
			select 'PSDailyLiving', 'Daily Living Skills' 
			) ps
			
*/
			




-- map legacy code to state code
declare @Disab table (Code varchar(5), StateCode varchar(255)) -- Verify that these are the same for each district 
set nocount on;
insert @Disab values ('1', 'P')
insert @Disab values ('2', 'H')
insert @Disab values ('3', 'O')
insert @Disab values ('5', 'J')
insert @Disab values ('6', 'U')
insert @Disab values ('7', 'L')
insert @Disab values ('8', 'M')
insert @Disab values ('9', 'G')
insert @Disab values ('10', 'D')
insert @Disab values ('11', 'C')
insert @Disab values ('12', 'V')
insert @Disab values ('13', 'E')
insert @Disab values ('16', 'K')
insert @Disab values ('17', 'F')
insert @Disab values ('18', 'T')
insert @Disab values ('20', 'S')
insert @Disab values ('21', 'I')
insert @Disab values ('22', 'Z')
insert @Disab values ('23', 'W')


--declare @Gender table (Code varchar(10), Label varchar(10), StateCode varchar(10))
--set nocount on ;
--insert @Gender values ('M', 'Male', 'M')
--insert @Gender values ('F', 'Female', 'F')

-- FL state codes for lookups of Sped data being converted. description provided because some statelabels were truncated.
declare @FL table (Type varchar(20), SubType varchar(20), StateCode varchar(20), StateLabel varchar(254), StateDescription varchar(1000))
set nocount on;
insert @FL values ('Disab', NULL, 'P', 'Autistic', 'Autistic')
insert @FL values ('Disab', NULL, 'H', 'Deaf or Hard of Hearing', 'Deaf or Hard of Hearing')
insert @FL values ('Disab', NULL, 'T', 'Developmentally Delayed', 'Developmentally Delayed')
insert @FL values ('Disab', NULL, 'O', 'Dual-Sensory Impaired', 'Dual-Sensory Impaired')
insert @FL values ('Disab', NULL, 'J', 'Emotionally Handicapped', 'Emotionally Handicapped')
insert @FL values ('Disab', NULL, 'U', 'Established Conditions', 'Established Conditions')
insert @FL values ('Disab', NULL, 'L', 'Gifted', 'Gifted')
insert @FL values ('Disab', NULL, 'M', 'Hospital/Homebound', 'Hospital/Homebound')
insert @FL values ('Disab', NULL, 'W', 'Intellectual Disability', 'Intellectual Disability')
insert @FL values ('Disab', NULL, 'G', 'Language Impaired', 'Language Impaired')
insert @FL values ('Disab', NULL, 'Z', 'Not Applicable', 'Not Applicable')
insert @FL values ('Disab', NULL, 'D', 'Occupational Therapy', 'Occupational Therapy')
insert @FL values ('Disab', NULL, 'C', 'Orthopedically Impaired', 'Orthopedically Impaired')
insert @FL values ('Disab', NULL, 'V', 'Other Health Impaired', 'Other Health Impaired')
insert @FL values ('Disab', NULL, 'E', 'Physical Therapy', 'Physical Therapy')
insert @FL values ('Disab', NULL, 'K', 'Specific Learning Disabled', 'Specific Learning Disabled')
insert @FL values ('Disab', NULL, 'F', 'Speech Impaired', 'Speech Impaired')
insert @FL values ('Disab', NULL, 'S', 'Traumatic Brain Injured', 'Traumatic Brain Injured')
insert @FL values ('Disab', NULL, 'I', 'Visually Impaired', 'Visually Impaired')
insert @FL values ('Exit', NULL, 'DNE', 'Any KG-12 student who was expected to attend a school but did not enter as expected for unknown reasons and required documented efforts to locate the student are maintained per s. 1003.26, Florida Statutes.', 'Any KG-12 student who was expected to attend a school but did not enter as expected for unknown reasons and required documented efforts to locate the student are maintained per s. 1003.26, Florida Statutes.')
insert @FL values ('Exit', NULL, 'W01', 'Any PK-12 student promoted, retained or transferred to another attendance reporting unit in the same school.', 'Any PK-12 student promoted, retained or transferred to another attendance reporting unit in the same school.')
insert @FL values ('Exit', NULL, 'W02', 'Any PK-12 student promoted, retained or transferred to another school in the same district.', 'Any PK-12 student promoted, retained or transferred to another school in the same district.')
insert @FL values ('Exit', NULL, 'W04', 'Any PK-12 student who withdraws to attend a nonpublic school in- or out-of-state or out-ofcountry.', 'Any PK-12 student who withdraws to attend a nonpublic school in- or out-of-state or out-ofcountry.')
insert @FL values ('Exit', NULL, 'W05', 'Any student age 16 or older who leaves school voluntarily with no intention of returning and has filed a formal declaration of intent to terminate school enrollment per s. 1003.21, Florida Statutes.', 'Any student age 16 or older who leaves school voluntarily with no intention of returning and has filed a formal declaration of intent to terminate school enrollment per s. 1003.21, Florida Statutes.')
insert @FL values ('Exit', NULL, 'W06', 'Any student who graduated from school and met all of the requirements to receive a standard diploma.', 'Any student who graduated from school and met all of the requirements to receive a standard diploma.')
insert @FL values ('Exit', NULL, 'W07', 'Any student who graduated from school with a special diploma based on option one - as referenced in State Board of Education Rule 6A-1.09961.', 'Any student who graduated from school with a special diploma based on option one - as referenced in State Board of Education Rule 6A-1.09961.')
insert @FL values ('Exit', NULL, 'W08', 'Any student who received a certificate of completion. The student met the minimum credits and local requirements, but did not pass the state approved graduation test or an alternate assessment, and/or did not achieve the required GPA.', 'Any student who received a certificate of completion. The student met the minimum credits and local requirements, but did not pass the state approved graduation test or an alternate assessment, and/or did not achieve the required GPA.')
insert @FL values ('Exit', NULL, 'W09', 'Any student who received a special certificate of completion, is properly classified as an eligible exceptional education student, met applicable local requirements, and was unable to meet appropriate special state minimum requirements.', 'Any student who received a special certificate of completion, is properly classified as an eligible exceptional education student, met applicable local requirements, and was unable to meet appropriate special state minimum requirements.')
insert @FL values ('Exit', NULL, 'W10', 'Any student who completed the Performance-Based Exit Option Model Program requirements, passed the GED Tests and the state approved graduation test, and was awarded a State of Florida High School Performance-Based Diploma.', 'Any student who completed the Performance-Based Exit Option Model Program requirements, passed the GED Tests and the state approved graduation test, and was awarded a State of Florida High School Performance-Based Diploma.')
insert @FL values ('Exit', NULL, 'W12', 'Any PK-12 student withdrawn from school due to death.', 'Any PK-12 student withdrawn from school due to death.')
insert @FL values ('Exit', NULL, 'W13', 'Any KG-12 student withdrawn from school due to court action. (This code does not apply to DJJ placement.)', 'Any KG-12 student withdrawn from school due to court action. (This code does not apply to DJJ placement.)')
insert @FL values ('Exit', NULL, 'W15', 'Any KG-12 student who is withdrawn from school due to nonattendance after all procedures outlined in sections 1003.26 and 1003.27, Florida Statutes, have been followed.', 'Any KG-12 student who is withdrawn from school due to nonattendance after all procedures outlined in sections 1003.26 and 1003.27, Florida Statutes, have been followed.')
insert @FL values ('Exit', NULL, 'W18', 'Any KG-12 student who withdraws from school due to medical reasons and the student is unable to receive educational services, such as those provided through the hospital/homebound program.', 'Any KG-12 student who withdraws from school due to medical reasons and the student is unable to receive educational services, such as those provided through the hospital/homebound program.')
insert @FL values ('Exit', NULL, 'W21', 'Any KG-12 student who is withdrawn from school due to being expelled with no educational services.', 'Any KG-12 student who is withdrawn from school due to being expelled with no educational services.')
insert @FL values ('Exit', NULL, 'W22', 'Any KG-12 student whose whereabouts is unknown and required documented efforts to locate the student are maintained per s. 1003.26, Florida Statutes.', 'Any KG-12 student whose whereabouts is unknown and required documented efforts to locate the student are maintained per s. 1003.26, Florida Statutes.')
insert @FL values ('Exit', NULL, 'W23', 'Any KG-12 student who withdraws from school for any reason other than W01 - W22 or W24– W27.', 'Any KG-12 student who withdraws from school for any reason other than W01 - W22 or W24– W27.')
insert @FL values ('Exit', NULL, 'W24', 'Any KG-12 student who withdraws from school to attend a Home Education program.', 'Any KG-12 student who withdraws from school to attend a Home Education program.')
insert @FL values ('Exit', NULL, 'W25', 'Any student under the age of 6 who withdraws from school.', 'Any student under the age of 6 who withdraws from school.')
insert @FL values ('Exit', NULL, 'W26', 'Any student who withdraws from school to enter the adult education program prior to completion of graduation requirements.', 'Any student who withdraws from school to enter the adult education program prior to completion of graduation requirements.')
insert @FL values ('Exit', NULL, 'W6A', 'Any student who graduated from school and met all of the requirements to receive a standard diploma, based on the 18-credit college preparatory graduation option.', 'Any student who graduated from school and met all of the requirements to receive a standard diploma, based on the 18-credit college preparatory graduation option.')
insert @FL values ('Exit', NULL, 'W6B', 'Any student who graduated from school and met all of the requirements to receive a standard diploma, based on the 18-credit career preparatory graduation option.', 'Any student who graduated from school and met all of the requirements to receive a standard diploma, based on the 18-credit career preparatory graduation option.')
insert @FL values ('Exit', NULL, 'W8A', 'Any student who met all of the requirements to receive a standard diploma except passing the state approved graduation test and received a certificate of completion and is eligible to take the College Placement Test and be admitted to remedial or credit ', 'Any student who met all of the requirements to receive a standard diploma except passing the state approved graduation test and received a certificate of completion and is eligible to take the College Placement Test and be admitted to remedial or credit c')
insert @FL values ('Exit', NULL, 'WFA', 'Any student who graduated from school with a standard diploma based on an 18-credit college preparatory graduation option and satisfied the state approved graduation test requirement through an alternate assessment.', 'Any student who graduated from school with a standard diploma based on an 18-credit college preparatory graduation option and satisfied the state approved graduation test requirement through an alternate assessment.')
insert @FL values ('Exit', NULL, 'WFB', 'Any student who graduated from school with a standard diploma based on an 18-credit career preparatory graduation option and satisfied the state approved graduation test requirement through an alternate assessment.', 'Any student who graduated from school with a standard diploma based on an 18-credit career preparatory graduation option and satisfied the state approved graduation test requirement through an alternate assessment.')
insert @FL values ('Exit', NULL, 'WFT', 'Any student who graduated from school with a standard diploma and satisfied the state approved graduation test requirement through an alternate assessment. (For students meeting accelerated high school graduation option requirements, see WFA and WFB.)', 'Any student who graduated from school with a standard diploma and satisfied the state approved graduation test requirement through an alternate assessment. (For students meeting accelerated high school graduation option requirements, see WFA and WFB.)')
insert @FL values ('Exit', NULL, 'WFW', 'Any student with disabilities who graduated from school with a standard diploma and an FCAT waiver.', 'Any student with disabilities who graduated from school with a standard diploma and an FCAT waiver.')
insert @FL values ('Exit', NULL, 'WGD', 'Any student who completed the Performance-Based Exit Option Model Program requirements and passed the GED Tests, but did not pass the state approved graduation test and was awarded a State of Florida diploma.', 'Any student who completed the Performance-Based Exit Option Model Program requirements and passed the GED Tests, but did not pass the state approved graduation test and was awarded a State of Florida diploma.')
insert @FL values ('Exit', NULL, 'WPO', 'Any student who is withdrawn from school without receiving a standard diploma and subsequent to receiving a W07, W08, W8A, W09, or W27 during the student’s year of high school completion.', 'Any student who is withdrawn from school without receiving a standard diploma and subsequent to receiving a W07, W08, W8A, W09, or W27 during the student’s year of high school completion.')
insert @FL values ('Exit', NULL, 'W27', 'Any student who graduated from school with a special diploma based on option two-mastery of employment and community competencies.', 'Any student who graduated from school with a special diploma based on option two-mastery of employment and community competencies.')
insert @FL values ('Exit', NULL, 'W3A', 'Any PK-12 student who withdraws to attend a public school in another district in Florida.', 'Any PK-12 student who withdraws to attend a public school in another district in Florida.')
insert @FL values ('Exit', NULL, 'W3B', 'Any PK-12 student who withdraws to attend another public school out-of-state or out-ofcountry.', 'Any PK-12 student who withdraws to attend another public school out-of-state or out-ofcountry.')
insert @FL values ('Exit', NULL, 'WGA', 'Any student who completed the Performance-Based Exit Option Model Program requirements, passed the GED Tests, satisfied the state approved graduation test requirement through an alternate assessment, and was awarded a State of Florida High School Perform', 'Any student who completed the Performance-Based Exit Option Model Program requirements, passed the GED Tests, satisfied the state approved graduation test requirement through an alternate assessment, and was awarded a State of Florida High School Performa')
insert @FL values ('Gender', NULL, 'M', 'Male', 'Male')
insert @FL values ('Gender', NULL, 'F', 'Female', 'Female')
insert @FL values ('Grade', NULL, '01', 'First Grade', 'First Grade')
insert @FL values ('Grade', NULL, '02', 'Second Grade', 'Second Grade')
insert @FL values ('Grade', NULL, '03', 'Third Grade', 'Third Grade')
insert @FL values ('Grade', NULL, '04', 'Fourth Grade', 'Fourth Grade')
insert @FL values ('Grade', NULL, '05', 'Fifth Grade', 'Fifth Grade')
insert @FL values ('Grade', NULL, '06', 'Sixth Grade', 'Sixth Grade')
insert @FL values ('Grade', NULL, '07', 'Seventh Grade', 'Seventh Grade')
insert @FL values ('Grade', NULL, '08', 'Eighth Grade', 'Eighth Grade')
insert @FL values ('Grade', NULL, '09', 'Ninth Grade', 'Ninth Grade')
insert @FL values ('Grade', NULL, '10', 'Tenth Grade', 'Tenth Grade')
insert @FL values ('Grade', NULL, '11', 'Eleventh Grade', 'Eleventh Grade')
insert @FL values ('Grade', NULL, '12', 'Twelfth Grade', 'Twelfth Grade')
insert @FL values ('Grade', NULL, 'KG', 'Kindergarten', 'Kindergarten')
insert @FL values ('Grade', NULL, 'PK', 'Pre-kindergarten', 'Pre-kindergarten')
insert @FL values ('LRE', 'Infant', 'Z', 'All students with disabilities ages 0-2', 'All students with disabilities ages 0-2')
insert @FL values ('LRE', 'PK', 'A', 'Home', 'Home')
insert @FL values ('LRE', 'PK', 'B', 'Special Education Program in a Residential Facility', 'Special Education Program in a Residential Facility')
insert @FL values ('LRE', 'PK', 'J', 'Service Provider', 'Service Provider')
insert @FL values ('LRE', 'PK', 'K', 'Early Childhood Program Receiving the Majority of Special Education Services Inside the Early Childhood Program', 'Early Childhood Program Receiving the Majority of Special Education Services Inside the Early Childhood Program')
insert @FL values ('LRE', 'PK', 'L', 'Special Education Program at a Regular School Campus or Community Based Setting', 'Special Education Program at a Regular School Campus or Community Based Setting')
insert @FL values ('LRE', 'PK', 'M', 'Early Childhood Program Receiving the Majority of Special Education Services Outside the Early Childhood Program', 'Early Childhood Program Receiving the Majority of Special Education Services Outside the Early Childhood Program')
insert @FL values ('LRE', 'PK', 'S', 'Special Education Program in a Separate School', 'Special Education Program in a Separate School')
insert @FL values ('LRE', 'K12', 'C', 'Correction Facility', 'Correction Facility')
insert @FL values ('LRE', 'K12', 'D', 'Separate School', 'Separate School')
insert @FL values ('LRE', 'K12', 'F', 'Residential Facility', 'Residential Facility')
insert @FL values ('LRE', 'K12', 'H', 'Home/Hospital', 'Home/Hospital')
insert @FL values ('LRE', 'K12', 'P', 'Private Schools', 'Private Schools')
insert @FL values ('LRE', 'K12', 'Z', 'None of the Above', 'None of the Above')



-- select Type, count(*) from (

select Type, SubType, EnrichID = '', StateCode, LegacySpedCode = Code, EnrichLabel = Label -- or LegacySpedCode = Code
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
		fl.Type, 
		SubType = '', 
		Code = Convert(char(1), StateLabel), -- it works in this case, but won't in CO
		Label = cast(fl.StateLabel as varchar(254)), 
		StateCode = cast(fl.StateCode as varchar(10)), 
		Sequence = 0
	from @FL fl
	where Type = 'Gender'

-- *************** Exceptionality =** Disability *****************************************************          
UNION ALL
    select 
		LookupOrder = cast(4 as int),
		Type = 'Disab', 
		SubType = '', 
		d.DisabilityID,
		Label = d.DisabDesc, 
		StateCode = isnull(s.StateCode,''),
		Sequence = cast(0 as int) 
	From DisabilityLook d left join 
		@Disab s on d.DisabilityID = s.Code
	where d.DisabilityID <> 'NA'

-- *************** SpedExitReason *****************************************************          
UNION ALL
    select 
		LookupOrder = cast(5 as int),
		Type = 'Exit', 
		SubType = '', 
		Code,
		Label = LookDesc, 
		StateCode = isnull(fl.StateCode, ''),
		Sequence = cast(0 as int) 
	from CodeDescLook k left join 
		@FL fl on k.Code = fl.StateCode and fl.Type = 'Exit'
	where UsageID = 'SpEdReas'

-- *************** LRE *****************************************************          
UNION ALL
 --   select			---------------------- narrow this down to only those LREs we are importing
	--	LookupOrder = cast(6 as int),
	--	Type = 'LRE',		---  NOTE that Pete probably already mapped these
	--	SubType = case 
	--		when Code between '100' and '199' then 'Infant'
	--		when Code between '200' and '299' then 'PK'
	--		when Code between '300' and '399' then 'K12'
	--	end,
	--	Code,
	--	Label = LookDesc, 
	--	StateCode = isnull(Code,''),
	--	Sequence = cast(0 as int) 
	--from CodeDescLook
	--	-- where LookDesc like '%Homebound%'

    select
		LookupOrder = cast(6 as int),
		Type = 'LRE',		---  NOTE that Pete probably already mapped these
		lre.SubType,
		lre.Code,
		lre.Label,
		StateCode = '', -- isnull(fl.StateCode,''), -- there was only 1 that matched - K12 residential facility.  It didn't make sense to have just one legacy label and state label match
		Sequence = cast(0 as int) 
	from @LRE lre LEFT JOIN 
		@FL fl on 
			lre.SubType = fl.SubType and
			lre.Label = fl.StateLabel and
			fl.Type = 'LRE'

-- *************** Service *****************************************************          
UNION ALL

    select 
    	LookupOrder = cast(7 as int),
		Type = 'Service', 
		SubType = 'SpecialEd', 
		Code,
		Label = LookDesc,
		StateCode = '',
		Sequence = cast(0 as int) 
	from CodeDescLook
	where UsageID = 'SpedServices' -- SpEd


	UNION ALL


    select 
    	LookupOrder = cast(8 as int),
		Type = 'Service', 
		SubType = 'Related', 
		Code,
		Label = LookDesc,
		StateCode = '',
		Sequence = cast(0 as int) 
	from CodeDescLook
	where UsageID = 'RelatedService' -- RelServ
--order by LookDesc

	UNION ALL

    select 
    	LookupOrder = cast(9 as int),
		Type = 'Service', 
		SubType = 'Support', 
		Code,
		Label = LookDesc,
		StateCode = '',
		Sequence = cast(0 as int) 
	from CodeDescLook
	where UsageID = 'ProgMods' -- Personnel


	UNION ALL


    select 
    	LookupOrder = cast(10 as int),
		Type = 'Service', 
		SubType = 'Supplementary', 
		Code,
		Label = LookDesc,
		StateCode = '',
		Sequence = cast(0 as int) 
	from CodeDescLook
	where UsageID = 'SuppAides' -- Aids


	UNION ALL

	--	Add some to map to services that do not have a service definition code because the service definition text was manually entered.  provide one for each Service SubType (Service Category in Enrich)
    select 
    	LookupOrder = cast(11 as int),
		Type = 'Service', 
		SubType = 'SpecialEd', 
		Code = 'ZZZ',
		Label = 'Manually Entered Service Description',
		StateCode = '',
		Sequence = cast(0 as int) 
	
	UNION ALL
	
    select 
    	LookupOrder = cast(11 as int),
		Type = 'Service', 
		SubType = 'Related', 
		Code = 'ZZZ',
		Label = 'Manually Entered Service Description',
		StateCode = '',
		Sequence = cast(0 as int) 

	UNION ALL
	
    select 
    	LookupOrder = cast(11 as int),
		Type = 'Service', 
		SubType = 'Support', 
		Code = 'ZZZ',
		Label = 'Manually Entered Service Description',
		StateCode = '',
		Sequence = cast(0 as int) 

	UNION ALL
	
    select 
    	LookupOrder = cast(11 as int),
		Type = 'Service', 
		SubType = 'Supplementary', 
		Code = 'ZZZ',
		Label = 'Manually Entered Service Description',
		StateCode = '',
		Sequence = cast(0 as int) 

	UNION ALL
	
    select 
    	LookupOrder = cast(11 as int),
		Type = 'ServFreq', 
		SubType = '', 
		Code = 'ZZZ',
		Label = 'Unknown',
		StateCode = '',
		Sequence = cast(0 as int) 

--order by Label



--select v.* 
--from SpecialEdStudentsAndIEPs x
--join ServiceTbl v on x.GStudentID = v.GStudentID 
--where isnull(v.del_flag,0)=0
--and Type = 'Overall'

--declare @g uniqueidentifier ; select @g = gstudentid from student where studentid = '3628262605'
--select * from servicetbl where isnull(del_flag,0)=0 and gstudentid = @g

--select * from codedesclook where lookdesc = 'No Related Services Received'

--select Type, count(*) Tot
--from SpecialEdStudentsAndIEPs x
--join ServiceTbl v on x.GStudentID = v.GStudentID 
--where isnull(v.del_flag,0)=0
--group by Type

--Aids	2398
--Courses	64
--Overall	47
--AnticipServices	1622
--RelServ	9722
--SpEd	29144
--Personnel	61567

--select * from CodeDescLook where Code = 'T*RC'

--select r.UsageID rUsage, s.UsageID sUsage, b.Code, b.LookDesc
--from (
--	select Code, LookDesc from CodeDescLook where UsageID = 'RelatedService'
--	union
--	select Code, LookDesc from CodeDescLook where UsageID = 'ServiceEnc'
--	) b
--left join CodeDescLook r on b.Code = r.Code and r.UsageID = 'RelatedService'
--left join CodeDescLook s on b.Code = s.Code and s.UsageID = 'ServiceEnc'
----order by r.UsageID, s.UsageID, 
----	case when isnumeric(b.Code) = 1 then cast(b.Code as int) else 99999999999999 end, b.Code, 
----	b.LookDesc
--order by b.LookDesc, r.UsageID, s.UsageID




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
--UNION ALL
--    select 
--    	LookupOrder = cast(8 as int),
--		Type = 'ServProv', 
--		SubType = '', -- Jeanne indicated that all services in the EO db are SpEd, no related
--		Code,
--		Label, 
--		StateCode = '',
--		Sequence = cast(0 as int) 
--	from -- select top 10 * from servicetbl -- select * from ProviderTbl -- select * from staff
--	(select distinct Code = k.LookupDesc, Label = k.LookupDesc from SpecialEdStudentsAndIEPs i join ServiceTbl v on i.gstudentid = v.gstudentid join DescLook k on v.ProvDesc = k.LookupDesc where k.UsageID = 'Title') t
UNION ALL
    select 
    	LookupOrder = cast(13 as int),
		Type = 'ServProv', 
		SubType = '', -- Jeanne indicated that all services in the EO db are SpEd, no related
		Code = 'ZZZ',
		Label = 'Not available', 
		StateCode = '',
		Sequence = cast(0 as int) 

-- *************** ServiceFrequency *****************************************************          
UNION ALL
    select 
    	LookupOrder = cast(14 as int),
		Type = 'ServFreq',  -- these are already in the database but we need to map to them
		SubType = '', 
		Code = DerivedFrequency,
		Label = DerivedFrequency, 
		StateCode = '',
		Sequence = cast(0 as int) 
	from (
		select distinct DerivedFrequency = 
			case 
				when LookupDesc like '%year%' then 'year'
				when LookupDesc like '%quarter%' then 'quarter'
				when (LookupDesc like '%month%' or LookupDesc = 'Biweekly') then 'month'
				when ((LookupDesc like '%week%' or LookupDesc like '%Wk%') and LookupDesc <> 'Biweekly') then 'week'
				when (LookupDesc like '%day%' or lookupdesc like '%daily%' or lookupdesc like '%Continuous%') then 'day'		-- note:  use this same case statement when extracting data from this text field
				else ''
			end
		from DescLook 
		where UsageID = 'TimeServd' -- select * from DescLook where UsageID = 'TimeServd'
		-- 	order by LookupDesc
		) k
	where DerivedFrequency <> ''


-- *************** GoalArea *****************************************************          -- I don't understand goals
UNION ALL
    select 
    	LookupOrder = cast(15 as int),
		Type = 'GoalArea', 
		SubType = '', 
		Code = Code,
		Label = Label, 
		StateCode = '',
		Sequence = cast(0 as int) 
	from (
		select cast('GAReading' as varchar(20)) Code, cast('Reading' as varchar(50)) Label union all 
		select 'GAWriting', 'Writing' union all 
		select 'GAMath', 'Math' union all 
		select 'GAOther', 'Other' union all 
		select 'GAEmotional', 'Social Emotional Behavior' union all 
		select 'GAIndependent', 'Independent Functioning' union all 
		select 'GAHealth', 'Health Care' union all 
		select 'GACommunication', 'Communication'
		) ga
	
-- *************** PostSchoolGoalArea *****************************************************          -- I don't understand goals
	UNION ALL
		select 
    		LookupOrder = cast(16 as int),
			Type = 'PostSchArea', 
			SubType = '', 
			Code,
			Label, 
			StateCode = '',
			Sequence = cast(0 as int) 
		from (
			select cast('PSInstruction' as varchar(20)) Code, cast('Instruction' as varchar(50)) Label union all 
			select 'PSCommunity', 'Community Experiences' union all 
			select 'PSAdult', 'Post-School Adult Living' union all 
			select 'PSVocational', 'Functional Vocational Education' union all 
			select 'PSRelated', 'Related Services' union all 
			select 'PSEmployment', 'Employment' union all 
			select 'PSDailyLiving', 'Daily Living Skills' 
			) ps
) t
order by Type, SubType, EnrichLabel















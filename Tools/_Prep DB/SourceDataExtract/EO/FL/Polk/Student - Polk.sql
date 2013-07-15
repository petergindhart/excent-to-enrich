set nocount on;
set ansi_warnings off;

/*  Polk is on an older version of EO that does not have the Race values in the Student table */

select  
	StudentRefID = s.GStudentID,
	StudentLocalID = s.StudentID,
	StudentStateID = s.AlterID, -- select top 10 s.* from student s join SpecialEdStudentsAndIEPs x on s.gstudentid = x.gstudentid
	s.Firstname,
	MiddleName = isnull(s.MiddleName,''),
	s.LastName,
	Birthdate = convert(varchar, s.Birthdate, 101),
	Gender = left(s.Sex, 1),
	MedicaidNumber = isnull(s.medicaidnum,''),
	GradeLevelCode = s.Grade, -- find out if this is current
	ServiceDistrictCode = h.ServiceDistCode, -- select top 10 * from reportstudentschools
	ServiceSchoolCode = h.ServiceSchCode,
	HomeDistrictCode = isnull(h.ResidDistCode, h.ServiceDistCode),
	HomeSchoolCode = isnull(h.ResidSchCode, h.ServiceSchCode),
--	s.Ethnic,
	IsHispanic = '', -- cast(case when HispanicLatino = 1 then 'Y' else 'N' end as varchar(1)), -- select top 10 * from student
	IsAmericanIndian = '', -- cast(case when AmerIndOrALNatRace = 1 then 'Y' else 'N' end as varchar(1)),
	IsAsian = '', -- cast(case when AsianRace = 1 then 'Y' else 'N' end as varchar(1)),
	IsBlackAfricanAmerican = '', -- cast(case when BlackOrAfrAmerRace = 1 then 'Y' else 'N' end as varchar(1)),
	IsHawaiianPacIslander = '', -- cast(case when NatHIOrOthPacIslRace = 1 then 'Y' else 'N' end as varchar(1)),
	IsWhite = '', -- cast(case when WhiteRace = 1 then 'Y' else 'N' end as varchar(1)),
	d.Disability1Code,
	d.Disability2Code,
	d.Disability3Code,
	d.Disability4Code,
	d.Disability5Code,
	d.Disability6Code,
	d.Disability7Code,
	d.Disability8Code,
	d.Disability9Code,
	ESYElig = case x.ESY when 1 then 'Y' else 'N' end,
	ExitDate = isnull(convert(varchar, s.SpedExitDate, 101),''),
	ExitCode = case isnull(s.SpedExitCode,'') when '0' then '' else isnull(s.SpedExitCode,'') end,
	SpecialEdStatus = case when s.SpedStat = 1 then 'A' else 'I' end
from SpecialEdStudentsAndIEPs x -- 2451 -- select * from SpecialEdStudentsAndIEPs -- select * from IEPTbl
JOIN Student s on x.GStudentID = s.GStudentID
JOIN ReportStudentSchools h on s.gstudentid = h.gstudentid
JOIN (
	select disab.GStudentID, 
		Disability1Code = max(case when Sequence = 1 then DisabilityID else '' end),
		Disability2Code = max(case when Sequence = 2 then DisabilityID else '' end),
		Disability3Code = max(case when Sequence = 3 then DisabilityID else '' end),
		Disability4Code = max(case when Sequence = 4 then DisabilityID else '' end),
		Disability5Code = max(case when Sequence = 5 then DisabilityID else '' end),
		Disability6Code = max(case when Sequence = 6 then DisabilityID else '' end),
		Disability7Code = max(case when Sequence = 7 then DisabilityID else '' end),
		Disability8Code = max(case when Sequence = 8 then DisabilityID else '' end),
		Disability9Code = max(case when Sequence = 9 then DisabilityID else '' end)
	from (
		select 
			sd.GStudentID, 
			sd.DisabilityID, 
			sd.PrimaryDiasb,
			Sequence = cast(1 as int)
		from StudDisability sd join
		DisabilityLook d on sd.DisabilityID = d.DisabilityID
		where isnull(sd.del_flag,0)=0
		and sd.PrimaryDiasb = 1
		union all
		select 
			sd.GStudentID, 
			sd.DisabilityID, 
			sd.PrimaryDiasb,
			Sequence = (select count(*)+1 from StudDisability dc where isnull(dc.del_flag,0)=0 and sd.PrimaryDiasb = 0 and dc.GStudentID = sd.gstudentid and dc.RecNum < sd.RecNum)
		from StudDisability sd join
		DisabilityLook d on sd.DisabilityID = d.DisabilityID
		where isnull(sd.del_flag,0)=0
		and sd.primarydiasb = 0
		-- order by sd.gstudentid, sequence
	) disab
	group by disab.GStudentID
	) d on s.gstudentid = d.gstudentid
GO



/*


select x.gstudentid, d1.DisabilityID
from SpecialEdStudentsAndIEPs x
join ReportStudPrimaryDisability d1 on x.gstudentid = d1.gstudentid
-- 2294

sp_helptext ReportStudPrimaryDisability

-- The correct column name to mimic ReportStudentPrimaryDisability in other states is DisabilityDesc
select D1.GStudentID, D1.DisabilityID, D.DisabDesc, D.DisabDesc as DisabilityDesc
FROM ReportStudDisab_A D1
JOIN DisabilityLook D on D1.DisabilityID = D.DisabilityID


sp_helptext ReportStudDisab_A 
Text


create view ReportStudDisab_A
as
select GStudentID, 
	CASE 
	when IntellCapab=1 then '01'
	when EmotDisab=1 then '03'
	when CommDisab=1 then '04'
	when HearDisab=1 then '05'
	when VisionDisab=1 then '06'
	when OthPhyDisab=1 then '07'
	when SpeechDisab=1 then '08'
	when DeafBlindDisab=1 then '09'
	when CogImpair=1 then '10'
	when PreDisab=1 then '11'
	when Autism=1 then '13'
	when TraBrain=1 then '14'
	else '00' end as DisabilityID
from EligConsiderTbl
where isnull(del_flag,0)!=1









select * from SpecialEdStudentsAndIEPs where gstudentid = '47AEC5EF-6668-4058-A83D-AF8DE6FBAB20'

select * from ReportStudentSchools where gstudentid = '47AEC5EF-6668-4058-A83D-AF8DE6FBAB20'

*/
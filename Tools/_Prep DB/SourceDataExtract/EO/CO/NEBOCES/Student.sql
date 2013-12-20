set nocount on;


declare @md table (EODistrictCode varchar(4), StateDistrictCode varchar(4))
insert @md values ('1000', '2862')

declare @ms table (EOSchoolCode varchar(4), StateSchoolCode varchar(4))

insert @ms values ('1001', '4369')
insert @ms values ('5223', '5221')
insert @ms values ('9790', '9791')
insert @ms values ('9794', '9795')
insert @ms values ('9798', '9799')
insert @ms values ('9724', '9725')
insert @ms values ('9728', '9729')
insert @ms values ('9732', '9733')


select  
	StudentRefID = s.GStudentID,
	StudentLocalID = s.StudentID,
	StudentStateID = s.AlterID, 
	s.Firstname,
	MiddleName = isnull(s.MiddleName,''),
	s.LastName,
	Birthdate = convert(varchar, s.Birthdate, 101),
	Gender = left(s.Sex, 1),
	MedicaidNumber = isnull(s.medicaidnum,''),
	GradeLevelCode = case isnull(s.Grade,'') when 'Kdg' then '006' when 'Pre' then '004' else isnull(s.Grade,'') end, -- find out if this is current
----oSvcDist = h.ServiceDistCode, 
----	msEODist = mds.EODistrictCode, 
----	mds.StateDistrictCode,
	ServiceDistrictCode = coalesce(mds.StateDistrictCode, h.ServiceDistCode, h.ResidDistCode,''), 
----oSvcSch = h.ServiceSchCode, 
----	msEOSch = mss.EOSchoolCode, 
----	mss.StateSchoolCode,
	ServiceSchoolCode = coalesce(mss.StateSchoolCode, h.ServiceSchCode, h.ResidSchCode, ''),
----oHomDist = h.ResidDistCode, 
----	oSvcDist = h.ServiceDistCode,
----	mhEODist = mdh.EODistrictCode, 
----	mhStDist = mdh.StateDistrictCode, 
----	msStDist = mds.StateDistrictCode,
	HomeDistrictCode = coalesce(mdh.StateDistrictCode, h.ResidDistCode, h.ServiceDistCode),
----oHomSch = h.ResidSchCode,
----	oSvcSch = h.ServiceSchCode, 
----	mhStSch = msh.StateSchoolCode, 
	HomeSchoolCode = coalesce(msh.StateSchoolCode, h.ResidSchCode, h.ServiceSchCode),
	IsHispanic = cast(case when HispanicLatino = 1 then 'Y' else 'N' end as varchar(1)), 
	IsAmericanIndian = cast(case when AmerIndOrALNatRace = 1 then 'Y' else 'N' end as varchar(1)),
	IsAsian = cast(case when AsianRace = 1 then 'Y' else 'N' end as varchar(1)),
	IsBlackAfricanAmerican = cast(case when BlackOrAfrAmerRace = 1 then 'Y' else 'N' end as varchar(1)),
	IsHawaiianPacIslander = cast(case when NatHIOrOthPacIslRace = 1 then 'Y' else 'N' end as varchar(1)),
	IsWhite = cast(case when WhiteRace = 1 then 'Y' else 'N' end as varchar(1)),
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
	ESYTBDDate = '',
	ExitDate = isnull(convert(varchar, s.SpedExitDate, 101),''),
	ExitCode = case isnull(s.SpedExitCode,'') when '0' then '' else isnull(s.SpedExitCode,'') end,
	SpecialEdStatus = case when s.SpedStat = 1 then 'A' else 'I' end
from SpecialEdStudentsAndIEPs x 
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
			Sequence = (select count(*)+2 from StudDisability dc where isnull(dc.del_flag,0)=0 and dc.PrimaryDiasb = 0 and dc.GStudentID = sd.gstudentid and dc.RecNum < sd.RecNum)
		from StudDisability sd join
		DisabilityLook d on sd.DisabilityID = d.DisabilityID
		where isnull(sd.del_flag,0)=0
		and sd.primarydiasb = 0
	) disab
	group by disab.GStudentID
	) d on s.gstudentid = d.gstudentid
left join @md mds on isnull(h.ServiceDistCode, h.ResidDistCode) = mds.EODistrictCode
left join @ms mss on isnull(h.ServiceSchCode, h.ResidSchCode) = mss.EOSchoolCode
left join @md mdh on isnull(h.ResidDistCode, h.ServiceDistCode) = mdh.EODistrictCode
left join @ms msh on isnull(h.ResidSchCode, h.ServiceSchCode) = msh.EOSchoolCode
--where h.ResidDistCode = '1000' or h.ServiceDistCode = '1000'
--where s.StudentID = '4603433577'
--where firstname = 'Dylan' and lastname= 'Simpson'
order by ServiceDistCode, ServiceSchCode
GO


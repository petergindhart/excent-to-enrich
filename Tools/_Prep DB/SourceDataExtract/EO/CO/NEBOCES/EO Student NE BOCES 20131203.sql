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
	--StudentRefID = s.GStudentID,
	StudentLocalID = s.StudentID,
	StudentStateID = s.AlterID, -- select top 10 s.* from student s join SpecialEdStudentsAndIEPs x on s.gstudentid = x.gstudentid
	s.Firstname,
	MiddleName = isnull(s.MiddleName,''),
	s.LastName,
	--Birthdate = convert(varchar, s.Birthdate, 101),
	--Gender = left(s.Sex, 1),
	--MedicaidNumber = isnull(s.medicaidnum,''),
	GradeLevelCode = case isnull(s.Grade,'') when 'Kdg' then '006' when 'Pre' then '004' else isnull(s.Grade,'') end, -- find out if this is current
mdsEODistrictCode = mds.EODistrictCode, mssStateSchoolCode = mss.StateSchoolCode, mdhEODistrictCode = mdh.EODistrictCode, mshStateSchoolCode = msh.StateSchoolCode, 
	ServiceDistrictCode = coalesce(mds.EODistrictCode, h.ServiceDistCode, h.ResidDistCode,''), 
	ServiceSchoolCode = coalesce(mss.StateSchoolCode, h.ServiceSchCode, h.ResidSchCode, ''),
	HomeDistrictCode = coalesce(mdh.EODistrictCode, h.ResidDistCode, h.ServiceDistCode),
	HomeSchoolCode = coalesce(msh.StateSchoolCode, h.ResidSchCode, h.ServiceSchCode),
	--IsHispanic = cast(case when HispanicLatino = 1 then 'Y' else 'N' end as varchar(1)), -- select top 10 * from student
	--IsAmericanIndian = cast(case when AmerIndOrALNatRace = 1 then 'Y' else 'N' end as varchar(1)),
	--IsAsian = cast(case when AsianRace = 1 then 'Y' else 'N' end as varchar(1)),
	--IsBlackAfricanAmerican = cast(case when BlackOrAfrAmerRace = 1 then 'Y' else 'N' end as varchar(1)),
	--IsHawaiianPacIslander = cast(case when NatHIOrOthPacIslRace = 1 then 'Y' else 'N' end as varchar(1)),
	--IsWhite = cast(case when WhiteRace = 1 then 'Y' else 'N' end as varchar(1)),
	d.Disability1Code,
	--d.Disability2Code,
	--d.Disability3Code,
	--d.Disability4Code,
	--d.Disability5Code,
	--d.Disability6Code,
	--d.Disability7Code,
	--d.Disability8Code,
	--d.Disability9Code,
	--ESYElig = case x.ESY when 1 then 'Y' else 'N' end,
	--ESYTBDDate = '',
	--ExitDate = isnull(convert(varchar, s.SpedExitDate, 101),''),
	--ExitCode = case isnull(s.SpedExitCode,'') when '0' then '' else isnull(s.SpedExitCode,'') end,
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
			Sequence = (select count(*)+2 from StudDisability dc where isnull(dc.del_flag,0)=0 and dc.PrimaryDiasb = 0 and dc.GStudentID = sd.gstudentid and dc.RecNum < sd.RecNum)
		from StudDisability sd join
		DisabilityLook d on sd.DisabilityID = d.DisabilityID
		where isnull(sd.del_flag,0)=0
		and sd.primarydiasb = 0
		-- order by sd.gstudentid, sequence
	) disab
	group by disab.GStudentID
	) d on s.gstudentid = d.gstudentid
left join @ms mss on h.ServiceSchCode = mss.EOSchoolCode
left join @md mds on h.ServiceDistCode = mds.EODistrictCode
left join @ms msh on h.ResidSchCode = msh.EOSchoolCode
left join @md mdh on h.ResidDistCode = mdh.EODistrictCode
where h.ResidDistCode = '1000' or h.ServiceDistCode = '1000'
order by ServiceDistCode, ServiceSchCode
GO




--select * from Grade

--select * from ReportStudentSchools where gstudentid = '0F19E3A6-A41C-43D4-9E86-96F759E5184B'

--select * from SchoolTbl s where GStudentID = '0F19E3A6-A41C-43D4-9E86-96F759E5184B' and s.Deletedate is null

--sp_helptext ReportStudentSchools



--Text


----	The ReportStudentSchools view depends on the ReportStudentSchoolTypes view, which is specific to each state and which was first created in the CO project.
--select 
--	h2.gstudentid, 
--	h2.ServiceSchCode, hs.SchoolName ServiceSchName, 
---- 	hs.SchoolRegion ServiceSchRegion, hs.SchoolType ServiceSchoolType, 
--	h2.ServiceDistCode, ds.districtname ServiceDistName, 
--	--h2.ResidSchCode, hr.SchoolName ResidSchName, hr.SchoolRegion ResidSchRegion, hr.SchoolType ResidSchoolType, h2.ResidDistCode, dr.DistrictName ResidDistName	
--	bogus = 0
--from (  
-- select s.GStudentID,   
--  ha.SchoolID ServiceSchCode, ha.DistCode ServiceDistCode, 
--  hb.SchoolID ResidSchCode, hb.DistCode ResidDistCode
-- from StudentActive s  
-- -- the following max queries are designed to avoid duplicate rows in the output of this view query.  Sometimes students will have multiple rows per school in SchoolTbl  
-- left join (
--  select gstudentid, max(recnum) recnum   
--  from schooltbl h  
--  join ReportStudentSchoolTypes t on h.schtype = t.schtype and t.schtypeorder in (1, 3)
--  where isnull(del_flag,0) = 0  
--  and GStudentID = '0F19E3A6-A41C-43D4-9E86-96F759E5184B'
--  group by gstudentid  
--  ) ha2 on s.gstudentid = ha2.gstudentid  
-- left join SchoolTbl ha on ha2.recnum = ha.recnum -- include gstudentid if nec to improve performance  
-- left join (
--  select gstudentid, max(recnum) recnum   
--  from schooltbl h  
--  join ReportStudentSchoolTypes t on h.schtype = t.schtype and t.schtypeorder in (2, 3)
--  where isnull(del_flag,0) = 0  
--  and GStudentID = '0F19E3A6-A41C-43D4-9E86-96F759E5184B'
--  group by gstudentid
-- ) hb2 on s.gstudentid = hb2.gstudentid
-- left join SchoolTbl hb on hb2.recnum = hb.recnum
-- ) h2
--left join School hs on h2.ServiceSchCode = hs.SchoolID and isnull(hs.del_flag,0)=0
----left join School hr on h2.ResidSchCode = hr.SchoolID and isnull(hr.del_flag,0)=0
--left join district ds on h2.ServiceDistCode = ds.DistrictID
--le--ft join district dr on h2.ResidDistCode = dr.DistrictID
--where GStudentID = '0F19E3A6-A41C-43D4-9E86-96F759E5184B'


--select * from ReportStudentSchoolTypes

--  select gstudentid, max(recnum) recnum   
--  from schooltbl h  
--  join ReportStudentSchoolTypes t on h.schtype = t.schtype and t.schtypeorder in (1, 3) -- school of attendance
--  where isnull(del_flag,0) = 0  
--  and GStudentID = '0F19E3A6-A41C-43D4-9E86-96F759E5184B'
--  group by gstudentid  

--  select gstudentid, max(recnum) recnum   
--  from schooltbl h  
--  join ReportStudentSchoolTypes t on h.schtype = t.schtype and t.schtypeorder in (2, 3)
--  where isnull(del_flag,0) = 0  
--  and GStudentID = '0F19E3A6-A41C-43D4-9E86-96F759E5184B'
--  group by gstudentid

--select * from ReportStudentSchoolTypes


--select * from SchoolTbl where GStudentID = '0F19E3A6-A41C-43D4-9E86-96F759E5184B' and Deletedate is null 


--select s.SchType, t.SchTypeOrder, count(*)
--from SpecialEdStudentsAndIEPs x
--join SchoolTbl s on x.GStudentID = s.GStudentID
--join ReportStudentSchoolTypes t on s.SchType = t.SchType
--group by s.SchType, t.SchTypeOrder



--sp_helptext ReportStudentSchoolTypes


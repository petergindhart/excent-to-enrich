IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vw_Student') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.vw_Student
GO

CREATE VIEW dbo.vw_Student
AS
select 
    --Line_No=Row_Number() OVER (ORDER BY (SELECT 1)), 
	StudentRefID = s.GStudentID,
	StudentLocalID = s.StudentID,
	StudentStateID = s.AlterID, -- select top 10 s.* from student s join SpecialEdStudentsAndIEPs x on s.gstudentid = x.gstudentid
	s.Firstname,
	MiddleName = s.MiddleName,
	s.LastName,
	Birthdate = convert(varchar, s.Birthdate, 101),
	Gender = left(s.Sex, 1),
	MedicaidNumber = s.medicaidnum,
	GradeLevelCode = s.Grade, -- find out if this is current
	ServiceDistrictCode = h.ServiceDistCode, -- select top 10 * from reportstudentschools
	ServiceSchoolCode = h.ServiceSchCode,
	HomeDistrictCode = isnull(h.ResidDistCode, h.ServiceDistCode),
	HomeSchoolCode = isnull(h.ResidSchCode, h.ServiceSchCode),
--	s.Ethnic,
	IsHispanic = cast(case when HispanicLatino = 1 then 'Y' else 'N' end as varchar(1)), -- select top 10 * from student
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
	ESYTBDDate = convert(varchar, y.ESYDeter, 101),
	ExitDate = convert(varchar, s.SpedExitDate, 101),
	ExitCode = case s.SpedExitCode when '0' then NULL else s.SpedExitCode end,
	SpecialEdStatus = case when s.SpedStat = 1 then 'A' else 'E' end	
from SpecialEdStudentsAndIEPs x -- 2451 -- select * from SpecialEdStudentsAndIEPs -- select * from IEPTbl
JOIN dbo.Student s on x.GStudentID = s.GStudentID
JOIN ReportStudentSchools h on s.gstudentid = h.gstudentid
JOIN (
	select disab.GStudentID, 
		Disability1Code = max(case when Sequence = 1 then DisabilityID else NULL end),
		Disability2Code = max(case when Sequence = 2 then DisabilityID else NULL end),
		Disability3Code = max(case when Sequence = 3 then DisabilityID else NULL end),
		Disability4Code = max(case when Sequence = 4 then DisabilityID else NULL end),
		Disability5Code = max(case when Sequence = 5 then DisabilityID else NULL end),
		Disability6Code = max(case when Sequence = 6 then DisabilityID else NULL end),
		Disability7Code = max(case when Sequence = 7 then DisabilityID else NULL end),
		Disability8Code = max(case when Sequence = 8 then DisabilityID else NULL end),
		Disability9Code = max(case when Sequence = 9 then DisabilityID else NULL end)
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
left join ICIEPSpecialFactorTbl y on x.IEPSeqNum = y.IEPComplSeqNum and y.RecNum = (
	select min(miny.RecNum)
	from ICIEPSpecialFactorTbl miny 
	where y.IEPComplSeqNum = miny.IEPComplSeqNum
	and isnull(miny.del_flag,0)=0 
	)
	
GO

IF  EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'student_src') AND type in (N'U'))
DROP TABLE dbo.student_src
GO
SELECT 
    Line_No= IDENTITY(INT,1,1), 
	StudentRefID ,
	StudentLocalID ,
	StudentStateID, -- select top 10 s.* from student s join SpecialEdStudentsAndIEPs x on s.gstudentid = x.gstudentid
	Firstname,
	MiddleName ,
	LastName,
	Birthdate,
	Gender ,
	MedicaidNumber ,
	GradeLevelCode, -- find out if this is current
	ServiceDistrictCode , -- select top 10 * from reportstudentschools
	ServiceSchoolCode ,
	HomeDistrictCode ,
	HomeSchoolCode ,
--	s.Ethnic,
	IsHispanic , -- select top 10 * from student
	IsAmericanIndian,
	IsAsian ,
	IsBlackAfricanAmerican ,
	IsHawaiianPacIslander ,
	IsWhite,
	Disability1Code,
	Disability2Code,
	Disability3Code,
	Disability4Code,
	Disability5Code,
	Disability6Code,
	Disability7Code,
	Disability8Code,
	Disability9Code,
	ESYElig ,
	ESYTBDDate ,
	ExitDate ,
	ExitCode,
	SpecialEdStatus
	INTO dbo.student_src
FROM vw_Student

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Student_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.Student_EO
GO

CREATE VIEW dbo.Student_EO
AS
SELECT 
    Line_No, 
	StudentRefID ,
	StudentLocalID ,
	StudentStateID, -- select top 10 s.* from student s join SpecialEdStudentsAndIEPs x on s.gstudentid = x.gstudentid
	Firstname,
	MiddleName ,
	LastName,
	Birthdate,
	Gender ,
	MedicaidNumber ,
	GradeLevelCode, -- find out if this is current
	ServiceDistrictCode , -- select top 10 * from reportstudentschools
	ServiceSchoolCode ,
	HomeDistrictCode ,
	HomeSchoolCode ,
--	s.Ethnic,
	IsHispanic , -- select top 10 * from student
	IsAmericanIndian,
	IsAsian ,
	IsBlackAfricanAmerican ,
	IsHawaiianPacIslander ,
	IsWhite,
	Disability1Code,
	Disability2Code,
	Disability3Code,
	Disability4Code,
	Disability5Code,
	Disability6Code,
	Disability7Code,
	Disability8Code,
	Disability9Code,
	ESYElig ,
	ESYTBDDate ,
	ExitDate ,
	ExitCode,
	SpecialEdStatus
FROM dbo.student_src


--SELECT * FROM dbo.Student_EO
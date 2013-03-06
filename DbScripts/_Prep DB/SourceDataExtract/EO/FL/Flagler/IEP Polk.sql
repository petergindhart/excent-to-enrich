set nocount on;
set ansi_warnings off;

-- select InitConsentServDate, MeetDate, NextEligMeet, ReviewMeet, InitConsentForEvalDate, InitEligibilityDate from IEPTbl

select IepRefId = i.IEPSeqNum, 
	StudentRefId = x.gstudentid, 
	IEPMeetDate = isnull(convert(varchar, i.MeetDate, 101), ''),
	IEPStartDate = isnull(convert(varchar, i.MeetDate, 101),''),
	IEPEndDate = isnull(convert(varchar, i.ReviewDate, 101),''), -- isnull(convert(varchar, dateadd(dd, -1, dateadd(yy, 1, i.InitDate)), 101),''),
	-- NextReviewDate = isnull(convert(varchar, i.ReviewDate, 101),''),
	NextReviewDate = isnull(convert(varchar, dateadd(yy, 1, dateadd(dd, -1, i.MeetDate)), 101), ''), -- Per Chris Enrich 5/17/2012
	InitialEvaluationDate = '', -- isnull(convert(varchar, i.InitConsentForEvalDate, 101), ''), -- elig = eval?   InitConsentForEvalDate not InitEligibilityDate
	LatestEvaluationDate =  isnull(convert(varchar, i.CurEvalDate, 101),''),
	NextEvaluationDate = isnull(convert(varchar, isnull(i.ReEvalDate, dateadd(dd, -1, dateadd(yy, 3, i.CurEvalDate))), 101), ''), 
	EligibilityDate = '',-- isnull(convert(varchar, i.ReEvalDate, 101), ''), 
	ConsentForServicesDate = isnull(convert(varchar, i.InitDate, 101),''), -- en lieu of obtaining the date from another data source -- isnull(convert(varchar, i.InitConsentServDate, 101),''),
	ConsentForEvaluationDate = convert(varchar, isnull(n.ConsentDate, i.CurEvalDate), 101), 
	LREAgeGroup = x.AgeGroup,
	LRECode = isnull(x.Placement,''),
	MinutesPerWeek = cast (0 as int), -- cast(cast(ep.TotalSchoolHoursPerWeek*60 as int)as varchar(4)),
	ServiceDeliveryStatement = '' -- select x.GStudentID             -- replace(isnull(convert(varchar(8000), t.servdeliv),''), char(13)+char(10), char(240)+'^') -- note :  will have to remove line breaks
from SpecialEdStudentsAndIEPs x
join IEPCompleteTbl i on x.iepseqnum = i.iepseqnum 
left join NoticeTbl n on x.GStudentID = n.GStudentID and isnull(n.del_flag,0)=0 and n.ConsentDate is not null
	and n.NoticeSeqNum = (
		select max(qmax.NoticeSeqNum) 
		from NoticeTbl qmax 
		where isnull(qmax.del_flag,0)=0 
		and n.GStudentID = qmax.GStudentID
		and qmax.ConsentDate is not null
		and n.ConsentDate = (
			select max(nmax.ConsentDate)
			from NoticeTbl nmax
			where qmax.GStudentID = nmax.GStudentID
			and isnull(nmax.del_flag,0)=0 and nmax.ConsentDate is not null
			)
		)
go

-- 7471



-- select * from IepCompleteTbl
-- select * from iepcompletetbl where IepSeqNum = 175012
-- select * from Student where GStudentID = 'A0018CBB-DE04-46CA-BCAD-003F80396567'


-- select * from SpecialEdStudentsAndIEPs -- 7482


--select o.name, c.name
--from sysobjects o
--join syscolumns c on o.id = c.id
--join systypes t on c.xusertype = t.xusertype
--where o.type = 'U'
--and c.name like '%eval%'
--and t.name like '%date%'
--and c.name not in ('createdate', 'deletedate', 'modifydate')
--order by o.name, c.name


--select * from StudDisability


--select * from ConsentAgencyTbl
--select * from ConsentDataTbl
--select * from NoticeTbl
--select * from ProcEligibilityTbl
--ProcEligibilityTbl


--select o.name, c.name
--from (
--	select distinct o.id, o.name
--	from sysobjects o
--	join syscolumns c on o.id = c.id
--	where o.type = 'U'
--	and c.name like '%consent%'
--	) o
--join syscolumns c on o.id = c.id
--join systypes t on c.xusertype = t.xusertype
--where t.name like '%date%'
--and c.name not in ('createdate', 'deletedate', 'modifydate')
--order by o.name, c.name


--select * from ProcEligibilityTbl


--select p.gstudentid, count(*) tot
--from SpecialEdStudentsAndIEPs x
--join AssessmentTbl p on x.gstudentid = p.gstudentid
--group by p.gstudentid
--having count(*) > 1

--select * from AssessmentTbl 
--where gstudentid = 'FDDDD426-4F8C-475D-B6F4-158D60FEF0A5'



--select * from IEPTbl

--select * from sysobjects o join syscolumns c on o.id = c.id where o.type = 'U' and c.name = 'Placement'

--select SchPrimInstrCode, count(*) tot
--from IEPLRETbl 
--where modifydate >= '1/1/2009'
--group by SchPrimInstrCode
--order by SchPrimInstrCode 

--declare @g uniqueidentifier ; select @g = gstudentid from student where studentid = '56301'
--select * from TransServTbl where gstudentid = @g

--select Gstudentid, count(*) tot
--from TransServTbl 
--where servdeliv is not null
--group by Gstudentid
--having count(*) > 1


--select p.gstudentid, count(*) tot
--from IEPLRETbl p
--join SpecialEdStudentsAndIEPs x on p.gstudentid = x.gstudentid
--group by p.gstudentid
--having count(*) > 1

--select * 
--from IEPLRETbl p
--where gstudentid = '4591EDD5-504E-4CD4-B92E-17075A3553C0'




--IEPStartDate = IEP Meeting Date
--IEPEndDate = (IEP Meeting date plus 1 year minus 1 day)
--NextReviewDate = Next iep review (on or before)
--InitialEvaluationDate = Initial Eligibility
--LatestEvaluationDate =  ??????
--NextEvaluationDate = Next Eligibility Meeting
--ConsentForServicesDate = Initial Consent For Services?





--txtConsentGivenDate	
--	InitConsentServDate

--txtMeetDate		iep meeting date
--	MeetDate

--txtNxtElig		next eligibility meeting
--	NextEligMeet

--txtNxtIEPRev		Next iep review (on or before)
--	ReviewMeet

--txtInitConEval		initial consent for eval
--	InitConsentForEvalDate

--txtInitElig		initial eligibility
--	InitEligibilityDate


--initial eval
--latest eval date



--select o.name, c.name 
--from sysobjects o join syscolumns c on o.id = c.id join systypes t on c.xusertype = t.xusertype where o.type = 'U' and c.name like '%eval%' and t.name like '%date%' -- and o.name like '%eval%'
--order by o.name, c.name




--select studentid, lastname, firstname, age
--from student s
--join dbo.fn_studentAge('12/1/2010') a on s.studentindex = a.studentindex
--join ieptbl i on s.gstudentid = i.gstudentid
--where age between 3 and 5
--and i.iepcomplete = 'IEPComplete'



--servdeliv comes from TransServTbl


--select * from Student where GStudentID = '3BCECDF5-2EC6-4EB0-8736-27AE6F78A9F5'


--select o.name from sysobjects o join syscolumns c on o.id = c.id where o.type = 'U' and c.name = 'ServDeliv'










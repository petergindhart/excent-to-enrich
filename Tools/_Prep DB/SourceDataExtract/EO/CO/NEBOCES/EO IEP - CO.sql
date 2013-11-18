set nocount on;
set ansi_warnings off;

-- select InitConsentServDate, MeetDate, NextEligMeet, ReviewMeet, InitConsentForEvalDate, InitEligibilityDate from IEPTbl

-- select StudentRefId, count(*) tot from (
select IepRefId = i.IEPSeqNum, 
	StudentRefId = x.gstudentid, 
	IEPMeetDate = isnull(convert(varchar, i.MeetDate, 101), ''),
	IEPStartDate = isnull(convert(varchar, i.MeetDate, 101),''),
	IEPEndDate = isnull(convert(varchar, dateadd(dd, -1, dateadd(yy, 1, i.MeetDate)), 101),''),
	NextReviewDate = convert(varchar, i.ReviewMeet, 101),
	InitialEvaluationDate = isnull(convert(varchar, i.InitConsentForEvalDate, 101), ''), -- elig = eval?   InitConsentForEvalDate not InitEligibilityDate
	LatestEvaluationDate =  isnull(convert(varchar, dateadd(yy, -3, i.NextEligMeet), 101),''), -- fudging this for now
	NextEvaluationDate = isnull(convert(varchar, i.NextEligMeet, 101), ''), 
	EligibilityDate = '',
	ConsentForServicesDate = isnull(convert(varchar, i.InitConsentServDate, 101),''),
	ConsentForEvaluationDate = convert(varchar, isnull(i.InitConsentForEvalDate, ''), 101),
	LREAgeGroup = case 
			when p.SchPrimInstrCode between '100' and '199' then 'Inf'
			when p.SchPrimInstrCode between '200' and '299' then 'PK'
			when p.SchPrimInstrCode between '300' and '399' then 'K12'
			-- else ''
		end,
	LRECode = isnull(p.SchPrimInstrCode,''),
	MinutesPerWeek = cast (0 as int), -- cast(cast(ep.TotalSchoolHoursPerWeek*60 as int)as varchar(4)),
	ServiceDeliveryStatement = replace(isnull(convert(varchar(8000), t.servdeliv),''), char(13)+char(10), char(240)+'^') -- note :  will have to remove line breaks
from SpecialEdStudentsAndIEPs x
JOIN IEPCompleteTbl i on x.IEPSeqNum = i.IEPSeqNum
join ICIEPLRETbl p on i.IEPSeqNum = p.IEPComplSeqNum and x.IEPLRESeqNum = p.IEPLRESeqNum
left join ICTransServTbl t on i.IEPSeqNum = t.IEPComplSeqNum and x.TranSeqNum = t.TranSeqNum
go


--select top 1 * from IEPCompleteTbl


--left join NoticeTbl n on x.GStudentID = n.GStudentID and isnull(n.del_flag,0)=0 and n.ConsentDate is not null
--	and n.NoticeSeqNum = (
--		select max(qmax.NoticeSeqNum) 
--		from NoticeTbl qmax 
--		where isnull(qmax.del_flag,0)=0 
--		and n.GStudentID = qmax.GStudentID
--		and qmax.ConsentDate is not null
--		and n.ConsentDate = (
--			select max(nmax.ConsentDate)
--			from NoticeTbl nmax
--			where qmax.GStudentID = nmax.GStudentID
--			and isnull(nmax.del_flag,0)=0 and nmax.ConsentDate is not null
--			)
--		)


--select * from StudDisability

--select o.name, c.name
--from sys.objects o
--join sys.columns c on o.object_id = c.object_id
--join sys.types t on c.user_type_id = t.user_type_id
--where c.name like '%send%'
--and o.type = 'U'
---- and t.name like '%date%'
--order by o.name, c.name

--select top 1 * from EligConsiderTbl ec order by ec.EligConSeqNum desc
--select top 1 * from EligConsiderSubTbl st order by st.EligConSeqNum desc

--select top 100 * from IEPTransferTbl t order by t.TransSeqNum desc

--select top 100 * from MeetingTbl order by MeetSeqNum desc


--select MeetPurposeElig, count(*) tot
--from MeetingTbl 
--group by MeetPurposeElig
--order by MeetPurposeElig desc

----Version: 3.0.0.5186 - CO

--select * from Setting




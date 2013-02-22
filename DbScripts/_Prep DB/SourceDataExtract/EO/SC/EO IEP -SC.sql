-- select InitConsentServDate, MeetDate, NextEligMeet, ReviewMeet, InitConsentForEvalDate, InitEligibilityDate from IEPTbl

-- select StudentRefId, count(*) tot from (
select IepRefId = i.IEPSeqNum, 
	StudentRefId = x.gstudentid, 
	IEPMeetDate = isnull(convert(varchar, i.MeetDate, 101), ''),
	IEPStartDate = isnull(convert(varchar, i.MeetDate, 101),''),  --replIEPStartDate
	IEPEndDate = isnull(convert(varchar, dateadd(dd, -1, dateadd(yy, 1, i.MeetDate)), 101),''),
	NextReviewDate = convert(varchar, i.ReviewDate, 101),
	InitialEvaluationDate = isnull(convert(varchar, i.CurrEvalDate, 101), ''), -- elig = eval?   InitConsentForEvalDate not InitEligibilityDate
	LatestEvaluationDate =  isnull(convert(varchar, dateadd(yy, -3, i.LastIEPDate), 101),''), -- fudging this for now
	NextEvaluationDate = isnull(convert(varchar, i.ReEvalDate, 101), ''), 
	EligibilityDate = '',
	ConsentForServicesDate = isnull(convert(varchar, i.MeetDate, 101),''), --replIEPStartDate
	ConsentForEvaluationDate = '',
	LREAgeGroup = '',
	/*
	case 
			when p.SchPrimInstrCode between '100' and '199' then 'Infant'
			when p.SchPrimInstrCode between '200' and '299' then 'PK'
			when p.SchPrimInstrCode between '300' and '399' then 'K12'
			-- else ''
		end,
		*/
	LRECode = isnull(p.LRECode,''),
	MinutesPerWeek = cast (0 as int), -- cast(cast(ep.TotalSchoolHoursPerWeek*60 as int)as varchar(4)),
	ServiceDeliveryStatement = ''
	--ServiceDeliveryStatement = replace(isnull(convert(varchar(8000), t.servdeliv),''), char(13)+char(10), char(240)+'^') -- note :  will have to remove line breaks
from SpecialEdStudentsAndIEPs x
JOIN IEPCompleteTbl i on x.IEPSeqNum = i.IEPSeqNum
join ICIEPLRETbl p on i.IEPSeqNum = p.IEPComplSeqNum and x.IEPLRESeqNum = p.IEPLRESeqNum
--left join ICTransServTbl t on i.IEPSeqNum = t.IEPComplSeqNum and x.TranSeqNum = t.TranSeqNum
go

--select * from IEPCompleteTbl
--select * from ICIEPLRETbl
--select * from IEPTbl_SC
--select * from IEPTbl
--select * from ReportIEPTbl
--select * from ReportIEPCompleteTbl
--select * FROM IEPLRETbl
--select * from EligibilityTbl
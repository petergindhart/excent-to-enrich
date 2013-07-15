use ExcentOnline
go

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
	ConsentForServicesDate = isnull(convert(varchar, i.InitConsentServDate, 101),''),
	LREAgeGroup = case 
			when p.SchPrimInstrCode between '100' and '199' then 'Infant'
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


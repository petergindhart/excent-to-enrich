use EO_SC
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.IEP_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.IEP_EO
GO

CREATE VIEW dbo.IEP_EO
AS
-- select StudentRefId, count(*) tot from (
SELECT 
    Line_No=Row_Number() OVER (ORDER BY (SELECT 1)), 
    IepRefId = i.IEPSeqNum, 
	StudentRefId = x.gstudentid, 
	IEPMeetDate = convert(varchar, i.MeetDate, 101), 
	IEPStartDate = convert(varchar, i.MeetDate, 101),  --replIEPStartDate
	IEPEndDate = convert(varchar, dateadd(dd, -1, dateadd(yy, 1, i.MeetDate)), 101),
	NextReviewDate = convert(varchar, i.ReviewDate, 101),
	InitialEvaluationDate = convert(varchar, i.CurrEvalDate, 101), -- elig = eval?   InitConsentForEvalDate not InitEligibilityDate
	LatestEvaluationDate =  convert(varchar, dateadd(yy, -3, i.LastIEPDate), 101), -- fudging this for now
	NextEvaluationDate = convert(varchar, i.ReEvalDate, 101), 
	EligibilityDate = NULL,
	ConsentForServicesDate = convert(varchar, i.MeetDate, 101), --replIEPStartDate
	ConsentForEvaluationDate = NULL,
	LREAgeGroup = NULL,
	/*
	case 
			when p.SchPrimInstrCode between '100' and '199' then 'Infant'
			when p.SchPrimInstrCode between '200' and '299' then 'PK'
			when p.SchPrimInstrCode between '300' and '399' then 'K12'
			-- else ''
		end,
		*/
	LRECode = p.LRECode,
	MinutesPerWeek = cast (0 as int), -- cast(cast(ep.TotalSchoolHoursPerWeek*60 as int)as varchar(4)),
	ServiceDeliveryStatement = NULL
	--ServiceDeliveryStatement = replace(isnull(convert(varchar(8000), t.servdeliv),''), char(13)+char(10), char(240)+'^') -- note :  will have to remove line breaks
FROM SpecialEdStudentsAndIEPs x
JOIN IEPCompleteTbl i on x.IEPSeqNum = i.IEPSeqNum
join ICIEPLRETbl p on i.IEPSeqNum = p.IEPComplSeqNum and x.IEPLRESeqNum = p.IEPLRESeqNum
--left join ICTransServTbl t on i.IEPSeqNum = t.IEPComplSeqNum and x.TranSeqNum = t.TranSeqNum


--select * from IEPCompleteTbl
--select * from ICIEPLRETbl
--select * from IEPTbl_SC
--select * from IEPTbl
--select * from ReportIEPTbl
--select * from ReportIEPCompleteTbl
--select * FROM IEPLRETbl
--select * from EligibilityTbl
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vw_IEP') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.vw_IEP
GO

CREATE VIEW dbo.vw_IEP
AS
-- select StudentRefId, count(*) tot from (
SELECT 
    --Line_No=Row_Number() OVER (ORDER BY (SELECT 1)), 
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
	LRECode = ISNULL(p.LRECode,'ZZZ'),
	MinutesPerWeek = cast (0 as int), -- cast(cast(ep.TotalSchoolHoursPerWeek*60 as int)as varchar(4)),
	ServiceDeliveryStatement = NULL
	--ServiceDeliveryStatement = replace(isnull(convert(varchar(8000), t.servdeliv),''), char(13)+char(10), char(240)+'^') -- note :  will have to remove line breaks
FROM SpecialEdStudentsAndIEPs x
JOIN IEPCompleteTbl i on x.IEPSeqNum = i.IEPSeqNum
join ICIEPLRETbl p on i.IEPSeqNum = p.IEPComplSeqNum and x.IEPLRESeqNum = p.IEPLRESeqNum
--left join ICTransServTbl t on i.IEPSeqNum = t.IEPComplSeqNum and x.TranSeqNum = t.TranSe

GO

IF  EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'iep_src') AND type in (N'U'))
DROP TABLE dbo.iep_src
GO
SELECT 
    Line_No= IDENTITY(INT,1,1), 
    IepRefId , 
	StudentRefId , 
	IEPMeetDate , 
	IEPStartDate ,  --replIEPStartDate
	IEPEndDate,
	NextReviewDate ,
	InitialEvaluationDate , -- elig = eval?   InitConsentForEvalDate not InitEligibilityDate
	LatestEvaluationDate, -- fudging this for now
	NextEvaluationDate, 
	EligibilityDate = NULL,
	ConsentForServicesDate , --replIEPStartDate
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
	LRECode ,
	MinutesPerWeek , -- cast(cast(ep.TotalSchoolHoursPerWeek*60 as int)as varchar(4)),
	ServiceDeliveryStatement 
	INTO dbo.iep_src
FROM dbo.vw_IEP

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.IEP_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.IEP_EO
GO

CREATE VIEW dbo.IEP_EO
AS
SELECT 
    Line_No, 
    IepRefId , 
	StudentRefId , 
	IEPMeetDate , 
	IEPStartDate ,  --replIEPStartDate
	IEPEndDate,
	NextReviewDate ,
	InitialEvaluationDate , -- elig = eval?   InitConsentForEvalDate not InitEligibilityDate
	LatestEvaluationDate, -- fudging this for now
	NextEvaluationDate, 
	EligibilityDate = NULL,
	ConsentForServicesDate , --replIEPStartDate
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
	LRECode ,
	MinutesPerWeek , -- cast(cast(ep.TotalSchoolHoursPerWeek*60 as int)as varchar(4)),
	ServiceDeliveryStatement 
FROM dbo.iep_src
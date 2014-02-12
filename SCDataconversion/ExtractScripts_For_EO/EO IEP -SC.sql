IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.IEP_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.IEP_EO
GO

CREATE VIEW dbo.IEP_EO
AS

SELECT 
    Line_No=Row_Number() OVER (ORDER BY (SELECT 1)), 
    IepRefId = i.IEPSeqNum, 
	StudentRefId = x.gstudentid, 
	IEPMeetDate = convert(varchar, x.MeetDate, 101), 
	IEPStartDate = convert(varchar, x.StartDate, 101),  
	IEPEndDate = convert(varchar, x.EndDate, 101), -- 
	NextReviewDate = convert(varchar, x.ReviewDate, 101),
	InitialEvaluationDate = convert(varchar, pMin.LastEvalDate, 101),  --- ( Eligibility/Revaluation Determination Date ? ) -- MIN
	LatestEvaluationDate =  convert(varchar, pMax.LastEvalDate, 101), -- Eligibility/Reevaluation Determination Date ...  SC_PlaceHistoryTbl.LastEvalDate ... max teammeetingdate
	NextEvaluationDate = convert(varchar, pMax.AnticipatedDate, 101),  -- Anticipated date of 3 year Reevaluation ... SC_PlaceHistoryTbl.AnticipatedDate
	EligibilityDate = convert(varchar, pMin.InitialEligDate, 101), -- SC_PlaceConsentTbl.InitialEligDate (min TeamMeetingDate ) -------------------------------------------------- look for the initial flag, also
	ConsentForServicesDate = convert(varchar, cMin.ReceiveDate, 101), -- SC_PlaceConsentTbl.ReceiveDate
	ConsentForEvaluationDate = convert(varchar, pMax.ParentalConsentToEvalDate, 101), -- MeetingTbl.ParRespDate  (MeetingTbl_SC, where Reason2 = 1)  ---   SC_PlaceHistoryTbl.ParentalConsentToEvalDate (for one student found this on the MOST RECENT ph record)
	LREAgeGroup = lre.AgeGroup,
	LRECode = lre.Placement,
	MinutesPerWeek = cast (0 as int), -- cast(cast(ep.TotalSchoolHoursPerWeek*60 as int)as varchar(4)),
 	ServiceDeliveryStatement = NULL
from SpecialEdStudentsAndIEPs x
join IEPCompleteTbl i on x.IEPSeqNum = i.IEPSeqNum
join DataConversionLREPlacementView lre on i.IEPSeqNum = lre.IEPComplSeqNum
join SC_PlaceHistoryTbl pmax on x.GStudentID = pmax.GStudentID 
	and pmax.RecNum = (
		select max(nmax.RecNum)
		from SC_PlaceHistoryTbl nmax
		where isnull(nmax.del_flag,0)=0 
		and pMax.GStudentID = nMax.GStudentID 
		and nmax.PlaceDate = (
			select max(tMax.PlaceDate)
			from SC_PlaceHistoryTbl tMax
			where isnull(tmax.del_flag,0)=0 
			and nMax.GStudentID = tMax.GStudentID 
			and isnull(tmax.TeamMeetingDate, tmax.PlaceDate) = (
				select max(isnull(maxr.TeamMeetingDate, maxr.PlaceDate))
				from SC_PlaceHistoryTbl maxr
				where tMax.GStudentID = maxr.gstudentid and isnull(maxr.del_flag,0)=0   ) 
			) 
		) 
join SC_PlaceHistoryTbl pmin on x.GStudentID = pmin.GStudentID 
	and pmin.RecNum = (
		select min(nmin.RecNum)
		from SC_PlaceHistoryTbl nmin
		where isnull(nmin.del_flag,0)=0 
		and pmin.GStudentID = nmin.GStudentID 
		and nmin.PlaceDate = (
			select min(tmin.PlaceDate)
			from SC_PlaceHistoryTbl tmin
			where isnull(tmin.del_flag,0)=0 
			and nmin.GStudentID = tmin.GStudentID 
			and isnull(tmin.TeamMeetingDate, tmin.PlaceDate) = (
				select min(isnull(minr.TeamMeetingDate, minr.PlaceDate))
				from SC_PlaceHistoryTbl minr
				where tmin.GStudentID = minr.gstudentid and isnull(minr.del_flag,0)=0   ) 
			) 
		) 

left join SC_PlaceConsentTbl cMin on x.GStudentID = cMin.GStudentID
	and cmin.PlaceConsentSeqNum = (
		select min(qMin.PlaceConsentSeqNum)
		from SC_PlaceConsentTbl qmin
		where cMin.GStudentID = qMin.GStudentID and isnull(qMin.del_flag,0)=0 
		and qMin.InitialDate = (
			select min(xMin.InitialDate)
			from SC_PlaceConsentTbl xMin
			where qMin.GStudentID = xMin.GStudentID and isnull(xMin.del_flag,0)=0 
		) 
	)
GO
-- 


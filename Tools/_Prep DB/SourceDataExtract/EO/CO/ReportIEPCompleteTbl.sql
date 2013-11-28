
/****** Object:  View [dbo].[ReportIEPCompleteTbl]    Script Date: 10/17/2013 1:57:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



ALTER  view [dbo].[ReportIEPCompleteTbl]
as
/*
This view is specific to the state of CO
*/
Select i.RecNum,
	I.GStudentID, I.IEPSeqNum, MeetDate, LastIEPDate, isnull(IEPComplete, 'Draft') IEPComplete,
	Ia.Type as IEPType, NULL as IEPAppDate,
	F.FirstName+' '+F.LastName as CaseMgr, F.Title as CaseMgrTitle, 
	I.ReviewMeet ReviewDate, I.NextEligMeet as ReEvalDate, I.MeetDate as CurrEvalDate, ReviseDate as repIEPReviseDate,
	I.MeetDate as repIEPStartDate, -- There is no IEP Start date for Colorado
	isnull(T.ServBeyond,0) as ESYElig
from IEPCompleteTbl I
left join IEPAddInfoTbl Ia on I.GStudentID = Ia.GStudentID and I.IEPSeqNum = Ia.IEPSeqNum
left join (select GStudentID, max(TranSeqNum) TranSeqNum from TransServTbl where isnull(del_flag,0)!=1 group by gstudentid) t2
	on i.GStudentID = t2.GStudentID
left join TransServTbl T on T2.GStudentID = T.GStudentID and T2.TranSeqNum = T.TranSeqNum
LEFT JOIN AccessMembers A ON (I.GStudentID = A.GStudentid and isnull(a.del_flag,0)=0 AND A.CaseMgr = 1)
LEFT JOIN StaffActive F ON A.StaffGID = F.StaffGID
where isnull(I.del_flag,0)!=1
GO



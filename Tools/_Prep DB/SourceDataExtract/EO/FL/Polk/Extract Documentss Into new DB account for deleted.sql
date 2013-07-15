
select s.* 
into SPEDDOC.dbo.AllDocs
from (
select 
	DocumentRefID = x.AssessDevSeq,
	DocumentType = CAST('Reevaluation' AS varchar(100)), -- done
	DocumentDate = x.Meetdate,
	StudentRefID = x.GStudentID,
	MimeType = cast('document/pdf' as varchar(25)),
	Content = SavedPDF
from -- select * from 
	ExcentOnline.dbo.AssessDevTbl x 
where 
	SavedPDF is not null
	and isnull(del_flag,0)=0
-- 
union all
select 
	DocumentRefID = x.BehavSeqNum,
	DocumentType = CAST('BIP' AS varchar(100)), -- done
	DocumentDate = x.PlanDate,
	StudentRefID = x.GStudentID,
	MimeType = cast('document/pdf' as varchar(25)),
	Content = SavedPDF
from
	ExcentOnline.dbo.BehaviourInterTbl x 
where 
	SavedPDF is not null
	and isnull(del_flag,0)=0
-- 
union all
select 
	DocumentRefID = x.ConfSeqNum,
	DocumentType = CAST('Conference' AS varchar(100)), -- done
	DocumentDate = coalesce(x.Date2, x.Date1, x.CreateDate),
	StudentRefID = x.GStudentID,
	MimeType = cast('document/pdf' as varchar(25)),
	Content = SavedPDF
from
	ExcentOnline.dbo.ConferenceTbl x 
where 
	SavedPDF is not null
	and isnull(del_flag,0)=0
-- 
union all
select 
	DocumentRefID = x.ConsentSeqNum,
	DocumentType = CAST('Consent' AS varchar(100)), -- done
	DocumentDate = isnull(x.LetDate, x.CreateDate),
	StudentRefID = x.GStudentID,
	MimeType = cast('document/pdf' as varchar(25)),
	Content = SavedPDF -- select * 
from
	ExcentOnline.dbo.ConsentDataTbl x 
where 
	SavedPDF is not null
	and isnull(del_flag,0)=0
-- 
union all
select 
	DocumentRefID = x.AssessSeqNum,
	DocumentType = CAST('Eligibility Assessment' AS varchar(100)),
	DocumentDate = isnull(x.ReportDate, x.CreateDate),
	StudentRefID = x.GStudentID,
	MimeType = cast('document/pdf' as varchar(25)),
	Content = SavedPDF -- select x.*
from
	ExcentOnline.dbo.EligAssessTbl x 
where 
	SavedPDF is not null
	and isnull(del_flag,0)=0
-- 
union all
select 
	DocumentRefID = x.MeetSeqNum,
	DocumentType = CAST('Meeting' AS varchar(100)),
	DocumentDate = coalesce(x.Attempt3, x.Attempt2, x.Attempt1, x.CreateDate),
	StudentRefID = x.GStudentID,
	MimeType = cast('document/pdf' as varchar(25)),
	Content = SavedPDF -- select x.*
from
	ExcentOnline.dbo.MeetingTbl x 
where 
	SavedPDF is not null
	and isnull(del_flag,0)=0
-- 
union all
select 
	DocumentRefID = x.NoticeSeqNum,
	DocumentType = CAST('Notice' AS varchar(100)),
	DocumentDate = isnull(x.NoticeDate, x.CreateDate),
	StudentRefID = x.GStudentID,
	MimeType = cast('document/pdf' as varchar(25)),
	Content = SavedPDF -- select x.*
from
	ExcentOnline.dbo.NoticeTbl x 
where 
	SavedPDF is not null
	and isnull(del_flag,0)=0
-- 
union all
select 
	DocumentRefID = x.PriorSeqNum,
	DocumentType = CAST('Prior Notice' AS varchar(100)),
	DocumentDate = isnull(x.NoticeDate, x.CreateDate),
	StudentRefID = x.GStudentID,
	MimeType = cast('document/pdf' as varchar(25)),
	Content = SavedPDF -- select x.*
from
	ExcentOnline.dbo.PriorNoticeTbl x 
where 
	SavedPDF is not null
	and isnull(del_flag,0)=0
-- 
union all
select 
	DocumentRefID = x.EligSeqNum,
	DocumentType = CAST('Eligibility' AS varchar(100)),
	DocumentDate = isnull(x.MeetDate, x.CreateDate),
	StudentRefID = x.GStudentID,
	MimeType = cast('document/pdf' as varchar(25)),
	Content = SavedPDF -- select x.*
from
	ExcentOnline.dbo.ProcEligibilityTbl x 
where 
	SavedPDF is not null
	and isnull(del_flag,0)=0
-- 
union all
select 
	DocumentRefID = x.ReferSeqNum,
	DocumentType = CAST('Referral' AS varchar(100)),
	DocumentDate = isnull(x.MeetDate, x.CreateDate),
	StudentRefID = x.GStudentID,
	MimeType = cast('document/pdf' as varchar(25)),
	Content = SavedPDF -- select x.*
from
	ExcentOnline.dbo.ReferralTbl x 
where 
	SavedPDF is not null
	and isnull(del_flag,0)=0
union all
select -- COUNT(*) tot
	DocumentRefID = x.iepseqnum,
	DocumentType = CAST('IEP' AS varchar(100)),
	DocumentDate = isnull(x.MeetDate, ic.CreateDate),
	StudentRefID = x.GStudentID,
	MimeType = cast('document/pdf' as varchar(25)),
	Content = PDFImage -- select x.*
from ExcentOnline.dbo.SpecialEdStudentsAndIEPs x 
join ExcentOnline.dbo.IEPCompleteTbl ic on x.IEPSeqNum = ic.IEPSeqNum and isnull(ic.del_flag,0)=0
join ExcentOnline.dbo.IEPArchiveDocTbl ad on ic.RecNum = ad.RecNum and ic.GStudentID = ad.GStudentID -- 11506
where ad.RecNum = (
	select MAX(y.RecNum)
	from IEPArchiveDocTbl y 
	where ad.GStudentID = y.GStudentID
	and isnull(y.del_flag,0)=0
	) -- 11003
union all
select -- COUNT(*) tot
	DocumentRefID = x.IEPConsiderSeqNum,
	DocumentType = CAST('Matrix of Services' AS varchar(100)),
	DocumentDate = isnull(x.CompDate, x.CreateDate),
	StudentRefID = x.GStudentID,
	MimeType = cast('document/pdf' as varchar(25)),
	Content = x.SavedPDF -- select x.*
from 
	ExcentOnline.dbo.IEPConsiderTbl x 
where 
	SavedPDF is not null
	and isnull(del_flag,0)=0
) s

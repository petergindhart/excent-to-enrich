--create SCHEMA SPEDDOC

--drop table SPEDDOC.dbo.AllDocs


select * 
into SPEDDOC.dbo.AllDocs
from (
select 
	PKSeq = x.AssessDevSeq,
	DocIdentifier = cast('Assessment - '+isnull(convert(varchar, x.MeetDate, 101), '') as varchar(100)),
	StudentRefID = GStudentID,
	-- IEPRefID = cast(NULL as varchar(150)),
	DocType = cast('PDF' as varchar(15)),
	Content = SavedPDF
from
	ExcentOnline.dbo.AssessDevTbl x
where 
	SavedPDF is not null
-- 
union all
select 
	PKSeq = x.BehavSeqNum,
	DocIdentifier = 'BIP - '+isnull(convert(varchar, x.PlanDate, 101), ''),
	StudentRefID = GStudentID,
	--IEPRefID = cast(NULL as varchar(150)),
	DocType = cast('PDF' as varchar(15)),
	Content = SavedPDF
from
	ExcentOnline.dbo.BehaviourInterTbl x
where 
	SavedPDF is not null
-- 
union all
select 
	PKSeq = x.ConfSeqNum,
	DocIdentifier = 'Conference - '+isnull(convert(varchar, isnull(x.Date2, x.Date1), 101), ''),
	StudentRefID = GStudentID,
	--IEPRefID = cast(NULL as varchar(150)),
	DocType = cast('PDF' as varchar(15)),
	Content = SavedPDF
from
	ExcentOnline.dbo.ConferenceTbl x
where 
	SavedPDF is not null
-- 
union all
select 
	PKSeq = x.ConsentSeqNum,
	DocIdentifier = 'Consent - '+isnull(convert(varchar, x.LetDate, 101), ''),
	StudentRefID = GStudentID,
	--IEPRefID = cast(NULL as varchar(150)),
	DocType = cast('PDF' as varchar(15)),
	Content = SavedPDF
from
	ExcentOnline.dbo.ConsentDataTbl x
where 
	SavedPDF is not null
-- 
union all
select 
	PKSeq = x.AssessSeqNum,
	DocIdentifier = 'Assessment ('+x.AssessType+') - '+isnull(convert(varchar, ISNULL(x.ReportDate, x.CreateDate), 101), ''),
	StudentRefID = GStudentID,
	--IEPRefID = cast(NULL as varchar(150)),
	DocType = cast('PDF' as varchar(15)),
	Content = SavedPDF -- select x.*
from
	ExcentOnline.dbo.EligAssessTbl x
where 
	SavedPDF is not null
-- 
union all
select 
	PKSeq = x.MeetSeqNum,
	DocIdentifier = 'Meeting  - '+
	--case 
	--	when x.Attempt3 IS NOT NULL then isnull(x.Type3,'')
	--	when x.Attempt2 IS NOT NULL then isnull(x.Type2,'')
	--	else x.Type1
	--end+' - '+
	isnull(convert(varchar, coalesce(x.Attempt3, x.Attempt2, x.Attempt1), 101), ''),
	StudentRefID = GStudentID,
	--IEPRefID = cast(NULL as varchar(150)),
	DocType = cast('PDF' as varchar(15)),
	Content = SavedPDF -- select x.*
from
	ExcentOnline.dbo.MeetingTbl x
where 
	SavedPDF is not null
-- 
union all
select 
	PKSeq = x.NoticeSeqNum,
	DocIdentifier = 'Notice - '+isnull(convert(varchar, x.NoticeDate, 101), ''),
	StudentRefID = GStudentID,
	--IEPRefID = cast(NULL as varchar(150)),
	DocType = cast('PDF' as varchar(15)),
	Content = SavedPDF -- select x.*
from
	ExcentOnline.dbo.NoticeTbl x
where 
	SavedPDF is not null
-- 
union all
select 
	PKSeq = x.PriorSeqNum,
	DocIdentifier = 'Prior Notice - '+isnull(convert(varchar, x.NoticeDate, 101), ''),
	StudentRefID = GStudentID,
	--IEPRefID = cast(NULL as varchar(150)),
	DocType = cast('PDF' as varchar(15)),
	Content = SavedPDF -- select x.*
from
	ExcentOnline.dbo.PriorNoticeTbl x
where 
	SavedPDF is not null
-- 
union all
select 
	PKSeq = x.EligSeqNum,
	DocIdentifier = 'Eligibility - '+isnull(convert(varchar, x.MeetDate, 101), ''),
	StudentRefID = GStudentID,
	--IEPRefID = cast(NULL as varchar(150)),
	DocType = cast('PDF' as varchar(15)),
	Content = SavedPDF -- select x.*
from
	ExcentOnline.dbo.ProcEligibilityTbl x
where 
	SavedPDF is not null
-- 
union all
select 
	PKSeq = x.ReferSeqNum,
	DocIdentifier = 'Referral - '+isnull(convert(varchar, x.MeetDate, 101), ''),
	StudentRefID = GStudentID,
	--IEPRefID = cast(NULL as varchar(150)),
	DocType = cast('PDF' as varchar(15)),
	Content = SavedPDF -- select x.*
from
	ExcentOnline.dbo.ReferralTbl x
where 
	SavedPDF is not null
union all
select -- COUNT(*) tot
	PKSeq = x.iepseqnum,
	DocIdentifier = 'IEP - '+isnull(convert(varchar, x.MeetDate, 101), ''),
	StudentRefID = x.GStudentID,
	DocType = cast('document\pdf' as varchar(15)),
	Content = PDFImage -- select x.*
from ExcentOnline.dbo.SpecialEdStudentsAndIEPs x 
join ExcentOnline.dbo.IEPCompleteTbl ic on x.IEPSeqNum = ic.IEPSeqNum
join ExcentOnline.dbo.IEPArchiveDocTbl ad on ic.RecNum = ad.RecNum and ic.GStudentID = ad.GStudentID -- 11506
where ad.RecNum = (
	select MAX(y.RecNum)
	from IEPArchiveDocTbl y 
	where ad.GStudentID = y.GStudentID
	) -- 11003
) s



--select -- COUNT(*) tot
--	PKSeq = x.iepseqnum,
--	DocIdentifier = 'Referral - '+isnull(convert(varchar, x.MeetDate, 101), ''),
--	StudentRefID = x.GStudentID,
--	DocType = cast('document\pdf' as varchar(15)),
--	Content = PDFImage -- select x.*
--from ExcentOnline.dbo.SpecialEdStudentsAndIEPs x 
--join ExcentOnline.dbo.IEPCompleteTbl ic on x.IEPSeqNum = ic.IEPSeqNum
--join ExcentOnline.dbo.IEPArchiveDocTbl ad on ic.RecNum = ad.RecNum and ic.GStudentID = ad.GStudentID -- 11506
--where ad.RecNum = (
--	select MAX(y.RecNum)
--	from IEPArchiveDocTbl y 
--	where ad.GStudentID = y.GStudentID
--	) -- 11003









	
	
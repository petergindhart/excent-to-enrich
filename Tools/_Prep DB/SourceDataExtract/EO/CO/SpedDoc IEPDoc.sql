
/*

drop table ExcentOnlineData.dbo.IEPArchiveDocTbl
drop table ExcentOnlineData.dbo.IEPArchiveTbl
drop table ExcentOnlineData.dbo.IEPCompleteTbl
drop table ExcentOnlineData.dbo.ICIEPArchive

*/


select x.* from SpecialEdStudentsAndIEPs x join IEPCompleteTbl ic on x.IEPSeqNum = ic.IEPSeqNum



select top 1 * from IEPArchiveDocTbl

select StudentRefID = ad.GStudentiD, IEPRefID = ic.IEPSeqnum, ad.DocType, Content = ad.PDFImage
into SpedDoc.dbo.IEPDoc
from SpecialEdStudentsAndIEPs x 
join IEPCompleteTbl ic on x.IEPSeqNum = ic.IEPSeqNum
join IEPArchiveDocTbl ad on ic.RecNum = ad.RecNum and ic.GStudentID = ad.GStudentID
-- where ad.IEPCompleteDate >= dateadd(yy, -2, getdate()) -- 84686 recs, 19:19
-- and ic.MeetDate >= dateadd(yy, -2, getdate())
-- (27428 row(s) affected) when joining IEPComplete with IEPArchiveDocTbl

-- order by recnum desc

--select *
--into IEPCompleteTbl 
--from IEPCompleteTbl 
--where MeetDate >= dateadd(yy, -2, getdate()) -- FL.  (78560 row(s) affected), 36 sec




--(35997 row(s) affected)
--
--(35011 row(s) affected)
--
--(28123 row(s) affected)
--
--(35171 row(s) affected)

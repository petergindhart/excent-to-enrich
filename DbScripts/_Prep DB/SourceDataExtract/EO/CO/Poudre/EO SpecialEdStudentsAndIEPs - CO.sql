-- Colorado
alter view SpecialEdStudentsAndIEPs
as
-- Exposing the lre and trans seqnums to facilitate access in later queries.  why not expose the elements required?   idunno.
select distinct
	s.GStudentID, ic.IEPSeqNum, 
	p.SchPrimInstrCode, 
	s.SpedStat, s.SpedExitDate, s.SpedExitCode, 
	ic.Meetdate, 
	ESY = ic.ESYElig,
	IEPLRESeqNum,
	TranSeqNum
from Student s 
join ReportIEPCompleteTbl ic on s.gstudentid = ic.gstudentid 
join ICIEPLRETbl p on ic.IEPSeqNum = p.IEPComplSeqNum 
join StudDisability d on s.GStudentID = d.GStudentID and d.PrimaryDiasb = 1 and isnull(d.del_flag,0)=0
left join ICTransServTbl t on ic.IEPSeqNum = t.IEPComplSeqNum
where ic.RecNum = (
	select max(icRec.RecNum)
	from IEPCompleteTbl icRec
	where isnull(icRec.del_flag,0)=0
	and ic.GStudentID = icRec.GStudentID 
	and icRec.MeetDate = (
		select max(icDt.MeetDate) 
		from IEPCompleteTbl icDt
		where icRec.GStudentID = icDt.GStudentID
		and isnull(icDt.del_flag,0)=0 
		and icDt.MeetDate = icRec.MeetDate
		)
	)
and 	(s.SpedStat = 1 or (s.SpedStat = 2 and s.SpedExitDate > convert(char(4), datepart(yy, getdate() ) - case when datepart(mm, getdate()) < 7 then 1 else 0 end)))  
and ic.MeetDate > dateadd(mm, -18, getdate())
and s.gstudentid in (select gstudentid from reportstudentschools)
and s.GStudentID in (select sd.GStudentID from StudDisability sd join DisabilityLook d on sd.DisabilityID = d.DisabilityID where isnull(sd.del_flag,0)=0 and sd.PrimaryDiasb = 1) -- 2641
and isnull(s.del_flag,0)=0
and s.enrollstat = 1
and t.TranSeqNum = (
	select min(tmin.transeqnum)
	from ICTransServTbl tmin 
	where t.IEPComplSeqNum = tmin.IEPComplSeqNum
	and isnull(t.del_flag,0)=0
	)
and p.IEPLRESeqNum = (
	select min(pmin.IEPLRESeqNum)
	from ICIEPLRETbl pmin 
	where p.IEPComplSeqNum = pmin.IEPComplSeqNum
	and isnull(p.del_flag,0)=0
	)
go







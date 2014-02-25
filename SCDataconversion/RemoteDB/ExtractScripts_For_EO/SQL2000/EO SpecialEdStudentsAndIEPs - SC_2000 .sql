IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SpecialEdStudentsAndIEPs') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.SpecialEdStudentsAndIEPs
GO

create view dbo.SpecialEdStudentsAndIEPs
as
select distinct
	s.GStudentID, ic.IEPSeqNum, 
	-- p.SchPrimInstrCode, 
	case when p.AgeGroup = '6+' then 'K12' else p.AgeGroup end+'_'+convert(varchar(5), p.LREPlacement) LREPlacement,
	s.SpedStat, s.SpedExitDate, s.SpedExitCode, 
	ic.Meetdate, 
	ESY = ic.ESYElig,
	IEPLRESeqNum,
	TranSeqNum = NULL -- select s.GStudentID, ic.IEPSeqNum
--select s.*
from Student s 
join ReportIEPCompleteTbl ic on s.gstudentid = ic.gstudentid -- select top 10 * from ReportIEPCompleteTbl 
join ReportICIEPLRETblPlace p on ic.IEPSeqNum = p.IEPComplSeqNum -- select top 10 * from ReportICIEPLRETblPlace 
join StudDisability d on s.GStudentID = d.GStudentID and d.PrimaryDiasb = 1 and isnull(d.del_flag,0)=0
--left join ICTransServTbl t on ic.IEPSeqNum = t.IEPComplSeqNum
where ic.IEPSeqNum = ( -- select top 10 * from iepcompletetbl
	select max(icRec.IEPSeqNum)
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
--and ic.MeetDate > dateadd(mm, -18, getdate())  --in QASCConvert all the records are older than 18 months...I neglectd this time... 
and s.gstudentid in (select gstudentid from reportstudentschools)
and s.GStudentID in (select sd.GStudentID from StudDisability sd join DisabilityLook d on sd.DisabilityID = d.DisabilityID where isnull(sd.del_flag,0)=0 and sd.PrimaryDiasb = 1) -- 2641
and isnull(s.del_flag,0)=0
and s.enrollstat = 1
--and t.TranSeqNum = (
--	select min(tmin.transeqnum)
--	from ICTransServTbl tmin 
--	where t.IEPComplSeqNum = tmin.IEPComplSeqNum
--	and isnull(t.del_flag,0)=0
--	)
and p.IEPLRESeqNum = (
	select min(pmin.IEPLRESeqNum)
	from ICIEPLRETbl pmin 
	where p.IEPComplSeqNum = pmin.IEPComplSeqNum
	-- and isnull(p.del_flag,0)=0
	)
go
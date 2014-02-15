
if exists (select 1 from sys.objects where name = 'DataConversionSpeedObjects')
drop proc DataConversionSpeedObjects 
go

create proc DataConversionSpeedObjects 
as

begin 
DELETE DataConvSpedStudentsAndIEPs

select * 
into DataConvSpedStudentsAndIEPs
from (
select 
	s.GStudentID, 
	ic.IEPSeqNum, 
	s.SpedStat, 
	s.SpedExitDate, 
	s.SpedExitCode, 
	ic.Meetdate, 
	StartDate = ic2.IEPInitDate,
	EndDate = ic2.IEPEndDate,
	ic.ReviewDate,
	ESY = isnull(sf.Considered7,0)
from Student s 
--join ReportIEPCompleteTbl ic on s.gstudentid = ic.gstudentid 
join IEPCompleteTbl ic on s.GStudentID = ic.GStudentID and
	ic.IEPSeqNum = ( 
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
join ICIEPTbl_SC ic2 on ic.IEPSeqNum = ic2.IEPComplSeqnum
left join ICIEPSpecialFactorTbl sf on ic.IEPSeqNum = sf.IEPComplSeqNum
where 1=1
and s.enrollstat = 1
and isnull(s.del_flag,0)=0
and (s.SpedStat = 1 or (s.SpedStat = 2 and s.SpedExitDate > convert(char(4), datepart(yy, getdate() ) - case when datepart(mm, getdate()) < 7 then 1 else 0 end)))  
and exists (select 1 from reportstudentschools sch where sch.GStudentID = s.GStudentID)
and exists (select 1 from StudDisability sd where sd.GStudentID = s.GStudentID and isnull(sd.del_flag,0)=0 and sd.PrimaryDiasb = 1) 
) x

alter table DataConvSpedStudentsAndIEPs 
	add constraint PK_DataConvSpedStudentsAndIEPs_IEPSeqNum primary key (IEPSeqNum)
--

select v.*
into DataConvICServiceTbl
from DataConvSpedStudentsAndIEPs x
join ICServiceTbl v on x.IEPSeqNum = v.IEPComplSeqNum
where isnull(v.del_flag,0)=0

alter table DataConvICServiceTbl
	add constraint PK_DataConvICServiceTbl_IEPComplSeqNum_ServSeqNum primary key (IEPComplSeqNum, ServSeqNum)
-- 
END
go



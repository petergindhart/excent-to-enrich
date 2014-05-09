/*

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SpecialEdStudentsAndIEPs') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW SpecialEdStudentsAndIEPs
GO
-- South Carolina
create view SpecialEdStudentsAndIEPs
as
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

*/


if exists (select 1 from sys.objects where name = 'DataConvSpedStudentsAndIEPs')
drop table DataConvSpedStudentsAndIEPs
go

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
and (s.SpedStat = 1 or (s.SpedStat = 2 and s.SpedExitDate >= '7/1/'+convert(char(4), datepart(yy, getdate() ) - case when datepart(mm, getdate()) < 7 then 1 else 0 end)))  
and exists (select 1 from reportstudentschools sch where sch.GStudentID = s.GStudentID)
and exists (select 1 from StudDisability sd where sd.GStudentID = s.GStudentID and isnull(sd.del_flag,0)=0 and sd.PrimaryDiasb = 1) 
) x

alter table DataConvSpedStudentsAndIEPs 
	add constraint PK_DataConvSpedStudentsAndIEPs_IEPSeqNum primary key (IEPSeqNum)
go

if exists (select 1 from sys.objects where name = 'DataConvICServiceTbl')
drop table DataConvICServiceTbl
go

-- we are casting and converting to larger datatypes to accommodate the supplementary services
select v.GStudentID, v.IEPComplSeqNum, ServCode = convert(varchar(150), v.ServCode), ServDesc = convert(varchar(250), v.ServDesc), v.ProvCode, v.ProvDesc, LocationCode = convert(varchar(150), v.LocationCode), LocationDesc = convert(varchar(250), v.LocationDesc), Frequency = convert(varchar(150), v.Frequency), v.InitDate, v.EndDate, v.DirHr, v.IndirHr, v.ESY, v.Type, v.Subject, v.Teacher, v.Linkages, v.TimeServiced, v.Duration, v.ServSeqNum, v.CreateID, v.CreateDate, v.ModifyID, v.ModifyDate, v.DeleteID, v.Deletedate, v.Del_Flag, v.TotalHr, v.GenEdMin, v.Position1, v.Position2, v.ServType, v.Resource, v.Setting, v.Include1, v.Include2, v.ServOrder, v.TotalMin, v.RelServDesc, v.Length
into DataConvICServiceTbl
from DataConvSpedStudentsAndIEPs x
join ICServiceTbl v on x.IEPSeqNum = v.IEPComplSeqNum
where isnull(v.del_flag,0)=0
go

-- import Supplementary services for SC
insert DataConvICServiceTbl (GStudentID, IEPComplSeqNum, ServSeqNum, ServCode, ServDesc, LocationCode, Frequency, Type)
select ss.GStudentID, ss.IEPComplSeqNum, ss.IEPSuppServSeq+9000000, cast(NULL as nvarchar(20)), cast(ss.service as nvarchar(250)), convert(varchar(150), ss.Location), convert(nvarchar(150), ss.Frequency), 'U'
from ICIEPSuppServTbl_SC ss 
join specialedstudentsandieps x on ss.iepcomplseqnum = x.iepseqnum
left join DataConvICServiceTbl t on ss.iepcomplseqnum = t.IEPComplSeqNum and t.ServSeqNum = 9000000+ss.IEPSuppServSeq
where isnull(ss.del_flag,0)=0
and convert(varchar(max), service) not in ('NA', 'none', 'N/A')
and convert(varchar(max), service) not like 'Not Appl%'
and t.servseqnum is null

alter table DataConvICServiceTbl
	add constraint PK_DataConvICServiceTbl_IEPComplSeqNum_ServSeqNum primary key (IEPComplSeqNum, ServSeqNum)
go

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SpecialEdStudentsAndIEPs') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW SpecialEdStudentsAndIEPs
GO
-- South Carolina
create view SpecialEdStudentsAndIEPs
as
select * from DataConvSpedStudentsAndIEPs
go



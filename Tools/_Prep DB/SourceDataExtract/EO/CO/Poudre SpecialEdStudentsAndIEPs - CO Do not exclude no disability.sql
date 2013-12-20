select * from StudDisability where gstudentid = 'FAF1AD6F-7623-40F5-BA23-41883779C0DA'
select * from student where GStudentID = 'FAF1AD6F-7623-40F5-BA23-41883779C0DA'


-- do not exclude students without a primary disability (commented out 2 lines).
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
, d.DisabilityID
from Student s 
join ReportIEPCompleteTbl ic on s.gstudentid = ic.gstudentid 
join ICIEPLRETbl p on ic.IEPSeqNum = p.IEPComplSeqNum 
left join StudDisability d on s.GStudentID = d.GStudentID and d.PrimaryDiasb = 1 and isnull(d.del_flag,0)=0 -- if their disability was deleted...
left join ICTransServTbl t on ic.IEPSeqNum = t.IEPComplSeqNum
where 1=1
and ic.RecNum = (
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
and 	(
	s.SpedStat = 1 
	-- or (s.SpedStat = 2 and s.SpedExitDate > convert(char(4), datepart(yy, getdate() ) - case when datepart(mm, getdate()) < 7 then 1 else 0 end))
	)  
and ic.MeetDate > dateadd(mm, -18, getdate())
and s.gstudentid in (select gstudentid from reportstudentschools)
--and s.GStudentID in (select sd.GStudentID from StudDisability sd join DisabilityLook d on sd.DisabilityID = d.DisabilityID where isnull(sd.del_flag,0)=0 and sd.PrimaryDiasb = 1) -- oops.  filtered twice
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

--and d.GStudentID is null
--and s.GStudentID not in ('936C85DB-1741-489B-A105-13BC01174530', '8BBEC1AC-192D-4F24-8C28-A1A964B53EF3', '62228CCF-E169-4DCD-85D6-C23D82131E96', '854A48E6-25D3-4D1D-9471-93EF3442663C', 'D55069E9-D0C8-419C-AE96-B1CFC1CF885E', 'F99BF54B-E6DB-4ACB-93F1-31AF9CA8FF47', '09B98258-A7F0-4410-86A0-76F0A69B1C6B', '7F3B33D0-B0B0-4927-9038-FAC95B3D5D78', '9683A75A-1D65-4E27-B337-ABC8CB3FE0AD', 'F3C305E4-2CF1-4598-B848-599E04E68E66')



go

/*

begin tran
insert StudDisability (GStudentID, DisabilityID, DisOrder, DisabilityDesc, PrimaryDiasb,  CreateID,  CreateDate)
select x.GStudentID, DisabilityID = '00', DisOrder = 0, DisabilityDesc = 'None', PrimaryDiasb = 1, CreateID = 'admin', CreateDate = getdate()
from SpecialEdStudentsAndIEPs x
left join StudDisability d on x.gstudentid = d.gstudentid and isnull(d.del_flag,0)=0 and d.PrimaryDiasb = 1
where d.GStudentID is null


---- rollback 

---- commit



--GStudentID, RecNum, DisabilityID, DisOrder, DisabilityDesc, PrimaryDiasb, CreateID, CreateDate, StudentDisabilityGID

--select * from StudDisability

--sp_help StudDisability


--select * from SeqNum where TableName = 'StudDisability'





*/






























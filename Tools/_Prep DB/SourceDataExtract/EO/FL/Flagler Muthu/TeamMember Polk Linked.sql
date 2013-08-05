set nocount on
go

set ansi_warnings on
go


declare @gtbl table (gstudentid uniqueidentifier not null primary key)
insert @gtbl 
select distinct gstudentid from excent9710a.ExcentOnlineFL.dbo.SpecialEdStudentsAndIEPs

select 
	StaffEmail = t.email, 
	StudentRefId = am.GStudentID,
	IsCaseManager = Max(case when CaseMgr = 1 then 'Y' else 'N' end)
from excent9710a.ExcentOnlineFL.dbo.AccessMembers am 
join excent9710a.ExcentOnlineFL.dbo.Staff t on am.staffgid = t.staffgid 
join @gtbl s on am.gstudentid = s.gstudentid
where isnull(am.del_flag,0)=0 
and isnull(t.del_flag,0)=0
group by t.email, am.GStudentID
-- and GStudentID in (select gstudentid from @gtbl)
Go



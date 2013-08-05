set nocount on
go

set ansi_warnings on
go


declare @gtbl table (gstudentid uniqueidentifier not null primary key)
insert @gtbl 
select distinct gstudentid from SpecialEdStudentsAndIEPs x where x.SpedOrGifted = 'SpEd'

select 
	StaffEmail = t.email, 
	StudentRefId = am.GStudentID,
	IsCaseManager = Max(case when CaseMgr = 1 then 'Y' else 'N' end)
from AccessMembers am 
join Staff t on am.staffgid = t.staffgid 
join @gtbl s on am.gstudentid = s.gstudentid
where isnull(am.del_flag,0)=0 
and isnull(t.del_flag,0)=0
and isnull(t.email,'') <> '' 
and t.email not in (select isnull(de.email,'') from staff de where isnull(de.del_flag,0)=0 group by isnull(de.email,'') having count(*) > 1)
and len(isnull(t.email,'')) > 3
and patindex('%@%', t.Email) > 1
group by t.email, am.GStudentID
-- and GStudentID in (select gstudentid from @gtbl)
Go



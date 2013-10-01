

----------------------------------------- save this code! ----------------------------------------- -- select * from LEGACYSPED.IEP_LOCAL



-- merge duplicate students first

set nocount on;
begin tran
declare @q varchar(max), @newline varchar(5), @rowcount int ; set @newline = char(10)+char(13)
-- IF one is active and the other is not, choose the active one.
declare Q cursor for 
select distinct 'x_DATATEAM.StudentRecordException_MergeNoConflictRecords_DeleteTests @pickedStudent = '''+convert(varchar(36), t.pickedStudent)+''', @notPickedStudent = '''+convert(varchar(36), t.notPickedStudent)+''''
from ( 
	select ExceptionID = d.ID, 
		pickedStudent = case s1.isActive when 1 then s1.id else s2.id end, 
		notPickedStudent = case s2.isactive when 1 then s2.id else s1.id end -------- check this logic
	from StudentRecordException d
	join Student s1 on d.Student1ID = s1.id
	join student s2 on d.Student2ID = s2.ID
	where ignore = 0 and s1.IsActive != s2.IsActive
	) t

open Q
fetch Q into @q 
while @@fetch_status = 0
begin
	exec (@q)
	set @rowcount = @@rowcount
	if @rowcount > -1
	print @q+@newline+convert(varchar(5), @rowcount)
fetch Q into @q 
end
close Q
deallocate Q

-- set nocount on ; declare @q varchar(max), @newline varchar(5), @rowcount int ; set @newline = char(10)+char(13)
-- IF one is manually entered and the other is imported from SIS, choose the SIS record.
declare Q cursor for 
select distinct 'x_DATATEAM.StudentRecordException_MergeNoConflictRecords_DeleteTests @pickedStudent = '''+convert(varchar(36), t.pickedStudent)+''', @notPickedStudent = '''+convert(varchar(36), t.notPickedStudent)+''''
from ( 
	select ExceptionID = d.ID, 
		pickedStudent = case s1.ManuallyEntered when 0 then s1.ID else s2.ID end, 
		notPickedStudent = case s1.ManuallyEntered when 1 then s1.ID else s2.ID end
	from StudentRecordException d
	join Student s1 on d.Student1ID = s1.id
	join student s2 on d.Student2ID = s2.ID
	join LEGACYSPED.Transform_Student ts1 on ts1.Number = s1.number -- or s.Number = s2.Number
	where ignore = 0 -- and s1.IsActive != s2.IsActive
	and s1.Number = s2.Number
	and s1.ManuallyEntered <> s2.ManuallyEntered
	and s1.id <> s2.id
) t
open Q
fetch Q into @q 
while @@fetch_status = 0
begin
	exec (@q)
	set @rowcount = @@rowcount
	if @rowcount > -1
	print @q+@newline+convert(varchar(5), @rowcount)
fetch Q into @q 
end
close Q
deallocate Q


-- set nocount on ; declare @q varchar(max), @newline varchar(5), @rowcount int ; set @newline = char(10)+char(13)
-- IF both manually entered and only one has a street address, chose that one
declare Q cursor for 	
select distinct 'x_DATATEAM.StudentRecordException_MergeNoConflictRecords_DeleteTests @pickedStudent = '''+convert(varchar(36), t.pickedStudent)+''', @notPickedStudent = '''+convert(varchar(36), t.notPickedStudent)+''''
from ( 
	select ExceptionID = d.ID, 
		pickedStudent = case when s1.Street is not null and s2.Street is null then s1.ID when s2.street is not null and s1.street is null then s2.ID end, 
		notPickedStudent = case when s1.Street is null and s2.Street is not null then s1.ID when s2.street is null and s1.street is not null then s2.ID end
	from StudentRecordException d
	join Student s1 on d.Student1ID = s1.id
	join student s2 on d.Student2ID = s2.ID
	join LEGACYSPED.Transform_Student ts1 on ts1.Number = s1.number -- or s.Number = s2.Number
	where ignore = 0 
	and s1.Number = s2.Number and s1.LastName = s2.LastName 
	and len(isnull(s1.Street,'')+isnull(s2.street,'')) > 3 -- at least one of them has an address
	and s1.street+s2.street is null -- one of them is null
	and case when s1.Street is not null and s2.Street is null then s1.ID else s2.ID end is not null
	and case when s1.Street is null and s2.Street is not null then s2.ID else s1.ID end is not null
) t
open Q
fetch Q into @q 
while @@fetch_status = 0
begin
	exec (@q)
	set @rowcount = @@rowcount
	if @rowcount > -1
	print @q+@newline+convert(varchar(5), @rowcount)
fetch Q into @q 
end
close Q
deallocate Q




update m set DestID = a.ContextID
-- select Victim = a.TargetID, Preserved = a.ContextID, a.Message
from LEGACYSPED.MAP_StudentRefID m 
left join dbo.Student s on m.DestID = s.ID
join AuditLogEntry a on m.DestID = a.TargetID and a.Message like 'Student duplicate exception%'
where s.ID is null




-- rollback 

-- commit










------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
begin tran

-- before upgrade db

-- refactor IEP_LOCAL to include new column
select IepRefID, StudentRefID, IEPMeetDate, IEPStartDate, IEPEndDate, NextReviewDate, InitialEvaluationDate, LatestEvaluationDate, NextEvaluationDate, EligibilityDate, ConsentForServicesDate, ConsentForEvaluationDate = NULL, LREAgeGroup, LRECode, MinutesPerWeek, ServiceDeliveryStatement 
into x_DATATEAM.IEP_LOCAL_COPY
from LEGACYSPED.IEP_LOCAL

drop table LEGACYSPED.IEP_LOCAL

select *
into LEGACYSPED.IEP_LOCAL
from x_DATATEAM.IEP_LOCAL_COPY

drop table x_DATATEAM.IEP_LOCAL_COPY


-- refactor LEGACYSPED.MAP_IEPStudentRefID to add new column
select IepRefID, StudentRefID, SpecialEdStatus = cast('A' as char(1)), DestID
into LEGACYSPED.MAP_IEPStudentRefID_NEW 
from LEGACYSPED.MAP_IEPStudentRefID -- 16988

drop table LEGACYSPED.MAP_IEPStudentRefID

select *
into LEGACYSPED.MAP_IEPStudentRefID
from LEGACYSPED.MAP_IEPStudentRefID_NEW

drop table LEGACYSPED.MAP_IEPStudentRefID_NEW
-- 16988
go


sp_refreshview 'LEGACYSPED.IEP'
go

sp_refreshview 'LEGACYSPED.EvaluateIncomingItems'
go
sp_refreshview 'LEGACYSPED.Transform_PrgIep'
go


-- populate this new map table MAP_StudentRefIDAll

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_StudentRefIDAll') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
create table LEGACYSPED.MAP_StudentRefIDAll (
StudentRefID varchar(150) not null,
DestID uniqueidentifier not null
)

ALTER TABLE LEGACYSPED.MAP_StudentRefIDAll ADD CONSTRAINT
	PK_MAP_StudentRefIDAll PRIMARY KEY CLUSTERED
	(
	StudentRefID
	) 
END
go


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_MAP_StudentRefIDAll_DestID')
create index IX_LEGACYSPED_MAP_StudentRefIDAll_DestID on LEGACYSPED.MAP_StudentRefIDAll (DestID)
go

----------------------------------------------------------------------------------------------------- new.  there are some Student records without IEP records
delete s
-- select *
from LEGACYSPED.Student_LOCAL s
left join LEGACYSPED.IEP i on s.StudentRefID = i.StudentRefID
where i.IepRefID is null
-- 3 rows

insert LEGACYSPED.MAP_StudentRefIDAll
select distinct t.StudentRefID, t.DestID
from LEGACYSPED.Transform_Student t left join
LEGACYSPED.MAP_StudentRefIDAll m on t.StudentRefID = m.StudentRefID 
where m.DestID is null
-- 17006

------------------------------------------------------ test
select * from LEGACYSPED.MAP_StudentRefIDAll
go
------------------------------------------------------ test




delete lt -- select lt.*
from VC3ETL.LoadTable lt where ID in ('90313AAB-0BDC-4B10-BCE0-B7E0BD5397F5', 'FF83BE84-BD8E-425B-98A8-EC39568A3AC6', '3FF765A3-A754-4159-9FAE-352E917A4B72', '509B0A43-DC6D-48CA-B3F8-FA28922D2AD4') -- EFF stuff


-- begin tran

-- (Decided not to before deleting involvements, update MAP_INVOLVEMENT).  Though Some may have had a new involvement id. (this does not seem to be the case)
delete m
-- select * 
from LEGACYSPED.MAP_PrgInvolvementID m left join PrgInvolvement t on m.DestID = t.ID where t.ID is null -- 7 (16917)

delete m -- student may have no involvement or may have a new involvement.
-- select * 
from LEGACYSPED.MAP_IepStudentRefID m left join PrgItem t on m.DestID = t.ID where t.ID is null -- 19 (16988)

delete m
-- select * 
from LEGACYSPED.MAP_PrgSectionID m left join PrgSection t on m.DestID = t.ID where t.id is null -- 75

delete m
-- select * 
from LEGACYSPED.MAP_PrgSectionID_NonVersioned m left join PrgSection t on m.DestID = t.ID where t.id is null -- 19

delete m
-- select * 
from LEGACYSPED.MAP_PrgVersionID m left join PrgVersion t on m.DestID = t.ID where t.ID is null -- 19

delete m
-- select * 
from LEGACYSPED.MAP_IepPlacementID m left join IepPlacement t on m.DestID = t.ID where t.ID is null -- 23

delete m
-- select * 
from LEGACYSPED.MAP_IepDisabilityEligibilityID m left join IepDisabilityEligibility t on m.DestID = t.ID where t.ID is null -- 131

-- insert misssing MAP_PrgInvolvementID records, if any
insert LEGACYSPED.MAP_PrgInvolvementID
select mitm.StudentRefID, DestID = itm.InvolvementID
from LEGACYSPED.MAP_IepStudentRefID mitm 
join PrgItem itm on mitm.DestID = itm.ID and itm.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' and itm.CreatedDate = '1/1/1970' /* */ -- ensure a converted IEP from DC, not UI
left join LEGACYSPED.MAP_PrgInvolvementID minv on mitm.StudentRefID = minv.StudentRefID
where minv.DestID is null -- 73 records to populate in LEGACYSPED.MAP_PrgInvolvementID  (77 ?)
-- 77


-- we have some straggler involvement ids that don't belong
delete -- select destid 
from LEGACYSPED.MAP_PrgInvolvementID where DestID not in (select inv.ID from PrgInvolvement inv join PrgItem itm on inv.id = itm.InvolvementID and itm.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' and itm.CreatedDate = '1/1/1970')
-- 13






-- rollback
-- commit



-- ==========================================================================================================================================================
-- ==                                                                   AFTER UPGRADE DB                                                                   ==
-- ==========================================================================================================================================================

-- might need to do this before the import   AFTER UPGRADE DB

begin tran
insert LEGACYSPED.MAP_IEPStudentRefID -------------------------------------------------------------------------------------------- This did not work BEFORE import
select ti.IEPRefID, ti.StudentRefID, ti.SpecialEdStatus, ti.DestID
from LEGACYSPED.Transform_PrgIep ti 
left join LEGACYSPED.MAP_IEPStudentRefID m on ti.StudentRefID = m.StudentRefID
--where m.DestID is null					-- 19 are null
where m.DestID is not null					-- 16988 are null


-- rollback

-- and some that are mysteriously missing (is this to be run after import???????)   what is the difference between this and the one above?
insert LEGACYSPED.MAP_PrgInvolvementID
select s.StudentRefID, ev.ExistingInvolvementID /* , invID = pinv.ID, inv.*  */
from LEGACYSPED.student s -- select s.* from (select '0815058' StudentRefID) x join LEGACYSPED.student s on x.StudentRefID = s.StudentRefID 
left join LEGACYSPED.MAP_PrgInvolvementID inv on s.StudentRefID = inv.StudentRefID 
left join LEGACYSPED.EvaluateIncomingItems ev on s.StudentRefID = ev.StudentRefID 
-- left join PrgInvolvement pinv on ev.StudentID = pinv.StudentID -- and pinv.EndDate is null  ---- on second thought, I think we still want the map record to be back filled
where inv.DestID is null
and ExistingInvolvementID is not null
-- 80





/*
---- run this before import (did:  0 rows)
select s.*
from PrgSection s
left join IepEsy e on s.ID = e.ID
where DefID = 'F60392DA-8EB3-49D0-822D-77A1618C1DAA'
and e.ID is null
---- after importing files - 0 rows also

*/


------------------------------------------------------ this needs to be done AFTER IMPORT of new data         (we are inserting this table above with the stored procedure)
----begin tran
--update mx set IepRefID = i.IepRefID
---- select s.StudentRefID, i.StudentRefID, m.StudentRefID, IEP = 'IEP', InvalidIEPRefID = mx.IepRefID, NewIEPRefID = i.IepRefID
--from LEGACYSPED.Student s
--join LEGACYSPED.MAP_IEPStudentRefID mx on s.StudentLocalID = mx.StudentRefID
--join LEGACYSPED.IEP i on s.StudentLocalID = i.StudentRefID
--left join LEGACYSPED.MAP_IEPStudentRefID m on i.IepRefID = m.IepRefID
--	-- on s.StudentLocalID = m.StudentRefID  -- where m.DestID is null -- one record:  0711966
--where s.StudentRefID <> '0711966'
--and m.DestID is null -- 584




rollback

--commit

go


----------------------------------------- save this code! -----------------------------------------


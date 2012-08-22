/*	BEFORE RUNNING THIS SCRIPT, follow these steps

1.  Create schema using this script:
		create schema ADHOCIMPORT
2.  Import both the StaffMember (and/or SpedStaffMember) and StaffSchool files into tables named ADHOCIMPORT.StaffMember and ADHOCIMPORT.StaffSchool
3.  Run this script

This script will normally be run on the Staging server before data conversino is run.

*/

set nocount on;
begin tran usersimport

declare @u uniqueidentifier, @e varchar(100), @f varchar(100), @l varchar(100), @r uniqueidentifier, @o uniqueidentifier, @po uniqueidentifier -- parent org
select @po = o.ID from OrgUnit o join School h on o.ID = h.OrgUnitID where ParentID is null 

declare U cursor for 
select sm.StaffEmail, sm.Firstname, sm.Lastname, r.ID, UserProfileID = newid() from ADHOCIMPORT.StaffMember sm left join Person p on sm.STAFFEMAIL = p.EmailAddress left join SecurityRole r on sm.ENRICHROLE = r.Name where p.ID is null

open U
fetch U into @e, @f, @l, @r, @u

while @@fetch_status = 0 

begin

insert Person (ID, TypeID, Firstname, Lastname, EmailAddress, ManuallyEntered) 
values (@u, 'U', @f, @l, @e, 1)

insert UserProfile (ID, RoleID, Username, CanPerformAllServices, CanSignAllServices, IsSchoolAutoSelected, CurrentFailedLoginAttempts, RoleStatusID)
values (@u, isnull(@r, 'A798648D-777C-411D-B2BA-682400B3EDE6'), 'Enrich:'+@f+@l, 0, 0, 0, 0, 'M')

insert UserProfileOrgUnit (UserProfileID, OrgUnitID) 
select @u, isnull(@o, @po) where not exists (select 1 from UserProfileOrgUnit uo where uo.UserProfileID = @u and uo.OrgUnitID = isnull(@o, @po))

insert UserProfileSchool 
select newid(), @u, h.ID 
from School h join 
ADHOCIMPORT.StaffSchool ss on h.Number = ss.SCHOOLCODE left join
UserProfileSchool us on h.ID = us.SchoolID and us.UserProfileID = @u
where h.DeletedDate is null
and ss.STAFFEMAIL = @e
and us.ID is null

fetch U into @e, @f, @l, @r, @u
end
close U
deallocate U



-- commit tran usersimport
-- rollback tran usersimport


--select * from UserProfile 

--select * from UserProfile where username like '%Support%'


--select * from SecurityRole


/*

update up set RoleID = 'A798648D-777C-411D-B2BA-682400B3EDE6'
-- select up.*
from UserProfile up 
where up.RoleID = 'A101B7EC-62CA-48C2-9562-DD511AB88534'

*/

-- select * from UserProfile up where up.RoleID


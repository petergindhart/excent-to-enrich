-- select * from Person -- select ID, TypeID, Firstname, Lastname, EmailAddress, ManuallyEntered from Person
-- select * from UserProfile -- select ID, RoleID, Username, CanPerformAllServices, CanSignAllServices, IsSchoolAutoSelected, CurrentFailedLoginAttempts, RoleStatusID from UserProfile

-- select * from OrgUnit
-- select * from School order by Number
---- how to insert each different school in each different org unit for BOCES model
--select @o = (
--select top 1 o.ID
--from OrgUnit o join
--School s on o.ID = s.OrgUnitID join 
--ADHOCIMPORT.StaffSchool ss on s.Number = ss.SCHOOLCODE 
--where ss.STAFFEMAIL = @e
--group by o.ID 
--order by count(*) desc
--)


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
values (@u, isnull(@r, 'A101B7EC-62CA-48C2-9562-DD511AB88534'), 'Enrich:'+@f+@l, 0, 0, 0, 0, 'M')

--insert UserProfileOrgUnit (UserProfileID, OrgUnitID) 
--select @u, isnull(@o, @po) where not exists (select 1 from UserProfileOrgUnit uo where uo.UserProfileID = @u and uo.OrgUnitID = isnull(@o, @po))

insert UserProfileOrgUnit
select distinct UserProfileID = up.ID, OrgUnitID = h.OrgUnitID
from School h join 
ADHOCIMPORT.StaffSchool ss on h.Number = ss.SCHOOLCODE left join
dbo.Person up on ss.STAFFEMAIL = up.EmailAddress and up.TypeID = 'U' left join
dbo.UserProfileOrgUnit pou on h.OrgUnitID = pou.OrgUnitID and pou.UserProfileID = up.ID
where h.DeletedDate is null
and ss.STAFFEMAIL = @e
and pou.OrgUnitID is null


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



commit tran usersimport
-- rollback tran usersimport

-- select * from UserProfile


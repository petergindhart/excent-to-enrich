/*
declare @rolemap table (
EORole	varchar(50),
EnrichRole varchar(50)
)

declare @users table (
Firstname varchar(50),
Lastname varchar(50),
Email varchar(100),
EORole varchar(50),
School varchar(10)
)
set nocount on; 

insert @rolemap values ('Teacher', 'Teacher')

insert @users
select firstname, lastname, email, EORole = 'Teacher', SchoolNumber = SchoolID
from GEORGE.BrevardEOusers 
where email not like '%BrevardSchools.org'
and (firstname <> '.' and lastname <> '.')
and email <> ''
and email not like '%Brevard.k12.fl.us'
and email not in ( -- where email addresses are shared
	select email 
	from (
		select distinct firstname, lastname, email
		from GEORGE.BrevardEOusers 
		where email not like '%Brevard.k12.fl.us'
		and email not like '%Brevardschools.org'
		and email <> ''
		-- group by firstname, lastname, email
		-- having COUNT(*) > 1
		) e
	group by email 
	having COUNT(*) > 1
	)
order by lastname, firstname, email, SchoolNumber



select * from SecurityRole




--- select * from Person where emailaddress = 'shannon.sullivan@psysolutions.com'


--  select * from SecurityRole

set nocount off;

declare 
	@newpersonid uniqueidentifier, 
	@newpersonemail varchar(150), 
	@roleid uniqueidentifier, 
	@lastname varchar(50), 
	@firstname varchar(50), 
	@email varchar(100), 
	@newusername varchar(100), 
	@schoolid uniqueidentifier ; 

declare U cursor for
select distinct u.Firstname, u.Lastname, u.Email, RoleID = sr.ID
from @users u join 
	@rolemap r on u.EORole = r.EORole join -- there should not be any incorrect role names
	SecurityRole sr on r.EnrichRole = sr.Name
order by Email

begin tran newuser

open U

fetch U into @firstname, @lastname, @newpersonemail, @roleid

while @@FETCH_STATUS = 0
begin


select @newusername = 'Enrich:'+@lastname+'.'+@firstname

print @newusername


if exists (select 1 from Person where EmailAddress = @newpersonemail and TypeID = 'U')
	update Person set Deleted = NULL where EmailAddress = @newpersonemail and TypeID = 'U' and not exists (select EmailAddress from Person where EmailAddress = @newpersonemail group by EmailAddress having COUNT(*) > 1) -- ensure not deleted
else
begin
	insert dbo.Person (ID, TypeID, FirstName, LastName, EmailAddress, ManuallyEntered) values (newid(), 'U', @firstname, @lastname, @newpersonemail, 1)
end
select @newpersonid = ID from Person where EmailAddress = @newpersonemail and Deleted is null

-- insert UserProfile
if not exists (select 1 from UserProfile where ID = @newpersonid)
begin
	insert UserProfile (ID, RoleID, Username, CanPerformAllServices, CanSignAllServices, IsSchoolAutoSelected, CurrentFailedLoginAttempts, RoleStatusID) values (@newpersonid, @roleid, @newusername, 0, 0, 0, 0, 'M')
end

-- insert UserProfileSchool 
insert UserProfileSchool 
select
	ID = NEWID(),
	NewPersonID = @newpersonid, 
	SchoolID = s.ID
from @users u join
	School s on u.School = s.Number left join
	UserProfileSchool t on t.UserProfileID = @newpersonid and t.SchoolID = s.ID 
where u.Email = @newpersonemail and
	t.ID is null and 
	s.DeletedDate is null
order by s.Name


-- insert UserProfileOrgUnit 
insert UserProfileOrgUnit 
select distinct @newpersonid, s.OrgUnitID
from UserProfileSchool ups join 
	School s on ups.SchoolID = s.ID join
	OrgUnit ou on s.OrgUnitID = ou.ID left join
	UserProfileOrgUnit t on s.OrgUnitID = t.OrgUnitID and t.UserProfileID = @newpersonid -- make sure record doesn't already exist
where ups.UserProfileID = @newpersonid and
	t.UserProfileID is null and
	s.DeletedDate is null
-- order by ou.Name


fetch U into @firstname, @lastname, @newpersonemail, @roleid
end
close U
deallocate U

-- rollback tran newuser

-- commit tran newuser


*/


/*


(1 row(s) affected)
Enrich:Lebron.Antonio

(1 row(s) affected)

(1 row(s) affected)
Msg 2627, Level 14, State 1, Line 79
Violation of UNIQUE KEY constraint 'UN_ProfileSchool'. Cannot insert duplicate key in object 'dbo.UserProfileSchool'.
The statement has been terminated.

(0 row(s) affected)
Enrich:Davis.Donna

(1 row(s) affected)
Msg 2627, Level 14, State 1, Line 79
Violation of UNIQUE KEY constraint 'UN_ProfileSchool'. Cannot insert duplicate key in object 'dbo.UserProfileSchool'.
The statement has been terminated.

(0 row(s) affected)
Enrich:Fenn.Nicholas

(1 row(s) affected)
Msg 2627, Level 14, State 1, Line 79
Violation of UNIQUE KEY constraint 'UN_ProfileSchool'. Cannot insert duplicate key in object 'dbo.UserProfileSchool'.
The statement has been terminated.

(0 row(s) affected)
Enrich:Grant.Paul

(1 row(s) affected)
Msg 2627, Level 14, State 1, Line 79
Violation of UNIQUE KEY constraint 'UN_ProfileSchool'. Cannot insert duplicate key in object 'dbo.UserProfileSchool'.
The statement has been terminated.

(0 row(s) affected)
Enrich:McGinty.Robert

(1 row(s) affected)
Msg 2627, Level 14, State 1, Line 79
Violation of UNIQUE KEY constraint 'UN_ProfileSchool'. Cannot insert duplicate key in object 'dbo.UserProfileSchool'.
The statement has been terminated.

(0 row(s) affected)
Enrich:Sullivan.Shannon



*/


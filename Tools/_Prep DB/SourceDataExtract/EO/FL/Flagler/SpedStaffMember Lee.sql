set nocount on;
set ansi_warnings off;

select 
	StaffEmail = isnull(t.Email,''),
	t.Firstname,
	t.Lastname,
	EnrichRole = ''
from 
	Staff t
where isnull(t.del_flag,0)=0 
and isnull(t.email,'') <> ''
and t.email not in (select de.email from staff de where isnull(de.del_flag,0)=0 group by de.email having count(*) > 1)



-- where t.RefID = '12959F41-6577-4C16-8D5D-5F9F85C45966'

-- select * from 
-- 12959F41-6577-4C16-8D5D-5F9F85C45966
/*

select RefID, Lastname, Firstname, SSN, EmailAddress, GenderCode, BirthDate
from StaffMember_HR
-- has no relationship to staffmember table


select * from StaffType
-- service provider types

-- this has potential
select RefID, UserID, UserName, StaffMemberRefID, EmailAddress from SystemUser
-- 657 rows, but email address is almost always null
-- 657 is not a lot compared to the other tables


select top 10 * from staff






*/




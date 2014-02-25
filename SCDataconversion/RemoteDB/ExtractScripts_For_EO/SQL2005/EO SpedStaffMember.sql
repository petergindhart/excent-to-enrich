IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.SpedStaffMember_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.SpedStaffMember_EO
GO

CREATE VIEW dbo.SpedStaffMember_EO
AS
select
    Line_No=Row_Number() OVER (ORDER BY (SELECT 1)), 
	StaffEmail = t.Email,
	t.Firstname,
	t.Lastname,
	EnrichRole = NULL
--select t.*
FROM 
	Staff t
where isnull(t.email,'') <> ''
	-- isnull(t.del_flag,0)=0  -- removing this criterion because some recent service providers may have been deleted
and t.email  in (select de.email from staff de where isnull(de.del_flag,0)=0 group by de.email having count(*) = 1)
and t.staffgid = (
	select min(convert(varchar(36), stmin.staffgid))
	from Staff stmin
	where t.email = stmin.email 
	and isnull(stmin.del_flag,0)= (
		select min(isnull(convert(tinyint,delmin.del_flag),0))
		from Staff delmin
		where stmin.email = delmin.email 
		)
	)
	--order by t.email

-- select * from staff where email = 'rguidry@psdschools.org'


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




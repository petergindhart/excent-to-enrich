set nocount on;
set ansi_warnings off;

select 
	StaffEmail = isnull(t.Email,''),
	t.Firstname,
	t.Lastname,
	EnrichRole = ''
from 
	Staff t
where isnull(t.email,'') <> ''
	-- isnull(t.del_flag,0)=0  -- removing this criterion because some recent service providers may have been deleted
and t.email not in (select de.email from staff de where isnull(de.del_flag,0)=0 group by de.email having count(*) > 1)
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

--and t.Email = 'tdurbin@neboces.com'
	order by t.email

--select * from 
--(select de.email from staff de where isnull(de.del_flag,0)=0 group by de.email having count(*) > 1) t
--where Email = 'tdishman@neboces.com'


--select de.*
--from staff de 
--where isnull(de.del_flag,0)=0 
--and Email = 'tdishman@neboces.com'

--select de.*
--from staff de 
--where isnull(de.del_flag,0)=0 
--and Email = 'tdurbin@neboces.com'

-- update staff set email = NULL where StaffGID = '0764EBAD-E196-42DC-94C1-4381674D5B76'



--group by de.email 
--having count(*) > 1


-- McDonald	Mark	tdishman@neboces.com




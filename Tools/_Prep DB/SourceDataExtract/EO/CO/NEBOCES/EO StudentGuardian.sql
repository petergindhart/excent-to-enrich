

	--ID varchar(150) NOT NULL,
	--StudentID varchar(150) NOT NULL,
	--GuardianID varchar(150) NOT NULL,
	--RelationshipID varchar(150) NOT NULL


-- C613714B-D56F-48EB-8ED5-6624CC665FE9	Mother
-- 5995C589-10E7-47FD-85A2-C61A2670B7B8	Father

set nocount on;

select ID = c.RecNum, StudentID = c.GStudentID, GuardianID = c.RecNum, Relation = isnull(c.Relation,'')
from Contacts c

/*
select Relation = isnull(Relation, ''), count(*) tot
from Contacts
where isnull(del_flag,0)=0
group by isnull(Relation, '')
order by Relation
*/






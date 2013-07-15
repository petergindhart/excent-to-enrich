
-- identify student records that have invalid district/school codes.  provide this to the customer as aditional validation.


select distinct DistrictCode , SchoolCode
from (
	select StudentID = rtrim(s.e_studentlocalid), Firstname = rtrim(s.e_firstname), Lastname = rtrim(s.e_lastname), DistrictCode = rtrim(s.e_servicedistrictcode), SchoolCode = rtrim(s.e_serviceschoolcode)
	from SCHOOL h right join 
	STUDENT s on 
		h.e_districtcode = s.e_servicedistrictcode and
		h.e_SchoolCode = s.e_serviceschoolcode
	where h.refid is null
	
	union 
	select StudentID = rtrim(s.e_studentlocalid), Firstname = rtrim(s.e_firstname), Lastname = rtrim(s.e_lastname), DistrictCode = rtrim(s.e_homedistrictcode), SchoolCode = rtrim(s.e_homeschoolcode)
	from SCHOOL h right join 
	STUDENT s on 
		h.e_districtcode = s.e_homedistrictcode and
		h.e_SchoolCode = s.e_homeschoolcode
	where h.refid is null
	) t
group by DistrictCode , SchoolCode
order by DistrictCode, SchoolCode





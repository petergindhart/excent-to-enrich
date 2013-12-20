set nocount on;

declare @md table (EODistrictCode varchar(4), StateDistrictCode varchar(4))
insert @md values ('1000', '2862') -- barring being able to write re-usable code for all districts, trying to create a re-usable strategy...

select 
	DistrictCode = d.DistrictID,
	d.DistrictName
from District d 
where DistrictName is not null
and d.DistrictID in (
	select s.ResidDistCode
	from dbo.SpecialEdStudentsAndIEPs x
	join dbo.ReportStudentSchools s on x.GStudentID = s.gstudentid 
	union
	select s.ServiceDistCode
	from dbo.SpecialEdStudentsAndIEPs x
	join dbo.ReportStudentSchools s on x.GStudentID = s.gstudentid 
)
and d.DistrictID not in (select md.EODistrictCode from @md md)
go



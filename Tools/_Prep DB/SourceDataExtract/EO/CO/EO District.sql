set nocount on;

select 
	DistrictCode = d.DistrictID,
	d.DistrictName
from District d 
where DistrictName is not null
go

--- select * from District


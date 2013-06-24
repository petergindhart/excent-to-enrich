set nocount on;

select 
	DistrictCode = d.DistrictID,
	d.DistrictName
from (select top 1 * from Forms where DistrictID is not null ) f
join District d on f.DistrictID = d.DistrictID
go



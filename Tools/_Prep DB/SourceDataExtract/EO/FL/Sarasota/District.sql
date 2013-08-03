set nocount on;

select 
	DistrictCode = case d.DistrictID when 'SAR' then '58' else d.DistrictID end,
	d.DistrictName
from (select top 1 * from Forms where DistrictID is not null ) f
join District d on f.DistrictID = d.DistrictID
go

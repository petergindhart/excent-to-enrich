set nocount on;

select 
	DistrictCode = d.DistrictID,
	d.DistrictName
from (select top 1 * from excent9710a.ExcentOnlineFL.dbo.Forms where DistrictID is not null ) f
join excent9710a.ExcentOnlineFL.dbo.District d on f.DistrictID = d.DistrictID
go



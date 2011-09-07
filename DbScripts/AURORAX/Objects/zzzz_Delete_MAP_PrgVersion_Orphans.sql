delete m 
from AURORAX.MAP_PrgVersionID m left join 
	dbo.PrgVersion v on m.DestID = v.ID
where v.ID is null
go

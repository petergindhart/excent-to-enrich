
delete m
from AURORAX.MAP_PrgSectionID m 
left join PrgSection s on m.DestID = s.ID
where s.ID is null
GO

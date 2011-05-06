IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_PrgLocation]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_PrgLocation]
GO

CREATE VIEW [AURORAX].[Transform_PrgLocation]  
as
select 
  ServiceLocationCode = sc.Code,
  StaticMap = cast (0 as bit),
  DestID = m.DestID,
  Description = cast(NULL as varchar(100)),
  Name = sc.Label,
  MedicaidLocationID = cast(NULL as uniqueidentifier)
from AURORAX.Lookups sc LEFT JOIN 
	AURORAX.MAP_ServiceLocationID m on sc.Code = m.ServiceLocationCode LEFT JOIN
	dbo.PrgLocation pl on m.DestID = pl.ID
where sc.Type = 'ServLoc'
	and sc.Code not in (select servicelocationcode from AURORAX.MAP_ServiceLocationIDstatic)
union all
select 
  ServiceLocationCode = sc.Code,
  StaticMap = cast (1 as bit),
  DestID = m.DestID,
  Description = cast(NULL as varchar(100)),
  Name = pl.Name,
  MedicaidLocationID = cast(NULL as uniqueidentifier)
from AURORAX.Lookups sc JOIN 
	AURORAX.MAP_ServiceLocationIDstatic ms on sc.Code = ms.ServiceLocationCode LEFT JOIN
	AURORAX.MAP_ServiceLocationID m on ms.ServiceLocationCode = m.ServiceLocationCode LEFT JOIN
	dbo.PrgLocation pl on ms.DestID = pl.ID
where sc.Type = 'ServLoc'
go
--
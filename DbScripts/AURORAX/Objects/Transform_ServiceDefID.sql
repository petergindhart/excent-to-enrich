IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_ServiceDefID]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_ServiceDefID]
GO

CREATE VIEW AURORAX.Transform_ServiceDefID
AS
/*
	This transform looks at the service table in order to exclude service definition codes that are not used.
	Unusual in that it uses 2 maps, a static map for the hard-coded mappings and a maintainable map.
*/
 SELECT
  x.ServiceDefCode,
  x.HardMap,
  x.DestID,
  TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784',
  Name = isnull(i.Name, x.Label),
  Description = cast(NULL as text),
  DefaultLocationID = cast(NULL as uniqueidentifier),
  DefaultProviderTitleID = cast(NULL as uniqueidentifier)
 from (
  select distinct
   ServiceDefCode = x.Code,
   HardMap = case when ms.ServiceDefCode is null then 0 else 1 end,
   DestID = isnull(ms.DestID, m.DestID),
   Label = isnull(d.Name, right(x.Label, len(x.Label)-(patindex('% - %', x.Label)+2)))
  FROM
   AURORAX.Lookups x join
   AURORAX.Service v on x.Code = v.ServiceDefinitionCode and x.Type = 'Service' LEFT JOIN
   AURORAX.MAP_ServiceDefID m on v.ServiceDefinitionCode = m.ServiceDefCode LEFT JOIN
   AURORAX.MAP_ServiceDefIDstatic ms on x.code = ms.ServiceDefCode LEFT JOIN
   ServiceDef d on ms.DestID = d.ID
  ) x LEFT JOIN
 ServiceDef i on x.DestId = i.ID
GO
---
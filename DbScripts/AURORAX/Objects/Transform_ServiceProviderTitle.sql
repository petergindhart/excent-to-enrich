IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_ServiceProviderTitle]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_ServiceProviderTitle]  
GO  
  
CREATE VIEW [AURORAX].[Transform_ServiceProviderTitle]  
AS  
 SELECT   
	ServiceProviderCode = k.Code,
   m.DestID,
	Name = k.Label
 FROM  
  AURORAX.Lookups k LEFT JOIN
  AURORAX.MAP_ServiceProviderTitleID m on k.Code = m.ServiceProviderCode LEFT JOIN
  dbo.ServiceProviderTitle t on m.DestID = t.ID
 WHERE
  k.Type = 'ServProv'
GO

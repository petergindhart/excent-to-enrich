IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_OrgUnit]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_OrgUnit]  
GO  
  
CREATE VIEW [AURORAX].[Transform_OrgUnit]  
AS
 SELECT   
  d.DistrictRefID,
  m.DestID,   
  TypeID = '420A9663-FFE8-4FF1-B405-1DB1D42B6F8A',   
  Name = case when ou.ID is null then d.DistrictName else ou.Name end, 
  ou.ParentID,
  ou.Street,
  ou.City,
  ou.State,
  ou.ZipCode,
  ou.PhoneNumber
 FROM
  AURORAX.District d LEFT JOIN
  AURORAX.MAP_OrgUnit m on d.DistrictRefID = m.DistrictRefID LEFT JOIN
  OrgUnit ou on m.DestID = ou.ID
GO
--
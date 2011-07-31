IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_OrgUnit]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_OrgUnit]  
GO  
  
CREATE VIEW [AURORAX].[Transform_OrgUnit]  
AS
select 
  d.DistrictRefID, 
  DestID = isnull(ou.ID, m.DestID),
  TypeID = '420A9663-FFE8-4FF1-B405-1DB1D42B6F8A',   -- select * from orgunittype
  Name = case when ou.ID is null then d.DistrictName else ou.Name end, 
  ou.ParentID,
  ou.Street,
  ou.City,
  ou.State,
  ou.ZipCode,
  ou.PhoneNumber,
  Number = d.DistrictCode,
  ou.Sequence -- 
from AURORAX.District d left join 
	AURORAX.MAP_OrgUnit m on d.DistrictRefID = m.DistrictRefID left join 
	dbo.OrgUnit ou on d.DistrictCode = ou.Number left join
	dbo.SystemSettings ss on ou.ID = ss.LocalOrgRootID
where
	ss.ID is null -- assures that the map will only contain districts other than the target district
GO
--



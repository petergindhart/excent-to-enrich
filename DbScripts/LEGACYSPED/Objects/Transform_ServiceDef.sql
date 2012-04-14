--#include Transform_IepServiceCategory.sql
-- ############################################################################# 
-- Service Definition
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_ServiceDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_ServiceDefID
(
	ServiceCategoryCode  varchar(20) NOT null,
	ServiceDefCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_ServiceDefID ADD CONSTRAINT
PK_Map_ServiceDefID PRIMARY KEY CLUSTERED
(
	-- ServiceCategoryCode, ServiceDefCode -- could not create a PK on a nullable column, and apparently it is possible to not associate a service with category
	DestID
	, ServiceCategoryCode
)

CREATE INDEX IX_MAP_ServiceDefID_ServiceCategoryCode_ServiceDefCode on LEGACYSPED.MAP_ServiceDefID (ServiceCategoryCode, ServiceDefCode)


ALTER TABLE LEGACYSPED.MAP_ServiceDefID ADD CONSTRAINT 
UQ_MAP_ServiceDefID_ServiceCategoryCode_ServiceDefCode UNIQUE NONCLUSTERED 
(
 ServiceDefCode
)


END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_ServiceDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_ServiceDef
GO

CREATE VIEW LEGACYSPED.Transform_ServiceDef
AS
/*
	ServiceDef and IepServiceDef are no longer included in the Config Export (they cannot be since this data is different from district to district)
	Customer is given the opportunity to provide a list of preferred values for this element.  (LEGACYSPED.SelectLists)
	LegacySpedCode may be blank if the customer does not have a value that corresponds to an out-of-the-box Enrich value.  

	This view was written to accommodate the scenario where a customer already has desired Service Definitions in their target database.  
	Care must be taken to prepare the SelectLists file, so that the appropriate IDs exist in that file.

	1. Map table has been wiped out before the clean import
	2. ServiceDef table records that were not del-flagged have been left in place
	3. There may be no way to match up legacy service with services in enrich.  best effort at most.

*/

select 
	ServiceCategoryCode = k.SubType,
	ServiceDefCode = k.LegacySpedCode,
	DestID = coalesce(i.ID, n.ID, t.ID, m.DestID), -- give this some thought
	StateCode = coalesce(i.StateCode, n.StateCode, t.StateCode),
	TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784',
	Name = coalesce(i.Name, n.ServiceDefName, t.Name, k.EnrichLabel),
	Description = coalesce(i.Description, n.Description, t.Description), 
	DefaultLocationID = coalesce(i.DefaultLocationID, n.DefaultLocationID, t.DefaultLocationID), 
	DeletedDate = case when k.EnrichID is not null then NULL when coalesce(i.ID, n.ID, t.ID) is null then getdate() else coalesce(i.DeletedDate, n.DeletedDate, t.DeletedDate) end
from LEGACYSPED.SelectLists k left join 
	dbo.ServiceDef i on k.EnrichID = i.ID left join (
	select sd.ID, ServiceDefName = sd.Name, sd.StateCode, sd.DeletedDate, ServiceCategoryName = isc.Name, sd.Description, sd.DefaultLocationID 
	from dbo.ServiceDef sd join 
		dbo.IepServiceDef isd on sd.ID = isd.ID left join 
		dbo.IepServiceCategory isc on isd.CategoryID = isc.ID
	) n on n.ServiceDefName = k.EnrichLabel and isnull(n.ServiceCategoryName,'') = case isnull(k.SubType,'') when 'SpecialEd' then 'Special Education' else isnull(k.SubType,'') end  left join 
	LEGACYSPED.MAP_ServiceDefID m on k.LegacySpedCode = m.ServiceDefCode and isnull(k.SubType,'') = isnull(m.ServiceCategoryCode,'') left join 
	dbo.ServiceDef t on m.DestID = t.ID
where k.Type = 'Service'
	and k.LegacySpedCode is not null -- there is nothing to do if this is null
GO

--

/*

select * from LEGACYSPED.SelectLists where Type = 'Service' -- 254
order by EnrichLabel




select * 
from LEGACYSPED.SelectLists sl left join
(select d.ID, ServiceDef = d.Name, i.CategoryID, CategoryName = c.Name, d.DeletedDate from dbo.ServiceDef d join iepservicedef i on d.id = i.id left join iepservicecategory c on i.categoryid = c.ID  ) sd on sl.EnrichLabel = sd.ServiceDef -- 14 no category
where sl.Type = 'Service' 
and not ((sl.SubType = 'Related' and sl.LegacySpedCode in ('Speech/Language Therapy', 'Psychological Services')) or (sd.CategoryName = 'Related' and sd.ServiceDef in ('Speech/Language Therapy', 'Psychological Services')))
order by CategoryName, ServiceDef


select * from 


*/








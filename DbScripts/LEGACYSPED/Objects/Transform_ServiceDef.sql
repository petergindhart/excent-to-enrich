-- ############################################################################# 
-- Service Definition
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_ServiceDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_ServiceDefID
(
	ServiceCategoryCode  varchar(20) null,
	ServiceDefCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_ServiceDefID ADD CONSTRAINT
PK_Map_ServiceDefID PRIMARY KEY CLUSTERED
(
	-- ServiceCategoryCode, ServiceDefCode -- could not create a PK on a nullable column, and apparently it is possible to not associate a service with category
	DestID
)

CREATE INDEX IX_MAP_ServiceDefID_ServiceCategoryCode_ServiceDefCode on LEGACYSPED.MAP_ServiceDefID (ServiceCategoryCode, ServiceDefCode)

alter table LEGACYSPED.MAP_ServiceDefID ADD CONSTRAINT UQ_MAP_ServiceDefID_ServiceCategoryCode_ServiceDefCode unique nonclustered (ServiceCategoryCode, ServiceDefCode)

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
	ServiceDefCode = isnull(k.LegacySpedCode, convert(varchar(150), k.EnrichLabel)),
	DestID = coalesce(i.ID, n.ID, t.ID, m.DestID), -- give this some thought
	StateCode = coalesce(i.StateCode, n.StateCode, t.StateCode),
	TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784',
	Name = coalesce(i.Name, n.ServiceDefName, t.Name, k.EnrichLabel),
	Description = coalesce(i.Description, n.Description, t.Description), 
	DefaultLocationID = coalesce(i.DefaultLocationID, n.DefaultLocationID, t.DefaultLocationID), 
	DeletedDate = case when k.EnrichID is not null then NULL else coalesce(i.DeletedDate, n.DeletedDate, t.DeletedDate) end,
	UserDefined = cast(1 as Bit),
	PhysicianReferralRequired = cast(0 as Bit),
	NotTiedToIep = CAST(0 as BIT)
from LEGACYSPED.SelectLists k left join 
	dbo.ServiceDef i on k.EnrichID = i.ID left join (
	select sd.ID, ServiceDefName = sd.Name, sd.StateCode, sd.DeletedDate, ServiceCategoryName = isc.Name, sd.Description, sd.DefaultLocationID 
	from dbo.ServiceDef sd join 
		dbo.IepServiceDef isd on sd.ID = isd.ID left join 
		dbo.IepServiceCategory isc on isd.CategoryID = isc.ID
	) n on n.ServiceDefName = k.EnrichLabel and isnull(n.ServiceCategoryName,'') = case isnull(k.SubType,'') when 'SpecialEd' then 'Special Education' else isnull(k.SubType,'') end  left join 
	LEGACYSPED.MAP_ServiceDefID m on ISNULL(k.LegacySpedCode,convert(varchar(150), k.EnrichLabel)) = m.ServiceDefCode   
	and isnull(k.SubType,'x') = isnull(m.ServiceCategoryCode,'y') left join 
	dbo.ServiceDef t on m.DestID = t.ID
where k.Type = 'Service' and k.SubType is not null and n.DeletedDate is null
	--and k.LegacySpedCode is not null -- there is nothing to do if this is null
GO
--

/*

select * from LEGACYSPED.SelectLists where Type = 'Service' -- 254
order by EnrichLabel
select * from LEGACYSPED.Transform_ServiceDef where ServiceDefCode = 'OT6'

select k.*
from (
	select Type, LegacySpedCode
	from LEGACYSPED.SelectLists 
	where Type = 'Service'
	and LegacySpedCode is not null
	group by Type, LegacySpedCode
	having count(*) > 1
	) dup 
join LEGACYSPED.SelectLists k on dup.Type = k.Type and dup.LegacySpedCode = k.LegacySpedCode 
order by k.LegacySpedCode, k.SubType

delete k
-- update k set SubType = 'Related' 
-- select k.*
from (
	select Type, LegacySpedCode
	from LEGACYSPED.SelectLists 
	where Type = 'Service'
	and LegacySpedCode is not null
	and LegacySpedCode in ('AA', 'C-SpLg', 'C-SpLg', 'OT6', 'PT2')
	group by Type, LegacySpedCode
	having count(*) > 1
	) dup 
join LEGACYSPED.SelectLists k on dup.Type = k.Type and dup.LegacySpedCode = k.LegacySpedCode 
where k.EnrichID is null


select k.*
from (
	select Type, LegacySpedCode = isnull(LegacySpedCode,'')
	from LEGACYSPED.SelectLists 
	where Type = 'Service'
	and LegacySpedCode is null
	group by Type, isnull(LegacySpedCode,'')
	having count(*) > 1
	) dup 
join LEGACYSPED.SelectLists k on dup.Type = k.Type and dup.LegacySpedCode = isnull(k.LegacySpedCode,'')
order by k.LegacySpedCode, k.SubType

select * from ServiceDef where Name = 'Consultation'


select * 
from LEGACYSPED.SelectLists sl left join
(select d.ID, ServiceDef = d.Name, i.CategoryID, CategoryName = c.Name, d.DeletedDate from dbo.ServiceDef d join iepservicedef i on d.id = i.id left join iepservicecategory c on i.categoryid = c.ID  ) sd on sl.EnrichLabel = sd.ServiceDef -- 14 no category
where sl.Type = 'Service' 
and not ((sl.SubType = 'Related' and sl.LegacySpedCode in ('Speech/Language Therapy', 'Psychological Services')) or (sd.CategoryName = 'Related' and sd.ServiceDef in ('Speech/Language Therapy', 'Psychological Services')))
order by CategoryName, ServiceDef


select * from 


*/








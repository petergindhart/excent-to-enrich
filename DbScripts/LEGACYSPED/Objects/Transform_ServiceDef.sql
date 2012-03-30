--#include Transform_IepServiceCategory.sql
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

alter table LEGACYSPED.MAP_ServiceDefID ADD CONSTRAINT UQ_MAP_ServiceDefID_ServiceCategoryCode_ServiceDefCode unique clustered (ServiceCategoryCode, ServiceDefCode)

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
	ServiceDefCode = k.LegacySpedCode,
	ServiceCategoryCode = k.SubType,
	DestID = coalesce(k.EnrichID, s.ServiceDefID, m.DestID), -- give this some thought
	--sdDestID = s.ServiceDefID,
	--slDestID = k.EnrichID,
	--mDestID = m.DestID,
	--tDestID = t.DestID,
	StateCode = k.StateCode,
	TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784',
	Name = isnull(s.ServiceDefName, k.EnrichLabel),
	Description = s.Description,
	DefaultLocationID = s.DefaultLocationID,
	DeletedDate = case when coalesce(k.EnrichID, s.ServiceDefID, m.DestID) is null then getdate() else s.DeletedDate end
from LEGACYSPED.SelectLists k left join
(select ServiceDefID = sd.ID, ServiceDefName = sd.Name, sd.DeletedDate, ServiceCategoryName = isc.Name, sd.Description, sd.DefaultLocationID from dbo.ServiceDef sd join dbo.IepServiceDef isd on sd.ID = isd.ID join dbo.IepServiceCategory isc on isd.CategoryID = isc.ID) s on s.ServiceDefName = k.EnrichLabel and isnull(s.ServiceCategoryName,'') = case isnull(k.SubType,'') when 'SpecialEd' then 'Special Education' else isnull(k.SubType,'') end  left join 
LEGACYSPED.MAP_ServiceDefID m on k.LegacySpedCode = m.ServiceDefCode and isnull(k.SubType,'') = isnull(m.ServiceCategoryCode,'') left join 
dbo.ServiceDef t on m.DestID = t.ID
where k.Type = 'Service'
and k.LegacySpedCode is not null
GO
--

/*


select * from LEGACYSPED.Transform_ServiceDef where ServiceCategoryCode is null


GEO.ShowLoadTables ServiceDef

set nocount on;
declare @n varchar(100) ; select @n = 'ServiceDef'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	HasMapTable = 1, 
	MapTable = 'LEGACYSPED.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'ServiceCategoryCode, ServiceDefCode'
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = 's.DestID in (select DestID from LEGACYSPED.MAP_ServiceDefID)'
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n



select d.*
-- UPDATE ServiceDef SET DeletedDate=s.DeletedDate, Name=s.Name, TypeID=s.TypeID, Description=s.Description, DefaultLocationID=s.DefaultLocationID, StateCode=s.StateCode
FROM  ServiceDef d JOIN 
	LEGACYSPED.Transform_ServiceDef  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from LEGACYSPED.MAP_ServiceDefID)

-- INSERT LEGACYSPED.MAP_ServiceDefID
SELECT ServiceCategoryCode, ServiceDefCode, NEWID()
FROM LEGACYSPED.Transform_ServiceDef s
WHERE NOT EXISTS (SELECT * FROM ServiceDef d WHERE s.DestID=d.ID)

-- INSERT ServiceDef (ID, DeletedDate, Name, TypeID, Description, DefaultLocationID, StateCode)
SELECT s.DestID, s.DeletedDate, s.Name, s.TypeID, s.Description, s.DefaultLocationID, s.StateCode
FROM LEGACYSPED.Transform_ServiceDef s
WHERE NOT EXISTS (SELECT * FROM ServiceDef d WHERE s.DestID=d.ID)

select * from ServiceDef



*/










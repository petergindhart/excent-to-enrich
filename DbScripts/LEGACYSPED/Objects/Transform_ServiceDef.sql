--#include Transform_IepServiceCategory.sql
-- ############################################################################# 
-- Service Definition
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_ServiceDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_ServiceDefID
(
	ServiceCategoryCode  varchar(20) not null,
	ServiceDefCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_ServiceDefID ADD CONSTRAINT
PK_Map_ServiceDefID PRIMARY KEY CLUSTERED
(
	ServiceCategoryCode, ServiceDefCode
)

CREATE INDEX IX_MAP_ServiceDefID_ServiceCategoryCode_ServiceDefCode on LEGACYSPED.MAP_ServiceDefID (ServiceCategoryCode, ServiceDefCode)
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_ServiceDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_ServiceDef
GO

CREATE VIEW LEGACYSPED.Transform_ServiceDef
AS
/*
	ServiceDef and IepServiceDef are no longer included in the Config Export (they cannot be since this data is different from district to district)
	Customer is given the opportunity to provide a list of preferred values for this element.  (LEGACYSPED.Lookups Type = Service, DisplayInUI = Y.  
	AUROAX.Lookups.Code should never be blank.  For new ServiceDef (customer pref), use first 150 characters of Label as a code.
	
	This should show in the UI:
		1. State reporting values (required)
		2. Customer preferred lookups
		3. LEGACYSPED.
		.DisplayInUI indicates which legacy lookups to display in UI

*/

SELECT distinct
-- ServiceDef
	ServiceDefCode = isnull(k.LegacySpedCode, convert(varchar(150), k.EnrichLabel)), -- Validation tool has beenn updated to require a code.  only matters in preferences, so no worries about joining to the legacy service records
	ServiceCategoryCode = k.SubType,
	DestID = coalesce(s.ID, t.ID, m.DestID), -- may not need coalesce below this line because we are only updating legacy records.
	StateCode = coalesce(s.StateCode, t.StateCode, k.StateCode),
	TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', -- IEP
	Name = coalesce(s.Name, t.Name, k.EnrichLabel),
	Description = cast(coalesce(s.Description, t.Description) as varchar(max)),
	DefaultLocationID = coalesce(s.DefaultLocationID, t.DefaultLocationID),
	DeletedDate = 
			CASE 
				WHEN s.ID IS NOT NULL THEN s.DeletedDate
				WHEN t.ID IS NOT NULL THEN t.DeletedDate
				ELSE 
					--CASE WHEN k.DisplayInUI = 'Y' THEN NULL -- User specified they want to see this in the UI.  Let them.
					--ELSE GETDATE()
					END
			END -- select k.* 
FROM (select 'Service' Type) x  join 
	LEGACYSPED.SelectLists k on x.Type = k.Type LEFT JOIN -- Legacy ServiceDefs and preferred ServiceDefs provided in the same file )
	(
		select sd.ID, c.ServiceCategoryCode, sd.Name, sd.StateCode, sd.Description, sd.DefaultLocationID, sd.DeletedDate
		from dbo.ServiceDef sd join dbo.IepServiceDef i on sd.ID = i.ID JOIN
			LEGACYSPED.Transform_IepServiceCategory c on i.CategoryID = c.DestID 
	) s on k.SubType = s.ServiceCategoryCode and
		isnull(k.StateCode, 'kService') = isnull(s.StateCode, 'sService')
		  -- objective:  join on state code only if there is a match.
		LEFT JOIN 
	(
		select distinct sd.ID, c.ServiceCategoryCode, sd.Name, sd.StateCode, Description = cast(sd.Description as varchar(max)), sd.DefaultLocationID, sd.DeletedDate
		from dbo.ServiceDef sd JOIN dbo.IepServiceDef i on sd.ID = i.ID JOIN
			LEGACYSPED.Transform_IepServiceCategory c on i.CategoryID = c.DestID
	) n on k.SubType = n.ServiceCategoryCode and -- objective : identify where a ServiceDefinition with this label already exists in Enrich database.  
		k.EnrichLabel = n.Name left join -- as currently written, if IepServiceDef.CategoryID is null, a new record will be added to ServiceDef for the proper ServiceCategory
	LEGACYSPED.MAP_ServiceDefID m on 
		k.SubType = m.ServiceCategoryCode and 
		isnull(k.LegacySpedCode, convert(varchar(150), k.EnrichLabel)) = m.ServiceDefCode LEFT JOIN
	dbo.ServiceDef t on m.DestID = t.ID 
WHERE 
	k.Type = 'Service' 
GO
--

/*


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










--#include Transform_IepServiceCategory.sql

-- AURORAX.Transform_IepServiceDef should use the same logic as AURORAX.Transform_ServiceDef

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_IepServiceDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_IepServiceDef
GO

CREATE VIEW AURORAX.Transform_IepServiceDef
AS

SELECT
-- ServiceDef
	ServiceDefCode = isnull(k.Code, convert(varchar(150), k.Label)),
	ServiceCategoryCode = k.SubType,
	md.DestID,
-- IepServiceDef
	ServiceCategoryID = mc.DestID,
	DefaultProviderTitleID = cast(NULL as uniqueidentifier),
	CategoryID = mc.DestID, 
	DirectID = t.DirectID, -- Imported at individual service level, not here
	ExcludesID = t.ExcludesID, -- Imported individual service level, not here
	ScheduleFreqOnly = CAST(0 as bit) -- we don't know this, so assume Time required.  Pete says:  True means when user adds a service for this definition on an IEP, they will only be prompted for frequency as a unit (times, Amount = 1), not time.  This was for Florida.
FROM 
	AURORAX.Transform_ServiceDef md join -- should be 100% match
	AURORAX.Lookups k on 
		md.ServiceCategoryCode = k.SubType and 
		md.ServiceDefCode = isnull(k.Code, convert(varchar(150), k.Label)) LEFT JOIN 
	AURORAX.Transform_IepServiceCategory mc on md.ServiceCategoryCode = mc.ServiceCategoryCode LEFT JOIN
	dbo.IepServiceDef t on md.DestID = t.ID 
WHERE 
	k.Type = 'Service' 
GO
--


/*

GEO.ShowLoadTables IepServiceDef


set nocount on;
declare @n varchar(100) ; select @n = 'IepServiceDef'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	SourceTable = 'AURORAX.Transform_IepServiceDef'
	, HasMapTable = 0
	, MapTable = NULL -- the map used in this transform is maintained in Transform_ServiceDef.sql
	, KeyField = NULL
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = 's.DestID in (select DestID from AURORAX.MAP_ServiceDefID)'
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n

select d.*
-- UPDATE IepServiceDef SET ScheduleFreqOnly=s.ScheduleFreqOnly, DirectID=s.DirectID, ExcludesID=s.ExcludesID, DefaultProviderTitleID=s.DefaultProviderTitleID, CategoryID=s.CategoryID
FROM  IepServiceDef d JOIN 
	AURORAX.Transform_IepServiceDef  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from AURORAX.MAP_ServiceDefID)

-- INSERT IepServiceDef (ID, ScheduleFreqOnly, DirectID, ExcludesID, DefaultProviderTitleID, CategoryID)
SELECT s.DestID, s.ScheduleFreqOnly, s.DirectID, s.ExcludesID, s.DefaultProviderTitleID, s.CategoryID
FROM AURORAX.Transform_IepServiceDef s
WHERE NOT EXISTS (SELECT * FROM IepServiceDef d WHERE s.DestID=d.ID)

select * from IepServiceDef



*/



-- LEGACYSPED.Transform_IepServiceDef should use the same logic as LEGACYSPED.Transform_ServiceDef

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepServiceDef') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepServiceDef
GO

CREATE VIEW LEGACYSPED.Transform_IepServiceDef
AS

SELECT
-- ServiceDef
	ServiceDefCode = isnull(k.LegacySpedCode, convert(varchar(150), k.EnrichLabel)),
	ServiceCategoryCode = isnull(k.SubType, mc.ServiceCategoryCode),
	md.DestID,
-- IepServiceDef
	ServiceCategoryID = mc.DestID,
	DefaultProviderTitleID = cast(NULL as uniqueidentifier),
	CategoryID = mc.DestID, 
	DirectID = t.DirectID, -- Imported at individual service level, not here
	ExcludesID = t.ExcludesID, -- Imported individual service level, not here
	ScheduleFreqOnly = ISNULL(t.ScheduleFreqOnly,0), -- we don't know this, so assume Time required.  Pete says:  True means when user adds a service for this definition on an IEP, they will only be prompted for frequency as a unit (times, Amount = 1), not time.  This was for Florida.
	UseServiceAmountRange = cast( 0 as bit)
FROM 
	LEGACYSPED.Transform_ServiceDef md left join -- should be 100% match
	LEGACYSPED.SelectLists k on 
		md.ServiceCategoryCode = k.SubType and 
		md.ServiceDefCode = isnull(k.LegacySpedCode, convert(varchar(150), k.EnrichLabel)) LEFT JOIN 
	LEGACYSPED.Transform_IepServiceCategory mc on md.ServiceCategoryCode = mc.ServiceCategoryCode LEFT JOIN
	dbo.IepServiceDef t on md.DestID = t.ID 
WHERE 
	k.Type = 'Service' 
GO
--


/*

select * from ServiceDef -- 259

select * from ServiceDef where deleteddate is not null -- 0

select * from LEGACYSPED.SelectLists k where type = 'Service' order by subtype








*/



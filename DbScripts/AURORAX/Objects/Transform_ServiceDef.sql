IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_ServiceDefID]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_ServiceDefID]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_ServiceDef]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_ServiceDef]
GO

CREATE VIEW AURORAX.Transform_ServiceDef
AS

SELECT
	md.DestID,
	l.UniqueCode,
	TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', -- IEP
	Name = l.Label,
	Description = CAST(NULL AS Text),
	DefaultLocationID = cast(NULL as uniqueidentifier),
	StateCode = l.StateCode,
	-- IepServiceDef
	DefaultProviderTitleID = cast(NULL as uniqueidentifier),
	CategoryID = mc.DestID,
	DirectID = CAST (NULL as uniqueidentifier),
	ExcludesID = CAST (NULL as uniqueidentifier),
	CategoryCode = l.SubType,
	ScheduleFreqOnly = CAST(1 as bit)
FROM
	(
		SELECT
			UniqueCode = ISNULL(CAST(StateCode AS VARCHAR(20)), SubType + '|' + Code), -- address this
			*
		FROM AURORAX.Lookups
		WHERE Type = 'Service'
	) l LEFT JOIN
	AURORAX.MAP_IepServiceCategoryID mc on l.SubType = mc.SubType LEFT JOIN
	AURORAX.Map_ServiceDefID md on l.UniqueCode = md.ServiceDefCode LEFT JOIN
	dbo.ServiceDef d on md.DestID = d.ID
GO
---
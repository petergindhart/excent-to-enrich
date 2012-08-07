-- #############################################################################
-- Service Provider Title
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_ServiceProviderTitleID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_ServiceProviderTitleID
(
	ServiceProviderTitleCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_ServiceProviderTitleID ADD CONSTRAINT
PK_MAP_ServiceProviderTitleID PRIMARY KEY CLUSTERED
(
	ServiceProviderTitleCode
)
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_ServiceProviderTitle') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_ServiceProviderTitle
GO  

CREATE VIEW LEGACYSPED.Transform_ServiceProviderTitle  
AS
 SELECT distinct
	ServiceProviderCode = isnull(k.LegacySpedCode, k.EnrichLabel),
	DestID = coalesce(i.ID, n.ID, t.ID, m.DestID, k.EnrichID),
	Name = coalesce(i.Name, n.Name, t.Name, k.EnrichLabel),
	StateCode = coalesce(i.StateCode, n.StateCode, t.StateCode),
	DeletedDate = case when k.EnrichID is not null then NULL when coalesce(i.ID, n.ID, t.ID) is null then NULL else coalesce(i.DeletedDate, n.DeletedDate, t.DeletedDate) end
 FROM  
	LEGACYSPED.SelectLists k LEFT JOIN
	dbo.ServiceProviderTitle i on k.EnrichID = i.ID left join
	dbo.ServiceProviderTitle n on k.EnrichLabel = n.Name left join 
	LEGACYSPED.MAP_ServiceProviderTitleID m on k.LegacySpedCode = m.ServiceProviderTitleCode LEFT JOIN
	dbo.ServiceProviderTitle t on m.ServiceProviderTitleCode = t.Name
 WHERE
	k.Type = 'ServProv'
GO
--

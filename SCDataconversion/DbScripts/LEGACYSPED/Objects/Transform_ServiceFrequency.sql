/*
   LEGACYSPED.MAP_ServiceFrequencyID is created in the Localization file.
	Service Frequency needs to be set up manually per district because:
	1. ServiceFrequency is populated with seed data when Enrich is installed
	2. The values from legacy systems are not consistent.  They may be hand-entered in legacy systems.
	
*/
-- ############################################################################# 
--		Service Frequency
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_ServiceFrequencyID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_ServiceFrequencyID
(
	ServiceFrequencyCode	varchar(150) NOT NULL,
	ServiceFrequencyName	varchar(50) not null,
	DestID uniqueidentifier NOT NULL
)
ALTER TABLE LEGACYSPED.MAP_ServiceFrequencyID ADD CONSTRAINT
PK_MAP_ServiceFrequencyID PRIMARY KEY CLUSTERED
(
	ServiceFrequencyName
)
CREATE INDEX IX_Map_ServiceFrequencyID_ServiceFrequencyName on LEGACYSPED.Map_ServiceFrequencyID (ServiceFrequencyName)
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_ServiceFrequency') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_ServiceFrequency 
GO

CREATE VIEW LEGACYSPED.Transform_ServiceFrequency
AS 
 SELECT
  ServiceFrequencyCode = k.LegacySpedCode,
  ServiceFrequencyName = coalesce(i.Name, n.Name, t.Name, k.EnrichLabel),
  DestID = coalesce(i.ID, n.ID, t.ID, m.DestID),
  Name = coalesce(i.Name, n.Name, t.Name, k.EnrichLabel), 
  Sequence = coalesce(i.Sequence, n.Sequence, t.sequence, 99),
  WeekFactor = coalesce(i.WeekFactor, n.WeekFactor, t.weekfactor, 0), -- Pete will advise
  StateCode = coalesce(i.StateCode, n.StateCode, t.StateCode),
  DeletedDate = case when k.EnrichID is not null then NULL when coalesce(i.ID, n.ID, t.ID) is null then getdate() else coalesce(i.DeletedDate, n.DeletedDate, t.DeletedDate) end
 FROM
  LEGACYSPED.SelectLists k LEFT JOIN 
  dbo.ServiceFrequency i on k.EnrichID = i.ID left join
  dbo.ServiceFrequency n on k.EnrichLabel = n.Name left join
  LEGACYSPED.MAP_ServiceFrequencyID m on k.LegacySpedCode = m.ServiceFrequencyCode LEFT JOIN
  dbo.ServiceFrequency t on m.DestID = t.ID 
 WHERE
  k.Type = 'ServFreq'
GO
-- last line

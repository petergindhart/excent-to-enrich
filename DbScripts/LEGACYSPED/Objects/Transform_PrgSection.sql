--#include Transform_PrgIep.sql
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_Section') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_Section
GO
-- ############################################################################# 
-- Section
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgSectionID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgSectionID
(
	DefID uniqueidentifier NOT NULL,
	VersionID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgSectionID ADD CONSTRAINT
PK_MAP_PrgSectionID PRIMARY KEY CLUSTERED
(
	DefID, VersionID
)
END
GO

-- ############################################################################# 
-- Section
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgSectionID_NonVersioned') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgSectionID_NonVersioned
(
	DefID uniqueidentifier NOT NULL,
	ItemID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgSectionID_NonVersioned ADD CONSTRAINT
PK_MAP_PrgSectionID_NonVersioned PRIMARY KEY CLUSTERED
(
	DefID, ItemID
)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgSection') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgSection
GO

CREATE VIEW LEGACYSPED.Transform_PrgSection
AS
	SELECT
		DestID = case when t.CanVersion = 1 then s.DestID else nvm.DestID end, -- when versioned, use the version map, when non-versioned use that map
		ItemID = i.DestID,
		DefID = d.ID,
		VersionID = CASE WHEN t.CanVersion = 1 THEN i.VersionDestID ELSE CAST(NULL as uniqueidentifier) END,
		FormInstanceID = cast(NULL as uniqueidentifier)
	FROM
		LEGACYSPED.Transform_PrgIep i CROSS JOIN
		PrgSectionDef d JOIN 
		PrgSectionType t on d.TypeID = t.ID JOIN
		LEGACYSPED.ImportPrgSections p on d.ID = p.SectionDefID and p.Enabled = 1 LEFT JOIN 
		LEGACYSPED.MAP_PrgSectionID s ON 
			s.VersionID = i.VersionDestID AND
			s.DefID = d.ID LEFT JOIN
		LEGACYSPED.MAP_PrgSectionID_NonVersioned nvm ON
			nvm.ItemID = i.DestID AND
			nvm.DefID = d.ID 
GO
--

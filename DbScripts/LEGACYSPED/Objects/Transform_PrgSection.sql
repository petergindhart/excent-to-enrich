
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_Section') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_Section
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

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_MAP_PrgSectionID_NonVersioned_DestID')
create nonclustered index  IX_LEGACYSPED_MAP_PrgSectionID_NonVersioned_DestID on LEGACYSPED.MAP_PrgSectionID_NonVersioned (DestID)

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_IEP_LOCAL_StudentRefID')
CREATE NONCLUSTERED INDEX  IX_LEGACYSPED_IEP_LOCAL_StudentRefID ON [LEGACYSPED].[IEP_LOCAL] ([StudentRefID])

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgSection') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgSection
GO

CREATE VIEW LEGACYSPED.Transform_PrgSection
AS
	SELECT
		DestID = case when d.IsVersioned = 1 then s.DestID else nvm.DestID end, -- when versioned, use the version map, when non-versioned use that map
		ItemID = i.DestID,
		DefID = d.ID,
		VersionID = CASE WHEN d.IsVersioned = 1 THEN i.VersionDestID ELSE CAST(NULL as uniqueidentifier) END,
		FormInstanceID = case when d.ID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F' then tsvc.FormInstanceID else NULL end,
		HeaderFormInstanceID =  CAST (NULL as UNIQUEIDENTIFIER),
		OnLatestVersion = cast(1 as bit),
		i.DoNotTouch
	FROM
		LEGACYSPED.Transform_PrgIep i CROSS JOIN
		PrgSectionDef d JOIN
		PrgSectionType t on d.TypeID = t.ID JOIN
		LEGACYSPED.ImportPrgSections p on d.ID = p.SectionDefID and p.Enabled = 1 LEFT JOIN
		LEGACYSPED.MAP_PrgSectionID s ON
			isnull(s.VersionID,'00000000-0000-0000-0000-000000000000') = isnull(i.VersionDestID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF') AND
			s.DefID = d.ID LEFT JOIN
		LEGACYSPED.MAP_PrgSectionID_NonVersioned nvm ON
			nvm.ItemID = i.DestID AND
			nvm.DefID = d.ID left join 
		LEGACYSPED.Transform_IepServices tsvc on i.DestID = tsvc.ItemID
GO
--84588, 28 seconds
-- after indexes :  4 seconds

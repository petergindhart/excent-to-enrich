
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_Section') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_Section
GO


-- ############################################################################# 
-- Section
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_PrgSectionID_NonVersioned') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_PrgSectionID_NonVersioned
(
	DefID uniqueidentifier NOT NULL,
	ItemID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE x_LEGACYGIFT.MAP_PrgSectionID_NonVersioned ADD CONSTRAINT
PK_MAP_PrgSectionID_NonVersioned PRIMARY KEY CLUSTERED
(
	DefID, ItemID
)
END

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_MAP_PrgSectionID_NonVersioned_DestID')
create nonclustered index  IX_x_LEGACYGIFT_MAP_PrgSectionID_NonVersioned_DestID on x_LEGACYGIFT.MAP_PrgSectionID_NonVersioned (DestID)
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_PrgSection') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_PrgSection
GO

CREATE VIEW x_LEGACYGIFT.Transform_PrgSection
AS
	SELECT
		sDestID = s.DestID,
		nvmDestID = nvm.DestID,
		DestID = case when d.IsVersioned = 1 then s.DestID else nvm.DestID end, 
		ItemID = i.DestID,
		DefID = d.ID,
		d.IsVersioned,
		VersionID = CASE WHEN d.IsVersioned = 1 THEN i.VersionDestID ELSE CAST(NULL as uniqueidentifier) END,
		FormInstanceID = mfi.FormInstanceID, -- does this map distinguish footer and header forms?
		HeaderFormInstanceID =  cast(NULL as uniqueidentifier), 
		OnLatestVersion = cast(1 as bit)
	FROM
		x_LEGACYGIFT.Transform_PrgItem i CROSS JOIN
		PrgSectionDef d JOIN
		PrgSectionType t on d.TypeID = t.ID JOIN
		x_LEGACYGIFT.ImportPrgSections p on d.ID = p.SectionDefID and p.Enabled = 1 LEFT JOIN
		x_LEGACYGIFT.MAP_FormInstanceID mfi on i.EPRefID = mfi.EPRefID and d.id = mfi.SectionDefID left JOIN
		x_LEGACYGIFT.MAP_PrgSectionID s ON
			isnull(s.VersionID,'00000000-0000-0000-0000-000000000000') = isnull(i.VersionDestID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF') AND
			s.DefID = d.ID LEFT JOIN
		x_LEGACYGIFT.MAP_PrgSectionID_NonVersioned nvm ON
			nvm.ItemID = i.DestID AND
			nvm.DefID = d.ID left join 
		x_LEGACYGIFT.Transform_IepServices tsvc on i.DestID = tsvc.ItemID
GO

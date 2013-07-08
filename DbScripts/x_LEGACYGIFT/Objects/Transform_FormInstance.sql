-- 
-- #############################################################################
-- FormInstance
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_FormInstanceID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_FormInstanceID
	(
	EPRefID nvarchar(150) NOT NULL,
	SectionDefID	uniqueidentifier	not null,
	FormInstanceID uniqueidentifier NOT NULL
	)

ALTER TABLE x_LEGACYGIFT.MAP_FormInstanceID ADD CONSTRAINT
	PK_MAP_FormInstanceID PRIMARY KEY CLUSTERED
	(
	EPRefID, SectionDefID
	)
END

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_MAP_FormInstanceID_FormInstanceID')
create index IX_x_LEGACYGIFT_MAP_FormInstanceID_FormInstanceID on x_LEGACYGIFT.MAP_FormInstanceID (FormInstanceID)
GO

-- #############################################################################
-- FormInstanceInterval
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_FormInstanceIntervalID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_FormInstanceIntervalID -- drop table x_LEGACYGIFT.MAP_FormInstanceIntervalID
	(
	EPRefID nvarchar(150) NOT NULL,
	SectionDefID	uniqueidentifier not null,
	FormInstanceIntervalID uniqueidentifier NOT NULL
	)

ALTER TABLE x_LEGACYGIFT.MAP_FormInstanceIntervalID ADD CONSTRAINT
	PK_MAP_FormInstanceIntervalID PRIMARY KEY CLUSTERED
	(
	EPRefID, SectionDefID
	)
END
if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_MAP_FormInstanceIntervalID_FormInstanceIntervalID')
create index IX_x_LEGACYGIFT_MAP_FormInstanceIntervalID_FormInstanceIntervalID on x_LEGACYGIFT.MAP_FormInstanceIntervalID (FormInstanceIntervalID)
GO



-- #############################################################################
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_PrgSectionFormInstance') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_PrgSectionFormInstance
GO

CREATE VIEW x_LEGACYGIFT.Transform_PrgSectionFormInstance
AS
with CTE_Formlets
as (
	select 
		iep.EPRefID,
		ItemID = iep.DestID,
		-- sd.IsVersioned, -- is this needed?  
		sec.FormPlace,
		sec.SectionDefID,
	-- FormInstance
		mfi.FormInstanceID, -- DestID / FormInstanceID
		sec.TemplateID,
	-- PrgItemForm 
		CreatedDate = GETDATE(),
		CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
		AssociationTypeID = 'DE0AFD97-84C8-488E-94DC-E17CAAA62082', -- Section
	-- FormInstanceInterval 
		mfii.FormInstanceIntervalID,
		-- InstanceID = FormInstanceID (above)
		IntervalID = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D', -- Value (should this be hard-coded?)
		CompletedDate = GETDATE(),
		CompletedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB' -- BuiltIn: Support
	FROM 
		x_LEGACYGIFT.Transform_PrgItem iep JOIN 
		dbo.PrgSectionDef sd on iep.DefID = sd.ItemDefID and not (sd.FormTemplateID is null and sd.HeaderFormTemplateID is null) join (
			select FormPlace = 'Footer', SectionDefID, TemplateID = FooterFormTemplateID from x_LEGACYGIFT.ImportPrgSections where FooterFormTemplateID is not null 
			union all 
			select FormPlace = 'Header', SectionDefID, TemplateID = HeaderFormTemplateID from x_LEGACYGIFT.ImportPrgSections where HeaderFormTemplateID is not null) sec on sd.ID = sec.SectionDefID left join
		x_LEGACYGIFT.MAP_FormInstanceID mfi on iep.EPRefID = mfi.EPRefID and sd.id = mfi.SectionDefID left join 
		x_LEGACYGIFT.MAP_FormInstanceIntervalID mfii on iep.EPRefID = mfii.EPRefID and sd.ID = mfii.SectionDefID
	) 
select 
	Template = fft.Name, 
	c.* 
from CTE_Formlets c left join dbo.FormTemplate fft on c.TemplateID = fft.Id 
go






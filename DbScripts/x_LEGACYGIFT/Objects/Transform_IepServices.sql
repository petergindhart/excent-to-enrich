-- getting error when upgrading collier db, moving this map table here
-- ############################################################################# 
-- Section
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_PrgSectionID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_PrgSectionID
(
	DefID uniqueidentifier NOT NULL,
	VersionID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE x_LEGACYGIFT.MAP_PrgSectionID ADD CONSTRAINT
PK_MAP_PrgSectionID PRIMARY KEY CLUSTERED
(
	DefID, VersionID
)
END

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_MAP_PrgSectionID_DestID')
CREATE NONCLUSTERED INDEX IX_x_LEGACYGIFT_MAP_PrgSectionID_DestID ON [x_LEGACYGIFT].[MAP_PrgSectionID] ([DestID])

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_MAP_PrgSectionID_DefID_DestID')
CREATE NONCLUSTERED INDEX  IX_x_LEGACYGIFT_MAP_PrgSectionID_DefID_DestID ON [x_LEGACYGIFT].[MAP_PrgSectionID] ([DefID],[DestID])

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_PrgSection_DefID')
CREATE NONCLUSTERED INDEX  IX_x_LEGACYGIFT_PrgSection_DefID ON [dbo].[PrgSection] ([DefID]) INCLUDE ([VersionID])

GO


-- #############################################################################
-- FormInstance_Services
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_FormInstance_Services') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_FormInstance_Services
	(
	EPRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)

ALTER TABLE x_LEGACYGIFT.MAP_FormInstance_Services ADD CONSTRAINT
	PK_MAP_FormInstance_ServicesID PRIMARY KEY CLUSTERED
	(
	EPRefID
	)
END
if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_MAP_FormInstance_Services_DestID')
create index IX_x_LEGACYGIFT_MAP_FormInstance_Services_DestID on x_LEGACYGIFT.MAP_FormInstance_Services (DestID)
GO

-- #############################################################################
-- FormInstanceInterval_Services
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_FormInstanceInterval_Services') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_FormInstanceInterval_Services
	(
	EPRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)

ALTER TABLE x_LEGACYGIFT.MAP_FormInstanceInterval_Services ADD CONSTRAINT
	PK_MAP_FormInstanceInterval_ServicesID PRIMARY KEY CLUSTERED
	(
	EPRefID
	)
END
if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_MAP_FormInstanceInterval_Services_DestID')
create index IX_x_LEGACYGIFT_MAP_FormInstanceInterval_Services_DestID on x_LEGACYGIFT.MAP_FormInstanceInterval_Services (DestID)
GO


-- #############################################################################
-- FormInputValue_Services
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_FormInputValue_Services') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_FormInputValue_Services
	(
	EPRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)

ALTER TABLE x_LEGACYGIFT.MAP_FormInputValue_Services ADD CONSTRAINT
	PK_MAP_FormInputValue_ServicesID PRIMARY KEY CLUSTERED
	(
	EPRefID
	)
END
GO




-- #############################################################################
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_IepServices') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_IepServices
GO

CREATE VIEW x_LEGACYGIFT.Transform_IepServices
AS
	SELECT
		IEP.EPRefID,
		m.DestID,
		DeliveryStatement = iep.ServiceDeliveryStatement, -- since Transform_IepServices is use in a lot of operations, leave the text field out of the transform for speed
		ItemID = iep.ItemDestID,
	-- FormInstance
		FormInstanceID = mfi.DestID, -- instance of form for this prgitem based on the template for IEP Section 13 Services (next column in this view)
		TemplateID = '427C86E1-AB95-482A-B8A5-9801F309481A', -- FormTemplate for IEP Section 13 Services
	-- PrgItemForm 
		CreatedDate = GETDATE(),
		CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
		AssociationTypeID = 'DE0AFD97-84C8-488E-94DC-E17CAAA62082', -- PrgItemFormTyppe = Section
	-- FormInstanceInterval 
		FormInstanceIntervalID = mfii.DestID,
		-- InstanceID = FormInstanceID (above)
		IntervalID = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D', -- Value
		CompletedDate = GETDATE(),
		CompletedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
	-- FormInputValue -- select * from FormInputValue
		FormInputValue = mfiv.DestID,
		-- IntervalID = FormInstanceIntervalID (above)
		InputFieldId = '49DCF86E-FE6C-47DC-A8FD-D561FA564148', -- FormTemplateInputItem record for Service Delivery Statement  ----------------------- UNIQUE? NO!!!!!!!!!!!!!!
		Sequence = 0, -- could default in VC3ETL.LoadColumn, but.....
	-- FormInputTextValue
		--FormInputTextValueID = FormInputValue, -- (above)
		Value = iep.ServiceDeliveryStatement -- selecting this twice on this view.  Target table column name is Value.  Source table column name is ServiceDeliveryStatement (VC3ETL.LoadColumn)
	FROM
		x_LEGACYGIFT.Transform_PrgItem iep JOIN 
		x_LEGACYGIFT.MAP_PrgSectionID m on 
			m.DefID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F' and 
			m.VersionID = iep.VersionDestID left join 
		x_LEGACYGIFT.MAP_FormInstance_Services mfi on iep.EPRefID = mfi.EPRefID left join 
		x_LEGACYGIFT.MAP_FormInstanceInterval_Services mfii on iep.EPRefID = mfii.EPRefID left join 
		x_LEGACYGIFT.MAP_FormInputValue_Services mfiv on iep.EPRefID = mfiv.EPRefID 
GO
--







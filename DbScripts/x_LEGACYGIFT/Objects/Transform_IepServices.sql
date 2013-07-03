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


if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_MAP_PrgSectionID_DestID')
CREATE NONCLUSTERED INDEX IX_x_LEGACYGIFT_MAP_PrgSectionID_DestID ON [x_LEGACYGIFT].[MAP_PrgSectionID] ([DestID])

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_MAP_PrgSectionID_DefID_DestID')
CREATE NONCLUSTERED INDEX  IX_x_LEGACYGIFT_MAP_PrgSectionID_DefID_DestID ON [x_LEGACYGIFT].[MAP_PrgSectionID] ([DefID],[DestID])

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_PrgSection_DefID')
CREATE NONCLUSTERED INDEX  IX_x_LEGACYGIFT_PrgSection_DefID ON [dbo].[PrgSection] ([DefID]) INCLUDE ([VersionID])

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
		DeliveryStatement = cast(iep.ServiceDeliveryStatement as varchar(max)), -- since Transform_IepServices is use in a lot of operations, leave the text field out of the transform for speed
		ItemID = iep.DestID,
	-- FormInputValue 
--		FormInputValue = mfiv.DestID,
		-- IntervalID = FormInstanceIntervalID (above)
--		InputFieldId = '49DCF86E-FE6C-47DC-A8FD-D561FA564148', -- FormTemplateInputItem record for Service Delivery Statement  ----------------------- UNIQUE? NO!!!!!!!!!!!!!!
--		Sequence = 0, -- could default in VC3ETL.LoadColumn, but.....
	-- FormInputTextValue
		--FormInputTextValueID = FormInputValue, -- (above)
		Value = iep.ServiceDeliveryStatement -- selecting this twice on this view.  Target table column name is Value.  Source table column name is ServiceDeliveryStatement (VC3ETL.LoadColumn)
	FROM 
		x_LEGACYGIFT.Transform_PrgItem iep JOIN 
		x_LEGACYGIFT.MAP_PrgSectionID_NonVersioned m on 
			m.DefID = '8EFD24A0-46F0-4734-999A-0B4CCE2C1519' and -- gifted services
			m.ItemID = iep.DestID -- left join 
--		x_LEGACYGIFT.MAP_FormInstance_Services mfi on iep.EPRefID = mfi.EPRefID left join 
--		x_LEGACYGIFT.MAP_FormInstanceInterval_Services mfii on iep.EPRefID = mfii.EPRefID left join 
--		x_LEGACYGIFT.MAP_FormInputValue_Services mfiv on iep.EPRefID = mfiv.EPRefID 
GO
--






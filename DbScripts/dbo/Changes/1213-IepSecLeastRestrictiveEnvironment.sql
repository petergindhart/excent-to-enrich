
CREATE TABLE dbo.IepPlacementType
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPlacementType ADD CONSTRAINT
	PK_IepPlacementType PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepPlacementOption
	(
	ID uniqueidentifier NOT NULL,
	TypeID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	Text varchar(100) NOT NULL,
	StateCode varchar(10) NULL,
	MinPercentGenEd int NULL,
	MaxPercentGenEd int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPlacementOption ADD CONSTRAINT
	PK_IepPlacementOption PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPlacementOption ADD CONSTRAINT
	FK_IepPlacementOption#PlacementType#Options FOREIGN KEY
	(
	TypeID
	) REFERENCES dbo.IepPlacementType
	(
	ID
	)  
GO
ALTER TABLE dbo.IepSchool ADD
	MinutesInstruction int NULL
GO
ALTER TABLE dbo.IepDistrict ADD
	MinutesInstruction int NULL
GO
CREATE TABLE dbo.IepLeastRestrictiveEnvironment
	(
	ID uniqueidentifier NOT NULL,
	MinutesInstruction int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepLeastRestrictiveEnvironment ADD CONSTRAINT
	PK_IepLeastRestrictiveEnvironment PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepLeastRestrictiveEnvironment ADD CONSTRAINT
	FK_IepLeastRestrictiveEnvironment_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE  CASCADE 
GO
CREATE TABLE dbo.IepPlacement
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	TypeID uniqueidentifier NOT NULL,
	OptionID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPlacement ADD CONSTRAINT
	PK_IepPlacement PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPlacement ADD CONSTRAINT
	FK_IepPlacement#Instance#Placements FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepLeastRestrictiveEnvironment
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepPlacement ADD CONSTRAINT
	FK_IepPlacement#PlacementType# FOREIGN KEY
	(
	TypeID
	) REFERENCES dbo.IepPlacementType
	(
	ID
	)  
GO
ALTER TABLE dbo.IepPlacement ADD CONSTRAINT
	FK_IepPlacement#PlacementOption# FOREIGN KEY
	(
	OptionID
	) REFERENCES dbo.IepPlacementOption
	(
	ID
	) ON DELETE  CASCADE 
GO

-- section type/def
INSERT PrgSectionType VALUES ( 'D1C4004B-EF82-4E8F-BA12-D8F086EB9BBE', 'IEP LRE', 'ieplre', 'Least Restrictive Environment', NULL, NULL, NULL, '~/SpecEd/SectionLre.ascx' )
INSERT PrgSectionDef VALUES ( 'E34A618E-DC70-465D-84FE-3663D524B0F7', 'D1C4004B-EF82-4E8F-BA12-D8F086EB9BBE', '251DA756-A67A-453C-A676-3B88C1B9340C', 9, 1, NULL, NULL, NULL, NULL, NULL, NULL )

-- canned placement options
INSERT IepPlacementType VALUES ( 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 'Ages 3-5' )
INSERT IepPlacementOption VALUES ( 'DC20B53C-0559-44F6-A463-3A92D9D4F69A', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 0, 'In Regular Early Childhood Program at Least 80% of the Time', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( 'E5741B2C-CE35-4F3B-8AD5-58774E31C531', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 1, 'In Regular Early Childhood Education Program 40-79% of the Time', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( 'A3FA6E17-E828-4A7C-A002-0A49B834BD1E', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 2, 'In Regular Early Childhood Program Less Than 40% of the Time', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( '0B2E63D7-6493-44A7-95B1-8DF327D77C38', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 3, 'Separate Class', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( '2E45FDA2-0767-43D0-892D-D1BB40AFCEC1', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 4, 'Separate School', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( '0DA48AA5-183C-4434-91C1-AC3C9941BE15', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 5, 'Residential Facility', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( '0980382F-594C-453F-A0C9-77D54A0443B1', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 6, 'Home', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( '1945D36A-8D62-4FDB-9F22-5836F553A958', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 7, 'Service Provider Location', NULL, NULL, NULL )

INSERT IepPlacementType VALUES ( 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 'Ages 6-21' )
INSERT IepPlacementOption VALUES ( 'FEFF9910-F320-4097-AFC2-A3D9713470BD', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 0, 'Inside Regular Class 80% or more of the day', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( '521ACE5E-D04B-4E30-80E3-517516383536', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 1, 'Inside Regular Class 79-40% of the day', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( '9CD2726E-6461-4F6C-B65F-B4232FB4D36E', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 2, 'Inside Regular Class less than 40% of the day', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( '77E0EE80-143B-41E5-84B9-5076605CCC9A', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 3, 'Separate School', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( 'E4EE85F2-8307-4C8D-BA77-4EB5D12D8470', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 4, 'Residential Facility', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( '91EF0ECE-A770-4D05-8868-F19180A000DB', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 5, 'Homebound/Hospital - Medical Homebound', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( '5EE0CA16-1F59-4BC8-9AFA-BAED97D29B77', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 6, 'Homebound/Hospital - Hospital', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( 'D634CD6A-C22F-4B34-89A8-340A13891E24', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 7, 'Homebound/Hospital - Home-based', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( '84DAF081-F700-4F57-99DA-A2A983FDE919', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 8, 'Correctional Facilities', NULL, NULL, NULL )
INSERT IepPlacementOption VALUES ( '304AEBA5-3162-4B40-89D3-F094602CFF2D', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 9, 'Parentally Placed In Private Schools', NULL, NULL, NULL )

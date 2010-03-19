
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

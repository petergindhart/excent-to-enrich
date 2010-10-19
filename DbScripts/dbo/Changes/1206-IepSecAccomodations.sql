CREATE TABLE dbo.IepAccomodations
	(
	ID uniqueidentifier NOT NULL,
	Explanation text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepAccomodations ADD CONSTRAINT
	PK_IepAccomodations PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepAccomodations ADD CONSTRAINT
	FK_IepAccomodations_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE CASCADE
GO
CREATE TABLE dbo.IepAccomodationCategory
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL,
	AllowCustom bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepAccomodationCategory ADD CONSTRAINT
	PK_IepAccomodationCategory PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepAccomodationDef
	(
	ID uniqueidentifier NOT NULL,
	CategoryID uniqueidentifier NOT NULL,
	Text varchar(100) NOT NULL,
	IsModification bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepAccomodationDef ADD CONSTRAINT
	PK_IepAccomodationDef PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepAccomodationDef ADD CONSTRAINT
	FK_IepAccomodationDef#Category#Definitions FOREIGN KEY
	(
	CategoryID
	) REFERENCES dbo.IepAccomodationCategory
	(
	ID
	) ON DELETE CASCADE
GO
CREATE TABLE dbo.IepAccomodation
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	CategoryID uniqueidentifier NOT NULL,
	DefID uniqueidentifier NULL,
	CustomText varchar(100) NULL,
	IsModification bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepAccomodation ADD CONSTRAINT
	PK_IepAccomodation PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepAccomodation ADD CONSTRAINT
	FK_IepAccomodation#Instance#Items FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepAccomodations
	(
	ID
	)
GO
ALTER TABLE dbo.IepAccomodation ADD CONSTRAINT
	FK_IepAccomodation#Category# FOREIGN KEY
	(
	CategoryID
	) REFERENCES dbo.IepAccomodationCategory
	(
	ID
	)
GO
ALTER TABLE dbo.IepAccomodation ADD CONSTRAINT
	FK_IepAccomodation#Def# FOREIGN KEY
	(
	DefID
	) REFERENCES dbo.IepAccomodationDef
	(
	ID
	)
GO


insert PrgSectionType values ( '265AC4EC-2325-4CA8-A428-5361DC7F83F0', 'IEP Accomodations', 'iepaccoms', 'Accomodations & Modifications', null, null, null, '~/SpecEd/SectionAccomodations.ascx' )

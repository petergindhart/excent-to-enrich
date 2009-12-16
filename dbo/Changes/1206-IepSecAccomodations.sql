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
insert PrgSectionDef values ( '62BD2FF9-FC42-4295-8C7C-23ADB9417841', '265AC4EC-2325-4CA8-A428-5361DC7F83F0', '251DA756-A67A-453C-A676-3B88C1B9340C', 4, 1, null, null, null, null, null )


-- stub accomodations/modifications for dev testing
insert IepAccomodationCategory values( 'BBC68EC9-80EE-480E-8B5C-AD3F32EAB2C6', 'Curricular', 0 )
insert IepAccomodationDef values( '83F16441-6441-40E8-AC26-34162FB11073', 'BBC68EC9-80EE-480E-8B5C-AD3F32EAB2C6', 'curric accom 01', 0 )
insert IepAccomodationDef values( 'B03869B0-CD15-4177-AF08-D42272AFFF10', 'BBC68EC9-80EE-480E-8B5C-AD3F32EAB2C6', 'curric accom 02', 0 )
insert IepAccomodationDef values( 'D2BCB404-4152-430E-8C69-13E55F4491D7', 'BBC68EC9-80EE-480E-8B5C-AD3F32EAB2C6', 'curric accom 03', 0 )
insert IepAccomodationDef values( '64FEAC88-A0A7-43F0-A634-19CC27F6F1E5', 'BBC68EC9-80EE-480E-8B5C-AD3F32EAB2C6', 'curric modif 01', 1 )
insert IepAccomodationDef values( '8AE93F1D-8115-424C-9E13-0A4F0F0FD97F', 'BBC68EC9-80EE-480E-8B5C-AD3F32EAB2C6', 'curric modif 02', 1 )
insert IepAccomodationCategory values( 'FFC6969B-CFD1-4297-8216-D82A7085AEDE', 'Non-Curricular', 1 )
insert IepAccomodationDef values( 'A183B6BB-4AF0-4BB4-8215-0E42382B6167', 'FFC6969B-CFD1-4297-8216-D82A7085AEDE', 'noncur accom 01', 0 )
insert IepAccomodationDef values( '4F9A341C-4CD5-443D-B280-06C13D7D1CF1', 'FFC6969B-CFD1-4297-8216-D82A7085AEDE', 'noncur accom 02', 0 )
insert IepAccomodationDef values( '419B0055-4C29-4FD1-AE2D-CBA0A2465BE8', 'FFC6969B-CFD1-4297-8216-D82A7085AEDE', 'noncur modif 01', 1 )
insert IepAccomodationDef values( '2B416961-B827-4E20-B284-1076D5C4A537', 'FFC6969B-CFD1-4297-8216-D82A7085AEDE', 'noncur modif 02', 1 )
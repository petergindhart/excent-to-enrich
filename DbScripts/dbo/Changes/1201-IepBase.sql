
--##############################################################################
-- PrgItem Sections/Versions
CREATE TABLE dbo.PrgSectionType
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL,
	Code varchar(10) NOT NULL,
	Title varchar(50) NOT NULL,
	VideoUrl varchar(200) NULL,
	HelpTextLegal text NULL,
	HelpTextInfo text NULL,
	UserControlPath varchar(200) NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.PrgSectionType ADD CONSTRAINT
	PK_PrgSectionType PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]

GO

CREATE TABLE dbo.PrgSectionDef
	(
	ID uniqueidentifier NOT NULL,
	TypeID uniqueidentifier NOT NULL,
	ItemDefID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	IsVersioned bit NOT NULL,
	Code varchar(10) NULL,
	Title varchar(50) NULL,
	VideoUrl varchar(200) NULL,
	HelpTextLegal text NULL,
	HelpTextInfo text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.PrgSectionDef ADD CONSTRAINT
	PK_PrgSectionDef PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]

GO
ALTER TABLE dbo.PrgSectionDef ADD CONSTRAINT
	FK_PrgSectionDef#SectionType#SectionDefs FOREIGN KEY
	(
	TypeID
	) REFERENCES dbo.PrgSectionType
	(
	ID
	) ON DELETE CASCADE
	
GO
ALTER TABLE dbo.PrgSectionDef ADD CONSTRAINT
	FK_PrgSectionDef#ItemDef#SectionDefs FOREIGN KEY
	(
	ItemDefID
	) REFERENCES dbo.PrgItemDef
	(
	ID
	)
GO

CREATE TABLE dbo.PrgVersion
	(
	ID uniqueidentifier NOT NULL,
	ItemID uniqueidentifier NOT NULL,
	DateCreated datetime NOT NULL,
	DateFinalized datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgVersion ADD CONSTRAINT
	PK_PrgVersion PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]

GO
ALTER TABLE dbo.PrgVersion ADD CONSTRAINT
	FK_PrgVersion#Item#Versions FOREIGN KEY
	(
	ItemID
	) REFERENCES dbo.PrgItem
	(
	ID
	) ON DELETE CASCADE
	
GO

CREATE TABLE dbo.PrgSection
	(
	ID uniqueidentifier NOT NULL,
	DefID uniqueidentifier NOT NULL,
	ItemID uniqueidentifier NOT NULL,
	VersionID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgSection ADD CONSTRAINT
	PK_PrgSection PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]

GO
ALTER TABLE dbo.PrgSection ADD CONSTRAINT
	FK_PrgSection#SectionDef# FOREIGN KEY
	(
	DefID
	) REFERENCES dbo.PrgSectionDef
	(
	ID
	) ON DELETE CASCADE
	
GO
ALTER TABLE dbo.PrgSection ADD CONSTRAINT
	FK_PrgSection#Item#Sections FOREIGN KEY
	(
	ItemID
	) REFERENCES dbo.PrgItem
	(
	ID
	) ON DELETE CASCADE
	
GO
ALTER TABLE dbo.PrgSection ADD CONSTRAINT
	FK_PrgSection#Version#Sections FOREIGN KEY
	(
	VersionID
	) REFERENCES dbo.PrgVersion
	(
	ID
	)
GO

--##############################################################################
-- PrgIep
CREATE TABLE dbo.PrgIep
	(
	ID uniqueidentifier NOT NULL,
	IsTransitional bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgIep ADD CONSTRAINT
	PK_PrgIep PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]

GO
ALTER TABLE dbo.PrgIep ADD CONSTRAINT
	FK_PrgIep_PrgItem FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgItem
	(
	ID
	)
GO

-- insert PrgItemType for IEP
insert PrgItemType values ( 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870', 'IEP', 'Individualized Education Program' )

insert EnumType values( 'C8F52BFC-1AE8-4CC5-A9CA-EA746EDA336E', 'IEP.YesNo', 0, 0, NULL )
insert EnumValue values( 'B76DDCD6-B261-4D46-A98E-857B0A814A0C', 'C8F52BFC-1AE8-4CC5-A9CA-EA746EDA336E', 'Yes', 'Y', 1, 0 )
insert EnumValue values( 'F7E20A86-2709-4170-9810-15B601C61B79', 'C8F52BFC-1AE8-4CC5-A9CA-EA746EDA336E', 'No', 'N', 1, 1 )





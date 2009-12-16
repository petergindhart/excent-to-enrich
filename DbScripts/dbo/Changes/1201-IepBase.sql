
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

-- insert Program for Special Education
insert into Program values ( 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 'Special Education', 'Integration of evaluation, eligibility, placement, and monitoring aspects of a child receiving assistance under IDEA to ensure compliance with federal regulations.', NULL, NULL, 'SpEd', NULL )
-- insert PrgItemType for IEP
insert PrgItemType values ( 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870', 'IEP', 'Individualized Education Program' )

insert EnumType values( 'C8F52BFC-1AE8-4CC5-A9CA-EA746EDA336E', 'IEP.YesNo', 0, 0, NULL )
insert EnumValue values( 'B76DDCD6-B261-4D46-A98E-857B0A814A0C', 'C8F52BFC-1AE8-4CC5-A9CA-EA746EDA336E', 'Yes', 'Y', 1, 0 )
insert EnumValue values( 'F7E20A86-2709-4170-9810-15B601C61B79', 'C8F52BFC-1AE8-4CC5-A9CA-EA746EDA336E', 'No', 'N', 1, 1 )



insert PrgVariant values ('D9D0ABAD-69F6-46DF-83CB-BAFC72AAAB86', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 'Special Education')

insert PrgStatus values ('3AC946C4-57CF-4C96-84A7-3FF5A40F33AA', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 0, 'Placed', 0, 0, NULL, '85AAB540-503F-4613-9F1F-A14C72764285')
insert PrgStatus values ('667E6AEB-4DC8-4B64-99CB-0AAC39764BA8', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 1, 'Transfered Out', 1, 0, NULL, 'FA528C27-E567-4CC9-A328-FF499BB803F6')
insert PrgStatus values ('649D12AD-F9EE-40E2-888A-3D89A767B05A', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 2, 'Consent Revoked', 1, 0, NULL, 'FA528C27-E567-4CC9-A328-FF499BB803F6')

insert PrgItemDef values ('251DA756-A67A-453C-A676-3B88C1B9340C', 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', '3AC946C4-57CF-4C96-84A7-3FF5A40F33AA', 'Individualized Education Plan', NULL, NULL, 0, NULL, 0)





CREATE TABLE dbo.IepSpecialFactorDef
	(
	ID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	Question varchar(250) NOT NULL,
	Description text NULL,
	IsCustom bit NOT NULL,
	IsEnabled bit NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepSpecialFactorDef ADD CONSTRAINT
	PK_IepSpecialFactorDef PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]

GO
CREATE TABLE dbo.IepSpecialFactor
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	DefID uniqueidentifier NOT NULL,
	AnswerID uniqueidentifier NULL,
	Text text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepSpecialFactor ADD CONSTRAINT
	PK_IepSpecialFactor PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]

GO
ALTER TABLE dbo.IepSpecialFactor ADD CONSTRAINT
	FK_IepSpecialFactor#Instance#SpecialFactors FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE CASCADE
GO
ALTER TABLE dbo.IepSpecialFactor ADD CONSTRAINT
	FK_IepSpecialFactor#Def# FOREIGN KEY
	(
	DefID
	) REFERENCES dbo.IepSpecialFactorDef
	(
	ID
	) ON DELETE CASCADE
GO
ALTER TABLE dbo.IepSpecialFactor ADD CONSTRAINT
	FK_IepSpecialFactor#Answer# FOREIGN KEY
	(
	AnswerID
	) REFERENCES dbo.EnumValue
	(
	ID
	)
GO


insert PrgSectionType values ( '5647C4E2-D9C7-4737-B982-E641FB10B79F', 'IEP Special Factors', 'iepspfact', 'Consideration of Special Factors', null, null, null, '~/SpecEd/SectionSpecialFactors.ascx' )

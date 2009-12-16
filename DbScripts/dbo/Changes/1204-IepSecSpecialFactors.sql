

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
insert PrgSectionDef values ( '189AD8F1-47CF-4CA1-9823-6844276C6841', '5647C4E2-D9C7-4737-B982-E641FB10B79F', '251DA756-A67A-453C-A676-3B88C1B9340C', 2, 1, null, null, null, null, null )


insert IepSpecialFactorDef values( '030A34A3-6E16-40C6-AB55-945BF089DDD8', 0, 'Does this student exhibit behavior that requires a Behavior Intervention Plan?', 'If yes, generate Behavior Intervention Plan.', 1, 1 )
insert IepSpecialFactorDef values( '9FAA7E57-0599-4019-9C12-038AA8058488', 1, 'Is the student blind or visually impaired?', 'If yes, generate Learning Media Plan.', 1, 1 )
insert IepSpecialFactorDef values( '002C0B29-A8CE-45C8-A9B4-AB0CFA216AE2', 2, 'Is the student deaf or hard of hearing?', 'If yes, generate Communication Plan.', 1, 1 )
insert IepSpecialFactorDef values( '09BA910D-744D-46C1-91BC-9C9A5C1F07D7', 3, 'Is the student deaf-blind?', 'If yes, generate Learning Media & Communication Plan.', 1, 1 )
insert IepSpecialFactorDef values( '796F15CD-06DA-4D98-8D07-9A6A8C105B17', 4, 'Does the student require a Health Care Plan?', 'If yes, indicate location of Plan.', 1, 1 )
insert IepSpecialFactorDef values( '7544E258-659A-4843-BD6D-48C85203A9A5', 5, 'Does the student have Limited English Proficiency?', 'If yes, specify how this will be addressed:', 1, 1 )
insert IepSpecialFactorDef values( 'A07A4288-53CC-45D3-90B3-7E56122A81F5', 6, 'Does the student need Assistive Technology devices or services?', 'If yes, specify:', 1, 1 )
insert IepSpecialFactorDef values( '8FCB7E57-5235-4D87-973A-786CF501679B', 7, 'Does the student require Special Transportation?', 'If yes, specify:', 1, 1 )
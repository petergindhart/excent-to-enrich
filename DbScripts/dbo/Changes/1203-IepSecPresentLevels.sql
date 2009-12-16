CREATE TABLE dbo.IepPresentLevels
	(
	ID uniqueidentifier NOT NULL,
	StrengthsPreferencesInterest text NULL,
	EducationalPerformance text NULL,
	ImpactOfDisability text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepPresentLevels ADD CONSTRAINT
	PK_IepPresentLevels PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepPresentLevels ADD CONSTRAINT
	FK_IepPresentLevels_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE CASCADE
GO

insert PrgSectionType values ( '2DFA76AD-9139-4129-A1B2-EB19E0190B5A', 'IEP Present Levels', 'ieppreslvl', 'Present Levels of Performance', null, null, null, '~/SpecEd/SectionPresentLevels.ascx' )
insert PrgSectionDef values ( 'B18E5739-9242-498E-84A0-4FA79AC0627B', '2DFA76AD-9139-4129-A1B2-EB19E0190B5A', '251DA756-A67A-453C-A676-3B88C1B9340C', 1, 1, null, null, null, null, null )

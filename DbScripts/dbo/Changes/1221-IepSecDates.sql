-- add IepDates table
CREATE TABLE dbo.IepDates
	(
	ID uniqueidentifier NOT NULL,
	NextReviewDate datetime NULL,
	NextEvaluationDate datetime NULL,
	EligibilityDate datetime NULL,
	ConsentDate datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepDates ADD CONSTRAINT
	PK_IepDates PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepDates ADD CONSTRAINT
	FK_IepDates_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE  CASCADE 
GO

-- drop obsolete/unleveraged columns from PrgSectionType, PrgSectionDef
ALTER TABLE dbo.PrgSectionType DROP COLUMN UserControlPath
GO

-- add section configuration
INSERT PrgSectionType VALUES( '7E6F8640-DEB8-441F-BD3A-4B2E96EAA6B4', 'IEP Dates', 'Dates', 'Dates', NULL, NULL, NULL )
GO

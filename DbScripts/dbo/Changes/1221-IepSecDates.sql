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
INSERT PrgSectionDef VALUES( '0666ECBD-47D9-4536-B8A5-AA8E83C2BA2C', '7E6F8640-DEB8-441F-BD3A-4B2E96EAA6B4', '251DA756-A67A-453C-A676-3B88C1B9340C', 10, 1, NULL, NULL, NULL, NULL, NULL, NULL )
UPDATE PrgSectionDef SET Sequence = Sequence + 1
UPDATE PrgSectionDef SET Sequence = 0 WHERE ID = '0666ECBD-47D9-4536-B8A5-AA8E83C2BA2C'
GO

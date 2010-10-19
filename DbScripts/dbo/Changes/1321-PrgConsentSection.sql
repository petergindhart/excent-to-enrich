-- Add support for consent section
CREATE TABLE dbo.PrgConsentOutcome
	(
	ConsentSectionDefID uniqueidentifier NOT NULL,
	ItemOutcomeID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgConsentOutcome ADD CONSTRAINT
	PK_PrgConsentOutcome PRIMARY KEY CLUSTERED 
	(
	ConsentSectionDefID,
	ItemOutcomeID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgConsentOutcome ADD CONSTRAINT
	FK_PrgSectionDef#ConsentGrantedOutcomes FOREIGN KEY
	(
	ConsentSectionDefID
	) REFERENCES dbo.PrgSectionDef
	(
	ID
	) ON DELETE  CASCADE
GO
ALTER TABLE dbo.PrgConsentOutcome ADD CONSTRAINT
	FK_PrgItemOutcome#ConsentSectionDefs FOREIGN KEY
	(
	ItemOutcomeID
	) REFERENCES dbo.PrgItemOutcome
	(
	ID
	) ON DELETE  CASCADE
GO
CREATE TABLE dbo.PrgConsent
	(
	ID uniqueidentifier NOT NULL,
	ConsentGrantedID uniqueidentifier NULL,
	ConsentDate datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgConsent ADD CONSTRAINT
	PK_PrgConsent PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgConsent ADD CONSTRAINT
	FK_PrgConsent_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE  CASCADE
GO
ALTER TABLE dbo.PrgConsent ADD CONSTRAINT
	FK_PrgConsent#ConsentGranted# FOREIGN KEY
	(
	ConsentGrantedID
	) REFERENCES dbo.EnumValue
	(
	ID
	)
GO

-- PrgSectionType records for new consent sections
INSERT PrgSectionType VALUES( 'FAAC8057-2256-456A-A441-3391C2F1BEF7', 'Sped Consent Services', 'ConsentServ', 'Consent for Special Education Services', NULL, NULL, NULL )
INSERT PrgSectionType VALUES( '31A1AE20-5F63-47FD-852A-4801595033ED', 'Sped Consent Evaluation', 'ConsentEval', 'Consent to Evaluate', NULL, NULL, NULL )
GO

-- add flag to PrgSectionType to indicate whether a particular type
-- can accommodate versioning.
ALTER TABLE dbo.PrgSectionType ADD
	CanVersion bit NULL
GO

UPDATE PrgSectionType
SET CanVersion = 1

UPDATE PrgSectionType
SET CanVersion = 0 where ID in (
'FAAC8057-2256-456A-A441-3391C2F1BEF7', -- Sped Consent Services
'31A1AE20-5F63-47FD-852A-4801595033ED' -- Sped Consent Evaluation
)
GO

ALTER TABLE dbo.PrgSectionType ALTER COLUMN
	CanVersion bit NOT NULL
GO

-- drop persisted columns from IepDates section
ALTER TABLE dbo.IepDates
	DROP COLUMN EligibilityDate
GO
ALTER TABLE dbo.IepDates
	DROP COLUMN ConsentDate
GO
-- Add IepProcSafeguards table
-- Add columns to IepDemographics, and IepEsyCriterionDef
CREATE TABLE dbo.IepProcSafeguards
	(
	ID uniqueidentifier NOT NULL,
	ParentReceivedSafeguards bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepProcSafeguards ADD CONSTRAINT
	PK_IepProcSafeguards PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepProcSafeguards ADD CONSTRAINT
	FK_IepProcSafeguards_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepDemographics ADD
	LimittedEnglishProficiencyID uniqueidentifier NULL,
	InterpreterNeededID uniqueidentifier NULL
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#LimittedEnglishProficiency# FOREIGN KEY
	(
	LimittedEnglishProficiencyID
	) REFERENCES dbo.EnumValue
	(
	ID
	)  
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#InterpreterNeeded# FOREIGN KEY
	(
	InterpreterNeededID
	) REFERENCES dbo.EnumValue
	(
	ID
	)  
GO
ALTER TABLE dbo.IepEsyCriterionDef ADD
	Title varchar(50) NULL
GO

-- insert section definition and type for ProcSafeguards
insert PrgSectionType values( 'B2E99B75-1E6A-4A93-A6B0-BBE0074A2917', 'IEP Procedural Safeguards', 'ProcSafeguards', 'Procedural Safeguards', NULL, NULL, NULL )
GO

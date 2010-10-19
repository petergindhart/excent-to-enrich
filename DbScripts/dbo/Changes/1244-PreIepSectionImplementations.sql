-- implement sections for DisabilityEligibilities, SuspectedDisabilities, and Milestones
--##############################################################################
CREATE TABLE dbo.IepDisability
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL,
	Definition text NOT NULL,
	DeterminationFormTemplateID uniqueidentifier NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepDisability ADD CONSTRAINT
	PK_IepDisability PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
--##############################################################################
CREATE TABLE dbo.IepDisabilityEligibility
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	DisabilityID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	IsEligibileID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepDisabilityEligibility ADD CONSTRAINT
	PK_IepDisabilityEligibility PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepDisabilityEligibility ADD CONSTRAINT
	FK_IepDisabilityEligibility#Instance#Disabilities FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepDisabilityEligibility ADD CONSTRAINT
	FK_IepDisabilityEligibility#Disability# FOREIGN KEY
	(
	DisabilityID
	) REFERENCES dbo.IepDisability
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepDisabilityEligibility ADD CONSTRAINT
	FK_IepDisabilityEligibility#IsEligible# FOREIGN KEY
	(
	IsEligibileID
	) REFERENCES dbo.EnumValue
	(
	ID
	) 
GO
--##############################################################################
CREATE TABLE dbo.IepSuspectedDisabilities
	(
	ID uniqueidentifier NOT NULL,
	Reason text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepSuspectedDisabilities ADD CONSTRAINT
	PK_IepSuspectedDisabilities PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepSuspectedDisabilities ADD CONSTRAINT
	FK_IepSuspectedDisabilities_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE  CASCADE 
GO
CREATE TABLE dbo.IepSuspectedDisability
	(
	InstanceID uniqueidentifier NOT NULL,
	DisabilityID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepSuspectedDisability ADD CONSTRAINT
	PK_IepSuspectedDisability PRIMARY KEY CLUSTERED 
	(
	InstanceID,
	DisabilityID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepSuspectedDisability ADD CONSTRAINT
	FK_IepSuspectedDisabilities#Disabilities FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepSuspectedDisabilities
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepSuspectedDisability ADD CONSTRAINT
	FK_IepDisability#SuspectedDisabilies FOREIGN KEY
	(
	DisabilityID
	) REFERENCES dbo.IepDisability
	(
	ID
	) ON DELETE  CASCADE 
GO
--##############################################################################
CREATE TABLE dbo.PrgMilestoneDef
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL,
	Description text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.PrgMilestoneDef ADD CONSTRAINT
	PK_PrgMilestoneDef PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
CREATE TABLE dbo.PrgMilestone
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	DefID uniqueidentifier NOT NULL,
	DateDue datetime NULL,
	DateMet datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgMilestone ADD CONSTRAINT
	PK_PrgMilestone PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgMilestone ADD CONSTRAINT
	FK_PrgMilestone#Instance#Milestones FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.PrgMilestone ADD CONSTRAINT
	FK_PrgMilestone#Def# FOREIGN KEY
	(
	DefID
	) REFERENCES dbo.PrgMilestoneDef
	(
	ID
	) ON DELETE  CASCADE 
GO

-- add ProgramID to PrgMilestoneDef
CREATE TABLE dbo.Tmp_PrgMilestoneDef
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL,
	Description text NULL,
	ProgramID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.PrgMilestoneDef)
	 EXEC('INSERT INTO dbo.Tmp_PrgMilestoneDef (ID, Name, Description)
		SELECT ID, Name, Description FROM dbo.PrgMilestoneDef WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.PrgMilestone
	DROP CONSTRAINT FK_PrgMilestone#Def#
GO
DROP TABLE dbo.PrgMilestoneDef
GO
EXECUTE sp_rename N'dbo.Tmp_PrgMilestoneDef', N'PrgMilestoneDef', 'OBJECT' 
GO
ALTER TABLE dbo.PrgMilestoneDef ADD CONSTRAINT
	PK_PrgMilestoneDef PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.PrgMilestoneDef ADD CONSTRAINT
	FK_PrgMilestoneDef#Program#MilestoneDefs FOREIGN KEY
	(
	ProgramID
	) REFERENCES dbo.Program
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.PrgMilestone ADD CONSTRAINT
	FK_PrgMilestone#Def# FOREIGN KEY
	(
	DefID
	) REFERENCES dbo.PrgMilestoneDef
	(
	ID
	) ON DELETE  CASCADE 
GO

-- relate PrgSectionDef to PrgMilestoneDef
CREATE TABLE dbo.PrgSectionDefMilestoneDef
	(
	SectionDefID uniqueidentifier NOT NULL,
	MilestoneDefID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgSectionDefMilestoneDef ADD CONSTRAINT
	PK_PrgSectionDefMilestoneDef PRIMARY KEY CLUSTERED 
	(
	SectionDefID,
	MilestoneDefID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgSectionDefMilestoneDef ADD CONSTRAINT
	FK_PrgSectionDef#MilestoneDefs FOREIGN KEY
	(
	SectionDefID
	) REFERENCES dbo.PrgSectionDef
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.PrgSectionDefMilestoneDef ADD CONSTRAINT
	FK_DefMilestoneDef#SectionDefs FOREIGN KEY
	(
	MilestoneDefID
	) REFERENCES dbo.PrgMilestoneDef
	(
	ID
	) ON DELETE  CASCADE 
GO


-- add PrgSectionType records
INSERT PrgSectionType VALUES( 'E4302232-FFC9-423F-A332-AE5E56C76A09', 'Sped Milestones', 'Milestones', 'Milestones', NULL, NULL, NULL )
INSERT PrgSectionType VALUES( '65C743AB-40C7-4DEA-AB8D-5CCF01097DE9', 'Sped Suspected Disabilities', 'SuspDisabilities', 'Suspected Disabilities', NULL, NULL, NULL )
INSERT PrgSectionType VALUES( 'F65AEF7A-5EF8-46DD-B207-ADA61CD3A4CB', 'Sped Eligibility Determination', 'EligDetermination', 'Eligibility Determination', NULL, NULL, NULL )
GO

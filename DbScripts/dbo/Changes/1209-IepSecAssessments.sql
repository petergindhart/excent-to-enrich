CREATE TABLE dbo.IepJustificationDef
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(200) NOT NULL,
	Description text NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepJustificationDef ADD CONSTRAINT
	PK_IepJustificationDef PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
CREATE TABLE dbo.IepTestParticipationDef
	(
	ID uniqueidentifier NOT NULL,
	Text varchar(50) NOT NULL,
	AllowsAccoms bit NOT NULL,
	Sequence int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTestParticipationDef ADD CONSTRAINT
	PK_IepTestParticipationDef PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
CREATE TABLE dbo.IepTestAccomDef
	(
	ID uniqueidentifier NOT NULL,
	Text varchar(200) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTestAccomDef ADD CONSTRAINT
	PK_IepTestAccomDef PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
CREATE TABLE dbo.IepTestDef
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(100) NOT NULL,
	IsState bit NOT NULL,
	MinGradeID uniqueidentifier NULL,
	MaxGradeID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTestDef ADD CONSTRAINT
	PK_IepTestDef PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTestDef ADD CONSTRAINT
	FK_IepTestDef#MinGradeLevel# FOREIGN KEY
	(
	MinGradeID
	) REFERENCES dbo.GradeLevel
	(
	ID
	)  
GO
ALTER TABLE dbo.IepTestDef ADD CONSTRAINT
	FK_IepTestDef#MaxGradeLevel# FOREIGN KEY
	(
	MaxGradeID
	) REFERENCES dbo.GradeLevel
	(
	ID
	)  
GO
CREATE TABLE dbo.IepAllowedTestParticipation
	(
	TestDefID uniqueidentifier NOT NULL,
	ParticipationDefID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepAllowedTestParticipation ADD CONSTRAINT
	PK_IepAllowedTestParticipation PRIMARY KEY CLUSTERED 
	(
	TestDefID,
	ParticipationDefID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepAllowedTestParticipation ADD CONSTRAINT
	FK_IepTestDef#AllowedParticipationDefs FOREIGN KEY
	(
	TestDefID
	) REFERENCES dbo.IepTestDef
	(
	ID
	)  
GO
ALTER TABLE dbo.IepAllowedTestParticipation ADD CONSTRAINT
	FK_IepTestParticipationDef#AllowedTestDefs FOREIGN KEY
	(
	ParticipationDefID
	) REFERENCES dbo.IepTestParticipationDef
	(
	ID
	)  
GO
CREATE TABLE dbo.IepJustificationCriterion
	(
	ID uniqueidentifier NOT NULL,
	JustificationDefID uniqueidentifier NOT NULL,
	TestDefID uniqueidentifier NOT NULL,
	ParticipationDefID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepJustificationCriterion ADD CONSTRAINT
	PK_IepJustificationCriterion PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepJustificationCriterion ADD CONSTRAINT
	FK_IepJustificationCriterion#JustificationDef#Criteria FOREIGN KEY
	(
	JustificationDefID
	) REFERENCES dbo.IepJustificationDef
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepJustificationCriterion ADD CONSTRAINT
	FK_IepJustificationCriterion#TestDef# FOREIGN KEY
	(
	TestDefID
	) REFERENCES dbo.IepTestDef
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepJustificationCriterion ADD CONSTRAINT
	FK_IepJustificationCriterion#ParticipationDef# FOREIGN KEY
	(
	ParticipationDefID
	) REFERENCES dbo.IepTestParticipationDef
	(
	ID
	) ON DELETE  CASCADE 
GO
CREATE TABLE dbo.IepAllowedTestAccom
	(
	TestDefID uniqueidentifier NOT NULL,
	AccomDefID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepAllowedTestAccom ADD CONSTRAINT
	PK_IepAllowedTestAccom PRIMARY KEY CLUSTERED 
	(
	TestDefID,
	AccomDefID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepAllowedTestAccom ADD CONSTRAINT
	FK_IepTestDef#AllowedAccomDefs FOREIGN KEY
	(
	TestDefID
	) REFERENCES dbo.IepTestDef
	(
	ID
	)  
GO
ALTER TABLE dbo.IepAllowedTestAccom ADD CONSTRAINT
	FK_IepTestAccomDef#AllowedTestDefs FOREIGN KEY
	(
	AccomDefID
	) REFERENCES dbo.IepTestAccomDef
	(
	ID
	)  
GO
CREATE TABLE dbo.IepAssessments
	(
	ID uniqueidentifier NOT NULL,
	ParentsAreInformedID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepAssessments ADD CONSTRAINT
	PK_IepAssessments PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepAssessments ADD CONSTRAINT
	FK_IepAssessments_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	)  ON DELETE  CASCADE 
GO
CREATE TABLE dbo.IepJustification
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	DefID uniqueidentifier NOT NULL,
	Text text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepJustification ADD CONSTRAINT
	PK_IepJustification PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepJustification ADD CONSTRAINT
	FK_IepJustification#Instance#Justifications FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepAssessments
	(
	ID
	)  ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepJustification ADD CONSTRAINT
	FK_IepJustification#Def# FOREIGN KEY
	(
	DefID
	) REFERENCES dbo.IepJustificationDef
	(
	ID
	)  
GO
CREATE TABLE dbo.IepTestParticipation
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	TestDefID uniqueidentifier NOT NULL,
	ParticipationDefID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTestParticipation ADD CONSTRAINT
	PK_IepTestParticipation PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTestParticipation ADD CONSTRAINT
	FK_IepTestParticipation#Instance#Participations FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepAssessments
	(
	ID
	)  ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepTestParticipation ADD CONSTRAINT
	FK_IepTestParticipation#TestDef# FOREIGN KEY
	(
	TestDefID
	) REFERENCES dbo.IepTestDef
	(
	ID
	)  ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepTestParticipation ADD CONSTRAINT
	FK_IepTestParticipation#ParticipationDef# FOREIGN KEY
	(
	ParticipationDefID
	) REFERENCES dbo.IepTestParticipationDef
	(
	ID
	)  ON DELETE  CASCADE 
GO
CREATE TABLE dbo.IepTestAccom
	(
	ParticipationID uniqueidentifier NOT NULL,
	DefID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTestAccom ADD CONSTRAINT
	PK_IepTestAccom PRIMARY KEY CLUSTERED 
	(
	ParticipationID,
	DefID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTestAccom ADD CONSTRAINT
	FK_IepTestParticipation#Accommodations FOREIGN KEY
	(
	ParticipationID
	) REFERENCES dbo.IepTestParticipation
	(
	ID
	)  ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepTestAccom ADD CONSTRAINT
	FK_IepTestAccomDef#Participations FOREIGN KEY
	(
	DefID
	) REFERENCES dbo.IepTestAccomDef
	(
	ID
	)  ON DELETE  CASCADE 
GO




insert PrgSectionType values ( '6F3F1C06-64C6-4C70-A834-0941ACCD0F62', 'IEP Assessments', 'iepassess', 'State and District Assessment Participation', null, null, null, '~/SpecEd/SectionAssessments.ascx' )


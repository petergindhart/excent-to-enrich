CREATE TABLE dbo.IepProgRptStatus
	(
	ID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepProgRptStatus ADD CONSTRAINT
	PK_IepProgRptStatus PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepProgRptFreq
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepProgRptFreq ADD CONSTRAINT
	PK_IepProgRptFreq PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepProgRptPeriod
	(
	ID uniqueidentifier NOT NULL,
	FrequencyID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL,
	IsESY bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepProgRptPeriod ADD CONSTRAINT
	PK_IepProgRptPeriod PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepProgRptPeriod ADD CONSTRAINT
	FK_IepProgRptPeriod#ReportFrequency#Periods FOREIGN KEY
	(
	FrequencyID
	) REFERENCES dbo.IepProgRptFreq
	(
	ID
	) ON DELETE CASCADE
GO
CREATE TABLE dbo.IepProgRptTime
	(
	ID uniqueidentifier NOT NULL,
	RosterYearID uniqueidentifier NOT NULL,
	PeriodID uniqueidentifier NOT NULL,
	[Date] datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepProgRptTime ADD CONSTRAINT
	PK_IepProgRptTime PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepProgRptTime ADD CONSTRAINT
	FK_IepProgRptTime#RosterYear# FOREIGN KEY
	(
	RosterYearID
	) REFERENCES dbo.RosterYear
	(
	ID
	)
GO
ALTER TABLE dbo.IepProgRptTime ADD CONSTRAINT
	FK_IepProgRptTime#Period#Times FOREIGN KEY
	(
	PeriodID
	) REFERENCES dbo.IepProgRptPeriod
	(
	ID
	) ON DELETE CASCADE
GO
CREATE TABLE dbo.IepGoals
	(
	ID uniqueidentifier NOT NULL,
	ReportFrequencyID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepGoals ADD CONSTRAINT
	PK_IepGoals PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepGoals ADD CONSTRAINT
	FK_IepGoals#ReportFrequency# FOREIGN KEY
	(
	ReportFrequencyID
	) REFERENCES dbo.IepProgRptFreq
	(
	ID
	)
GO
ALTER TABLE dbo.IepGoals ADD CONSTRAINT
	FK_IepGoals_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE CASCADE
GO
CREATE TABLE dbo.IepGoal
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	TargetDate datetime NULL,
	GoalStatement text NULL,
	IsEsy bit NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepGoal ADD CONSTRAINT
	PK_IepGoal PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepGoal ADD CONSTRAINT
	FK_IepGoal#Instance#Goals FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepGoals
	(
	ID
	) ON DELETE CASCADE
GO
CREATE TABLE dbo.IepGoalProgress
	(
	ID uniqueidentifier NOT NULL,
	GoalID uniqueidentifier NOT NULL,
	ReportTimeID uniqueidentifier NOT NULL,
	StatusID uniqueidentifier NULL,
	Explanation text NULL,
	IsComplete bit NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepGoalProgress ADD CONSTRAINT
	PK_IepGoalProgress PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepGoalProgress ADD CONSTRAINT
	FK_IepGoalProgress#Goal#ProgressReports FOREIGN KEY
	(
	GoalID
	) REFERENCES dbo.IepGoal
	(
	ID
	)
GO
ALTER TABLE dbo.IepGoalProgress ADD CONSTRAINT
	FK_IepGoalProgress#ReportTime#ProgressReports FOREIGN KEY
	(
	ReportTimeID
	) REFERENCES dbo.IepProgRptTime
	(
	ID
	) ON DELETE CASCADE
GO
ALTER TABLE dbo.IepGoalProgress ADD CONSTRAINT
	FK_IepGoalProgress#Status# FOREIGN KEY
	(
	StatusID
	) REFERENCES dbo.IepProgRptStatus
	(
	ID
	) ON DELETE CASCADE
GO


insert PrgSectionType values ( '469601E0-B8E6-483A-9CE7-2A88DE0EAB78', 'IEP Goals', 'iepgoals', 'Goals', null, null, null, '~/SpecEd/SectionGoals.ascx' )

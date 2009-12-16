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
insert PrgSectionDef values ( '32B89B05-C90E-4F62-A171-E5B282981948', '469601E0-B8E6-483A-9CE7-2A88DE0EAB78', '251DA756-A67A-453C-A676-3B88C1B9340C', 6, 1, null, null, null, null, null )

-- -- goal progress status reports (for ExcentOnline migration)
-- insert IepProgRptStatus values ( 'C3D4DC55-207E-47F2-9C0F-F439B03F8DF9', 0, 'Did Not Meet Goal' )
-- insert IepProgRptStatus values ( '3F03981A-2334-47C7-B0D2-7FC004A4C2E1', 1, 'May meet goal by end of IEP' )
-- insert IepProgRptStatus values ( '11737F90-EE01-423F-9795-81A4A39463D2', 2, 'May not meet goal by end of IEP' )
-- insert IepProgRptStatus values ( 'D633C90C-D293-466E-8BDD-48590A4EA679', 3, 'Met Goal' )
-- 
-- insert IepProgRptFreq values ( 'BF539A57-94CE-4F78-B3A7-8984EE85FCDA', 'Quarterly Report Card Addendums' )
-- insert IepProgRptPeriod values ( 'AB1926A2-5B18-49CC-BA9F-7EC0D4FF605E', 'BF539A57-94CE-4F78-B3A7-8984EE85FCDA', '1st Quarter', 0 )
-- insert IepProgRptPeriod values ( 'C54C2CAF-9468-4A8E-9C95-058EAB495B65', 'BF539A57-94CE-4F78-B3A7-8984EE85FCDA', '2nd Quarter', 0 )
-- insert IepProgRptPeriod values ( '3638F877-BB94-4668-B27D-607C14EFE880', 'BF539A57-94CE-4F78-B3A7-8984EE85FCDA', '3rd Quarter', 0 )
-- insert IepProgRptPeriod values ( 'B3C60CB3-6BAA-4C8B-8D83-F0513CDE56B8', 'BF539A57-94CE-4F78-B3A7-8984EE85FCDA', '4th Quarter', 0 )
-- 
-- insert IepProgRptTime values ( '99AD9B7E-3097-42F3-9B6B-0657C58372E8', '334840F6-125D-41AD-AB64-0A029298D1F5', 'AB1926A2-5B18-49CC-BA9F-7EC0D4FF605E', '10/20/2009' )
-- insert IepProgRptTime values ( '936E3C86-02A5-4954-A4AB-5F69FC24B6D6', '334840F6-125D-41AD-AB64-0A029298D1F5', 'C54C2CAF-9468-4A8E-9C95-058EAB495B65', '01/11/2010' )
-- insert IepProgRptTime values ( '49CFFF44-1E0B-4356-944B-83CC9B119FA6', '334840F6-125D-41AD-AB64-0A029298D1F5', '3638F877-BB94-4668-B27D-607C14EFE880', '03/17/2010' )
-- insert IepProgRptTime values ( '77CA5DF6-AD5F-4AA8-805A-8C5DDAFB96A7', '334840F6-125D-41AD-AB64-0A029298D1F5', 'B3C60CB3-6BAA-4C8B-8D83-F0513CDE56B8', '05/28/2010' )
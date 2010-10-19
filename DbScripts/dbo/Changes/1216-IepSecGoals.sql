--##############################################################################
ALTER TABLE dbo.IepGoal
	DROP CONSTRAINT FK_IepGoal#Instance#Goals
GO
CREATE TABLE dbo.IepGoalAreaProbeType
	(
	ProbeTypeID uniqueidentifier NOT NULL,
	GoalAreaID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepGoalAreaProbeType ADD CONSTRAINT
	PK_IepGoalAreaProbeType PRIMARY KEY CLUSTERED 
	(
	ProbeTypeID,
	GoalAreaID
	)  ON [PRIMARY]
GO
CREATE TABLE dbo.IepGoalArea
	(
	ID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	Name varchar(50) NOT NULL,
	AllowCustomProbes bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepGoalArea ADD CONSTRAINT
	PK_IepGoalArea PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
CREATE TABLE dbo.Tmp_IepGoal
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	TargetDate datetime NULL,
	GoalStatement text NULL,
	IsEsy bit NOT NULL,
	GoalAreaID uniqueidentifier NULL,
	HasObjectives bit NULL,
	PostSchoolAreaID uniqueidentifier NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.IepGoal)
	 EXEC('INSERT INTO dbo.Tmp_IepGoal (ID, InstanceID, Sequence, TargetDate, GoalStatement, IsEsy)
		SELECT ID, InstanceID, Sequence, TargetDate, GoalStatement, IsEsy FROM dbo.IepGoal WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.IepGoalProgress
	DROP CONSTRAINT FK_IepGoalProgress#Goal#ProgressReports
GO
DROP TABLE dbo.IepGoal
GO
EXECUTE sp_rename N'dbo.Tmp_IepGoal', N'IepGoal', 'OBJECT' 
GO
ALTER TABLE dbo.IepGoal ADD CONSTRAINT
	PK_IepGoal PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepGoal ADD CONSTRAINT
	FK_IepGoal#Instance#Goals FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepGoals
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepGoal ADD CONSTRAINT
	FK_IepGoal#AreaOfNeed# FOREIGN KEY
	(
	GoalAreaID
	) REFERENCES dbo.IepGoalArea
	(
	ID
	)  
GO
ALTER TABLE dbo.IepGoal ADD CONSTRAINT
	FK_IepGoal#PostSchoolArea#AnnualGoals FOREIGN KEY
	(
	PostSchoolAreaID
	) REFERENCES dbo.IepPostSchoolArea
	(
	ID
	)  
GO
CREATE TABLE dbo.IepMeasurableGoal
	(
	ID uniqueidentifier NOT NULL,
	GoalID uniqueidentifier NOT NULL,
	ProbeTypeID uniqueidentifier NULL,
	IndDefID uniqueidentifier NULL,
	IndTarget real NULL,
	NumericTarget real NULL,
	RubricTarget uniqueidentifier NULL,
	FlagTarget bit NULL,
	RatioPartTarget real NULL,
	RatioOutOfTarget real NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepMeasurableGoal ADD CONSTRAINT
	PK_IepMeasurableGoal PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepMeasurableGoal ADD CONSTRAINT
	FK_IepMeasurableGoal#Goal#MeasurableGoals FOREIGN KEY
	(
	GoalID
	) REFERENCES dbo.IepGoal
	(
	ID
	) ON DELETE  CASCADE 
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

--##############################################################################
CREATE TABLE dbo.IepStandard
	(
	ID uniqueidentifier NOT NULL,
	Text varchar(200) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepStandard ADD CONSTRAINT
	PK_IepStandard PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
CREATE TABLE dbo.ProbeScheduleFrequency
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ProbeScheduleFrequency ADD CONSTRAINT
	PK_ProbeScheduleFrequency PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
CREATE TABLE dbo.ProbeSchedule
	(
	ID uniqueidentifier NOT NULL,
	IepID uniqueidentifier NOT NULL,
	FrequencyID uniqueidentifier NOT NULL,
	FrequencyAmount int NOT NULL,
	StartDate datetime NOT NULL,
	WeeklyMon bit NOT NULL,
	WeeklyTue bit NOT NULL,
	WeeklyWed bit NOT NULL,
	WeeklyThu bit NOT NULL,
	WeeklyFri bit NOT NULL,
	WeeklySat bit NOT NULL,
	WeeklySun bit NOT NULL,
	TimePerDay int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ProbeSchedule ADD CONSTRAINT
	PK_ProbeSchedule PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ProbeSchedule ADD CONSTRAINT
	FK_ProbeSchedule#PrgIep#ProbeSchedules FOREIGN KEY
	(
	IepID
	) REFERENCES dbo.PrgIep
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.ProbeSchedule ADD CONSTRAINT
	FK_ProbeSchedule#ProbeScheduleFrequency# FOREIGN KEY
	(
	FrequencyID
	) REFERENCES dbo.ProbeScheduleFrequency
	(
	ID
	)  
GO
CREATE TABLE dbo.IepGoalStandard
	(
	GoalID uniqueidentifier NOT NULL,
	StandardID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepGoalStandard ADD CONSTRAINT
	PK_IepGoalStandard PRIMARY KEY CLUSTERED 
	(
	GoalID,
	StandardID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepGoalStandard ADD CONSTRAINT
	FK_IepGoal#Standards FOREIGN KEY
	(
	GoalID
	) REFERENCES dbo.IepGoal
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepGoalStandard ADD CONSTRAINT
	FK_IepStandard#IepGoals FOREIGN KEY
	(
	StandardID
	) REFERENCES dbo.IepStandard
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.ProbeTime ADD CONSTRAINT
	FK_ProbeTime#ProbeSchedule#ProbeTimes FOREIGN KEY
	(
	ScheduleID
	) REFERENCES dbo.ProbeSchedule
	(
	ID
	)  
GO
CREATE TABLE dbo.ProbeScheduleProbeType
	(
	ProbeScheduleID uniqueidentifier NOT NULL,
	ProbeTypeID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ProbeScheduleProbeType ADD CONSTRAINT
	PK_ProbeScheduleProbeType PRIMARY KEY CLUSTERED 
	(
	ProbeScheduleID,
	ProbeTypeID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ProbeScheduleProbeType ADD CONSTRAINT
	FK_ProbeSchedule#ProbeTypes FOREIGN KEY
	(
	ProbeScheduleID
	) REFERENCES dbo.ProbeSchedule
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.ProbeScheduleProbeType ADD CONSTRAINT
	FK_ProbeType#ProbeSchedules FOREIGN KEY
	(
	ProbeTypeID
	) REFERENCES dbo.ProbeType
	(
	ID
	) ON DELETE  CASCADE 
GO
CREATE TABLE dbo.IepGoalAreaStandard
	(
	GoalAreaID uniqueidentifier NOT NULL,
	StandardID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepGoalAreaStandard ADD CONSTRAINT
	PK_IepGoalAreaStandard PRIMARY KEY CLUSTERED 
	(
	GoalAreaID,
	StandardID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepGoalAreaStandard ADD CONSTRAINT
	FK_IepGoalArea#Standards FOREIGN KEY
	(
	GoalAreaID
	) REFERENCES dbo.IepGoalArea
	(
	ID
	)  
GO
ALTER TABLE dbo.IepGoalAreaStandard ADD CONSTRAINT
	FK_IepStandard#GoalAreas FOREIGN KEY
	(
	StandardID
	) REFERENCES dbo.IepStandard
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepGoalAreaProbeType ADD CONSTRAINT
	FK_IepProbeType#GoalAreas FOREIGN KEY
	(
	ProbeTypeID
	) REFERENCES dbo.ProbeType
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepGoalAreaProbeType ADD CONSTRAINT
	FK_IepGoalArea#ProbeTypes FOREIGN KEY
	(
	GoalAreaID
	) REFERENCES dbo.IepGoalArea
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepMeasurableGoal ADD CONSTRAINT
	FK_IepMeasurableGoal#ProbeType# FOREIGN KEY
	(
	ProbeTypeID
	) REFERENCES dbo.ProbeType
	(
	ID
	)  
GO
ALTER TABLE dbo.IepMeasurableGoal ADD CONSTRAINT
	FK_IepMeasurableGoal#IndDef# FOREIGN KEY
	(
	IndDefID
	) REFERENCES dbo.IndDefinition
	(
	ID
	)  
GO
ALTER TABLE dbo.IndSource ADD
	ProbeDataTypeID uniqueidentifier NULL
GO
ALTER TABLE dbo.IndSource ADD CONSTRAINT
	FK_IndSource#ProbeDataType#IndSources FOREIGN KEY
	(
	ProbeDataTypeID
	) REFERENCES dbo.ProbeDataType
	(
	ID
	)  
GO

INSERT INTO ProbeScheduleFrequency VALUES('05ED7F8F-D492-4377-85DB-94B36C3F9290', 'Daily')
INSERT INTO ProbeScheduleFrequency VALUES('634EA996-D5FF-4A4A-B169-B8CB70DBBEC2', 'Weekly')
GO

-- add sequence to measurable goal
ALTER TABLE IepMeasurableGoal ADD
	Sequence INT NULL
GO

UPDATE m
SET Sequence = (SELECT COUNT(*) FROM IepMeasurableGoal WHERE GoalID = m.GoalID and ID < m.ID)
FROM IepMeasurableGoal m
GO

ALTER TABLE IepMeasurableGoal ALTER COLUMN
	Sequence INT NOT NULL
GO

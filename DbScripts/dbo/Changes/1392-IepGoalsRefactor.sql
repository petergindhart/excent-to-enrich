--##############################################################################
-- add PrgGoals/PrgGoal tables
CREATE TABLE dbo.PrgGoals
	(
	ID uniqueidentifier NOT NULL,
	ReportFrequencyID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoals ADD CONSTRAINT
	PK_PrgGoals PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoals ADD CONSTRAINT
	FK_PrgGoals_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE  CASCADE
GO
CREATE TABLE dbo.PrgGoalType
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoalType ADD CONSTRAINT
	PK_PrgGoalType PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.PrgGoal
	(
	ID uniqueidentifier NOT NULL,
	TypeID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	IsProbeGoal bit NOT NULL,
	TargetDate datetime NULL,
	GoalStatement text NULL,
	ProbeTypeID uniqueidentifier NULL,
	NumericTarget float(53) NULL,
	RubricTargetID uniqueidentifier NULL,
	RatioPartTarget float(53) NULL,
	RatioOutOfTarget float(53) NULL,
	BaselineScoreID uniqueidentifier NULL,
	IndDefID uniqueidentifier NULL,
	IndTarget float(53) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoal ADD CONSTRAINT
	PK_PrgGoal PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoal ADD CONSTRAINT
	FK_PrgGoal#GoalType# FOREIGN KEY
	(
	TypeID
	) REFERENCES dbo.PrgGoalType
	(
	ID
	) ON DELETE  CASCADE
GO
ALTER TABLE dbo.PrgGoal ADD CONSTRAINT
	FK_PrgGoal#Instance#Goals FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.PrgGoals
	(
	ID
	) ON DELETE  CASCADE
GO
ALTER TABLE dbo.PrgGoal ADD CONSTRAINT
	FK_PrgGoal#BaselineScore# FOREIGN KEY
	(
	BaselineScoreID
	) REFERENCES dbo.ProbeScore
	(
	ID
	)
GO

DROP TABLE dbo.IepMeasurableGoal
GO
CREATE TABLE dbo.PrgGoalProgressFreq
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoalProgressFreq ADD CONSTRAINT
	PK_PrgGoalProgressFreq PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoals ADD CONSTRAINT
	FK_PrgGoals#ReportFrequency# FOREIGN KEY
	(
	ReportFrequencyID
	) REFERENCES dbo.PrgGoalProgressFreq
	(
	ID
	)  
GO
ALTER TABLE dbo.PrgGoal ADD CONSTRAINT
	FK_PrgGoal#RubricTarget# FOREIGN KEY
	(
	RubricTargetID
	) REFERENCES dbo.ProbeRubricValue
	(
	ID
	)  
GO
ALTER TABLE dbo.PrgGoal ADD CONSTRAINT
	FK_PrgGoal#IndDef# FOREIGN KEY
	(
	IndDefID
	) REFERENCES dbo.IndDefinition
	(
	ID
	)  
GO
ALTER TABLE dbo.PrgGoal ADD CONSTRAINT
	FK_PrgGoal#ProbeType# FOREIGN KEY
	(
	ProbeTypeID
	) REFERENCES dbo.ProbeType
	(
	ID
	)  
GO

CREATE TABLE dbo.PrgGoalProgress
	(
	ID uniqueidentifier NOT NULL,
	GoalID uniqueidentifier NOT NULL,
	ReportTimeID uniqueidentifier NOT NULL,
	StatusID uniqueidentifier NULL,
	Explanation text NULL,
	IsComplete bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoalProgress ADD CONSTRAINT
	PK_PrgGoalProgress PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoalProgress ADD CONSTRAINT
	FK_PrgGoalProgress#Goal#ProgressReports FOREIGN KEY
	(
	GoalID
	) REFERENCES dbo.PrgGoal
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepGoal
	DROP CONSTRAINT FK_IepGoal#Instance#Goals
GO
ALTER TABLE dbo.IepGoalProgress
	DROP CONSTRAINT FK_IepGoalProgress#Goal#ProgressReports
GO
--##############################################################################
-- migrate basic goal information over to new tables
insert PrgGoalType values ( 'AB74929E-B03F-4A51-82CA-659CA90E291A', 'IEP' )

insert PrgGoalProgressFreq
select ID, Name
from IepProgRptFreq

insert PrgGoals
select s.ID, s.ReportFrequencyID
from IepGoals s

insert PrgGoal
select g.ID, 'AB74929E-B03F-4A51-82CA-659CA90E291A', g.InstanceID, g.Sequence, 1, g.TargetDate, g.GoalStatement, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
from IepGoal g
GO

--##############################################################################
-- convert IepGoal.IsEsy to EsyID (EnumValue)
ALTER TABLE dbo.IepGoal ADD
	EsyID uniqueidentifier NULL
GO
ALTER TABLE dbo.IepGoal ADD CONSTRAINT
	FK_IepGoal#Esy# FOREIGN KEY
	(
	EsyID
	) REFERENCES dbo.EnumValue
	(
	ID
	)
GO
update g
set EsyID = case
	when g.IsEsy = 1 then 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' -- Yes
	else 'F7E20A86-2709-4170-9810-15B601C61B79' -- No
	end
from IepGoal g
GO

--##############################################################################
-- swing IepGoal over to be subclass of PrgGoal
ALTER TABLE dbo.IepGoal
	DROP COLUMN InstanceID, Sequence, TargetDate, GoalStatement, HasObjectives, IsEsy
GO
ALTER TABLE dbo.IepGoal ADD CONSTRAINT
	FK_IepGoal_PrgGoal FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgGoal
	(
	ID
	) ON DELETE  CASCADE
GO
--##############################################################################
-- add PrgGoalObjectives
CREATE TABLE dbo.PrgGoalObjective
	(
	ID uniqueidentifier NOT NULL,
	GoalID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	Text text NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoalObjective ADD CONSTRAINT
	PK_PrgGoalObjective PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoalObjective ADD CONSTRAINT
	FK_PrgGoalObjective#Goal#Objectives FOREIGN KEY
	(
	GoalID
	) REFERENCES dbo.PrgGoal
	(
	ID
	) ON DELETE  CASCADE 
GO
CREATE TABLE dbo.PrgGoalObjectiveMastery
	(
	ProgressID uniqueidentifier NOT NULL,
	GoalObjectiveID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoalObjectiveMastery ADD CONSTRAINT
	PK_PrgGoalObjectiveMastery PRIMARY KEY CLUSTERED 
	(
	ProgressID,
	GoalObjectiveID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoalObjectiveMastery ADD CONSTRAINT
	FK_PrgGoalObjective#MasteredOn FOREIGN KEY
	(
	GoalObjectiveID
	) REFERENCES dbo.PrgGoalObjective
	(
	ID
	)
GO
ALTER TABLE dbo.PrgGoalObjectiveMastery ADD CONSTRAINT
	FK_PrgGoalProgress#MasteredObjectives FOREIGN KEY
	(
	ProgressID
	) REFERENCES dbo.PrgGoalProgress
	(
	ID
	) ON DELETE  CASCADE
GO

--##############################################################################
-- move over progress reporting tables
CREATE TABLE dbo.PrgGoalProgressStatus
	(
	ID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoalProgressStatus ADD CONSTRAINT
	PK_PrgGoalProgressStatus PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.PrgGoalProgressPeriod
	(
	ID uniqueidentifier NOT NULL,
	FrequencyID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL,
	IsESY bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoalProgressPeriod ADD CONSTRAINT
	PK_PrgGoalProgressPeriod PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoalProgressPeriod ADD CONSTRAINT
	FK_PrgGoalProgressPeriod#Frequency#Periods FOREIGN KEY
	(
	FrequencyID
	) REFERENCES dbo.PrgGoalProgressFreq
	(
	ID
	) ON DELETE  CASCADE 
GO
CREATE TABLE dbo.PrgGoalProgressTime
	(
	ID uniqueidentifier NOT NULL,
	RosterYearID uniqueidentifier NOT NULL,
	PeriodID uniqueidentifier NOT NULL,
	Date datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoalProgressTime ADD CONSTRAINT
	PK_PrgGoalProgressTime PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.PrgGoalProgressTime ADD CONSTRAINT
	FK_PrgGoalProgressTime#Period#Times FOREIGN KEY
	(
	PeriodID
	) REFERENCES dbo.PrgGoalProgressPeriod
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.PrgGoalProgressTime ADD CONSTRAINT
	FK_PrgGoalProgressTime#RosterYear# FOREIGN KEY
	(
	RosterYearID
	) REFERENCES dbo.RosterYear
	(
	ID
	) 
GO
ALTER TABLE dbo.PrgGoalProgress ADD CONSTRAINT
	FK_PrgGoalProgress#Status# FOREIGN KEY
	(
	StatusID
	) REFERENCES dbo.PrgGoalProgressStatus
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.PrgGoalProgress ADD CONSTRAINT
	FK_PrgGoalProgress#ReportTime#ProgressReports FOREIGN KEY
	(
	ReportTimeID
	) REFERENCES dbo.PrgGoalProgressTime
	(
	ID
	) ON DELETE  CASCADE 
GO


insert PrgGoalProgressStatus
select ID, Sequence, Name
from IepProgRptStatus
GO
--##############################################################################
-- remove objects that are no longer used
ALTER TABLE dbo.IepGoalProgress
	DROP CONSTRAINT FK_IepGoalProgress#Status#
GO
DROP TABLE dbo.IepProgRptStatus
GO
ALTER TABLE dbo.IepProgRptPeriod
	DROP CONSTRAINT FK_IepProgRptPeriod#ReportFrequency#Periods
GO
ALTER TABLE dbo.IepGoals
	DROP CONSTRAINT FK_IepGoals#ReportFrequency#
GO
DROP TABLE dbo.IepProgRptFreq
GO
DROP TABLE dbo.IepGoals
GO
ALTER TABLE dbo.IepProgRptTime
	DROP CONSTRAINT FK_IepProgRptTime#Period#Times
GO
DROP TABLE dbo.IepProgRptPeriod
GO
ALTER TABLE dbo.IepGoalProgress
	DROP CONSTRAINT FK_IepGoalProgress#ReportTime#ProgressReports
GO
DROP TABLE dbo.IepProgRptTime
GO
DROP TABLE dbo.IepGoalProgress
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoal_GetRecordsByInstance]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoal_GetRecordsByInstance]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoalProgress_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoalProgress_DeleteRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoalProgress_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoalProgress_GetAllRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoalProgress_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoalProgress_GetRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoalProgress_GetRecordsByGoal]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoalProgress_GetRecordsByGoal]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoalProgress_GetRecordsByReportTime]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoalProgress_GetRecordsByReportTime]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoalProgress_GetRecordsByStatus]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoalProgress_GetRecordsByStatus]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoalProgress_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoalProgress_InsertRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoalProgress_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoalProgress_UpdateRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoals_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoals_DeleteRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoals_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoals_GetAllRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoals_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoals_GetRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoals_GetRecordsByReportFrequency]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoals_GetRecordsByReportFrequency]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoals_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoals_InsertRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoals_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoals_UpdateRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepMeasurableGoal_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepMeasurableGoal_DeleteRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepMeasurableGoal_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepMeasurableGoal_GetAllRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepMeasurableGoal_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepMeasurableGoal_GetRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepMeasurableGoal_GetRecordsByGoal]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepMeasurableGoal_GetRecordsByGoal]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepMeasurableGoal_GetRecordsByIndDef]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepMeasurableGoal_GetRecordsByIndDef]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepMeasurableGoal_GetRecordsByProbeType]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepMeasurableGoal_GetRecordsByProbeType]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepMeasurableGoal_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepMeasurableGoal_InsertRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepMeasurableGoal_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepMeasurableGoal_UpdateRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptFreq_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptFreq_DeleteRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptFreq_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptFreq_GetAllRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptFreq_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptFreq_GetRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptFreq_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptFreq_InsertRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptFreq_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptFreq_UpdateRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptPeriod_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptPeriod_DeleteRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptPeriod_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptPeriod_GetAllRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptPeriod_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptPeriod_GetRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptPeriod_GetRecordsByReportFrequency]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptPeriod_GetRecordsByReportFrequency]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptPeriod_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptPeriod_InsertRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptPeriod_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptPeriod_UpdateRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptStatus_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptStatus_DeleteRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptStatus_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptStatus_GetAllRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptStatus_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptStatus_GetRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptStatus_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptStatus_InsertRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptStatus_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptStatus_UpdateRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptTime_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptTime_DeleteRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptTime_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptTime_GetAllRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptTime_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptTime_GetRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptTime_GetRecordsByPeriod]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptTime_GetRecordsByPeriod]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptTime_GetRecordsByRosterYear]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptTime_GetRecordsByRosterYear]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptTime_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptTime_InsertRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepProgRptTime_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepProgRptTime_UpdateRecord]
GO

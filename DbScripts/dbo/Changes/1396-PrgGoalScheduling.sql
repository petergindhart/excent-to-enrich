-- refactor ProbeSchedule to Schedule with the expectation of escalation to shared libs in the future
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_ProbeTime#ProbeSchedule#ProbeTimes]') AND type = 'F')
	ALTER TABLE [dbo].[ProbeTime] DROP CONSTRAINT [FK_ProbeTime#ProbeSchedule#ProbeTimes]
GO
IF EXISTS(select * from dbo.syscolumns where id = object_id('[dbo].[ProbeTime]') and name = 'ScheduleID')
	ALTER TABLE [dbo].[ProbeTime] DROP COLUMN [ScheduleID]
GO

ALTER TABLE dbo.ProbeSchedule
	DROP CONSTRAINT FK_ProbeSchedule#ProbeScheduleFrequency#
GO
DROP TABLE dbo.ProbeScheduleFrequency
GO
ALTER TABLE dbo.ProbeScheduleProbeType
	DROP CONSTRAINT FK_ProbeSchedule#ProbeTypes
GO
ALTER TABLE dbo.PrgGoal
	DROP CONSTRAINT FK_PrgGoal#ProbeSchedule#
GO
DROP TABLE dbo.ProbeSchedule
GO
DROP TABLE dbo.ProbeScheduleProbeType
GO
CREATE TABLE dbo.ScheduleFrequency
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ScheduleFrequency ADD CONSTRAINT
	PK_ScheduleFrequency PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.Schedule
	(
	ID uniqueidentifier NOT NULL,
	StartDate datetime NULL,
	EndDate datetime NULL,
	LasOccurrence datetime NULL,
	IsEnabled bit NULL,
	FrequencyID uniqueidentifier NULL,
	FrequencyAmount int NULL,
	WeeklyMon bit NULL,
	WeeklyTue bit NULL,
	WeeklyWed bit NULL,
	WeeklyThu bit NULL,
	WeeklyFri bit NULL,
	WeeklySat bit NULL,
	WeeklySun bit NULL,
	TimesPerDay int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Schedule ADD CONSTRAINT
	PK_Schedule PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.Schedule ADD CONSTRAINT
	FK_Schedule#Frequency# FOREIGN KEY
	(
	FrequencyID
	) REFERENCES dbo.ScheduleFrequency
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.PrgGoal ADD CONSTRAINT
	FK_PrgGoal#ProbeSchedule# FOREIGN KEY
	(
	ProbeScheduleID
	) REFERENCES dbo.Schedule
	(
	ID
	)  
GO

-- Add schedule frequency records
INSERT INTO ScheduleFrequency VALUES('05ED7F8F-D492-4377-85DB-94B36C3F9290', 'Daily')
INSERT INTO ScheduleFrequency VALUES('634EA996-D5FF-4A4A-B169-B8CB70DBBEC2', 'Weekly')
GO

-- drop no longer needed stored procedures
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeSchedule_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeSchedule_DeleteRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeSchedule_DeleteRecordsForProbeScheduleProbeTypeAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeSchedule_DeleteRecordsForProbeScheduleProbeTypeAssociation]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeSchedule_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeSchedule_GetAllRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeSchedule_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeSchedule_GetRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeSchedule_GetRecordsByPrgIep]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeSchedule_GetRecordsByPrgIep]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeSchedule_GetRecordsByProbeScheduleFrequency]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeSchedule_GetRecordsByProbeScheduleFrequency]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeSchedule_GetRecordsForProbeScheduleProbeTypeAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeSchedule_GetRecordsForProbeScheduleProbeTypeAssociation]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeSchedule_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeSchedule_InsertRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeSchedule_InsertRecordsForProbeScheduleProbeTypeAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeSchedule_InsertRecordsForProbeScheduleProbeTypeAssociation]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeSchedule_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeSchedule_UpdateRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeScheduleFrequency_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeScheduleFrequency_DeleteRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeScheduleFrequency_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeScheduleFrequency_GetAllRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeScheduleFrequency_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeScheduleFrequency_GetRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeScheduleFrequency_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeScheduleFrequency_InsertRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeScheduleFrequency_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeScheduleFrequency_UpdateRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeType_DeleteRecordsForProbeScheduleProbeTypeAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeType_DeleteRecordsForProbeScheduleProbeTypeAssociation]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeType_GetRecordsForProbeScheduleProbeTypeAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeType_GetRecordsForProbeScheduleProbeTypeAssociation]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeType_InsertRecordsForProbeScheduleProbeTypeAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeType_InsertRecordsForProbeScheduleProbeTypeAssociation]
GO

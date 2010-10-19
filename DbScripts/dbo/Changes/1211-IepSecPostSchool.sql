
--##############################################################################
-- drop unwanted objects
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepPostSchoolArea_DeleteRecordsForIepPostSchoolAreaAgencyAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepPostSchoolArea_DeleteRecordsForIepPostSchoolAreaAgencyAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepPostSchoolArea_DeleteRecordsForIepPostSchoolAreaCourseAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepPostSchoolArea_DeleteRecordsForIepPostSchoolAreaCourseAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepPostSchoolArea_DeleteRecordsForIepPostSchoolAreaServiceAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepPostSchoolArea_DeleteRecordsForIepPostSchoolAreaServiceAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepPostSchoolArea_InsertRecordsForIepPostSchoolAreaAgencyAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepPostSchoolArea_InsertRecordsForIepPostSchoolAreaAgencyAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepPostSchoolArea_InsertRecordsForIepPostSchoolAreaCourseAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepPostSchoolArea_InsertRecordsForIepPostSchoolAreaCourseAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepPostSchoolArea_InsertRecordsForIepPostSchoolAreaServiceAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepPostSchoolArea_InsertRecordsForIepPostSchoolAreaServiceAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionAgency_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionAgency_DeleteRecord]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionAgency_DeleteRecordsForIepPostSchoolAreaAgencyAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionAgency_DeleteRecordsForIepPostSchoolAreaAgencyAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionAgency_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionAgency_GetAllRecords]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionAgency_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionAgency_GetRecords]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionAgency_GetRecordsByAreaDef]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionAgency_GetRecordsByAreaDef]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionAgency_GetRecordsForIepPostSchoolAreaAgencyAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionAgency_GetRecordsForIepPostSchoolAreaAgencyAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionAgency_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionAgency_InsertRecord]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionAgency_InsertRecordsForIepPostSchoolAreaAgencyAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionAgency_InsertRecordsForIepPostSchoolAreaAgencyAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionAgency_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionAgency_UpdateRecord]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionCourse_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionCourse_DeleteRecord]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionCourse_DeleteRecordsForIepPostSchoolAreaCourseAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionCourse_DeleteRecordsForIepPostSchoolAreaCourseAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionCourse_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionCourse_GetAllRecords]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionCourse_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionCourse_GetRecords]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionCourse_GetRecordsByAreaDef]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionCourse_GetRecordsByAreaDef]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionCourse_GetRecordsForIepPostSchoolAreaCourseAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionCourse_GetRecordsForIepPostSchoolAreaCourseAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionCourse_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionCourse_InsertRecord]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionCourse_InsertRecordsForIepPostSchoolAreaCourseAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionCourse_InsertRecordsForIepPostSchoolAreaCourseAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionCourse_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionCourse_UpdateRecord]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionService_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionService_DeleteRecord]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionService_DeleteRecordsForIepPostSchoolAreaServiceAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionService_DeleteRecordsForIepPostSchoolAreaServiceAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionService_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionService_GetAllRecords]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionService_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionService_GetRecords]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionService_GetRecordsByAreaDef]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionService_GetRecordsByAreaDef]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionService_GetRecordsForIepPostSchoolAreaServiceAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionService_GetRecordsForIepPostSchoolAreaServiceAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionService_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionService_InsertRecord]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionService_InsertRecordsForIepPostSchoolAreaServiceAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionService_InsertRecordsForIepPostSchoolAreaServiceAssociation]
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepTransitionService_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1) DROP PROCEDURE [dbo].[IepTransitionService_UpdateRecord]

DROP TABLE IepPostSchoolAreaCourse
DROP TABLE IepPostSchoolAreaService
DROP TABLE IepPostSchoolAreaAgency
DROP TABLE IepTransitionCourse
DROP TABLE IepTransitionAgency
DROP TABLE IepTransitionService

-- correct codes for IEP.PostSchool.ParentsInformed enum value
update EnumValue set Code = 'Y' where ID = 'A2B683CD-BEA7-4EC8-8BF8-41C1ACBC909E'
update EnumValue set Code = 'N' where ID = '36DB0EF7-2E5A-4A21-BFF7-7087A25EE9BD'
update EnumValue set Code = 'NA' where ID = 'B44F8929-6EDB-44BC-AB85-7D6DC46DFC89'

--##############################################################################
-- create desired schema
CREATE TABLE dbo.IepPostSchoolCourseDef
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolCourseDef ADD CONSTRAINT
	PK_IepPostSchoolCourseDef PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepPostSchoolCourse
	(
	InstanceID uniqueidentifier NOT NULL,
	DefID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolCourse ADD CONSTRAINT
	PK_IepPostSchoolCourse PRIMARY KEY CLUSTERED 
	(
	InstanceID,
	DefID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolCourse ADD CONSTRAINT
	FK_IepPostSchoolConsiderations#CoursesOfStudy FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepPostSchoolConsiderations
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepPostSchoolCourse ADD CONSTRAINT
	FK_IepPostSchoolCourseDef# FOREIGN KEY
	(
	DefID
	) REFERENCES dbo.IepPostSchoolCourseDef
	(
	ID
	) ON DELETE  CASCADE 
GO
CREATE TABLE dbo.IepPostSchoolAgencyDef
	(
	ID uniqueidentifier NOT NULL,
	AreaDefID uniqueidentifier NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolAgencyDef ADD CONSTRAINT
	PK_IepPostSchoolAgencyDef PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolAgencyDef ADD CONSTRAINT
	FK_IepPostSchoolAgencyDef#AreaDef#AgencyDefs FOREIGN KEY
	(
	AreaDefID
	) REFERENCES dbo.IepPostSchoolAreaDef
	(
	ID
	) 
GO
CREATE TABLE dbo.IepPostSchoolServiceDef
	(
	ID uniqueidentifier NOT NULL,
	AreaDefID uniqueidentifier NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolServiceDef ADD CONSTRAINT
	PK_IepPostSchoolServiceDef PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolServiceDef ADD CONSTRAINT
	FK_IepPostSchoolServiceDef#AreaDef#ServiceDefs FOREIGN KEY
	(
	AreaDefID
	) REFERENCES dbo.IepPostSchoolAreaDef
	(
	ID
	) 
GO
CREATE TABLE dbo.IepPostSchoolAgency
	(
	AreaID uniqueidentifier NOT NULL,
	DefID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolAgency ADD CONSTRAINT
	PK_IepPostSchoolAgency PRIMARY KEY CLUSTERED 
	(
	AreaID,
	DefID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolAgency ADD CONSTRAINT
	FK_IepPostSchoolAgencyDef# FOREIGN KEY
	(
	DefID
	) REFERENCES dbo.IepPostSchoolAgencyDef
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepPostSchoolAgency ADD CONSTRAINT
	FK_IepPostSchoolArea#Agencies FOREIGN KEY
	(
	AreaID
	) REFERENCES dbo.IepPostSchoolArea
	(
	ID
	) ON DELETE  CASCADE 
GO
CREATE TABLE dbo.IepPostSchoolService
	(
	AreaID uniqueidentifier NOT NULL,
	DefID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolService ADD CONSTRAINT
	PK_IepPostSchoolService PRIMARY KEY CLUSTERED 
	(
	AreaID,
	DefID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolService ADD CONSTRAINT
	FK_IepPostSchoolServiceDef# FOREIGN KEY
	(
	DefID
	) REFERENCES dbo.IepPostSchoolServiceDef
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepPostSchoolService ADD CONSTRAINT
	FK_IepPostSchoolArea#Services FOREIGN KEY
	(
	AreaID
	) REFERENCES dbo.IepPostSchoolArea
	(
	ID
	) ON DELETE  CASCADE 
GO


CREATE TABLE dbo.PersonRecordExceptionType
	(
	ID char(1) NOT NULL,
	Name varchar(20) NOT NULL,
	Description varchar(100) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PersonRecordExceptionType ADD CONSTRAINT
	PK_PersonRecordExceptionType PRIMARY KEY CLUSTERED 
	(
	ID
	)

GO
CREATE TABLE dbo.PersonRecordExceptionReason
	(
	ID char(1) NOT NULL,
	Name varchar(20) NOT NULL,
	Description varchar(100) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PersonRecordExceptionReason ADD CONSTRAINT
	PK_PersonRecordExceptionReason PRIMARY KEY CLUSTERED 
	(
	ID
	)

GO

CREATE TABLE dbo.PersonRecordException
	(
	ID uniqueidentifier NOT NULL,
	TypeID char(1) NOT NULL,
	ReasonID char(1) NULL,
	Ignore bit NOT NULL,
	FirstSeenDate datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PersonRecordException ADD CONSTRAINT
	DF_PersonRecordException_Ignore DEFAULT 0 FOR Ignore
GO
ALTER TABLE dbo.PersonRecordException ADD CONSTRAINT
	PK_PersonRecordException PRIMARY KEY CLUSTERED 
	(
	ID
	)

GO
ALTER TABLE dbo.PersonRecordException ADD CONSTRAINT
	FK_PersonRecordException#Type#Exceptions FOREIGN KEY
	(
	TypeID
	) REFERENCES dbo.PersonRecordExceptionType
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.PersonRecordException ADD CONSTRAINT
	FK_PersonRecordException#Reason#Exceptions FOREIGN KEY
	(
	ReasonID
	) REFERENCES dbo.PersonRecordExceptionReason
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

CREATE TABLE dbo.PersonRecordExceptionPerson
	(
	ExceptionID uniqueidentifier NOT NULL,
	PersonID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PersonRecordExceptionPerson ADD CONSTRAINT
	PK_PersonRecordExceptionPerson PRIMARY KEY CLUSTERED 
	(
	ExceptionID,
	PersonID
	)

GO
ALTER TABLE dbo.PersonRecordExceptionPerson ADD CONSTRAINT
	FK_PersonRecordExceptionPerson#Person#RecordExceptions FOREIGN KEY
	(
	PersonID
	) REFERENCES dbo.Person
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PersonRecordExceptionPerson ADD CONSTRAINT
	FK_PersonRecordExceptionPerson#Exception#Persons FOREIGN KEY
	(
	ExceptionID
	) REFERENCES dbo.PersonRecordException
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO

INSERT PersonRecordExceptionType VALUES ('D','Duplicate','Indicates duplicate person records')
INSERT PersonRecordExceptionReason VALUES ('N','Name','Only first and last names matched')
INSERT PersonRecordExceptionReason VALUES ('E','Email Address','Email addresses matched as did first and last names')
INSERT PersonRecordExceptionReason VALUES ('H','Home Phone','Home phone numbers matched as did first and last names')
INSERT PersonRecordExceptionReason VALUES ('S','Street Address','Street addresses matched as did first and last names')
INSERT PersonRecordExceptionReason VALUES ('M','Multiple','At least 2 other fields matched as well as first and last names')
INSERT PersonRecordExceptionReason VALUES ('A','All','First Name, Last Name, Email Address, Home Phone, and Street Address all matched')
GO

CREATE TABLE dbo.PersonRecordExceptionMap
	(
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PersonRecordExceptionMap ADD CONSTRAINT
	PK_PersonRecordExceptionMap PRIMARY KEY CLUSTERED 
	(
	DestID
	)

GO
CREATE NONCLUSTERED INDEX IX_PersonRecordExceptionMap_Name ON dbo.PersonRecordExceptionMap
	(
	FirstName,
	LastName
	) 
	
GO
IF  EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[dbo].[SASI_Map_PersonID]') AND name = N'PK_SASI_Map_PersonID')
ALTER TABLE [dbo].[SASI_Map_PersonID] DROP CONSTRAINT [PK_SASI_Map_PersonID]
GO

IF  EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[IC].[Map_PersonID]') AND name = N'PK_Map_PersonID_1')
ALTER TABLE [IC].[Map_PersonID] DROP CONSTRAINT [PK_Map_PersonID_1]
GO

IF  EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[PWRSCH].[Map_PersonID]') AND name = N'PK_Map_PersonID')
ALTER TABLE [PWRSCH].[Map_PersonID] DROP CONSTRAINT [PK_Map_PersonID]
GO
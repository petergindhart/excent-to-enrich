CREATE TABLE dbo.StudentGuardianRelationship
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(40) NOT NULL,
	Description varchar(100) NULL,
	DeletedDate datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.StudentGuardianRelationship ADD CONSTRAINT
	PK_StudentGuardianRelationship PRIMARY KEY CLUSTERED 
	(
	ID
	) 

GO

ALTER TABLE dbo.Person ADD
	Street varchar(50) NULL,
	City varchar(50) NULL,
	Zip varchar(10) NULL,
	State char(2) NULL,
	HomePhone varchar(40) NULL,
	WorkPhone varchar(40) NULL,
	CellPhone varchar(40) NULL,
	ManuallyEntered bit NOT NULL CONSTRAINT DF_Person_ManuallyEntered DEFAULT 0,
	Agency varchar(100) NULL
GO

ALTER TABLE dbo.PrgItemTeamMember ADD
	Agency varchar(100) NULL
GO

CREATE TABLE dbo.StudentGuardian
	(
	ID uniqueidentifier NOT NULL,
	StudentID uniqueidentifier NOT NULL,
	PersonID uniqueidentifier NOT NULL,
	RelationshipID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	DeletedDate datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.StudentGuardian ADD CONSTRAINT
	DF_StudentGuardian_Sequence DEFAULT 0 FOR Sequence
GO
ALTER TABLE dbo.StudentGuardian ADD CONSTRAINT
	PK_StudentGuardian PRIMARY KEY CLUSTERED 
	(
	ID
	) 

GO
ALTER TABLE dbo.StudentGuardian ADD CONSTRAINT
	FK_StudentGuardian#Student#Guardians FOREIGN KEY
	(
	StudentID
	) REFERENCES dbo.Student
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.StudentGuardian ADD CONSTRAINT
	FK_StudentGuardian#Person#StudentRelationships FOREIGN KEY
	(
	PersonID
	) REFERENCES dbo.Person
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.StudentGuardian ADD CONSTRAINT
	FK_StudentGuardian#Relationship# FOREIGN KEY
	(
	RelationshipID
	) REFERENCES dbo.StudentGuardianRelationship
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

CREATE TABLE dbo.SASI_Map_PersonID
	(
	Schoolnum varchar(3) NOT NULL,
	Stulink numeric(18, 0) NOT NULL,
	Sequence numeric(18, 0) NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.SASI_Map_PersonID ADD CONSTRAINT
	PK_SASI_Map_PersonID PRIMARY KEY CLUSTERED 
	(
	DestID
	)

GO

CREATE TABLE dbo.SASI_Map_StudentGuardianID
	(
	StudentID uniqueidentifier NOT NULL,
	PersonID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.SASI_Map_StudentGuardianID ADD CONSTRAINT
	PK_SASI_Map_StudentGuardianID PRIMARY KEY CLUSTERED 
	(
	DestID
	)
GO

CREATE UNIQUE NONCLUSTERED INDEX IX_StudentGuardian_NaturalKey ON dbo.StudentGuardian
	(
	StudentID,
	PersonID,
	RelationshipID
	)
GO

ALTER TABLE Person
	ALTER COLUMN EmailAddress varchar(75)
GO
-- #############################################################################
-- Student
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_StudentID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_StudentID]
GO
CREATE TABLE [EXCENTO].[MAP_StudentID]
	(
	GStudentID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE [EXCENTO].[MAP_StudentID] ADD CONSTRAINT
	[PK_MAP_StudentID] PRIMARY KEY CLUSTERED 
	(
	GStudentID
	) ON [PRIMARY]
GO

-- #############################################################################
-- Involvement
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Map_InvolvementID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[Map_InvolvementID]
GO
CREATE TABLE EXCENTO.Map_InvolvementID
(
	GStudentID uniqueidentifier NOT NULL ,
	DestID uniqueidentifier NOT NULL
)
GO
ALTER TABLE EXCENTO.Map_InvolvementID ADD CONSTRAINT
PK_Map_InvolvementID PRIMARY KEY CLUSTERED 
(
	GStudentID
)
GO

-- #############################################################################
-- IEP
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Map_IepID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[Map_IepID]
GO
CREATE TABLE EXCENTO.Map_IepID
(
	IEPSeqNum int NOT NULL ,
	DestID uniqueidentifier NOT NULL
)
GO
ALTER TABLE EXCENTO.Map_IepID ADD CONSTRAINT
PK_Map_IepID PRIMARY KEY CLUSTERED 
(
	IEPSeqNum
)
GO

-- #############################################################################
-- Version
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Map_VersionID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[Map_VersionID]
GO
CREATE TABLE EXCENTO.Map_VersionID
(
	IEPSeqNum int NOT NULL ,
	DestID uniqueidentifier NOT NULL
)
GO
ALTER TABLE EXCENTO.Map_VersionID ADD CONSTRAINT
PK_Map_VersionID PRIMARY KEY CLUSTERED 
(
	IEPSeqNum
)
GO

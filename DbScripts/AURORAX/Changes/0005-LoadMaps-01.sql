-- #############################################################################
-- Student
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[MAP_StudentID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[MAP_StudentID]
GO
CREATE TABLE [AURORAX].[MAP_StudentID]
	(
	SASID varchar(20) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE [AURORAX].[MAP_StudentID] ADD CONSTRAINT
	[PK_MAP_StudentID] PRIMARY KEY CLUSTERED
	(
	SASID
	) ON [PRIMARY]
GO


-- #############################################################################
-- Involvement
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Map_InvolvementID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[Map_InvolvementID]
GO
CREATE TABLE AURORAX.Map_InvolvementID
(
	SASID uniqueidentifier NOT NULL ,
	DestID uniqueidentifier NOT NULL
)
GO
ALTER TABLE AURORAX.Map_InvolvementID ADD CONSTRAINT
PK_Map_InvolvementID PRIMARY KEY CLUSTERED 
(
	SASID
)
GO

-- #############################################################################
-- IEP
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Map_IepID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[Map_IepID]
GO
CREATE TABLE AURORAX.Map_IepID
(
	SASID varchar(20) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)
GO
ALTER TABLE AURORAX.Map_IepID ADD CONSTRAINT
PK_Map_IepID PRIMARY KEY CLUSTERED 
(
	SASID
)
GO

-- #############################################################################
-- Version
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Map_VersionID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[Map_VersionID]
GO
CREATE TABLE AURORAX.Map_VersionID
(
	SASID varchar(20) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)
GO
ALTER TABLE AURORAX.Map_VersionID ADD CONSTRAINT
PK_Map_VersionID PRIMARY KEY CLUSTERED
(
	SASID
)
GO

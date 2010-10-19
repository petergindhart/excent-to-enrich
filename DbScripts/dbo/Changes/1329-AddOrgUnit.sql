CREATE TABLE dbo.OrgUnitType
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL,
	IsCustom bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.OrgUnitType ADD CONSTRAINT
	PK_OrgUnitType PRIMARY KEY CLUSTERED 
	(
	ID
	)

GO

CREATE TABLE dbo.OrgUnit
	(
	ID uniqueidentifier NOT NULL,
	TypeID uniqueidentifier NOT NULL,
	Name varchar(100) NOT NULL,
	ParentID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.OrgUnit ADD CONSTRAINT
	PK_OrgUnit PRIMARY KEY CLUSTERED 
	(
	ID
	) 

GO
ALTER TABLE dbo.OrgUnit ADD CONSTRAINT
	FK_OrgUnit#Type#OrgUnits FOREIGN KEY
	(
	TypeID
	) REFERENCES dbo.OrgUnitType
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.SystemSettings ADD
	LocalOrgRootID uniqueidentifier NULL
GO
ALTER TABLE dbo.SystemSettings ADD CONSTRAINT
	FK_SystemSettings#LocalOrgRoot# FOREIGN KEY
	(
	LocalOrgRootID
	) REFERENCES dbo.OrgUnit
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

ALTER TABLE dbo.School ADD
	OrgUnitID uniqueidentifier NULL,
	IsLocalOrg bit NOT NULL CONSTRAINT DF_School_IsLocalOrg DEFAULT 1,
	ManuallyEntered bit NOT NULL CONSTRAINT DF_School_ManuallEntered DEFAULT 0
GO
ALTER TABLE dbo.School ADD CONSTRAINT
	FK_School#OrgUnit#Schools FOREIGN KEY
	(
	OrgUnitID
	) REFERENCES dbo.OrgUnit
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

ALTER TABLE dbo.OrgUnit ADD CONSTRAINT
	FK_OrgUnit#Parent#Children FOREIGN KEY
	(
	ParentID
	) REFERENCES dbo.OrgUnit
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

INSERT INTO OrgUnitType VALUES ('420A9663-FFE8-4FF1-B405-1DB1D42B6F8A','District',0)

INSERT INTO OrgUnit
SELECT '6531EF88-352D-4620-AF5D-CE34C54A9F53', '420A9663-FFE8-4FF1-B405-1DB1D42B6F8A', DistrictName, NULL
FROM SystemSettings

UPDATE SystemSettings SET LocalOrgRootID = '6531EF88-352D-4620-AF5D-CE34C54A9F53'

UPDATE School
SET OrgUnitID = '6531EF88-352D-4620-AF5D-CE34C54A9F53'

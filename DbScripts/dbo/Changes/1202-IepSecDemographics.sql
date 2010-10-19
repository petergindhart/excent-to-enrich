CREATE TABLE dbo.IepDistrict
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL,
	IsCustom bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepDistrict ADD CONSTRAINT
	PK_IepDistrict PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepSchool
	(
	ID uniqueidentifier NOT NULL,
	DistrictID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepSchool ADD CONSTRAINT
	PK_IepSchool PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]

GO
ALTER TABLE dbo.IepSchool ADD CONSTRAINT
	FK_IepSchool#District#Schools FOREIGN KEY
	(
	DistrictID
	) REFERENCES dbo.IepDistrict
	(
	ID
	) ON DELETE CASCADE
GO
CREATE TABLE dbo.IepLanguage
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepLanguage ADD CONSTRAINT
	PK_IepLanguage PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepDemographics
	(
	ID uniqueidentifier NOT NULL,
	PrimaryLanguageID uniqueidentifier NULL,
	PrimaryLanguageHomeID uniqueidentifier NULL,
	ServiceDistrictID uniqueidentifier NULL,
	ServiceSchoolID uniqueidentifier NULL,
	HomeDistrictID uniqueidentifier NULL,
	HomeSchoolID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	PK_IepDemographics PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE CASCADE
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#PrimaryLanguage# FOREIGN KEY
	(
	PrimaryLanguageID
	) REFERENCES dbo.IepLanguage
	(
	ID
	)
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#PrimaryLanguageHome# FOREIGN KEY
	(
	PrimaryLanguageHomeID
	) REFERENCES dbo.IepLanguage
	(
	ID
	)
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#ServiceDistrict# FOREIGN KEY
	(
	ServiceDistrictID
	) REFERENCES dbo.IepDistrict
	(
	ID
	)
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#ServiceSchool# FOREIGN KEY
	(
	ServiceSchoolID
	) REFERENCES dbo.IepSchool
	(
	ID
	)
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#HomeDistrict# FOREIGN KEY
	(
	HomeDistrictID
	) REFERENCES dbo.IepDistrict
	(
	ID
	)
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#HomeSchool# FOREIGN KEY
	(
	HomeSchoolID
	) REFERENCES dbo.IepSchool
	(
	ID
	)
GO
CREATE TABLE dbo.IepParent
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	GuardianStudentID uniqueidentifier NULL,
	RelationshipID uniqueidentifier NULL,
	FirstName varchar(50) NOT NULL,
	MiddleName varchar(50) NULL,
	LastName varchar(50) NOT NULL,
	Address varchar(50) NULL,
	City varchar(50) NULL,
	State varchar(2) NULL,
	Email varchar(50) NULL,
	HomePhone varchar(50) NULL,
	CellPhone varchar(50) NULL,
	Employer varchar(50) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepParent ADD CONSTRAINT
	PK_IepParent PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]

GO
ALTER TABLE dbo.IepParent ADD CONSTRAINT
	FK_IepParent#Instance#Parents FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepDemographics
	(
	ID
	) ON DELETE CASCADE
GO


insert PrgSectionType values ( 'F2A1374B-46D6-4E25-9733-D7F3256369ED', 'IEP Demographics', 'iepdemo', 'Demographics', null, null, null, '~/SpecEd/SectionDemographics.ascx' )

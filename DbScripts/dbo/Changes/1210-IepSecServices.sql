CREATE TABLE dbo.IepServiceFrequency
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepServiceFrequency ADD CONSTRAINT
	PK_IepServiceFrequency PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepServiceUnit
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepServiceUnit ADD CONSTRAINT
	PK_IepServiceUnit PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepServiceCategory
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepServiceCategory ADD CONSTRAINT
	PK_IepServiceCategory PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepServiceDef
	(
	ID uniqueidentifier NOT NULL,
	CategoryID uniqueidentifier NOT NULL,
	Name varchar(100) NOT NULL,
	Description text NULL,
	DefaultProviderTitle varchar(100) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepServiceDef ADD CONSTRAINT
	PK_IepServiceDef PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepServiceDef ADD CONSTRAINT
	FK_IepServiceDef#Category#ServiceDefs FOREIGN KEY
	(
	CategoryID
	) REFERENCES dbo.IepServiceCategory
	(
	ID
	) ON DELETE  CASCADE 
GO
CREATE TABLE dbo.IepServices
	(
	ID uniqueidentifier NOT NULL,
	DeliveryStatement text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepServices ADD CONSTRAINT
	PK_IepServices PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepServices ADD CONSTRAINT
	FK_IepServices_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE  CASCADE 
GO
CREATE TABLE dbo.IepService
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	DefID uniqueidentifier NOT NULL,
	DeliveryStatement text NULL,
	IsRelated bit NOT NULL,
	IsDirect bit NOT NULL,
	Location varchar(50) NULL,
	StartDate datetime NULL,
	EndDate datetime NULL,
	Amount int NULL,
	UnitID uniqueidentifier NULL,
	FrequencyID uniqueidentifier NULL,
	ExcludesFromGenEd bit NOT NULL,
	ProviderTitle varchar(100) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepService ADD CONSTRAINT
	PK_IepService PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepService ADD CONSTRAINT
	FK_IepService#Instance#Services FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepServices
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepService ADD CONSTRAINT
	FK_IepService#Def# FOREIGN KEY
	(
	DefID
	) REFERENCES dbo.IepServiceDef
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepService ADD CONSTRAINT
	FK_IepService#Unit# FOREIGN KEY
	(
	UnitID
	) REFERENCES dbo.IepServiceUnit
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepService ADD CONSTRAINT
	FK_IepService#Frequency# FOREIGN KEY
	(
	FrequencyID
	) REFERENCES dbo.IepServiceFrequency
	(
	ID
	) ON DELETE  CASCADE 
GO
CREATE TABLE dbo.IepServiceProvider
	(
	ServiceID uniqueidentifier NOT NULL,
	UserProfileID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepServiceProvider ADD CONSTRAINT
	PK_IepServiceProvider PRIMARY KEY CLUSTERED 
	(
	ServiceID,
	UserProfileID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepServiceProvider ADD CONSTRAINT
	FK_IepService#Providers FOREIGN KEY
	(
	ServiceID
	) REFERENCES dbo.IepService
	(
	ID
	) 
GO
ALTER TABLE dbo.IepServiceProvider ADD CONSTRAINT
	FK_UserProfile#AssignedServices FOREIGN KEY
	(
	UserProfileID
	) REFERENCES dbo.UserProfile
	(
	ID
	) 
GO

insert PrgSectionType values ( '54228EE4-3A8C-4544-9216-D842BE7B0A3B', 'IEP Services', 'iepserv', 'Services', null, null, null, '~/SpecEd/SectionServices.ascx' )

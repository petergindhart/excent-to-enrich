-- Add additional fields to IEP accomodations
CREATE TABLE dbo.IepAccomodationLocation
	(
	ID uniqueidentifier NOT NULL,
	Text varchar(100) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepAccomodationLocation ADD CONSTRAINT
	PK_IepAccomodationLocation PRIMARY KEY CLUSTERED 
	(
	ID
	)
GO
ALTER TABLE dbo.IepAccomodation ADD
	StartDate datetime NULL,
	EndDate datetime NULL,
	LocationID uniqueidentifier NULL,
	Frequency varchar(200) NULL
GO
ALTER TABLE dbo.IepAccomodation ADD CONSTRAINT
	FK_IepAccomodation#Location# FOREIGN KEY
	(
	LocationID
	) REFERENCES dbo.IepAccomodationLocation
	(
	ID
	) ON DELETE  CASCADE 
GO

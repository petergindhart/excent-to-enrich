-- remove IepServiceCategory from services graph
ALTER TABLE dbo.IepServiceDef
	DROP CONSTRAINT FK_IepServiceDef#Category#ServiceDefs
GO
DROP TABLE dbo.IepServiceCategory
GO
ALTER TABLE dbo.IepServiceDef
	DROP COLUMN CategoryID
GO

-- add Sequence, IsEsy to IepService
ALTER TABLE dbo.IepService ADD
	Sequence int NULL
GO
UPDATE dbo.IepService SET Sequence = 0
GO
ALTER TABLE dbo.IepService ALTER COLUMN
	Sequence int NOT NULL
GO

ALTER TABLE IepService ADD
	IsEsy BIT NULL
GO
UPDATE IepService SET IsEsy = 0
GO
ALTER TABLE IepService ALTER COLUMN
	IsEsy BIT NOT NULL
GO

-- add Sequence to IepServiceUnit, IepServiceFrequency
ALTER TABLE IepServiceUnit ADD
	Sequence INT NULL
GO
UPDATE IepServiceUnit SET Sequence = 0
GO
ALTER TABLE IepServiceUnit ALTER COLUMN
	Sequence INT NOT NULL
GO
ALTER TABLE IepServiceFrequency ADD
	Sequence INT NULL
GO
UPDATE IepServiceFrequency SET Sequence = 0
GO
ALTER TABLE IepServiceFrequency ALTER COLUMN
	Sequence INT NOT NULL
GO

-- add Week/Minute factor columns to IepServiceUnit, IepServiceFrequency
ALTER TABLE IepServiceFrequency ADD
	WeekFactor FLOAT NULL
GO
UPDATE IepServiceFrequency SET WeekFactor = 0
GO
ALTER TABLE IepServiceFrequency ALTER COLUMN
	WeekFactor FLOAT NOT NULL
GO
ALTER TABLE IepServiceUnit ADD
	MinuteFactor FLOAT NULL
GO
UPDATE IepServiceUnit SET MinuteFactor = 0
GO
ALTER TABLE IepServiceUnit ALTER COLUMN
	MinuteFactor FLOAT NOT NULL
GO

-- add Unit/Frequency records
insert IepServiceUnit values ( '347548AB-489D-47C4-BE54-63FCF3859FD7', 'minutes', 0, 1 )
insert IepServiceUnit values ( '0C533776-6FC3-49D4-A518-30151CE19948', 'hours', 1, 60 )
insert IepServiceUnit values ( 'B4A83345-B362-4158-AAAD-21756D40857B', 'times', 2, 0 )

insert IepServiceFrequency values ( '71590A00-2C40-40FF-ABD9-E73B09AF46A1', 'daily', 0, 5 )
insert IepServiceFrequency values ( 'A2080478-1A03-4928-905B-ED25DEC259E6', 'weekly', 1, 1 )
insert IepServiceFrequency values ( '3D4B557B-0C2E-4A41-9410-BA331F1D20DD', 'monthly', 2, 0.23 )
insert IepServiceFrequency values ( '5F3A2822-56F3-49DA-9592-F604B0F202C3', 'yearly', 3, 0.02 )
insert IepServiceFrequency values ( 'E2996A26-3DB5-42F3-907A-9F251F58AB09', 'only once', 4, 0.02 )


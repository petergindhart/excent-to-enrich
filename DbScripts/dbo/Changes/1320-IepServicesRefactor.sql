-- Add reference columns to IepService to replace values
-- previously represented by bits.

ALTER TABLE dbo.IepService ADD
	RelatedID uniqueidentifier NULL,
	DirectID uniqueidentifier NULL,
	ExcludesID uniqueidentifier NULL,
	EsyID uniqueidentifier NULL
GO
ALTER TABLE dbo.IepService ADD CONSTRAINT
	FK_IepService#Related# FOREIGN KEY
	(
	RelatedID
	) REFERENCES dbo.EnumValue
	(
	ID
	)
GO
ALTER TABLE dbo.IepService ADD CONSTRAINT
	FK_IepService#Direct# FOREIGN KEY
	(
	DirectID
	) REFERENCES dbo.EnumValue
	(
	ID
	)
GO
ALTER TABLE dbo.IepService ADD CONSTRAINT
	FK_IepService#Excludes# FOREIGN KEY
	(
	ExcludesID
	) REFERENCES dbo.EnumValue
	(
	ID
	)
GO
ALTER TABLE dbo.IepService ADD CONSTRAINT
	FK_IepService#Esy# FOREIGN KEY
	(
	EsyID
	) REFERENCES dbo.EnumValue
	(
	ID
	) 	
GO

-- migrate existing positive values
INSERT EnumType VALUES( 'BDD9A91A-674C-4716-83CC-CDA91B5ED834', 'IEP.ServiceRelated', 0, 0, NULL )
INSERT EnumValue VALUES( '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'BDD9A91A-674C-4716-83CC-CDA91B5ED834', 'Special Education', 'S', 1, 0 )
INSERT EnumValue VALUES( '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'BDD9A91A-674C-4716-83CC-CDA91B5ED834', 'Related', 'R', 1, 1 )

INSERT EnumType VALUES( '8AAE4560-A340-4E96-AD68-257013400684', 'IEP.ServiceDirect', 0, 0, NULL )
INSERT EnumValue VALUES( 'A7061714-ADA3-44F7-8329-159DD4AE2ECE', '8AAE4560-A340-4E96-AD68-257013400684', 'Direct', 'D', 1, 0 )
INSERT EnumValue VALUES( '1A8BF908-E3ED-45B0-8EEC-99CB1AD0806F', '8AAE4560-A340-4E96-AD68-257013400684', 'Indirect', 'I', 1, 1 )
GO

UPDATE IepService SET RelatedID = '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD' WHERE IsRelated = 1
UPDATE IepService SET DirectID = 'A7061714-ADA3-44F7-8329-159DD4AE2ECE' WHERE IsDirect = 1
UPDATE IepService SET ExcludesID = 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' WHERE ExcludesFromGenEd = 1
UPDATE IepService SET EsyID = 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' WHERE IsEsy = 1
GO

-- remove bit columns
ALTER TABLE dbo.IepService
	DROP COLUMN IsRelated
GO
ALTER TABLE dbo.IepService
	DROP COLUMN IsDirect
GO
ALTER TABLE dbo.IepService
	DROP COLUMN ExcludesFromGenEd
GO
ALTER TABLE dbo.IepService
	DROP COLUMN IsEsy
GO

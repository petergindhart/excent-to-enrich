ALTER TABLE dbo.IepAccomodations ADD
	NoneRequired bit NULL
GO

UPDATE dbo.IepAccomodations
SET NoneRequired = 0
GO

ALTER TABLE dbo.IepAccomodations ALTER COLUMN
	NoneRequired bit NOT NULL
GO

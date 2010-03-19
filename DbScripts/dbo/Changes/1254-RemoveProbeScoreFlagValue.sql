IF EXISTS (SELECT * FROM syscolumns WHERE id = OBJECT_ID('dbo.ProbeScore') AND name = 'FlagValue')
	ALTER TABLE dbo.ProbeScore DROP COLUMN FlagValue
GO

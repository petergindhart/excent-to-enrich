
ALTER TABLE PrgSectionType ALTER COLUMN
	Code VARCHAR(25) NULL
GO

ALTER TABLE PrgSectionDef ALTER COLUMN
	Code varchar(25) NULL
GO

IF NOT EXISTS ( SELECT * FROM PrgSectionType WHERE ID = '77C55154-06B5-476D-A15B-02EC0B5165F2' )
	INSERT PrgSectionType VALUES ( '77C55154-06B5-476D-A15B-02EC0B5165F2', 'Custom Form', NULL, 'Custom Form', NULL, NULL, NULL )
GO

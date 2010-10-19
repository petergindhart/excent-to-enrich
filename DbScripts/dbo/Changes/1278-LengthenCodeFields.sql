ALTER TABLE PrgSectionDef ALTER COLUMN
	Code VARCHAR(50) NULL
GO

ALTER TABLE PrgSectionType ALTER COLUMN
	Code VARCHAR(50) NULL
GO

ALTER TABLE FormTemplate ALTER COLUMN
	Code VARCHAR(50) NOT NULL
GO

UPDATE d
SET
	Code = f.Code,
	Title = f.Name
FROM
	PrgSectionDef d JOIN
	FormTemplate f ON d.FormTemplateID = f.Id
GO

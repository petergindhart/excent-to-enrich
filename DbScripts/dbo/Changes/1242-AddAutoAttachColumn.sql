ALTER TABLE PrgDocumentDef
ADD [AutoAttach] BIT NULL
GO

UPDATE PrgDocumentDef SET AutoAttach = 0
GO

ALTER TABLE PrgDocumentDef
ALTER COLUMN [AutoAttach] BIT NOT NULL
GO

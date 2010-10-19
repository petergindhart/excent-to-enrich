ALTER TABLE [dbo].[FileData]
ADD [IsTemporary] BIT NULL
GO

UPDATE FileData SET IsTemporary = 0
GO

ALTER TABLE [dbo].[FileData]
ALTER COLUMN [IsTemporary] BIT NOT NULL
GO

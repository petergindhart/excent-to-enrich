-- Add CollapseByStatus column
ALTER TABLE [dbo].[IndDefinition]
ADD [CollapseByStatus] BIT NULL
GO

UPDATE [IndDefinition] SET [CollapseByStatus] = 1
GO

ALTER TABLE [dbo].[IndDefinition]
ALTER COLUMN [CollapseByStatus] BIT NOT NULL
GO

ALTER TABLE FormTemplateInputItem
ADD IsRequired BIT NULL
GO

UPDATE FormTemplateInputItem SET IsRequired = 0
GO

ALTER TABLE FormTemplateInputItem
ALTER COLUMN IsRequired BIT NOT NULL
GO

ALTER TABLE FormTemplateInputItem
ADD Format VARCHAR(25) NULL
GO

ALTER TABLE FormTemplateInputSelectField
ADD IsMultiLine BIT NULL
GO

UPDATE FormTemplateInputSelectField SET IsMultiLine = 0
GO

ALTER TABLE FormTemplateInputSelectField
ALTER COLUMN IsMultiLine BIT NOT NULL
GO

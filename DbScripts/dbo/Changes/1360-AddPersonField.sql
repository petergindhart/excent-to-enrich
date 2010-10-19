-- Insert person field input type
insert into FormTemplateInputItemType
select '645E64CE-6380-497C-AFC7-A629B23EDD9A', 'Person'

-- Add person field value table
CREATE TABLE [dbo].[FormInputPersonValue](
	[Id] [UNIQUEIDENTIFIER] NOT NULL,
	[ValueID] [UNIQUEIDENTIFIER] NULL,
CONSTRAINT [PK_FormInputUserValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[FormInputPersonValue]
WITH CHECK ADD CONSTRAINT [FK_FormInputPersonValue#Value#]
FOREIGN KEY([ValueId])
REFERENCES [dbo].[Person] ([ID])
GO

ALTER TABLE [dbo].[FormInputPersonValue]
CHECK CONSTRAINT [FK_FormInputPersonValue#Value#]
GO

ALTER TABLE [dbo].[FormInputPersonValue]
WITH NOCHECK ADD CONSTRAINT [FK_FormInputPersonValue_FormInputValue]
FOREIGN KEY([Id])
REFERENCES [dbo].[FormInputValue] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[FormInputPersonValue]
CHECK CONSTRAINT [FK_FormInputPersonValue_FormInputValue]
GO

-- Primary key was named incorrectly
ALTER TABLE [dbo].[FormInputPersonValue] DROP CONSTRAINT [PK_FormInputUserValue]
GO

ALTER TABLE [dbo].[FormInputPersonValue]
ADD CONSTRAINT [PK_FormInputPersonValue]
PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
GO

-- Insert user field input type
insert into FormTemplateInputItemType
select '7F437BDE-91CE-4304-AD03-0CB2097CE62A', 'User'

-- Add user field value table
CREATE TABLE [dbo].[FormInputUserValue](
	[Id] [UNIQUEIDENTIFIER] NOT NULL,
	[ValueID] [UNIQUEIDENTIFIER] NULL,
CONSTRAINT [PK_FormInputUserValue] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[FormInputUserValue]
WITH CHECK ADD CONSTRAINT [FK_FormInputUserValue#Value#]
FOREIGN KEY([ValueId])
REFERENCES [dbo].[UserProfile] ([ID])
GO

ALTER TABLE [dbo].[FormInputUserValue]
CHECK CONSTRAINT [FK_FormInputUserValue#Value#]
GO

ALTER TABLE [dbo].[FormInputUserValue]
WITH NOCHECK ADD CONSTRAINT [FK_FormInputUserValue_FormInputValue]
FOREIGN KEY([Id])
REFERENCES [dbo].[FormInputValue] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[FormInputUserValue]
CHECK CONSTRAINT [FK_FormInputUserValue_FormInputValue]
GO

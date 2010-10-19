DROP TABLE PersonRecordExceptionPerson
GO

DROP TABLE PersonRecordExceptionMap
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_PersonRecordException#PersonA#RecordExceptions]') AND type = 'F')
ALTER TABLE [dbo].[PersonRecordException] DROP CONSTRAINT [FK_PersonRecordException#PersonA#RecordExceptions]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_PersonRecordException#Reason#Exceptions]') AND type = 'F')
ALTER TABLE [dbo].[PersonRecordException] DROP CONSTRAINT [FK_PersonRecordException#Reason#Exceptions]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_PersonRecordException#Type#Exceptions]') AND type = 'F')
ALTER TABLE [dbo].[PersonRecordException] DROP CONSTRAINT [FK_PersonRecordException#Type#Exceptions]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PersonRecordException_Ignore]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PersonRecordException] DROP CONSTRAINT [DF_PersonRecordException_Ignore]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PersonRecordException]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[PersonRecordException]
GO

CREATE TABLE [dbo].[PersonRecordException](
	[ID] [uniqueidentifier] NOT NULL,
	[TypeID] [char](1) NOT NULL,
	[ReasonID] [char](1) NULL,
	[Ignore] [bit] NOT NULL,
	[FirstSeenDate] [datetime] NOT NULL,
	[PersonAID] [uniqueidentifier] NOT NULL,
	[PersonBID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PersonRecordException] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PersonRecordException]  WITH CHECK ADD  CONSTRAINT [FK_PersonRecordException#PersonA#RecordExceptions] FOREIGN KEY([PersonAID])
REFERENCES [dbo].[Person] ([ID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[PersonRecordException] CHECK CONSTRAINT [FK_PersonRecordException#PersonA#RecordExceptions]
GO

ALTER TABLE [dbo].[PersonRecordException]  WITH CHECK ADD  CONSTRAINT [FK_PersonRecordException#Reason#Exceptions] FOREIGN KEY([ReasonID])
REFERENCES [dbo].[PersonRecordExceptionReason] ([ID])
GO

ALTER TABLE [dbo].[PersonRecordException] CHECK CONSTRAINT [FK_PersonRecordException#Reason#Exceptions]
GO

ALTER TABLE [dbo].[PersonRecordException]  WITH CHECK ADD  CONSTRAINT [FK_PersonRecordException#Type#Exceptions] FOREIGN KEY([TypeID])
REFERENCES [dbo].[PersonRecordExceptionType] ([ID])
GO

ALTER TABLE [dbo].[PersonRecordException] CHECK CONSTRAINT [FK_PersonRecordException#Type#Exceptions]
GO

ALTER TABLE [dbo].[PersonRecordException] ADD  CONSTRAINT [DF_PersonRecordException_Ignore]  DEFAULT ((0)) FOR [Ignore]
GO

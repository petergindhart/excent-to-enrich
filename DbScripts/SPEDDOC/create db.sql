
use master
go

create database SpedDoc
go


USE [SPEDDoc]
GO
/****** Object:  Table [dbo].[IEPDoc]    Script Date: 05/25/2012 03:15:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IEPDoc](
	[StudentRefID] [uniqueidentifier] NOT NULL,
	[IEPRefID] [varchar](150) NOT NULL,
	[DocType] [varchar](15) NULL,
	[Content] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO




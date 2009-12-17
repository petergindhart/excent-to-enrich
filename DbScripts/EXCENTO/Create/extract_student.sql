IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Student]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Student]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Student_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[Student_LOCAL]
GO

CREATE TABLE [EXCENTO].[Student_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[StudentID] [nvarchar](20) NOT NULL,
	[Lastname] [nvarchar](25) NULL,
	[Firstname] [nvarchar](20) NULL,
	[Middlename] [nvarchar](12) NULL,
	[Birthdate] [datetime] NULL,
	[Grade] [nvarchar](4) NULL,
	[Sex] [nvarchar](6) NULL,
	[Ethnic] [nvarchar](10) NULL,
	[AlterID] [nvarchar](15) NULL,
	[SpedStat] [int] NULL,
	[ExitDate] [datetime] NULL,
	[ExitCode] [nvarchar](80) NULL,
	[ExitReason] [nvarchar](80) NULL,
	[MedicaidNum] [nvarchar](14) NULL,
	[Notes] [ntext] NULL,
	[StudInterpret] [bit] NULL,
	[EnrollStat] [bit] NULL,
	[Picture] [image] NULL,
	[Reminder] [ntext] NULL,
	[StudLanguage] [nvarchar](80) NULL,
	[SpedExitDate] [datetime] NULL,
	[SpedExitCode] [nvarchar](80) NULL,
	[SpedExitReason] [nvarchar](80) NULL,
	[SchoolID] [nvarchar](10) NULL,
	[DistrictID] [nvarchar](10) NULL,
	[StateCode] [nvarchar](4) NULL,
	[MedicaidEligible] [bit] NULL,
	[MedicaidDate] [datetime] NULL,
	[CreateID] [nvarchar](20) NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[EnrollCode] [nvarchar](20) NULL,
	[YearAge] [int] NULL,
	[Monthage] [int] NULL,
	[Addr1] [nvarchar](60) NULL,
	[Addr2] [nvarchar](60) NULL,
	[City] [nvarchar](25) NULL,
	[Zip] [nvarchar](10) NULL,
	[ResPh] [nvarchar](20) NULL,
	[MedicPA] [bit] NULL,
	[AuthDate] [datetime] NULL,
	[Email] [nvarchar](50) NULL,
	[State] [nvarchar](4) NULL,
	[SCDOE] [nvarchar](20) NULL,
	[DHEC] [nvarchar](20) NULL,
	[SASI] [bit] NULL,
	[StudentIndex] [int] NOT NULL,
	[SubmitMedicaid] [bit] NULL,
	[SubmitReason] [nvarchar](80) NULL,
	[LEP] [nvarchar](2) NULL,
	[SIFID] [char](32) NULL,
	[UniqueStudentID] [nvarchar](20) NULL,
	[MedicaidRefusedDate] [datetime] NULL,
	[HispanicLatino] [bit] NULL,
	[NewRace] [nvarchar](10) NULL,
	[AmerIndOrALNatRace] [bit] NULL,
	[AsianRace] [bit] NULL,
	[BlackOrAfrAmerRace] [bit] NULL,
	[NatHIOrOthPacIslRace] [bit] NULL,
	[WhiteRace] [bit] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[Student]
AS
	SELECT * FROM [EXCENTO].[Student_LOCAL]
GO
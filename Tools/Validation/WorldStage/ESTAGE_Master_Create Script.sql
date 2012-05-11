USE [master]
GO
/****** Object:  Database [ESTAGE_MASTER]    Script Date: 05/10/2012 13:42:15 ******/
CREATE DATABASE [ESTAGE_MASTER] ON  PRIMARY 
( NAME = N'ESTAGE', FILENAME = N'C:\WorldStage\Backup\ESTAGE_MASTER.mdf' , SIZE = 40960KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ESTAGE_log', FILENAME = N'C:\WorldStage\Backup\ESTAGE_MASTER_1.ldf' , SIZE = 353216KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ESTAGE_MASTER] SET COMPATIBILITY_LEVEL = 90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ESTAGE_MASTER].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [ESTAGE_MASTER] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET ANSI_NULLS OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET ANSI_PADDING OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET ARITHABORT OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [ESTAGE_MASTER] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [ESTAGE_MASTER] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [ESTAGE_MASTER] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET  DISABLE_BROKER
GO
ALTER DATABASE [ESTAGE_MASTER] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [ESTAGE_MASTER] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [ESTAGE_MASTER] SET  READ_WRITE
GO
ALTER DATABASE [ESTAGE_MASTER] SET RECOVERY FULL
GO
ALTER DATABASE [ESTAGE_MASTER] SET  MULTI_USER
GO
ALTER DATABASE [ESTAGE_MASTER] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [ESTAGE_MASTER] SET DB_CHAINING OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'ESTAGE_MASTER', N'ON'
GO
USE [ESTAGE_MASTER]
GO
/****** Object:  User [TSSMADO]    Script Date: 05/10/2012 13:42:15 ******/
CREATE USER [TSSMADO] FOR LOGIN [TSSMADO] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[types]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[types](
	[typerefid] [char](38) NOT NULL,
	[typeid] [char](20) NULL,
	[cdesc] [char](100) NULL,
	[notes] [text] NULL,
 CONSTRAINT [PK_types] PRIMARY KEY CLUSTERED 
(
	[typerefid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[types] ([typerefid], [typeid], [cdesc], [notes]) VALUES (N'10F06429-17BA-E011-B467-0003FF5618F6  ', N'ServProv            ', N'ServProv                                                                                            ', N'{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Verdana;}}
\viewkind4\uc1\pard\f0\fs17 
\par }
')
INSERT [dbo].[types] ([typerefid], [typeid], [cdesc], [notes]) VALUES (N'50037312-17BA-E011-B467-0003FF5618F6  ', N'Exit                ', N'Exit                                                                                                ', N'{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Verdana;}}
\viewkind4\uc1\pard\f0\fs17 
\par }
')
INSERT [dbo].[types] ([typerefid], [typeid], [cdesc], [notes]) VALUES (N'51037312-17BA-E011-B467-0003FF5618F6  ', N'LRE                 ', N'LRE                                                                                                 ', N'{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Verdana;}}
\viewkind4\uc1\pard\f0\fs17 
\par }
')
INSERT [dbo].[types] ([typerefid], [typeid], [cdesc], [notes]) VALUES (N'701A3233-11BF-E011-B467-0003FF5618F6  ', N'PostSchoolArea      ', N'PostSchoolArea                                                                                      ', N'{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Verdana;}}
\viewkind4\uc1\pard\f0\fs17 
\par }
')
INSERT [dbo].[types] ([typerefid], [typeid], [cdesc], [notes]) VALUES (N'70802927-11BF-E011-B467-0003FF5618F6  ', N'GoalArea            ', N'GoalArea                                                                                            ', N'{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Verdana;}}
\viewkind4\uc1\pard\f0\fs17 
\par }
')
INSERT [dbo].[types] ([typerefid], [typeid], [cdesc], [notes]) VALUES (N'8051E302-17BA-E011-B467-0003FF5618F6  ', N'Gender              ', N'Gender                                                                                              ', N'{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Verdana;}}
\viewkind4\uc1\pard\f0\fs17 
\par }
')
INSERT [dbo].[types] ([typerefid], [typeid], [cdesc], [notes]) VALUES (N'900132F3-16BA-E011-B467-0003FF5618F6  ', N'Ethnic              ', N'Ethnic                                                                                              ', N'{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Verdana;}}
\viewkind4\uc1\pard\f0\fs17 
\par }
')
INSERT [dbo].[types] ([typerefid], [typeid], [cdesc], [notes]) VALUES (N'B05AD632-17BA-E011-B467-0003FF5618F6  ', N'ServFreq            ', N'ServFreq                                                                                            ', N'{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Verdana;}}
\viewkind4\uc1\pard\f0\fs17 
\par }
')
INSERT [dbo].[types] ([typerefid], [typeid], [cdesc], [notes]) VALUES (N'C059FB1B-17BA-E011-B467-0003FF5618F6  ', N'Service             ', N'Service                                                                                             ', N'{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Verdana;}}
\viewkind4\uc1\pard\f0\fs17 
\par }
')
INSERT [dbo].[types] ([typerefid], [typeid], [cdesc], [notes]) VALUES (N'C0E5060A-17BA-E011-B467-0003FF5618F6  ', N'Disab               ', N'Disab                                                                                               ', N'{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Verdana;}}
\viewkind4\uc1\pard\f0\fs17 
\par }
')
INSERT [dbo].[types] ([typerefid], [typeid], [cdesc], [notes]) VALUES (N'C159FB1B-17BA-E011-B467-0003FF5618F6  ', N'ServLoc             ', N'ServLoc                                                                                             ', N'{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Verdana;}}
\viewkind4\uc1\pard\f0\fs17 
\par }
')
INSERT [dbo].[types] ([typerefid], [typeid], [cdesc], [notes]) VALUES (N'E0604FFC-16BA-E011-B467-0003FF5618F6  ', N'Grade               ', N'Grade                                                                                               ', N'{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Verdana;}}
\viewkind4\uc1\pard\f0\fs17 
\par }
')
/****** Object:  Table [dbo].[TEAMMEMBER]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TEAMMEMBER](
	[refid] [char](38) NOT NULL,
	[e_staffemail] [char](150) NULL,
	[e_studentrefid] [char](150) NULL,
	[e_iscasemanager] [char](1) NULL,
 CONSTRAINT [PK_teammember] PRIMARY KEY CLUSTERED 
(
	[refid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[STUDENT]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[STUDENT](
	[refid] [char](38) NOT NULL,
	[e_studentrefid] [char](150) NULL,
	[e_studentlocalid] [char](50) NULL,
	[e_studentstateid] [char](50) NULL,
	[e_firstname] [char](50) NULL,
	[e_middlename] [char](50) NULL,
	[e_lastname] [char](50) NULL,
	[e_birthdate] [char](10) NULL,
	[e_gender] [char](150) NULL,
	[e_medicaidnumber] [char](50) NULL,
	[e_gradelevelcode] [char](150) NULL,
	[e_servicedistrictcode] [char](10) NULL,
	[e_serviceschoolcode] [char](10) NULL,
	[e_homedistrictcode] [char](10) NULL,
	[e_homeschoolcode] [char](10) NULL,
	[e_ishispanic] [char](1) NULL,
	[e_isamericanindian] [char](1) NULL,
	[e_isasian] [char](1) NULL,
	[e_isblackafricanamerican] [char](1) NULL,
	[e_ishawaiianpacislander] [char](1) NULL,
	[e_iswhite] [char](1) NULL,
	[e_disability1code] [char](150) NULL,
	[e_disability2code] [char](150) NULL,
	[e_disability3code] [char](150) NULL,
	[e_disability4code] [char](150) NULL,
	[e_disability5code] [char](150) NULL,
	[e_disability6code] [char](150) NULL,
	[e_disability7code] [char](150) NULL,
	[e_disability8code] [char](150) NULL,
	[e_disability9code] [char](150) NULL,
	[e_esyelig] [char](1) NULL,
	[e_exitdate] [char](10) NULL,
	[e_exitcode] [char](150) NULL,
	[e_specialedstatus] [char](1) NULL,
 CONSTRAINT [PK_student] PRIMARY KEY CLUSTERED 
(
	[refid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SPEDSTAFFMEMBER]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SPEDSTAFFMEMBER](
	[refid] [char](38) NOT NULL,
	[e_staffemail] [char](150) NULL,
	[e_firstname] [char](50) NULL,
	[e_lastname] [char](50) NULL,
	[e_enrichrole] [char](50) NULL,
 CONSTRAINT [PK_spedstaffmember] PRIMARY KEY CLUSTERED 
(
	[refid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SERVICE]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SERVICE](
	[refid] [char](38) NOT NULL,
	[e_servicetype] [char](20) NULL,
	[e_servicerefid] [char](150) NULL,
	[e_ieprefid] [char](150) NULL,
	[e_servicedefinitioncode] [char](150) NULL,
	[e_begindate] [char](10) NULL,
	[e_enddate] [char](10) NULL,
	[e_isrelated] [char](1) NULL,
	[e_isdirect] [char](1) NULL,
	[e_excludesfromgened] [char](1) NULL,
	[e_servicelocationcode] [char](150) NULL,
	[e_serviceprovidertitlecode] [char](150) NULL,
	[e_sequence] [int] NULL,
	[e_isesy] [char](1) NULL,
	[e_servicetime] [int] NULL,
	[e_servicefrequencycode] [char](150) NULL,
	[e_serviceproviderssn] [char](11) NULL,
	[e_staffemail] [char](150) NULL,
	[e_serviceareatext] [char](254) NULL,
 CONSTRAINT [PK_service] PRIMARY KEY CLUSTERED 
(
	[refid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SELECTLISTS]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SELECTLISTS](
	[refid] [char](38) NOT NULL,
	[e_type] [char](20) NULL,
	[e_subtype] [char](20) NULL,
	[e_enrichid] [char](150) NULL,
	[e_statecode] [char](10) NULL,
	[e_legacyspedcode] [char](150) NULL,
	[e_enrichlabel] [char](254) NULL,
 CONSTRAINT [PK_selectlists] PRIMARY KEY CLUSTERED 
(
	[refid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SCHOOL]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SCHOOL](
	[refid] [char](38) NOT NULL,
	[e_schoolcode] [char](10) NULL,
	[e_schoolname] [char](254) NULL,
	[e_districtcode] [char](150) NULL,
	[e_minutesperweek] [int] NULL,
 CONSTRAINT [PK_school] PRIMARY KEY CLUSTERED 
(
	[refid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OBJECTIVE]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OBJECTIVE](
	[refid] [char](38) NOT NULL,
	[e_objectiverefid] [char](150) NULL,
	[e_goalrefid] [char](150) NULL,
	[e_sequence] [int] NULL,
	[e_objtext] [text] NULL,
 CONSTRAINT [PK_objective] PRIMARY KEY CLUSTERED 
(
	[refid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[itable]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[itable](
	[itableid] [char](38) NOT NULL,
	[tdesc] [char](100) NULL,
	[istatus] [char](10) NULL,
 CONSTRAINT [PK_itable] PRIMARY KEY CLUSTERED 
(
	[itableid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[iStudent]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iStudent](
	[IStudentRefID] [char](38) NOT NULL,
	[StudentRefID] [char](50) NULL,
	[LastName] [char](50) NULL,
	[FirstName] [char](50) NULL,
	[BirthDate] [char](10) NULL,
	[IEPRefID] [char](50) NULL,
 CONSTRAINT [PK_iStudent] PRIMARY KEY CLUSTERED 
(
	[IStudentRefID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_iStudent_IEPRefID] ON [dbo].[iStudent] 
(
	[IEPRefID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_iStudent_RefID] ON [dbo].[iStudent] 
(
	[StudentRefID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IEP]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IEP](
	[refid] [char](38) NOT NULL,
	[e_ieprefid] [char](150) NULL,
	[e_studentrefid] [char](150) NULL,
	[e_iepmeetdate] [char](10) NULL,
	[e_iepstartdate] [char](10) NULL,
	[e_iependdate] [char](10) NULL,
	[e_nextreviewdate] [char](10) NULL,
	[e_initialevaluationdate] [char](10) NULL,
	[e_latestevaluationdate] [char](10) NULL,
	[e_nextevaluationdate] [char](10) NULL,
	[e_consentforservicesdate] [char](10) NULL,
	[e_lreagegroup] [char](3) NULL,
	[e_lrecode] [char](150) NULL,
	[e_minutesperweek] [int] NULL,
	[e_servicedeliverystatement] [text] NULL,
 CONSTRAINT [PK_iep] PRIMARY KEY CLUSTERED 
(
	[refid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ibatch]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ibatch](
	[ibatchid] [char](38) NOT NULL,
	[rundate] [smalldatetime] NULL,
	[runstart] [datetime] NULL,
	[runend] [datetime] NULL,
	[result] [char](10) NULL,
	[notes] [char](254) NULL,
	[success] [float] NULL,
	[fail] [float] NULL,
	[total] [float] NULL,
	[direction] [char](1) NULL,
 CONSTRAINT [PK_ibatch] PRIMARY KEY CLUSTERED 
(
	[ibatchid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_rundate] ON [dbo].[ibatch] 
(
	[rundate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_runstart] ON [dbo].[ibatch] 
(
	[runstart] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GOAL]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GOAL](
	[refid] [char](38) NOT NULL,
	[e_goalrefid] [char](150) NULL,
	[e_ieprefid] [char](150) NULL,
	[e_sequence] [int] NULL,
	[e_gareading] [char](1) NULL,
	[e_gawriting] [char](1) NULL,
	[e_gamath] [char](1) NULL,
	[e_gaother] [char](1) NULL,
	[e_gaemotional] [char](1) NULL,
	[e_gaindependent] [char](1) NULL,
	[e_gahealth] [char](1) NULL,
	[e_gacommunication] [char](1) NULL,
	[e_psinstruction] [char](1) NULL,
	[e_pscommunity] [char](1) NULL,
	[e_psadult] [char](1) NULL,
	[e_psvocational] [char](1) NULL,
	[e_psrelated] [char](1) NULL,
	[e_psemployment] [char](1) NULL,
	[e_psdailyliving] [char](1) NULL,
	[e_isesy] [char](1) NULL,
	[e_goalstatement] [text] NULL,
 CONSTRAINT [PK_goal] PRIMARY KEY CLUSTERED 
(
	[refid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DISTRICT]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DISTRICT](
	[refid] [char](38) NOT NULL,
	[e_districtcode] [char](10) NULL,
	[e_districtname] [char](254) NULL,
 CONSTRAINT [PK_district] PRIMARY KEY CLUSTERED 
(
	[refid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[codetrans]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[codetrans](
	[refid] [char](38) NOT NULL,
	[typeid] [char](20) NULL,
	[importid] [char](150) NULL,
	[enrichid] [char](150) NULL,
	[cdesc] [char](150) NULL,
	[stateid] [char](150) NULL,
 CONSTRAINT [PK_codetrans] PRIMARY KEY CLUSTERED 
(
	[refid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_typeid] ON [dbo].[codetrans] 
(
	[typeid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[iGoal]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iGoal](
	[IGoalRefID] [char](38) NOT NULL,
	[GoalRefID] [char](50) NULL,
	[IEPRefID] [char](50) NULL,
 CONSTRAINT [PK_iGoal] PRIMARY KEY CLUSTERED 
(
	[IGoalRefID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_iGoal_GoalRefID] ON [dbo].[iGoal] 
(
	[GoalRefID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_iGoal_IEPRefID] ON [dbo].[iGoal] 
(
	[IEPRefID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ifile]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ifile](
	[ifileid] [char](38) NOT NULL,
	[ibatchid] [char](38) NULL,
	[runorder] [decimal](4, 0) NULL,
	[itableid] [char](38) NULL,
	[fileloc] [char](254) NULL,
	[result] [char](10) NULL,
	[notes] [char](254) NULL,
	[runstart] [smalldatetime] NULL,
	[runend] [smalldatetime] NULL,
	[success] [float] NULL,
	[fail] [float] NULL,
	[total] [float] NULL,
 CONSTRAINT [PK_ifile] PRIMARY KEY CLUSTERED 
(
	[ifileid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_ibatchid] ON [dbo].[ifile] 
(
	[ibatchid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_itableid] ON [dbo].[ifile] 
(
	[itableid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[iline]    Script Date: 05/10/2012 13:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iline](
	[ilineid] [char](38) NOT NULL,
	[ifileid] [char](38) NOT NULL,
	[linenum] [float] NULL,
	[linetext] [text] NULL,
	[result] [char](10) NULL,
	[notes] [text] NULL,
	[success] [float] NULL,
	[fail] [float] NULL,
	[total] [float] NULL,
	[validtype] [char](12) NULL,
	[errlevel] [char](1) NULL,
 CONSTRAINT [PK_iline] PRIMARY KEY CLUSTERED 
(
	[ilineid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_ifileid] ON [dbo].[iline] 
(
	[ifileid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_linenum] ON [dbo].[iline] 
(
	[linenum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  ForeignKey [FK_ifile_ibatch]    Script Date: 05/10/2012 13:42:15 ******/
ALTER TABLE [dbo].[ifile]  WITH CHECK ADD  CONSTRAINT [FK_ifile_ibatch] FOREIGN KEY([ibatchid])
REFERENCES [dbo].[ibatch] ([ibatchid])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ifile] CHECK CONSTRAINT [FK_ifile_ibatch]
GO
/****** Object:  ForeignKey [FK_ifile_itable]    Script Date: 05/10/2012 13:42:15 ******/
ALTER TABLE [dbo].[ifile]  WITH CHECK ADD  CONSTRAINT [FK_ifile_itable] FOREIGN KEY([itableid])
REFERENCES [dbo].[itable] ([itableid])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ifile] CHECK CONSTRAINT [FK_ifile_itable]
GO
/****** Object:  ForeignKey [FK_iline_ifile]    Script Date: 05/10/2012 13:42:15 ******/
ALTER TABLE [dbo].[iline]  WITH CHECK ADD  CONSTRAINT [FK_iline_ifile] FOREIGN KEY([ifileid])
REFERENCES [dbo].[ifile] ([ifileid])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[iline] CHECK CONSTRAINT [FK_iline_ifile]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[IEPPresLevelTbl]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[IEPPresLevelTbl]
GO

if exists (select 1 from dbo.sysobjects where id = OBJECT_ID(N'[EXCENTO].[IEPPresLevelTbl_LOCAL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [EXCENTO].[IEPPresLevelTbl_LOCAL]
go

create table EXCENTO.IEPPresLevelTbl_LOCAL (
GStudentID	uniqueidentifier NOT NULL,
IEPPLSeqNum	bigint NOT NULL,
AreaID	bigint,
PresentLvl	ntext,
EduNeed	ntext,
DomainDesc	nvarchar(80),
RelData	ntext,
Strength	ntext,
Diagnosis	bit,
DiagnosisTxt	ntext,
Physician	nvarchar(65),
VisionDate	datetime,
VisionResult	int,
HearDate	datetime,
HearResult	int,
Corrected	nvarchar(80),
Sender	nvarchar(65),
Title	nvarchar(60),
CreateID	nvarchar(20),
CreateDate	datetime,
ModifyID	nvarchar(20),
ModifyDate	datetime,
DeleteID	nvarchar(20),
Deletedate	datetime,
Del_Flag	bit,
FBABIP	int,
ServType	int,
Active	bit)
GO

create view [EXCENTO].[IEPPresLevelTbl]
as
select * from [EXCENTO].IEPPresLevelTbl_LOCAL
go

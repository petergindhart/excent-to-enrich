IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[SC_PlaceHistoryTbl]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[SC_PlaceHistoryTbl]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[SC_PlaceHistoryTbl_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[SC_PlaceHistoryTbl_LOCAL]
GO

CREATE TABLE [EXCENTO].[SC_PlaceHistoryTbl_LOCAL](
GStudentID	uniqueidentifier NOT NULL,
RecNum	bigint NOT NULL,
PlaceDate	datetime,
TeacherRecord	uniqueidentifier,
StudStatus	nvarchar(80),
SpecialAssignSch	nvarchar(80),
PlaceType	nvarchar(80),
PlaceStatus	nvarchar(80),
LREMovement	nvarchar(80),
BeginDate	datetime,
EndDate	datetime,
Disability1	nvarchar(80),
DisabilityRank1	nvarchar(80),
DisabilityTeacher1	uniqueidentifier,
DisabilityEvalDate1	datetime,
DisabilityReEvalDate1	datetime,
Disability2	nvarchar(80),
DisabilityTeacher2	uniqueidentifier,
DisabilityEvalDate2	datetime,
DisabilityReEvalDate2	datetime,
Disability3	nvarchar(80),
DisabilityTeacher3	uniqueidentifier,
DisabilityEvalDate3	datetime,
DisabilityReEvalDate3	datetime,
CreateID	nvarchar(20),
CreateDate	datetime,
ModifyID	nvarchar(20),
ModifyDate	datetime,
DeleteID	nvarchar(20),
DeleteDate	datetime,
Del_Flag	bit,
InitialEligDate	datetime,
AnticipatedDate	datetime,
LastEvalDate	datetime,
SchoolID	nvarchar(10),
SpedExitReason	nvarchar(80),
SpedExitCode	nvarchar(80),
SpedExitDate	datetime,
SpedStat	int,
SchoolName	nvarchar(50),
LimEngProf	bit,
Model	int,
PrePlacement	int,
EdPlacement	int,
HomeHosPlace	int,
SecondDisabExitDate	datetime,
SecondDisabExitCode	nvarchar(80),
SecondDisabExitReason	nvarchar(80),
ThirdDisabExitDate	datetime,
ThirdDisabExitCode	nvarchar(80),
ThirdDisabExitReason	nvarchar(80),
TeamMeetingDate	datetime,
Notations	ntext,
ParentalConsentToEvalDate	datetime,
BabyNetReferral	bit,
BabyNetReferralDate	datetime,
IEPInPlace	bit,
WhyPlacementExceeded	ntext,
PlacementDate	datetime,
DistrictDiplomaEarned	int,
StActionType	nvarchar(15),
Init60Eval	bit,
ConcInit60Eval	bit
) ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[SC_PlaceHistoryTbl]
AS
	SELECT * FROM [EXCENTO].[SC_PlaceHistoryTbl_LOCAL]
GO


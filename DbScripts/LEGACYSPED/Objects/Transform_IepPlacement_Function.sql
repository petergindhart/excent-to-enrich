IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepPlacement_Function'))
DROP FUNCTION LEGACYSPED.Transform_IepPlacement_Function
GO
CREATE FUNCTION LEGACYSPED.Transform_IepPlacement_Function ()  
	RETURNS @p table(
		IepRefID varchar(150), 
		DestID uniqueidentifier,
		InstanceID uniqueidentifier,
		TypeID uniqueidentifier,
		OptionID uniqueidentifier,
		SourceID uniqueidentifier,
		AsOfDate datetime,
		IsDecOneCount bit,
		MinutesInstruction int,
		DoNotTouch bit
	) AS  
	BEGIN 

declare @Transform_IepLeastRestrictiveEnvironment  table (
IepRefId	varchar(150),
AgeGroup	varchar(3),
LRECode	varchar(150),
DestID	uniqueidentifier NOT NULL,
MinutesInstruction	int,
DoNotTouch	bigint)

--declare @Transform_IepPlacementOption  table (
--PlacementTypeCode	varchar(20),
--PlacementOptionCode	varchar(150),
--TypeID	uniqueidentifier,
--DestID	varchar(150),
--StateCode	varchar(10),
--Sequence	int NOT NULL,
--Text	varchar(500) NOT NULL,
--MinPercentGenEd	int,
--MaxPercentGenEd	int,
--DeletedDate	datetime)

declare @Transform_PrgIep  table (
StudentRefID	varchar(150) NOT NULL,
IEPRefID	varchar(150),
DestID	uniqueidentifier,
DoNotTouch	bigint,
DefID	varchar(36) NOT NULL,
StudentID	uniqueidentifier,
MeetDate	datetime,
StartDate	datetime,
EndDate	datetime,
ItemOutcomeID	uniqueidentifier,
CreatedDate	varchar(8) NOT NULL,
CreatedBy	varchar(36) NOT NULL,
EndedDate	datetime,
EndedBy	uniqueidentifier,
SchoolID	uniqueidentifier,
GradeLevelID	uniqueidentifier,
InvolvementID	uniqueidentifier,
StartStatusID	varchar(36) NOT NULL,
EndStatusID	uniqueidentifier,
PlannedEndDate	datetime,
IsEnded	bit,
Revision	bigint,
IsApprovalPending	bit,
ApprovedDate	datetime,
ApprovedByID	uniqueidentifier,
IsTransitional	bit,
VersionDestID	uniqueidentifier,
VersionFinalizedDate	datetime,
CreatedByID	varchar(36) NOT NULL,
AgeGroup	varchar(3),
LRECode	varchar(150),
MinutesPerWeek	int,
ConsentForServicesDate	datetime)

insert @Transform_IepLeastRestrictiveEnvironment
select * from LEGACYSPED.Transform_IepLeastRestrictiveEnvironment

insert @Transform_PrgIep
select * from LEGACYSPED.Transform_PrgIep

insert @p
select * from LEGACYSPED.Transform_IepPlacement

	return 
	END
GO


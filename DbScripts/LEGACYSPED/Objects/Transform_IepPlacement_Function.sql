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
		UseLimitedValidation bit,
		DoNotTouch bit
	) AS  
	BEGIN 

---------------------------------------------- test

--declare @p table (
--		IepRefID varchar(150), 
--		DestID uniqueidentifier,
--		InstanceID uniqueidentifier,
--		TypeID uniqueidentifier,
--		OptionID uniqueidentifier,
--		SourceID uniqueidentifier,
--		AsOfDate datetime,
--		IsDecOneCount bit,
--		MinutesInstruction int,
--		UseLimitedValidation bit,
--		DoNotTouch bit
--	)
---------------------------------------------- test


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
ConsentForServicesDate	datetime,
ConsentForEvaluationDate	datetime,
ServiceDeliveryStatement varchar(8000),
OID uniqueidentifier,
SpecialEdStatus char(1)
)

insert @Transform_IepLeastRestrictiveEnvironment
select * from LEGACYSPED.Transform_IepLeastRestrictiveEnvironment

insert @Transform_PrgIep
select * from LEGACYSPED.Transform_PrgIep

insert @p
-- select * from LEGACYSPED.Transform_IepPlacement
	SELECT 
		lre.IepRefID, 
		DestID = m.DestID,
		InstanceID = lre.DestID,
		TypeID = pt.ID,
		OptionID = case when po.TypeID = pt.ID then po.DestID else NULL End,
		SourceID = 'C9967875-E09B-4F3E-BE00-5BF2A97C7DAD', -- User Created:  Per Pete, use this in all cases as of 10/30/2012
		AsOfDate = CASE
			WHEN piep.StartDate >= DATEADD(YEAR, pt.MinAge, stu.DOB) THEN piep.StartDate
			ELSE DATEADD(YEAR, pt.MinAge, stu.DOB)
			END,
		IsDecOneCount = case when po.TypeID = pt.ID then 1 else 0 End,
		MinutesInstruction = lre.MinutesInstruction,
		UseLimitedValidation = cast (1 as bit),
		lre.DoNotTouch
	FROM @Transform_IepLeastRestrictiveEnvironment lre JOIN -- left join resulted in more rows returned.  did not investigate.  gg
		LEGACYSPED.Transform_IepPlacementOption po on 
			isnull(lre.AgeGroup,'a') = isnull(po.PlacementTypeCode,'b') AND
			isnull(lre.LRECode,'a') = isnull(po.PlacementOptionCode,'b') LEFT JOIN 
		LEGACYSPED.MAP_IepPlacementID m on 
			isnull(m.IepRefID,'a') = isnull(lre.IepRefID,'b') and 
			isnull(m.TypeID,'00000000-0000-0000-0000-000000000000') = isnull(po.TypeID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF') LEFT JOIN 
		dbo.IepPlacementType pt on po.TypeID = pt.ID left join
		dbo.IepPlacement t on isnull(lre.DestID,'00000000-0000-0000-0000-000000000000') = isnull(t.InstanceID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF')  LEFT JOIN  -- 1:24 for 23556 records.  Attempts to address performance issues not working well
		@Transform_PrgIep piep ON isnull(piep.IEPRefID,'a') =isnull(m.IepRefID,'b') LEFT JOIN  --For new LRE model
		dbo.Student stu ON stu.ID = isnull(piep.StudentID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF')
	return 
	END
GO


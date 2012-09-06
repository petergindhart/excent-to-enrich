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
		IsEnabled bit,
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
	SELECT * FROM (SELECT 
		lre.IepRefID, 
		DestID = m.DestID,
		InstanceID = lre.DestID,
		TypeID = pt.ID,
		OptionID = case when po.TypeID = pt.ID then po.DestID else NULL End,
		IsEnabled = case when po.TypeID = pt.ID then 1 else 0 End,
		SourceID = '3C5BFC1F-B3E6-4E69-BC32-FCFBA2E8185E', -- StartDate:  Per Pete, use this in all cases as of 9/5/2012
			--CASE
			--WHEN piep.StartDate >=  DATEADD(YEAR, pt.MinAge, stu.DOB) 
			--	 THEN '3C5BFC1F-B3E6-4E69-BC32-FCFBA2E8185E' -- StartDate
				 --ELSE '173E47D8-5B63-4A69-9430-8064759AAA47' -- Aged Up
		   --END,
		AsOfDate = CASE
            WHEN piep.StartDate >= DATEADD(YEAR, pt.MinAge, stu.DOB) THEN piep.StartDate
            ELSE DATEADD(YEAR, pt.MinAge, stu.DOB)
			END,
		IsDecOneCount = case when po.TypeID = pt.ID then 1 else 0 End,
		MinutesInstruction = lre.MinutesInstruction,
		lre.DoNotTouch
	FROM dbo.IepPlacementType pt CROSS JOIN
		LEGACYSPED.Transform_IepLeastRestrictiveEnvironment lre LEFT JOIN -- attempting to address a performance issue when treating nulls in queries referencing this view
		LEGACYSPED.Transform_IepPlacementOption po on 
			isnull(lre.AgeGroup,'a') = isnull(po.PlacementTypeCode,'b') AND
			isnull(lre.LRECode,'a') = isnull(po.PlacementOptionCode,'b') LEFT JOIN 
		LEGACYSPED.MAP_IepPlacementID m on 
			isnull(m.IepRefID,'a') = isnull(lre.IepRefID,'b') and 
			isnull(m.TypeID,'00000000-0000-0000-0000-000000000000') = isnull(pt.ID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF') LEFT JOIN 
		dbo.IepPlacement t on isnull(lre.DestID,'00000000-0000-0000-0000-000000000000') = isnull(t.ID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF')  LEFT JOIN  -- 1:24 for 23556 records.  Attempts to address performance issues not working well
		LEGACYSPED.Transform_PrgIep piep ON isnull(piep.IEPRefID,'a') =isnull(m.IepRefID,'b') LEFT JOIN  --For new LRE model
		dbo.Student stu ON stu.ID = isnull(piep.StudentID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF')) tieppl
		WHERE tieppl.IsEnabled = 1

	return 
	END
GO



--LEGACYSPED.Transform_IepLeastRestrictiveEnvironment
--LEGACYSPED.Transform_IepPlacementOption
--LEGACYSPED.Transform_PrgIep

--select c.name, t.name+
--	case when t.name like '%char%' then '('+convert(varchar, c.max_length)+')' else '' end+
--	case when c.is_nullable = 0 then '	NOT NULL,' else ',' end
--	from sys.schemas s 
--left join sys.objects o on s.schema_id = o.schema_id
--left join sys.columns c on o.object_id = c.object_id
--left join sys.types t on c.user_type_id = t.user_type_id
--where s.name = 'LEGACYSPED'
--and o.name = 'Transform_PrgIep' -- and c.name = 'sourcetbl'
--order by c.column_id


-- #############################################################################
-- ServicePlan
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_ServicePlanID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_ServicePlanID
	(
	ServiceRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)

ALTER TABLE LEGACYSPED.MAP_ServicePlanID ADD CONSTRAINT
	PK_MAP_ServicePlanID PRIMARY KEY CLUSTERED
	(
	ServiceRefID
	)
END

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_Person_TypeID_Deleted_EmailAddress')
CREATE NONCLUSTERED INDEX IX_LEGACYSPED_Person_TypeID_Deleted_EmailAddress ON [dbo].[Person] ([TypeID],[Deleted],[EmailAddress])

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_Service_LOCAL_IepRefID')
CREATE NONCLUSTERED INDEX IX_LEGACYSPED_Service_LOCAL_IepRefID ON [LEGACYSPED].[Service_LOCAL] ([IepRefId]) INCLUDE ([ServiceType],[ServiceRefId],[ServiceDefinitionCode],[ServiceLocationCode],[ServiceProviderTitleCode],[ServiceFrequencyCode],[StaffEmail])

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_MAP_ServicePlanID_DestID')
create index IX_LEGACYSPED_MAP_ServicePlanID_DestID on LEGACYSPED.MAP_ServicePlanID (DestID)
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepService') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepService
GO

create view LEGACYSPED.Transform_IepService
as
select
	v.ServiceRefId,
	iep.IepRefId,
	m.DestID,
-- ServicePlan
	DefId = sdm.DestId,
	InstanceID = sec.ID,
	iep.StudentID,
	StartDate = cast(v.BeginDate as datetime),
	EndDate = cast(v.EndDate as datetime),
	Amount = case v.ServiceTime when 0 then 1 else v.ServiceTime end, 
	FrequencyId = freq.DestID,
	UnitID = case v.ServiceTime when 0 then 'B4A83345-B362-4158-AAAD-21756D40857B' else '347548AB-489D-47C4-BE54-63FCF3859FD7' end, -- we request time from customer in minutes -- select * from ServiceUnit where ID = '347548AB-489D-47C4-BE54-63FCF3859FD7'
	ProviderTitleID = ttl.DestID,
	Sequence = (
		SELECT count(*)
		FROM LEGACYSPED.Service
		WHERE IepRefID = v.IepRefID AND
		ServiceRefID < v.ServiceRefID
		),
	ServiceTypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784',
-- IepServicePlan.  The case statements assume source data indicates Y or N (this is validated in the data validation tool)
	CategoryCode = v.ServiceType,
	CategoryID = cat.DestID,
	DirectID = case when IsDirect = 'Y' then 'A7061714-ADA3-44F7-8329-159DD4AE2ECE' else '1A8BF908-E3ED-45B0-8EEC-99CB1AD0806F' end, -- A7061714-ADA3-44F7-8329-159DD4AE2ECE	Direct, 1A8BF908-E3ED-45B0-8EEC-99CB1AD0806F	Indirect
	ExcludesID = case when ExcludesFromGenEd = 'Y' then '493713FB-6071-42D4-B46A-1B09037C1F8B' else '235C3167-A3E6-4D1D-8AAB-0B2B57FD5160' end, -- 235C3167-A3E6-4D1D-8AAB-0B2B57FD5160	Inside, 493713FB-6071-42D4-B46A-1B09037C1F8B	Outside
	EsyID = case when IsEsy = 'Y' then 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' else 'F7E20A86-2709-4170-9810-15B601C61B79' end, -- F7E20A86-2709-4170-9810-15B601C61B79	N, B76DDCD6-B261-4D46-A98E-857B0A814A0C	Y
	DeliveryStatement = v.ServiceAreaText,
	UseAmountRange = cast(0 as bit)
-- ServiceSchedule
	--ServiceSchedueDestID = ssm.DestID,
	--ProviderID = prv.UserProfileID,
	--Name = CAST(null as varchar),
	--LocationId = loc.DestID,
	--LocationDescription = loc.Name 
FROM
	LEGACYSPED.Transform_PrgIep iep JOIN
	PrgSection sec ON
		sec.ItemID = iep.DestID AND
		iep.VersionDestID = sec.VersionID AND
		sec.DefID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F' JOIN --IEP Services
	LEGACYSPED.Service v on iep.IepRefId = v.IepRefId LEFT JOIN
	LEGACYSPED.MAP_ServicePlanID m on v.ServiceRefID = m.ServiceRefID LEFT JOIN 
	LEGACYSPED.Transform_ServiceDef sdm on 
		v.ServiceType = isnull(sdm.ServiceCategoryCode,'') AND
		v.ServiceDefinitionCode = isnull(sdm.ServiceDefCode, 'ZZZ') LEFT JOIN
	--LEGACYSPED.Transform_PrgLocation loc on v.ServiceLocationCode = loc.ServiceLocationCode LEFT JOIN 
	LEGACYSPED.Transform_ServiceFrequency freq on isnull(v.ServiceFrequencyCode, 'ZZZ') = freq.ServiceFrequencyCode LEFT JOIN 
 	LEGACYSPED.Transform_ServiceProviderTitle ttl on v.ServiceProviderTitleCode = ttl.ServiceProviderCode and
 		cast(case when ttl.DeletedDate is null then 0 else 1 end as Int) = (
 			select min(cast(case when ttlt.DeletedDate is null then 0 else 1 end as Int)) from ServiceProviderTitle ttlt where ttl.Name = ttlt.Name) LEFT JOIN
 	LEGACYSPED.Transform_IepServiceCategory cat on isnull(cat.ServiceCategoryCode,'x') = isnull(v.ServiceType,'y')-- LEFT JOIN
	--LEGACYSPED.MAP_ScheduleID ssm on v.ServiceRefID = ssm.ServiceRefID LEFT JOIN
	--LEGACYSPED.MAP_SpedStaffMemberView prv on isnull(v.StaffEmail,'') = prv.StaffEmail
GO
--- 

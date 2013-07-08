--#include {SpedObjectsInclude}\Transform_ServiceFrequency.sql
--#include {SpedObjectsInclude}\Transform_ServiceProviderTitle.sql
--#include {SpedObjectsInclude}\Transform_IepServiceCategory.sql

-- GIFTED

-- #############################################################################
-- ServicePlan
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_ServicePlanID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_ServicePlanID
	(
	ServiceRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)

ALTER TABLE x_LEGACYGIFT.MAP_ServicePlanID ADD CONSTRAINT
	PK_MAP_ServicePlanID PRIMARY KEY CLUSTERED
	(
	ServiceRefID
	)
END
go


-- select c.name+', ' from sys.objects o join sys.columns c on o.object_id = c.object_id where o.name = 'GiftedService_Local'

--select ServiceType, ServiceRefId, EpRefId = ieprefid, ServiceDefinitionCode, BeginDate, EndDate, IsRelated, IsDirect, ExcludesFromGenEd, ServiceLocationCode, ServiceProviderTitleCode, Sequence, IsESY, ServiceTime, ServiceFrequencyCode, ServiceProviderSSN, StaffEmail, ServiceAreaText
--into #TEMPSERVICES
--from x_LEGACYGIFT.GiftedService

--drop table x_LEGACYGIFT.GiftedService_LOCAL


--select ServiceType, ServiceRefId, EpRefID, ServiceDefinitionCode, BeginDate, EndDate, IsRelated, IsDirect, ExcludesFromGenEd, ServiceLocationCode, ServiceProviderTitleCode, Sequence, IsESY, ServiceTime, ServiceFrequencyCode, ServiceProviderSSN, StaffEmail, ServiceAreaText
--into x_LEGACYGIFT.GiftedService_LOCAL
--from #TEMPSERVICES



--if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_Person_TypeID_Deleted_EmailAddress')
--CREATE NONCLUSTERED INDEX IX_x_LEGACYGIFT_Person_TypeID_Deleted_EmailAddress ON [dbo].[Person] ([TypeID],[Deleted],[EmailAddress])

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_GiftedService_LOCAL_EPRefID')
CREATE NONCLUSTERED INDEX IX_x_LEGACYGIFT_GiftedService_LOCAL_EPRefID ON [x_LEGACYGIFT].[GiftedService_LOCAL] ([EPRefID]) INCLUDE ([ServiceType],[ServiceRefId],[ServiceDefinitionCode],[ServiceLocationCode],[ServiceProviderTitleCode],[ServiceFrequencyCode],[StaffEmail])

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_MAP_ServicePlanID_DestID')
create index IX_x_LEGACYGIFT_MAP_ServicePlanID_DestID on x_LEGACYGIFT.MAP_ServicePlanID (DestID)
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_IepService') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_IepService
GO

create view x_LEGACYGIFT.Transform_IepService
as
select
	v.ServiceRefId,
	iep.EPRefID,
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
		FROM x_LEGACYGIFT.GiftedService
		WHERE EPRefID = v.EPRefID AND
		ServiceRefID < v.ServiceRefID
		),
	ServiceTypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784',
-- IepServicePlan.  The case statements assume source data indicates Y or N (this is validated in the data validation tool)
	CategoryCode = v.ServiceType,
	CategoryID = cat.DestID,
	DirectID = case when IsDirect = 'Y' then 'A7061714-ADA3-44F7-8329-159DD4AE2ECE' else '1A8BF908-E3ED-45B0-8EEC-99CB1AD0806F' end, -- A7061714-ADA3-44F7-8329-159DD4AE2ECE	Direct, 1A8BF908-E3ED-45B0-8EEC-99CB1AD0806F	Indirect
	ExcludesID = case when ExcludesFromGenEd = 'Y' then '493713FB-6071-42D4-B46A-1B09037C1F8B' else '235C3167-A3E6-4D1D-8AAB-0B2B57FD5160' end, -- 235C3167-A3E6-4D1D-8AAB-0B2B57FD5160	Inside, 493713FB-6071-42D4-B46A-1B09037C1F8B	Outside
	EsyID = case when IsEsy = 'Y' then 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' else 'F7E20A86-2709-4170-9810-15B601C61B79' end, -- F7E20A86-2709-4170-9810-15B601C61B79	N, B76DDCD6-B261-4D46-A98E-857B0A814A0C	Y
	DeliveryStatement = v.ServiceAreaText
-- ServiceSchedule
	--ServiceSchedueDestID = ssm.DestID,
	--ProviderID = prv.UserProfileID,
	--Name = CAST(null as varchar),
	--LocationId = loc.DestID,
	--LocationDescription = loc.Name 
FROM 
	x_LEGACYGIFT.Transform_PrgItem iep JOIN
	PrgSection sec ON
		sec.ItemID = iep.DestID AND
--		iep.VersionDestID = sec.VersionID AND
		sec.DefID = '8EFD24A0-46F0-4734-999A-0B4CCE2C1519' JOIN --IEP Services ------------------------------------------------------------- change to gifted
	x_LEGACYGIFT.GiftedService v on iep.EPRefID = v.EPRefID LEFT JOIN
	x_LEGACYGIFT.MAP_ServicePlanID m on v.ServiceRefID = m.ServiceRefID LEFT JOIN 
	LEGACYSPED.Transform_ServiceDef sdm on 
		v.ServiceType = isnull(sdm.ServiceCategoryCode,'') AND
		v.ServiceDefinitionCode = isnull(sdm.ServiceDefCode, 'ZZZ') LEFT JOIN
	LEGACYSPED.Transform_ServiceFrequency freq on isnull(v.ServiceFrequencyCode, 'ZZZ') = freq.ServiceFrequencyCode LEFT JOIN 
 	LEGACYSPED.Transform_ServiceProviderTitle ttl on v.ServiceProviderTitleCode = ttl.ServiceProviderCode and
 		cast(case when ttl.DeletedDate is null then 0 else 1 end as Int) = (
 			select min(cast(case when ttlt.DeletedDate is null then 0 else 1 end as Int)) from ServiceProviderTitle ttlt where ttl.Name = ttlt.Name) LEFT JOIN
 	LEGACYSPED.Transform_IepServiceCategory cat on isnull(cat.ServiceCategoryCode,'x') = isnull(v.ServiceType,'y')-- LEFT JOIN
GO
--- 

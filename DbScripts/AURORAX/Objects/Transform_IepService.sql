IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_IepService]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_IepService]
GO

create view AURORAX.Transform_IepService
as
select
	v.ServiceType,
	v.ServiceRefId,
	iep.IepRefId,
	m.DestID, 
-- IepServicePlan.  The case statements assume source data indicates Y or N (this is validated in the data validation tool)
	InstanceID = sec.ID,
	RelatedID = case when IsRelated = 'Y' then '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD' else '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7' end, -- 4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7	Special Education, 4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD	Related
	DirectID = case when IsDirect = 'Y' then 'A7061714-ADA3-44F7-8329-159DD4AE2ECE' else '1A8BF908-E3ED-45B0-8EEC-99CB1AD0806F' end, -- A7061714-ADA3-44F7-8329-159DD4AE2ECE	Direct, 1A8BF908-E3ED-45B0-8EEC-99CB1AD0806F	Indirect
	ExcludesID = case when ExcludesFromGenEd = 'Y' then '493713FB-6071-42D4-B46A-1B09037C1F8B' else '235C3167-A3E6-4D1D-8AAB-0B2B57FD5160' end, -- 235C3167-A3E6-4D1D-8AAB-0B2B57FD5160	Inside, 493713FB-6071-42D4-B46A-1B09037C1F8B	Outside
	EsyID = case when IsEsy = 'Y' then 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' else 'F7E20A86-2709-4170-9810-15B601C61B79' end, -- F7E20A86-2709-4170-9810-15B601C61B79	N, B76DDCD6-B261-4D46-A98E-857B0A814A0C	Y
	DeliveryStatement = cast(NULL as text),
-- ServicePlan
	DefId = sdm.DestId,
	iep.StudentID,
	StartDate = cast(v.BeginDate as datetime),
	EndDate = cast(v.EndDate as datetime),
	Amount = v.ServiceTime,
	FrequencyId = freq.DestID,
	UnitID = cast('347548AB-489D-47C4-BE54-63FCF3859FD7' as uniqueidentifier), -- we request this from customer in minutes
	ProviderTitleID = ttl.DestID,
	Sequence = (
		SELECT count(*)
		FROM AURORAX.Service
		WHERE IepRefID = v.IepRefID AND
		ServiceRefID < v.ServiceRefID
		),
-- ServiceSchedule
	ServiceSchedueDestID = ssm.DestID,
	ProviderID = cast(NULL as uniqueidentifier),  -- will require a matching view similar to Match_Students, but is complicated by the UserProfile works
	Name = cast(NULL as varchar),
	LocationId = loc.DestID,
	LocationDescription = cast(NULL as varchar)
FROM
	AURORAX.Transform_Iep iep JOIN
	PrgSection sec ON
		sec.VersionID = iep.VersionDestID AND
		sec.DefID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F' JOIN --IEP Services
	AURORAX.Service v on iep.IepRefId = v.IepRefId LEFT JOIN
	AURORAX.MAP_IepServiceID m on v.ServiceRefID = m.ServiceRefID LEFT JOIN
	AURORAX.MAP_ServiceDefID sdm on v.ServiceDefinitionCode = sdm.ServiceDefCode LEFT JOIN
	AURORAX.MAP_ServiceLocationID loc on v.ServiceLocationCode = loc.ServiceLocationCode LEFT JOIN 
	AURORAX.MAP_ServiceFrequencyID freq on v.ServiceFrequencyCode = freq.ServiceFrequencyCode LEFT JOIN 
   AURORAX.MAP_ServiceProviderTitleID ttl on v.ServiceProviderCode = ttl.ServiceProviderCode LEFT JOIN
	AURORAX.MAP_ScheduleID ssm on v.ServiceRefID = ssm.ServiceRefID 
GO

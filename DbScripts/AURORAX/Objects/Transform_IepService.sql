IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_IepService]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_IepService]
GO

create view AURORAX.Transform_IepService
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
	ServiceTypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784',
-- IepServicePlan.  The case statements assume source data indicates Y or N (this is validated in the data validation tool)
	CategoryCode = v.ServiceType,
	CategoryID = cat.DestID,
	DirectID = case when IsDirect = 'Y' then 'A7061714-ADA3-44F7-8329-159DD4AE2ECE' else '1A8BF908-E3ED-45B0-8EEC-99CB1AD0806F' end, -- A7061714-ADA3-44F7-8329-159DD4AE2ECE	Direct, 1A8BF908-E3ED-45B0-8EEC-99CB1AD0806F	Indirect
	ExcludesID = case when ExcludesFromGenEd = 'Y' then '493713FB-6071-42D4-B46A-1B09037C1F8B' else '235C3167-A3E6-4D1D-8AAB-0B2B57FD5160' end, -- 235C3167-A3E6-4D1D-8AAB-0B2B57FD5160	Inside, 493713FB-6071-42D4-B46A-1B09037C1F8B	Outside
	EsyID = case when IsEsy = 'Y' then 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' else 'F7E20A86-2709-4170-9810-15B601C61B79' end, -- F7E20A86-2709-4170-9810-15B601C61B79	N, B76DDCD6-B261-4D46-A98E-857B0A814A0C	Y
	DeliveryStatement = cast(NULL as text),
-- ServiceSchedule
	ServiceSchedueDestID = ssm.DestID,
	ProviderID = prv.UserProfileID,
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
 	AURORAX.MAP_ServiceProviderTitleID ttl on v.ServiceProviderTitleCode = ttl.ServiceProviderTitleCode LEFT JOIN
 	AURORAX.MAP_IepServiceCategoryID cat on v.ServiceType = cat.SubType LEFT JOIN
	AURORAX.MAP_ScheduleID ssm on v.ServiceRefID = ssm.ServiceRefID LEFT JOIN
	AURORAX.MAP_SpedStaffMemberView prv on v.ServiceProviderRefId = prv.SpedStaffRefID
GO
---

IF  EXISTS (SELECT 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'AURORAX' and o.name = 'MAP_SpedStaffMemberView')
	DROP VIEW AURORAX.MAP_SpedStaffMemberView
GO

CREATE VIEW AURORAX.MAP_SpedStaffMemberView
AS

	SELECT
		staff.SpedStaffRefID,
		UserProfileID = u.ID
	FROM
		AURORAX.SpedStaffMember staff JOIN
		Person p on p.EmailAddress = staff.Email JOIN
		UserProfile u on u.ID = p.ID JOIN
		(
			SELECT EmailAddress
			FROM Person
			WHERE
				Deleted IS NULL AND
				TypeID = 'U'
			GROUP BY EmailAddress
			HAVING COUNT(*) = 1
		) single_match ON p.EmailAddress = single_match.EmailAddress
		
GO
--
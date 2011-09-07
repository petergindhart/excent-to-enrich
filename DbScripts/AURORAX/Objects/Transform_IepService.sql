--#include Transform_PrgLocation.sql
--#include Transform_ServiceDef.sql

-- ############################################################################# 
-- ServicePlan
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_ServicePlanID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_ServicePlanID
	(
	ServiceRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)

ALTER TABLE AURORAX.MAP_ServicePlanID ADD CONSTRAINT
	PK_MAP_ServicePlanID PRIMARY KEY CLUSTERED
	(
	ServiceRefID
	)
END
GO

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
	DeliveryStatement = v.ServiceAreaText,
-- ServiceSchedule
	ServiceSchedueDestID = ssm.DestID,
	ProviderID = prv.UserProfileID,
	Name = CAST(null as varchar),
	LocationId = loc.DestID,
	LocationDescription = loc.Name -- select iep.ieprefid
FROM
	AURORAX.Transform_PrgIep iep JOIN
	PrgSection sec ON
		sec.ItemID = iep.DestID AND
		iep.VersionDestID = sec.VersionID AND
		sec.DefID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F' JOIN --IEP Services
	AURORAX.Service v on iep.IepRefId = v.IepRefId LEFT JOIN
	AURORAX.MAP_ServicePlanID m on v.ServiceRefID = m.ServiceRefID LEFT JOIN
	AURORAX.Transform_ServiceDef sdm on 
		v.ServiceType = sdm.ServiceCategoryCode AND
		v.ServiceDefinitionCode = sdm.ServiceDefCode LEFT JOIN
	AURORAX.Transform_PrgLocation loc on v.ServiceLocationCode = loc.ServiceLocationCode LEFT JOIN 
	AURORAX.MAP_ServiceFrequencyID freq on isnull(v.ServiceFrequencyCode, 'ZZZ') = freq.ServiceFrequencyCode LEFT JOIN 
 	AURORAX.MAP_ServiceProviderTitleID ttl on v.ServiceProviderTitleCode = ttl.ServiceProviderTitleCode LEFT JOIN
 	AURORAX.Transform_IepServiceCategory cat on v.ServiceType = cat.ServiceCategoryCode LEFT JOIN
	AURORAX.MAP_ScheduleID ssm on v.ServiceRefID = ssm.ServiceRefID LEFT JOIN
	AURORAX.MAP_SpedStaffMemberView prv on v.ServiceProviderRefId = prv.SpedStaffRefID
GO
---




/*

-- ==================================================================================================================== 
-- =================================================== ServicePlan  =================================================== 
-- ==================================================================================================================== 



GEO.ShowLoadTables ServicePlan

set nocount on;
declare @n varchar(100) ; select @n = 'ServicePlan'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	HasMapTable = 1
	, MapTable = 'AURORAX.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'ServiceRefID'
	, DeleteKey = 'DestID'
	, DeleteTrans = 1
	, UpdateTrans = 0
	, DestTableFilter = 'ID in (select ID from IepServicePlan where InstanceID in (select DestID from AURORAX.MAP_PrgSectionID where DefID = ''9AC79680-7989-4CC9-8116-1CCDB1D0AE5F''))'
	, Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n

begin tran testplan
DELETE AURORAX.MAP_ServicePlanID
FROM AURORAX.Transform_IepService AS s RIGHT OUTER JOIN 
	AURORAX.MAP_ServicePlanID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

DELETE ServicePlan
FROM AURORAX.MAP_ServicePlanID AS s RIGHT OUTER JOIN 
	ServicePlan as d ON s.DestID=d.ID
WHERE s.DestID IS NULL AND 1=1 AND  ID in (select ID from IepServicePlan where InstanceID in (select DestID from AURORAX.MAP_PrgSectionID where DefID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F'))

INSERT AURORAX.MAP_ServicePlanID
SELECT ServiceRefID, NEWID()
FROM AURORAX.Transform_IepService s
WHERE NOT EXISTS (SELECT * FROM ServicePlan d WHERE s.DestID=d.ID)

INSERT ServicePlan (ID, DefID, Amount, ServiceTypeID, FrequencyID, UnitID, ProviderTitleID, StudentID, EndDate, Sequence, StartDate)
SELECT s.DestID, s.DefID, s.Amount, s.ServiceTypeID, s.FrequencyID, s.UnitID, s.ProviderTitleID, s.StudentID, s.EndDate, s.Sequence, s.StartDate
FROM AURORAX.Transform_IepService s
WHERE NOT EXISTS (SELECT * FROM ServicePlan d WHERE s.DestID=d.ID)

rollback tran testplan


select * from ServicePlan




-- ==================================================================================================================== 
-- ================================================= IepServicePlan  ================================================== 
-- ==================================================================================================================== 



GEO.ShowLoadTables IepServicePlan

set nocount on;
declare @n varchar(100) ; select @n = 'IepServicePlan'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t

	HasMapTable = 0, 
	MapTable = NULL
	, KeyField = NULL
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = NULL
	, Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.*
-- UPDATE IepServicePlan SET ExcludesID=s.ExcludesID, InstanceID=s.InstanceID, EsyID=s.EsyID, CategoryID=s.CategoryID, DirectID=s.DirectID, DeliveryStatement=s.DeliveryStatement
FROM  IepServicePlan d JOIN 
	AURORAX.Transform_IepService  s ON s.DestID=d.ID

-- INSERT IepServicePlan (ID, ExcludesID, InstanceID, EsyID, CategoryID, DirectID, DeliveryStatement)
SELECT s.DestID, s.ExcludesID, s.InstanceID, s.EsyID, s.CategoryID, s.DirectID, s.DeliveryStatement
FROM AURORAX.Transform_IepService s
WHERE NOT EXISTS (SELECT * FROM IepServicePlan d WHERE s.DestID=d.ID)

select * from IepServicePlan




*/



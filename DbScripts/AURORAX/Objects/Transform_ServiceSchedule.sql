IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_ServiceSchedule') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_ServiceSchedule  
GO  
  
CREATE VIEW AURORAX.Transform_ServiceSchedule  
AS  
 SELECT
  sched.DestID,
  ScheduleID = sched.DestID, 
  ServicePlanID = v.DestID,
  v.ProviderID,
  v.Name,
  v.LocationID,
  v.LocationDescription
 FROM
  AURORAX.Transform_IepService v JOIN
  AURORAX.Transform_Schedule sched on v.ServiceRefID = sched.ServiceRefID
GO

/*

-- ==================================================================================================================== 
-- ================================================ ServiceSchedule  ================================================== 
-- ==================================================================================================================== 


GEO.ShowLoadTables ServiceSchedule

set nocount on;
declare @n varchar(100) ; select @n = 'ServiceSchedule'
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
-- UPDATE ServiceSchedule SET ProviderID=s.ProviderID, LocationDescription=s.LocationDescription, LocationID=s.LocationID, Name=s.Name
FROM  ServiceSchedule d JOIN 
	AURORAX.Transform_ServiceSchedule  s ON s.DestID=d.ID

-- INSERT ServiceSchedule (ID, ProviderID, LocationDescription, LocationID, Name)
SELECT s.DestID, s.ProviderID, s.LocationDescription, s.LocationID, s.Name
FROM AURORAX.Transform_ServiceSchedule s
WHERE NOT EXISTS (SELECT * FROM ServiceSchedule d WHERE s.DestID=d.ID)

select * from ServiceSchedule



-- ==================================================================================================================== 
-- ============================================ ServiceScheduleServicePlan ============================================
-- ==================================================================================================================== 


GEO.ShowLoadTables ServiceScheduleServicePlan

set nocount on;
declare @n varchar(100) ; select @n = 'ServiceScheduleServicePlan'
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
-- UPDATE ServiceScheduleServicePlan SET ServicePlanID=s.ServicePlanID
FROM  ServiceScheduleServicePlan d JOIN 
	AURORAX.Transform_ServiceSchedule  s ON s.ScheduleID=d.ScheduleID

-- INSERT ServiceScheduleServicePlan (ScheduleID, ServicePlanID)
SELECT s.ScheduleID, s.ServicePlanID
FROM AURORAX.Transform_ServiceSchedule s
WHERE NOT EXISTS (SELECT * FROM ServiceScheduleServicePlan d WHERE s.ScheduleID=d.ScheduleID)

select * from ServiceScheduleServicePlan










*/

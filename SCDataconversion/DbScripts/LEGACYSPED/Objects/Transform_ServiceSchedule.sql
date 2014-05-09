IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_ServiceSchedule') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_ServiceSchedule  
GO  
  
CREATE VIEW LEGACYSPED.Transform_ServiceSchedule  
AS
 SELECT
  sched.DestID,
  ScheduleID = sched.DestID, 
  ServicePlanID = v.DestID, 
  ProviderID = prv.UserProfileID,
  Name = CAST(null as varchar),
  LocationID =  loc.DestID,  
  LocationDescription = loc.Name
 FROM
  LEGACYSPED.MAP_ServicePlanID v JOIN
  LEGACYSPED.Transform_Schedule_Function() sched on v.ServiceRefID = sched.ServiceRefID left join 
  LEGACYSPED.MAP_ScheduleID ssm on v.ServiceRefID = ssm.ServiceRefID LEFT JOIN
  Legacysped.Service ser ON ser.ServiceRefId = v.ServiceRefID left join 
  LEGACYSPED.Transform_PrgLocation loc on ser.ServiceLocationCode = loc.ServiceLocationCode LEFT JOIN 
  LEGACYSPED.MAP_SpedStaffMemberView prv on isnull(ser.StaffEmail,'') = prv.StaffEmail
GO


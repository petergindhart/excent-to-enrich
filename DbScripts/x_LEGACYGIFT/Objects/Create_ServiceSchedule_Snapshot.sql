IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Create_ServiceSchedule_Snapshot'))
DROP PROC x_LEGACYGIFT.Create_ServiceSchedule_Snapshot
GO

create proc x_LEGACYGIFT.Create_ServiceSchedule_Snapshot
as
set ansi_warnings off;
	begin
	IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_ServiceSchedule_Snapshot') AND OBJECTPROPERTY(id, N'IsTable') = 1)
	DROP TABLE x_LEGACYGIFT.Transform_ServiceSchedule_Snapshot

 SELECT
  sched.DestID,
  ScheduleID = sched.DestID, 
  ServicePlanID = v.DestID, 
  ProviderID = prv.UserProfileID,
  Name = CAST(null as varchar),
  LocationID =  loc.DestID,  
  LocationDescription = loc.Name
 into x_LEGACYGIFT.Transform_ServiceSchedule_Snapshot
 FROM
  x_LEGACYGIFT.MAP_ServicePlanID v JOIN
  x_LEGACYGIFT.Transform_Schedule_Function() sched on v.ServiceRefID = sched.ServiceRefID left join 
  x_LEGACYGIFT.MAP_ScheduleID ssm on v.ServiceRefID = ssm.ServiceRefID LEFT JOIN
  x_LEGACYGIFT.GiftedService ser ON ser.ServiceRefId = v.ServiceRefID left join 
  LEGACYSPED.Transform_PrgLocation loc on ser.ServiceLocationCode = loc.ServiceLocationCode LEFT JOIN 
  LEGACYSPED.MAP_SpedStaffMemberView prv on isnull(ser.StaffEmail,'') = prv.StaffEmail
end
set ansi_warnings on;

go


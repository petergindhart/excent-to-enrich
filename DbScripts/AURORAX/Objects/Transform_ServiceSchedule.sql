IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_ServiceSchedule]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_ServiceSchedule]  
GO  
  
CREATE VIEW [AURORAX].[Transform_ServiceSchedule]  
AS  
 SELECT
  sched.DestID,
  ScheduleID = sched.DestID, -- Hmm.   Sloppy?  Maybe.  But Expedient!  gg
  ServicePlanID = serv.DestID,
  serv.ProviderID,
  serv.Name,
  serv.LocationID,
  serv.LocationDescription
 FROM
  AURORAX.Transform_IepService serv JOIN
  AURORAX.Transform_Schedule sched on serv.ServiceRefID = sched.ServiceRefID
GO

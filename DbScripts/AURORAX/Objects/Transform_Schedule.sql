IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Schedule]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Schedule]  
GO  
  
CREATE VIEW [AURORAX].[Transform_Schedule]  
AS  
 SELECT   
  v.ServiceRefID,
  m.DestID,
  TypeID = 'A27EC71B-2F61-46D5-A371-3F92C7642AEF',   
  StartDate = cast(NULL as datetime),   
  EndDate = cast(NULL as datetime),   
  LastOccurrence = cast(NULL as datetime),   
  IsEnabled = cast(0 as bit),   
  FrequencyID = cast(NULL as uniqueidentifier),   
  FrequencyAmount = cast(0 as int),   
  WeeklyMon = cast(0 as bit),   
  WeeklyTue = cast(0 as bit),   
  WeeklyWed = cast(0 as bit),   
  WeeklyThu = cast(0 as bit),   
  WeeklyFri = cast(0 as bit),   
  WeeklySat = cast(0 as bit),   
  WeeklySun = cast(0 as bit),
  TimesPerDay = cast(0 as int)
 FROM  
  AURORAX.Service v LEFT JOIN
  AURORAX.MAP_ScheduleID m on v.ServiceRefID = m.ServiceRefID LEFT JOIN
  dbo.Schedule sched on m.DestID = sched.ID
GO  
--
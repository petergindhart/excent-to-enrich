IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Schedule]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Schedule]  
GO  
  
CREATE VIEW [AURORAX].[Transform_Schedule]  
AS  
 SELECT   
  v.ServiceRefID,
  m.DestID,
  TypeID = 'A27EC71B-2F61-46D5-A371-3F92C7642AEF',   
  StartDate = cast(v.BeginDate as datetime),
  EndDate = cast(v.EndDate as datetime),   
  LastOccurrence = cast(NULL as datetime),   
  IsEnabled = cast(0 as bit),   
  FrequencyID = mf.DestID,
  FrequencyAmount = cast(v.ServiceTime as int),   
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
  AURORAX.Map_ScheduleFrequencyID mf on v.ServiceFrequencyCode = mf.ServiceFrequencyCode left join
  dbo.Schedule sched on m.DestID = sched.ID
GO  
--

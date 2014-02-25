-- #############################################################################
-- Schedule
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_ScheduleID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_ScheduleID
	(
	ServiceRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
ALTER TABLE LEGACYSPED.MAP_ScheduleID ADD CONSTRAINT
	PK_MAP_ScheduleID PRIMARY KEY CLUSTERED
	(
	ServiceRefID
	)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_Schedule') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_Schedule
GO

CREATE VIEW LEGACYSPED.Transform_Schedule
AS
 SELECT 
  v.ServiceRefID,
  m.DestID,
  TypeID = 'A27EC71B-2F61-46D5-A371-3F92C7642AEF', 
  StartDate = cast(v.BeginDate as datetime),
  EndDate = cast(v.EndDate as datetime), 
  LastOccurrence = cast(NULL as datetime), 
  IsEnabled = cast(1 as bit), 
  -- schedule frequency is static in Enrich
  FrequencyID = cast(case when isnull(v.ServiceTime,0) < 1 then NULL else '634EA996-D5FF-4A4A-B169-B8CB70DBBEC2' end as uniqueidentifier), -- weekly
  FrequencyAmount = cast(case when isnull(v.ServiceTime,0) < 1 then 1 else v.ServiceTime end as int), -- For FrequencyID and FrequencyAmount see change script 2023-CorrectConvertedIepServiceSchedules.sql
  WeeklyMon = cast(0 as bit),
  WeeklyTue = cast(0 as bit),
  WeeklyWed = cast(0 as bit),
  WeeklyThu = cast(0 as bit),
  WeeklyFri = cast(0 as bit),
  WeeklySat = cast(0 as bit),
  WeeklySun = cast(0 as bit),
  TimesPerDay = cast(0 as int) -- select v.*
 FROM
  LEGACYSPED.Service v LEFT JOIN
  LEGACYSPED.MAP_ScheduleID m on v.ServiceRefID = m.ServiceRefID LEFT JOIN
  LEGACYSPED.MAP_ServiceFrequencyID mf on isnull(v.ServiceFrequencyCode, 'ZZZ') = mf.ServiceFrequencyCode left join -- select * from  LEGACYSPED.MAP_ServiceFrequencyID
  dbo.Schedule sched on m.DestID = sched.ID
GO
--


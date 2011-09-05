-- #############################################################################
-- Schedule
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_ScheduleID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_ScheduleID
	(
	ServiceRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
ALTER TABLE AURORAX.MAP_ScheduleID ADD CONSTRAINT
	PK_MAP_ScheduleID PRIMARY KEY CLUSTERED
	(
	ServiceRefID
	)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_Schedule') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_Schedule
GO

CREATE VIEW AURORAX.Transform_Schedule
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
  FrequencyID = '634EA996-D5FF-4A4A-B169-B8CB70DBBEC2', 
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
  AURORAX.MAP_ServiceFrequencyID mf on isnull(v.ServiceFrequencyCode, 'ZZZ') = mf.ServiceFrequencyCode left join -- select * from  AURORAX.MAP_ScheduleFrequencyID
  dbo.Schedule sched on m.DestID = sched.ID
GO
--
/*

GEO.ShowLoadTables Schedule

set nocount on;
declare @n varchar(100) ; select @n = 'Schedule'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
	
	HasMapTable = 1, 
	MapTable = 'AURORAX.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'ServiceRefID'
	, DeleteKey = 'DestID'
	, DeleteTrans = 1
	, UpdateTrans = 0
	, DestTableFilter = NULL
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.*
-- DELETE AURORAX.MAP_ScheduleID
FROM AURORAX.Transform_Schedule AS s RIGHT OUTER JOIN 
	AURORAX.MAP_ScheduleID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

-- INSERT AURORAX.MAP_ScheduleID -- select * from AURORAX.MAP_ScheduleID
SELECT ServiceRefID, NEWID()
FROM AURORAX.Transform_Schedule s
WHERE NOT EXISTS (SELECT * FROM Schedule d WHERE s.DestID=d.ID)

-- INSERT Schedule (ID, StartDate, WeeklyFri, TimesPerDay, WeeklyTue, FrequencyAmount, WeeklyWed, FrequencyID, LastOccurrence, WeeklySun, EndDate, TypeID, WeeklyThu, IsEnabled, WeeklySat, WeeklyMon)
SELECT s.DestID, s.StartDate, s.WeeklyFri, s.TimesPerDay, s.WeeklyTue, s.FrequencyAmount, s.WeeklyWed, s.FrequencyID, s.LastOccurrence, s.WeeklySun, s.EndDate, s.TypeID, s.WeeklyThu, s.IsEnabled, s.WeeklySat, s.WeeklyMon
FROM AURORAX.Transform_Schedule s
WHERE NOT EXISTS (SELECT * FROM Schedule d WHERE s.DestID=d.ID)

select * from Schedule



*/


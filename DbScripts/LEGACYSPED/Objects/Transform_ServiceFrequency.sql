/*
   LEGACYSPED.MAP_ServiceFrequencyID is created in the Localization file.
	Service Frequency needs to be set up manually per district because:
	1. ServiceFrequency is populated with seed data when Enrich is installed
	2. The values from legacy systems are not consistent.  They may be hand-entered in legacy systems.
	
*/
-- ############################################################################# 
--		Service Frequency
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_ServiceFrequencyID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_ServiceFrequencyID
(
	ServiceFrequencyCode	varchar(150) NOT NULL,
	ServiceFrequencyName	varchar(50) not null,
	DestID uniqueidentifier NOT NULL
)
ALTER TABLE LEGACYSPED.MAP_ServiceFrequencyID ADD CONSTRAINT
PK_MAP_ServiceFrequencyID PRIMARY KEY CLUSTERED
(
	ServiceFrequencyName
)
CREATE INDEX IX_Map_ServiceFrequencyID_ServiceFrequencyName on LEGACYSPED.Map_ServiceFrequencyID (ServiceFrequencyName)
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_ServiceFrequency') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_ServiceFrequency 
GO

CREATE VIEW LEGACYSPED.Transform_ServiceFrequency
AS 
 SELECT
  ServiceFrequencyCode = k.Code,
  ServiceFrequencyName = coalesce(s.Name, t.Name, k.Label), -- we'll pretend that we don't know what the possibilities are right now:  quarterly will be quarter
  DestID = coalesce(s.ID, t.ID, m.DestID),
  Name = coalesce(s.Name, t.Name, k.Label), 
  Sequence = coalesce(s.Sequence, t.sequence, 99),
  WeekFactor = coalesce(s.WeekFactor, t.weekfactor, 0) -- Pete will advise
 FROM
  LEGACYSPED.Lookups k LEFT JOIN 
  dbo.ServiceFrequency s on 1 = 0 LEFT JOIN -- placeholder for when ServiceFrequency.StageCode is added to the database.
  LEGACYSPED.MAP_ServiceFrequencyID m on k.Code = m.ServiceFrequencyCode LEFT JOIN
  dbo.ServiceFrequency t on m.DestID = t.ID
 WHERE
  k.Type = 'ServFreq'
GO



/*

GEO.ShowLoadTables ServiceFrequency

set nocount on;
declare @n varchar(100) ; select @n = 'ServiceFrequency'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	HasMapTable = 1, 
	MapTable = 'LEGACYSPED.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'ServiceFrequencyCode, ServiceFrequencyName'
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 0
	, DestTableFilter = NULL -- 's.DestID in (select DestID from LEGACYSPED.MAP_ServiceFrequencyID where s.sequence = 99)'
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n

-- INSERT LEGACYSPED.MAP_ServiceFrequencyID
SELECT ServiceFrequencyCode, ServiceFrequencyName, NEWID()
FROM LEGACYSPED.Transform_ServiceFrequency s
WHERE NOT EXISTS (SELECT * FROM ServiceFrequency d WHERE s.DestID=d.ID)

-- INSERT ServiceFrequency (ID, Sequence, Name, WeekFactor)
SELECT s.DestID, s.Sequence, s.Name, s.WeekFactor
FROM LEGACYSPED.Transform_ServiceFrequency s
WHERE NOT EXISTS (SELECT * FROM ServiceFrequency d WHERE s.DestID=d.ID)

select * from ServiceFrequency









*/








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
  DestID = coalesce(s.ID, t.ID, mc.DestID, ml.DestID),
  Name = coalesce(s.Name, t.Name, k.Label), 
  Sequence = coalesce(s.Sequence, t.sequence, 99),
  WeekFactor = coalesce(s.WeekFactor, t.weekfactor, 0), -- Pete will advise
  StateCode = coalesce(s.StateCode, t.StateCode, k.StateCode),
  DeletedDate = case 
	when s.ID is not null then s.DeletedDate 
	when t.ID is not null then t.DeletedDate 
	else GETDATE() end
 FROM
  LEGACYSPED.Lookups k LEFT JOIN 
  dbo.ServiceFrequency s on k.StateCode = s.StateCode LEFT JOIN 
  LEGACYSPED.MAP_ServiceFrequencyID mc on k.Code = mc.ServiceFrequencyCode LEFT JOIN
  LEGACYSPED.MAP_ServiceFrequencyID ml on k.Label = ml.ServiceFrequencyName LEFT JOIN
  dbo.ServiceFrequency t on isnull(mc.DestID, ml.DestID) = t.ID 
--  dbo.ServiceFrequency t on mc.DestID = t.ID 
 WHERE
  k.Type = 'ServFreq'
GO

/*


select * from LEGACYSPED.Lookups where Type = 'ServFreq'
select * from LEGACYSPED.Transform_ServiceFrequency
select * from LEGACYSPED.MAP_ServiceFrequencyID

select * from vc3etl.extractdatabase

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


Msg 2627, Level 14, State 1, Line 2
Violation of PRIMARY KEY constraint 'PK_MAP_ServiceFrequencyID'. Cannot insert duplicate key in object 'LEGACYSPED.MAP_ServiceFrequencyID'.
The statement has been terminated.


select * from LEGACYSPED.MAP_ServiceFrequencyID

day	daily	71590A00-2C40-40FF-ABD9-E73B09AF46A1
month	monthly	3D4B557B-0C2E-4A41-9410-BA331F1D20DD
quarter	quarter	A5C8B0F7-4D1E-4595-BCF5-DB62D5BBD7A8
ZZZ	unknown	C42C50ED-863B-44B8-BF68-B377C8B0FA95
week	weekly	A2080478-1A03-4928-905B-ED25DEC259E6
year	yearly	5F3A2822-56F3-49DA-9592-F604B0F202C3




begin tran servfreq
INSERT LEGACYSPED.MAP_ServiceFrequencyID
SELECT ServiceFrequencyCode, ServiceFrequencyName, NEWID()
FROM LEGACYSPED.Transform_ServiceFrequency s
WHERE NOT EXISTS (SELECT * FROM ServiceFrequency d WHERE s.DestID=d.ID)

INSERT ServiceFrequency (ID, Sequence, Name, WeekFactor)
SELECT s.DestID, s.Sequence, s.Name, s.WeekFactor
FROM LEGACYSPED.Transform_ServiceFrequency s
WHERE NOT EXISTS (SELECT * FROM ServiceFrequency d WHERE s.DestID=d.ID)


rollback tran servfreq



*/








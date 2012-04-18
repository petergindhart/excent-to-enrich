-- use in all states, all districts
-- #############################################################################
-- IepServiceCategory Map Table
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepServiceCategoryID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1) 
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepServiceCategoryID
(
	ServiceCategoryCode varchar(20) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepServiceCategoryID ADD CONSTRAINT
PK_MAP_IepServiceCategoryID PRIMARY KEY CLUSTERED
(
	ServiceCategoryCode
)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepServiceCategory') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepServiceCategory  
GO  

CREATE VIEW LEGACYSPED.Transform_IepServiceCategory  
AS
	SELECT
		k.ServiceCategoryCode,
		DestID = t.ID,
		Name = coalesce(t.Name, case k.ServiceCategoryCode when 's' then 'Special Education' else 'Related' end), -- It is important to get t where it exists because we are updating the target table and we don't want to change t where t already existed
		Sequence = coalesce(t.Sequence, 99),
		DeletedDate = CAST(null as datetime)
	FROM
		(
		SELECT Distinct ServiceCategoryCode = SubType
		FROM LEGACYSPED.SelectLists 
		WHERE Type = 'Service'
		and SubType is not null
		GROUP BY SubType
		) k LEFT JOIN
		dbo.IepServiceCategory t on case k.ServiceCategoryCode when 'S' then 'Special Education' else 'Related' end = t.Name 
GO





/*
sp_helptext 'LEGACYSPED.Transform_IepServiceCategory'

select distinct subtype  from LEGACYSPED.SelectLists where type = 'Service'
select * from LEGACYSPED.SelectLists where subtype = 'Support'




select distinct servicetype from LEGACYSPED.service


select * from LEGACYSPED.Transform_IepServiceCategory  

GEO.ShowLoadTables IepServiceCategory


set nocount on;
declare @n varchar(100) ; select @n = 'IepServiceCategory'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	HasMapTable = 1, 
	MapTable = 'LEGACYSPED.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'ServiceCategoryCode'
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = 's.DestID in (select DestID from LEGACYSPED.MAP_IepServiceCategoryID)'
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n



select d.*
--UPDATE IepServiceCategory SET Name=s.Name, Sequence=s.Sequence, DeletedDate=s.DeletedDate
FROM  IepServiceCategory d JOIN 
	LEGACYSPED.Transform_IepServiceCategory  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from LEGACYSPED.MAP_IepServiceCategoryID)

-- INSERT LEGACYSPED.MAP_IepServiceCategoryID
SELECT ServiceCategoryCode, NEWID()
FROM LEGACYSPED.Transform_IepServiceCategory s
WHERE NOT EXISTS (SELECT * FROM IepServiceCategory d WHERE s.DestID=d.ID)

-- INSERT IepServiceCategory (ID, Name, Sequence, DeletedDate)
SELECT s.DestID, s.Name, s.Sequence, s.DeletedDate
FROM LEGACYSPED.Transform_IepServiceCategory s
WHERE NOT EXISTS (SELECT * FROM IepServiceCategory d WHERE s.DestID=d.ID)


select * from IepServiceCategory






*/

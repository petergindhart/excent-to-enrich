-- use in all states, all districts
-- #############################################################################
-- IepServiceCategory Map Table
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_IepServiceCategoryID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1) 
BEGIN
CREATE TABLE AURORAX.MAP_IepServiceCategoryID
(
	ServiceCategoryCode varchar(20) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE AURORAX.MAP_IepServiceCategoryID ADD CONSTRAINT
PK_MAP_IepServiceCategoryID PRIMARY KEY CLUSTERED
(
	ServiceCategoryCode
)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_IepServiceCategory') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_IepServiceCategory  
GO  

CREATE VIEW AURORAX.Transform_IepServiceCategory  
AS
	SELECT
		k.ServiceCategoryCode,
		DestID = coalesce(s.ID, t.ID, m.DestID),
		Name = coalesce(s.Name, t.Name, case k.ServiceCategoryCode when 'SpecialEd' then 'Special Education' else k.ServiceCategoryCode end), -- It is important to get t where it exists because we are updating the target table and we don't want to change t where t already existed
		Sequence = coalesce(s.Sequence, t.Sequence, 99),
		DeletedDate = CAST(null as datetime)
	FROM
		(
		SELECT ServiceCategoryCode = SubType
		FROM AURORAX.Lookups
		WHERE Type = 'Service'
		GROUP BY SubType
		) k LEFT JOIN
		dbo.IepServiceCategory s on case k.ServiceCategoryCode when 'SpecialEd' then 'Special Education' else k.ServiceCategoryCode end = s.Name LEFT JOIN
		AURORAX.MAP_IepServiceCategoryID m ON k.ServiceCategoryCode = m.ServiceCategoryCode LEFT JOIN
		dbo.IepServiceCategory t on m.DestID = t.ID	
GO

-- ServiceDefCode


/*

GEO.ShowLoadTables IepServiceCategory


set nocount on;
declare @n varchar(100) ; select @n = 'IepServiceCategory'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	HasMapTable = 1, 
	MapTable = 'AURORAX.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'ServiceCategoryCode'
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = 's.DestID in (select DestID from AURORAX.MAP_IepServiceCategoryID)'
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n



select d.*
--UPDATE IepServiceCategory SET Name=s.Name, Sequence=s.Sequence, DeletedDate=s.DeletedDate
FROM  IepServiceCategory d JOIN 
	AURORAX.Transform_IepServiceCategory  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from AURORAX.MAP_IepServiceCategoryID)

-- INSERT AURORAX.MAP_IepServiceCategoryID
SELECT ServiceCategoryCode, NEWID()
FROM AURORAX.Transform_IepServiceCategory s
WHERE NOT EXISTS (SELECT * FROM IepServiceCategory d WHERE s.DestID=d.ID)

-- INSERT IepServiceCategory (ID, Name, Sequence, DeletedDate)
SELECT s.DestID, s.Name, s.Sequence, s.DeletedDate
FROM AURORAX.Transform_IepServiceCategory s
WHERE NOT EXISTS (SELECT * FROM IepServiceCategory d WHERE s.DestID=d.ID)


select * from IepServiceCategory






*/

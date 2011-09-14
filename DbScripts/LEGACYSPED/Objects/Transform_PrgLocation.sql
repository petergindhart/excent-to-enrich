-- This file may be used in all states, all districts
-- ############################################################################# 
-- Service Location
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgLocationID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgLocationID
(
	ServiceLocationCode varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgLocationID ADD CONSTRAINT
PK_MAP_PrgLocationID PRIMARY KEY CLUSTERED
(
	ServiceLocationCode
)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgLocation') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgLocation  
GO  

CREATE VIEW LEGACYSPED.Transform_PrgLocation  
AS
	SELECT
		ServiceLocationCode = k.Code,
		DestID = coalesce(n.ID, s.ID, t.ID, m.DestID),
		Name = coalesce(s.Name, n.Name, t.Name, k.Label),
		Description = coalesce(s.Description, n.Description, t.Description),
		MedicaidLocationID = coalesce(s.MedicaidLocationID, n.MedicaidLocationID, t.MedicaidLocationID),
		StateCode = coalesce(s.StateCode, n.StateCode, t.StateCode, k.StateCode),
		DeletedDate = 
			CASE 
				WHEN s.ID IS NOT NULL THEN NULL -- Always show in UI where there is a StateID.
				ELSE 
					CASE WHEN k.DisplayInUI = 'Y' THEN NULL -- User specified they want to see this in the UI.  Let them. 
					ELSE GETDATE()
					END
			END 
	FROM  
		LEGACYSPED.Lookups k LEFT JOIN
		dbo.PrgLocation s on 
			isnull(k.StateCode,'kServLoc') = isnull(s.StateCode,'sServLoc') and
			s.ID = (select min(cast(ID as varchar(36))) from PrgLocation where StateCode = s.StateCode) left join -- return only one record where duplicate statecodes exist in target
		dbo.PrgLocation n on 
			k.Label = n.Name and
			n.ID = (select min(cast(ID as varchar(36))) from PrgLocation where Name = n.Name) left join -- return only one record where duplicate names exist in target
		LEGACYSPED.MAP_PrgLocationID m on k.Code = m.ServiceLocationCode LEFT JOIN
		dbo.PrgLocation t on m.DestID = t.ID 
	WHERE
		k.Type = 'ServLoc' 
GO

/*

select * from LEGACYSPED.lookups where type = 'ServLoc'



GEO.ShowLoadTables PrgLocation

set nocount on;
declare @n varchar(100) ; select @n = 'PrgLocation'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	HasMapTable = 1, 
	MapTable = 'LEGACYSPED.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'ServiceLocationCode'
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 0
	, DestTableFilter = 's.DestID in (select DestID from LEGACYSPED.MAP_'+@n+'ID)'
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.*
-- UPDATE PrgLocation SET MedicaidLocationID=s.MedicaidLocationID, Name=s.Name, StateCode=s.StateCode, Description=s.Description, DeletedDate=s.DeletedDate
FROM  PrgLocation d JOIN 
	LEGACYSPED.Transform_PrgLocation  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from LEGACYSPED.MAP_PrgLocationID)

-- INSERT LEGACYSPED.MAP_PrgLocationID
SELECT ServiceLocationCode, NEWID()
FROM LEGACYSPED.Transform_PrgLocation s
WHERE NOT EXISTS (SELECT * FROM PrgLocation d WHERE s.DestID=d.ID)

-- INSERT PrgLocation (ID, MedicaidLocationID, Name, StateCode, Description, DeletedDate)
SELECT s.DestID, s.MedicaidLocationID, s.Name, s.StateCode, s.Description, s.DeletedDate
FROM LEGACYSPED.Transform_PrgLocation s
WHERE NOT EXISTS (SELECT * FROM PrgLocation d WHERE s.DestID=d.ID)

select * from PrgLocation where Name = 'Cafeteria'


select * from TestOnlin_Ok2delete.dbo.PrgLocation where Name = 'Cafeteria'



*/




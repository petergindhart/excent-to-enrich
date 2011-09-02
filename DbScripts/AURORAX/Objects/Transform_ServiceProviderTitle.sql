-- #############################################################################
-- Service Provider Title
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_ServiceProviderTitleID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_ServiceProviderTitleID
(
	ServiceProviderTitleCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE AURORAX.MAP_ServiceProviderTitleID ADD CONSTRAINT
PK_MAP_ServiceProviderTitleID PRIMARY KEY CLUSTERED
(
	ServiceProviderTitleCode
)
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_ServiceProviderTitle') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_ServiceProviderTitle
GO  

CREATE VIEW AURORAX.Transform_ServiceProviderTitle  
AS  
 SELECT   
	ServiceProviderCode = k.Code,
	DestID = coalesce(s.ID, t.ID, m.DestID),
	Name = k.Label,
	StateCode = k.StateCode,
		DeletedDate = 
			CASE 
				WHEN s.ID IS NOT NULL THEN NULL -- Always show in UI where there is a StateID.  Period.
				ELSE 
					CASE WHEN k.DisplayInUI = 'Y' THEN NULL -- User specified they want to see this in the UI.  Let them.
					ELSE GETDATE()
					END
			END 
 FROM  
  AURORAX.Lookups k LEFT JOIN
  dbo.ServiceProviderTitle s on k.StateCode = s.StateCode LEFT JOIN
  AURORAX.MAP_ServiceProviderTitleID m on k.Code = m.ServiceProviderTitleCode LEFT JOIN
  dbo.ServiceProviderTitle t on m.ServiceProviderTitleCode = t.Name
 WHERE
  k.Type = 'ServProv'
GO
--
/*

GEO.ShowLoadTables ServiceProviderTitle

set nocount on;
declare @n varchar(100) ; select @n = 'ServiceProviderTitle'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	SourceTable = 'AURORAX.Transform_'+@n
	, HasMapTable = 1
	, MapTable = 'AURORAX.MAP_'+@n+'ID'
	, KeyField = 'ServiceProviderCode'
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = 's.DestID in (select DestID from AURORAX.MAP_ServiceProviderTitleID)'
	, Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n

select d.*
-- UPDATE ServiceProviderTitle SET DeletedDate=s.DeletedDate, StateCode=s.StateCode, Name=s.Name
FROM  ServiceProviderTitle d JOIN 
	AURORAX.Transform_ServiceProviderTitle  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from AURORAX.MAP_ServiceProviderTitleID)

-- INSERT AURORAX.MAP_ServiceProviderTitleID
SELECT ServiceProviderCode, NEWID()
FROM AURORAX.Transform_ServiceProviderTitle s
WHERE NOT EXISTS (SELECT * FROM ServiceProviderTitle d WHERE s.DestID=d.ID)

-- INSERT ServiceProviderTitle (ID, DeletedDate, StateCode, Name)
SELECT s.DestID, s.DeletedDate, s.StateCode, s.Name
FROM AURORAX.Transform_ServiceProviderTitle s
WHERE NOT EXISTS (SELECT * FROM ServiceProviderTitle d WHERE s.DestID=d.ID)

select * from ServiceProviderTitle




*/



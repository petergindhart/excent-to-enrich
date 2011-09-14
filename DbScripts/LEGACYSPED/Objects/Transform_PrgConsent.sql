IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgConsent') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgConsent
GO

CREATE VIEW LEGACYSPED.Transform_PrgConsent
AS
	SELECT
		DestID = m.DestID,
		ConsentGrantedID = CASE WHEN iep.ConsentForServicesDate IS NOT NULL THEN CAST('B76DDCD6-B261-4D46-A98E-857B0A814A0C' AS uniqueidentifier) ELSE NULL END,
		ConsentDate = CAST(iep.ConsentForServicesDate as DATETIME) -- select iep.IEPRefID
	FROM
		LEGACYSPED.Transform_PrgIep iep JOIN
		LEGACYSPED.MAP_PrgSectionID m on 
			m.DefID = 'D83A4710-A69F-4310-91F8-CB5BFFB1FE4C' AND --Sped Consent Services
			m.VersionID = iep.VersionDestID 
GO
--

/*



GEO.ShowLoadTables PrgConsent


set nocount on;
declare @n varchar(100) ; select @n = 'PrgConsent'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set enabled = 1
from VC3ETL.LoadTable t where t.ID = @t

update t set 
	SourceTable = 'LEGACYSPED.Transform_'+@n
	, HasMapTable = 0
	, MapTable = NULL
	, KeyField = NULL
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = NULL
	, Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.*
-- UPDATE PrgConsent SET ConsentDate=s.ConsentDate, ConsentGrantedID=s.ConsentGrantedID
FROM  PrgConsent d JOIN 
	LEGACYSPED.Transform_PrgConsent  s ON s.DestID=d.ID

-- INSERT PrgConsent (ID, ConsentDate, ConsentGrantedID)
SELECT s.DestID, s.ConsentDate, s.ConsentGrantedID
FROM LEGACYSPED.Transform_PrgConsent s
WHERE NOT EXISTS (SELECT * FROM PrgConsent d WHERE s.DestID=d.ID)

select * from PrgConsent


*/



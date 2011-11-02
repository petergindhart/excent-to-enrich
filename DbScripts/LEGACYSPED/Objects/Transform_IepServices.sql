IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepServices') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepServices
GO

CREATE VIEW LEGACYSPED.Transform_IepServices
AS
	SELECT
		IEP.IepRefId,
		m.DestID,
		DeliveryStatement = x.ServiceDeliveryStatement -- since Transform_IepServices is use in a lot of operations, leave the text field out of the transform for speed
	FROM
		LEGACYSPED.Transform_PrgIep iep JOIN		
		LEGACYSPED.MAP_PrgSectionID m on 
			m.DefID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F' and
			m.VersionID = iep.VersionDestID JOIN
		LEGACYSPED.IEP x on iep.IepRefID = x.IepRefID
GO
--


/*

GEO.ShowLoadTables IepServices


set nocount on;
declare @n varchar(100) ; select @n = 'IepServices'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t


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
-- UPDATE IepServices SET DeliveryStatement=s.DeliveryStatement
FROM  IepServices d JOIN 
	LEGACYSPED.Transform_IepServices  s ON s.DestID=d.ID

-- INSERT IepServices (ID, DeliveryStatement)
SELECT s.DestID, s.DeliveryStatement
FROM LEGACYSPED.Transform_IepServices s
WHERE NOT EXISTS (SELECT * FROM IepServices d WHERE s.DestID=d.ID)

select * from IepServices



*/



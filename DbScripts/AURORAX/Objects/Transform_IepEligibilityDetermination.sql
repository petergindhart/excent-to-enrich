IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_IepEligibilityDetermination') AND OBJECTPROPERTY(id, N'IsView') = 1)  
DROP VIEW AURORAX.Transform_IepEligibilityDetermination  
GO  
  
CREATE VIEW AURORAX.Transform_IepEligibilityDetermination  
AS  
 SELECT   
  DestID = s.DestID,
  DateDetermined = iep.StartDate
 FROM
  AURORAX.Transform_PrgIep iep JOIN
  AURORAX.MAP_PrgSectionID s on 
	s.DefID = 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A' and
	s.VersionID = iep.VersionDestID 
GO



/*


GEO.ShowLoadTables IepEligibilityDetermination

set nocount on;
declare @n varchar(100) ; select @n = 'IepEligibilityDetermination'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set enabled = 1
from VC3ETL.LoadTable t where t.ID = @t

	SourceTable = 'AURORAX.Transform_'+@n
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
-- UPDATE IepEligibilityDetermination SET DateDetermined=s.DateDetermined
FROM  IepEligibilityDetermination d JOIN 
	AURORAX.Transform_IepEligibilityDetermination  s ON s.DestID=d.ID

-- INSERT IepEligibilityDetermination (ID, DateDetermined)
SELECT s.DestID, s.DateDetermined
FROM AURORAX.Transform_IepEligibilityDetermination s
WHERE NOT EXISTS (SELECT * FROM IepEligibilityDetermination d WHERE s.DestID=d.ID)

select * from IepEligibilityDetermination





*/






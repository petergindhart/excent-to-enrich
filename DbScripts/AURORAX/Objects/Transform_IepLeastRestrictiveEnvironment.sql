IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_IepLeastRestrictiveEnvironment') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW AURORAX.Transform_IepLeastRestrictiveEnvironment
GO

CREATE VIEW AURORAX.Transform_IepLeastRestrictiveEnvironment
AS
	SELECT
		iep.IepRefId,
		DestID = sec.ID,
		MinutesInstruction = iep.MinutesPerWeek
	FROM
		AURORAX.Transform_PrgIep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = '0CBA436F-8043-4D22-8F3D-289E057F1AAB'  --IEP LRE
GO
-- 


/*

-- ==================================================================================================================== 
-- ========================================= IepLeastRestrictiveEnvironment  ==========================================
-- ==================================================================================================================== 

GEO.ShowLoadTables IepLeastRestrictiveEnvironment


set nocount on;
declare @n varchar(100) ; select @n = 'IepLeastRestrictiveEnvironment'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set enabled = 1
from VC3ETL.LoadTable t where t.ID = @t


update t set 
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
-- UPDATE IepLeastRestrictiveEnvironment SET MinutesInstruction=s.MinutesInstruction
FROM  IepLeastRestrictiveEnvironment d JOIN 
	AURORAX.Transform_IepLeastRestrictiveEnvironment  s ON s.DestID=d.ID

-- INSERT IepLeastRestrictiveEnvironment (ID, MinutesInstruction)
SELECT s.DestID, s.MinutesInstruction
FROM AURORAX.Transform_IepLeastRestrictiveEnvironment s
WHERE NOT EXISTS (SELECT * FROM IepLeastRestrictiveEnvironment d WHERE s.DestID=d.ID)

select * from IepLeastRestrictiveEnvironment










*/
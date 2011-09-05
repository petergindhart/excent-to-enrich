--#include Transform_PrgIep.sql
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_PrgGoals') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_PrgGoals
GO

CREATE VIEW AURORAX.Transform_PrgGoals
AS
	SELECT
		iep.IepRefId,
		DestID = sec.ID,
		ReportFrequencyID = cast(NULL as uniqueidentifier)
	FROM
	AURORAX.Transform_PrgIep iep JOIN -- 10721
	PrgSection sec ON
		sec.VersionID = iep.VersionDestID AND -- our map of PrgSection is using ItemID instead of VersionID.  Does that matter?
		sec.DefID = '84E5A67D-CC9A-4D5B-A7B8-C04E8C3B8E0A' --IEP Goals
	WHERE exists (select 1 from AURORAX.Goal g where iep.IepRefID = g.IepRefID) -- 10715 (interpretation : 6 ieps do not have goals.  Do not insert a PrgGoals record for these)
GO
-- 
/*

GEO.ShowLoadTables PrgGoals


set nocount on;
declare @n varchar(100) ; select @n = 'PrgGoals'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set Enabled = 1
	, HasMapTable = 0
	, MapTable = NULL
	, KeyField = NULL
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = NULL
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.*
-- UPDATE PrgGoals SET ReportFrequencyID=s.ReportFrequencyID
FROM  PrgGoals d JOIN 
	AURORAX.Transform_PrgGoals  s ON s.DestID=d.ID

-- INSERT PrgGoals (ID, ReportFrequencyID)
SELECT s.DestID, s.ReportFrequencyID
FROM AURORAX.Transform_PrgGoals s
WHERE NOT EXISTS (SELECT * FROM PrgGoals d WHERE s.DestID=d.ID)

select * from PrgGoals



*/


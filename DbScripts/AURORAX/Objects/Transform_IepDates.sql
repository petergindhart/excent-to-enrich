--#include Transform_Iep.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_IepDates') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_IepDates
GO

CREATE VIEW AURORAX.Transform_IepDates
AS
	SELECT
		DestID = m.DestID,
		NextReviewDate = CASE WHEN ISDATE(s.NextReviewDate) = 1 THEN s.NextReviewDate ELSE NULL END,
		NextEvaluationDate = CASE WHEN ISDATE(s.NextEvaluationDate) = 1 THEN s.NextEvaluationDate ELSE NULL END,
		InitialEvaluationDate = CASE WHEN ISDATE(s.InitialEvaluationDate) = 1 THEN s.InitialEvaluationDate ELSE NULL END,
		LatestEvaluationDate = CASE WHEN ISDATE(s.LatestEvaluationDate) = 1 THEN s.LatestEvaluationDate ELSE NULL END
	FROM
		AURORAX.Transform_PrgIep iep JOIN
		AURORAX.IEP s on s.IepRefID = iep.IepRefID LEFT JOIN
		AURORAX.MAP_PrgSectionID m on 
			m.DefID = 'EE479921-3ECB-409A-96D7-61C8E7BA0E7B' and
			m.ItemID = iep.DestID
GO
--

/*

GEO.ShowLoadTables IepDates


set nocount on;
declare @n varchar(100) ; select @n = 'IepDates'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	SourceTable = 'AURORAX.Transform_IepDates'
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
-- UPDATE IepDates SET NextEvaluationDate=s.NextEvaluationDate, LatestEvaluationDate=s.LatestEvaluationDate, NextReviewDate=s.NextReviewDate, InitialEvaluationDate=s.InitialEvaluationDate
FROM  IepDates d JOIN 
	AURORAX.Transform_IepDates  s ON s.DestID=d.ID

-- INSERT IepDates (ID, NextEvaluationDate, LatestEvaluationDate, NextReviewDate, InitialEvaluationDate)
SELECT s.DestID, s.NextEvaluationDate, s.LatestEvaluationDate, s.NextReviewDate, s.InitialEvaluationDate
FROM AURORAX.Transform_IepDates s
WHERE NOT EXISTS (SELECT * FROM IepDates d WHERE s.DestID=d.ID)


select * from IepDates



*/



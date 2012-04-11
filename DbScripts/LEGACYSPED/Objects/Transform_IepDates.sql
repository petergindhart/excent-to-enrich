--#include Transform_PrgSection.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_Dates') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_Dates
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepDates') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepDates
GO

CREATE VIEW LEGACYSPED.Transform_IepDates
AS
	SELECT
		DestID = m.DestID,
		NextReviewDate = CASE WHEN ISDATE(s.NextReviewDate) = 1 THEN s.NextReviewDate ELSE NULL END,
		NextEvaluationDate = CASE WHEN ISDATE(s.NextEvaluationDate) = 1 THEN s.NextEvaluationDate ELSE NULL END,
		InitialEvaluationDate = CASE WHEN ISDATE(s.InitialEvaluationDate) = 1 THEN s.InitialEvaluationDate ELSE NULL END,
		LatestEvaluationDate = CASE WHEN ISDATE(s.LatestEvaluationDate) = 1 THEN s.LatestEvaluationDate ELSE NULL END
	FROM
		LEGACYSPED.Transform_PrgIep iep JOIN
		LEGACYSPED.IEP s on s.IepRefID = iep.IepRefID LEFT JOIN
		LEGACYSPED.MAP_PrgSectionID m on 
			m.DefID = 'EE479921-3ECB-409A-96D7-61C8E7BA0E7B' and
			m.VersionID = iep.VersionDestID
GO
--



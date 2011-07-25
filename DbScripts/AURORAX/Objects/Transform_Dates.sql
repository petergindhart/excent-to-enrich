--#include Transform_Iep.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Dates]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Dates]
GO

CREATE VIEW AURORAX.Transform_Dates
AS
	SELECT
		DestID = m.DestID,
		NextReviewDate = CASE WHEN ISDATE(s.NextReviewDate) = 1 THEN s.NextReviewDate ELSE NULL END,
		NextEvaluationDate = CASE WHEN ISDATE(s.NextEvaluationDate) = 1 THEN s.NextEvaluationDate ELSE NULL END,
		InitialEvaluationDate = CASE WHEN ISDATE(s.InitialEvaluationDate) = 1 THEN s.InitialEvaluationDate ELSE NULL END,
		LatestEvaluationDate = CASE WHEN ISDATE(s.LatestEvaluationDate) = 1 THEN s.LatestEvaluationDate ELSE NULL END
		--EligibilityDate = i.IEPMeetingDate, -- should this be InitialEvalCompleteDate?  we probably need curr eval date
		--ConsentDate = i.InitialConsentDate, -- This is Initial - is that what is needed?
	FROM
		AURORAX.Transform_Iep iep JOIN
		AURORAX.IEP s on s.IepRefID = iep.IepRefID LEFT JOIN
		AURORAX.Map_SectionID m on 
			m.DefID = 'EE479921-3ECB-409A-96D7-61C8E7BA0E7B' and
			m.VersionID = iep.VersionDestID
GO
--
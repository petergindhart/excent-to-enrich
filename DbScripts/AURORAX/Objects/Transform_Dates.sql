--#include Transform_Iep.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Dates]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Dates]
GO

CREATE VIEW AURORAX.Transform_Dates
AS
	SELECT
		DestID = sec.ID,
		NextReviewDate = i.NextAnnualDate,
		NextEvaluationDate = i.NextTriennialDate,
		EligibilityDate = i.IEPMeetingDate, -- should this be InitialEvalCompleteDate?  we probably need curr eval date
		ConsentDate = i.InitialConsentDate -- This is Initial - is that what is needed?
	FROM
		AURORAX.Transform_Iep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = 'EE479921-3ECB-409A-96D7-61C8E7BA0E7B' JOIN --IEP Dates
		  AURORAX.IEP i on iep.IepRefID = i.IepRefID
GO
--
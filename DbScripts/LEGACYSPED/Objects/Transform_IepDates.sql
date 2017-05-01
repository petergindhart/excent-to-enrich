

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
		NextReviewDate = CASE WHEN ISDATE(iep.NextReviewDate) = 1 THEN iep.NextReviewDate ELSE NULL END,
		NextEvaluationDate = CASE WHEN ISDATE(iep.NextEvaluationDate) = 1 THEN iep.NextEvaluationDate ELSE NULL END,
		InitialEvaluationDate = CASE WHEN ISDATE(iep.InitialEvaluationDate) = 1 THEN iep.InitialEvaluationDate ELSE NULL END,
		LatestEvaluationDate = CASE WHEN ISDATE(iep.LatestEvaluationDate) = 1 THEN iep.LatestEvaluationDate ELSE NULL END,
		InitialEligibilityDate = CASE WHEN ISDATE(iep.InitialEligibilityDate) = 1 THEN iep.InitialEligibilityDate ELSE NULL END,
		NextEligibilityDate = CASE WHEN ISDATE(iep.NextEligibilityDate) = 1 THEN iep.NextEligibilityDate ELSE NULL END,
		InitialIepDate = CASE WHEN ISDATE(iep.InitialIepDate) = 1 THEN iep.InitialIepDate ELSE NULL END,
		InitialConsentforServicesDate = CASE WHEN ISDATE(iep.InitialConsentforServicesDate) = 1 THEN iep.InitialConsentforServicesDate ELSE NULL END,
		InitialConsentforEvaluationDate = COALESCE(iep.InitialConsentforEvaluationDate, iep.InitialEvaluationDate, iep.LatestEvaluationDate),
		i.DoNotTouch
	FROM
		LEGACYSPED.Transform_PrgIep i LEFT JOIN
		LEGACYSPED.IEP iep on i.IepRefID = iep.IepRefID LEFT JOIN
		LEGACYSPED.MAP_PrgSectionID m on 
			i.VersionDestID = m.VersionID and
			m.DefID = 'EE479921-3ECB-409A-96D7-61C8E7BA0E7B' 
GO
--

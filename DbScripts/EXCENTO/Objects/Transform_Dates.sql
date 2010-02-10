--#include Transform_Iep.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_Dates]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_Dates]
GO

CREATE VIEW EXCENTO.Transform_Dates
AS
	SELECT
		DestID = sec.ID,
		NextReviewDate = CAST(NULL AS DATETIME),
		NextEvaluationDate = CAST(NULL AS DATETIME),
		EligibilityDate = CAST(NULL AS DATETIME),
		ConsentDate = CAST(NULL AS DATETIME)
	FROM
		EXCENTO.Transform_Iep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = '0666ECBD-47D9-4536-B8A5-AA8E83C2BA2C' --IEP Dates

		
GO

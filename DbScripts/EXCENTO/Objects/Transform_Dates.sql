--#include Transform_Iep.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_Dates]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_Dates]
GO

CREATE VIEW EXCENTO.Transform_Dates
AS
	SELECT
		DestID = sec.ID,
		NextReviewDate = i.ReviewDate,
		NextEvaluationDate = i.ReEvalDate,
		EligibilityDate = i.CurrEvalDate,
		ConsentDate = p.ParentalConsentToEvalDate
	FROM
		EXCENTO.Transform_Iep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = '0666ECBD-47D9-4536-B8A5-AA8E83C2BA2C' JOIN --IEP Dates
		EXCENTO.IEPTbl i ON iep.IEPSeqNum = i.IEPSeqNum JOIN
		EXCENTO.IEPTbl_SC i2 ON i.IEPSeqNum = i2.IEPSeqNum LEFT JOIN (
			SELECT ph.GStudentID, max(ph.RecNum) RecNum  
			FROM EXCENTO.SC_PlaceHistoryTbl ph
			WHERE isnull(ph.del_flag,0)=0 and 
			ph.PlaceDate = (
				SELECT max(phIn.PlaceDate) PlaceDate
				FROM EXCENTO.SC_PlaceHistoryTbl phIn
				WHERE ph.GStudentID = phIn.GStudentID and 
					isnull(phIn.del_flag,0)=0 and
					phIn.ParentalConsentToEvalDate is NOT NULL
				)
			GROUP BY ph.GStudentID
			) p2 on i.GStudentID = p2.GStudentID LEFT JOIN
		EXCENTO.SC_PlaceHistoryTbl p on p2.RecNum = p.RecNum
GO

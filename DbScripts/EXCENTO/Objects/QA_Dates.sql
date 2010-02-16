--#include Transform_Iep.sql
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[QA_Dates]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[QA_Dates]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [EXCENTO].[QA_Dates]
AS
	SELECT
		iep.IEPSeqNum, iep.GStudentID,
		sec.NextReviewDate, sec.NextEvaluationDate, sec.EligibilityDate, sec.ConsentDate
	FROM
		EXCENTO.Transform_Iep iep JOIN
		EXCENTO.Transform_Section secBase ON secBase.ItemID = iep.DestID JOIN
		-- replace [<section table>] below with table name in list
		[IepDates] sec ON sec.ID = secBase.DestID
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepEligibilityDetermination') AND OBJECTPROPERTY(id, N'IsView') = 1)  
DROP VIEW LEGACYSPED.Transform_IepEligibilityDetermination  
GO

CREATE VIEW LEGACYSPED.Transform_IepEligibilityDetermination  
AS
SELECT   
	IEPRefID = iep.ExistingIEPRefID,
	DestID = s.DestID,
	DateDetermined = i.LatestEvaluationDate, -- had briefly used the EligibilityDate here, but it did not make sense, so it has been removed.
	NoneSuspected = cast(0 as Bit),
	iep.Touched
FROM
	LEGACYSPED.EvaluateIncomingItems iep JOIN 
	LEGACYSPED.IEP i on iep.ExistingIEPRefID = i.IepRefID LEFT JOIN
	LEGACYSPED.MAP_PrgSectionID s on 
		s.DefID = 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A' and
		s.VersionID = iep.ExistingConvertedVersionID 
-- where s.VersionID is not null
GO

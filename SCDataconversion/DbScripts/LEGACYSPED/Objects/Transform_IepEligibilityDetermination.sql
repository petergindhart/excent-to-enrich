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
		s.DefID = 'DC3BE88C-7BA4-4041-A8FB-BCC96D2D4C29' and
		s.VersionID = iep.ExistingConvertedVersionID 
-- where s.VersionID is not null
GO

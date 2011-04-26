IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_DisabilityEligibility') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_DisabilityEligibility
GO

CREATE VIEW AURORAX.Transform_DisabilityEligibility
AS
	SELECT
		iep.IepRefId,
		DestID = m.DestID, -- elig.ID, 
		InstanceID = sec.ID, 
		DisabilityID = dis.DestID, 
		Sequence = sd.DisabilitySequence, 
		IsEligibileID = 'B76DDCD6-B261-4D46-A98E-857B0A814A0C', -- Only Eligible disabilities provided  
		FormInstanceID = cast(NULL as uniqueidentifier)
		-- select iep.*
	FROM
		AURORAX.Transform_IEP iep JOIN
		PrgSection sec ON 
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A' JOIN -- select * from PrgSectionDef where ID = 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A' -- select * from PrgItemDef where ID = '8011D6A2-1014-454B-B83C-161CE678E3D3' -- select * from PrgSectionType where ID = 'F65AEF7A-5EF8-46DD-B207-ADA61CD3A4CB' -- Sped Eligibility Determination
-- 'C13C3138-D197-4ED2-9792-404C156FCDB4'
		AURORAX.StudentDisability sd on iep.IepRefId = sd.IepRefId JOIN
		AURORAX.MAP_IepDisabilityID dis on sd.DisabilityCode = dis.DisabilityCode LEFT JOIN -- only 1 instance per student w/2 disab?
		AURORAX.MAP_DisabilityEligibilityID m on 
			sd.IepRefId = m.IepRefId AND
			sd.DisabilitySequence = m.DisabilitySequence LEFT JOIN 
		dbo.IepDisabilityEligibility elig on 
			m.DestID = elig.ID
GO
--
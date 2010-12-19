IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_DisabilityEligibility') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_DisabilityEligibility
GO

CREATE VIEW AURORAX.Transform_DisabilityEligibility
AS
	SELECT
		iep.IEPPKID,
		DestID = m.DestID, -- elig.ID, 
		InstanceID = sec.ID, 
		DisabilityID = dis.DestID, 
		Sequence = sd.DisabilitySequence, 
		IsEligibileID = 'B76DDCD6-B261-4D46-A98E-857B0A814A0C', -- Only Eligible disabilities provided  
		FormInstanceID = cast(NULL as uniqueidentifier)
	FROM
		AURORAX.Transform_IEP iep JOIN
		PrgSection sec ON 
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A' JOIN 
		AURORAX.StudentDisability sd on iep.IEPPKID = sd.IEPPKID JOIN 
		AURORAX.MAP_IepDisabilityID dis on sd.DisabilityCode = dis.DisabilityCode LEFT JOIN -- only 1 instance per student w/2 disab?
		AURORAX.MAP_DisabilityEligibilityID m on 
			sd.IEPPKID = m.IEPPKID AND
			sd.DisabilitySequence = m.DisabilitySequence LEFT JOIN 
		dbo.IepDisabilityEligibility elig on 
			m.DestID = elig.ID
GO




--#include Transform_IepDisability.sql
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_DisabilityEligibility') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_DisabilityEligibility
GO

CREATE VIEW AURORAX.Transform_DisabilityEligibility
AS
	SELECT
		InstanceID = m.DestID, 
		DisabilityID = d.DestID, 
		Sequence = d.Sequence,
		IsEligibileID = 'B76DDCD6-B261-4D46-A98E-857B0A814A0C', -- Only Eligible disabilities provided  
		FormInstanceID = cast(NULL as uniqueidentifier)
	FROM
		AURORAX.Transform_Iep iep JOIN
		AURORAX.Map_SectionID m on 
			m.DefID = 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A' and
			m.VersionID = iep.VersionDestID JOIN
		AURORAX.Student s on s.StudentRefID = iep.StudentRefID JOIN
		(
			select StateCode, DestID, hack.Sequence
			FROM
			AURORAX.Transform_IepDisability CROSS JOIN
			(
				select 1 [Sequence] union
				select 2 [Sequence] union
				select 3 [Sequence] union
				select 4 [Sequence] union
				select 5 [Sequence] union
				select 6 [Sequence] union
				select 7 [Sequence] union
				select 8 [Sequence] union
				select 9 [Sequence] 
			) hack
		) d ON
			(s.Disability1Code = d.StateCode and d.Sequence = 1) OR
			(s.Disability2Code = d.StateCode and d.Sequence = 2) OR
			(s.Disability3Code = d.StateCode and d.Sequence = 3) OR
			(s.Disability4Code = d.StateCode and d.Sequence = 4) OR
			(s.Disability5Code = d.StateCode and d.Sequence = 5) OR
			(s.Disability6Code = d.StateCode and d.Sequence = 6) OR
			(s.Disability7Code = d.StateCode and d.Sequence = 7) OR
			(s.Disability8Code = d.StateCode and d.Sequence = 8) OR
			(s.Disability9Code = d.StateCode and d.Sequence = 9) 
GO
--
--#include Transform_Iep.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_PrgConsent]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_PrgConsent]
GO

CREATE VIEW AURORAX.Transform_PrgConsent
AS
	SELECT
		DestID = m.DestID,
		ConsentGrantedID = CASE WHEN s.ConsentForServicesDate IS NOT NULL THEN CAST('B76DDCD6-B261-4D46-A98E-857B0A814A0C' AS uniqueidentifier) ELSE NULL END,
		ConsentDate = CAST(s.ConsentForServicesDate as DATETIME)
	FROM
		AURORAX.Transform_Iep iep JOIN
		AURORAX.IEP s on s.IepRefID = iep.IepRefID LEFT JOIN
		AURORAX.Map_SectionID m on 
			m.DefID = 'D83A4710-A69F-4310-91F8-CB5BFFB1FE4C' AND --Sped Consent Services
			m.VersionID = iep.VersionDestID
GO
--
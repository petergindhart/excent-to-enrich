IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_IepDisability') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW AURORAX.Transform_IepDisability
GO

CREATE VIEW AURORAX.Transform_IepDisability
AS
	SELECT
		d.DisabilityCode,
		DestID = m.DestID,
		Name = d.DisabilityDesc,
		Definition = d.DisabilityCode,
		DeterminationFormTemplateID = CAST(NULL AS UNIQUEIDENTIFIER)
	FROM
		AURORAX.DisabilityCode d LEFT JOIN
		AURORAX.MAP_IepDisabilityID m on d.DisabilityCode = m.DisabilityCode
GO

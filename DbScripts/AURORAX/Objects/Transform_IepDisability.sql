IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_IepDisability]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_IepDisability]
GO

CREATE VIEW [AURORAX].[Transform_IepDisability]
AS
	SELECT
		DisabilityCode = x.Code,
		DestID = m.DestID,
		Name = x.Label,
		Definition = isnull(i.Definition, '<div></div>'),
		i.DeterminationFormTemplateID 
	FROM
		AURORAX.Lookups x LEFT JOIN
		AURORAX.MAP_IepDisabilityID m on x.Code = m.DisabilityCode LEFT JOIN
		IepDisability i on m.DestId = i.ID
	WHERE
		x.Type = 'Disab' AND
		x.Code <> '00' 
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_IepDisability]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_IepDisability]
GO

CREATE VIEW [AURORAX].[Transform_IepDisability]
AS
	SELECT
		DestID = ISNULL(x.ID, NEWID()),
		Name = isnull(x.Name, l.Label),
		Definition = isnull(x.Definition,''),
		DeterminationFormTemplateID = x.DeterminationFormTemplateID,
		StateCode = l.StateCode,
		DeletedDate = CASE WHEN x.ID IS NULL THEN GETDATE() ELSE x.DeletedDate END
	FROM
		AURORAX.Lookups l LEFT JOIN
		IepDisability x on l.StateCode = x.StateCode  -- there is no map table, so we must provide the state code with the student disability data to map directly to IepDisability
	WHERE
		l.Type = 'Disab' and
		--x.Code <> '00' AND -- use source table filter
		l.StateCode IS NOT NULL
GO
--

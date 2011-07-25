IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_IepDisability]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_IepDisability]
GO

CREATE VIEW [AURORAX].[Transform_IepDisability]
AS
	SELECT
		DestID = ISNULL(x.ID, NEWID()),
		Name = l.Label,
		Definition = cast('' as text),
		DeterminationFormTemplateID = cast(null as uniqueidentifier),
		StateCode = l.StateCode,
		DeletedDate = CASE WHEN x.ID IS NULL THEN GETDATE() ELSE x.DeletedDate END
	FROM
		AURORAX.Lookups l LEFT JOIN
		IepDisability x on l.StateCode = x.StateCode
	WHERE
		l.Type = 'Disab' AND
		--x.Code <> '00' AND -- use source table filter
		l.StateCode IS NOT NULL
GO
--
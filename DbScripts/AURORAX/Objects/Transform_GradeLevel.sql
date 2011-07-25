IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_GradeLevel]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_GradeLevel]
GO

CREATE VIEW [AURORAX].[Transform_GradeLevel]
AS
	SELECT
		DestID = ISNULL(x.ID, NEWID()),
		Name = l.Code
	FROM
		AURORAX.Lookups l LEFT JOIN
		GradeLevel x on l.Code = x.Name
	WHERE
		l.Type = 'Grade'
GO
--
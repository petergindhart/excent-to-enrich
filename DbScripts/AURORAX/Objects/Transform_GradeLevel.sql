IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_GradeLevel]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_GradeLevel]
GO

CREATE VIEW [AURORAX].[Transform_GradeLevel]
AS
	SELECT
		DestID = ISNULL(x.ID, NEWID()),
		Name = l.Code,
		StateCode = l.StateCode
	FROM
		AURORAX.Lookups l LEFT JOIN
		GradeLevel x on l.StateCode = x.StateCode -- since there is no map table we are going to have to provide the state code in the source data.
	WHERE
		l.Type = 'Grade'
GO
--

-- select * from GradeLevel order by sequence -- select * from [AURORAX].[Transform_GradeLevel] order by name

-- delete GradeLevel where Name = '002'


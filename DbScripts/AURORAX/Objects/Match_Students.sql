IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Match_Students]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Match_Students]
GO

CREATE VIEW [AURORAX].[Match_Students]
AS
	SELECT distinct a.SASID, b.ID [DestID]
	from
		AURORAX.IEP_Data a join
		dbo.Student b on
			a.StudentID = b.Number
GO

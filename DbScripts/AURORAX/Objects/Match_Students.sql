IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Match_Students]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Match_Students]
GO

CREATE VIEW [AURORAX].[Match_Students]
AS
	SELECT a.StudentRefID, b.ID [DestID]
	from
		AURORAX.Student a join
		dbo.Student b on
			a.StudentRefID = b.Number and
			a.Lastname = b.LastName 
			-- b.CurrentSchoolID is not null and --currently only active students; will update aftor manual student refactor
GO
--
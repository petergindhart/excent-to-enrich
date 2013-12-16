IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Match_Students') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Match_Students
GO

CREATE VIEW LEGACYSPED.Match_Students
AS
	SELECT a.StudentRefID, b.ID DestID
	from
		LEGACYSPED.Student a join
		dbo.Student b on
			a.StudentRefID = b.Number and
			a.Lastname = b.LastName 
			-- b.CurrentSchoolID is not null and --currently only active students; will update aftor manual student refactor
GO
--
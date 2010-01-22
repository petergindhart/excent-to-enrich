IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Match_Students]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Match_Students]
GO

CREATE VIEW [EXCENTO].[Match_Students]
AS
	SELECT a.GStudentID, b.ID [DestID]
	from
		EXCENTO.Student a join
		dbo.Student b on
			a.StudentID = b.Number and
			a.Lastname = b.LastName and
			a.Deletedate is null and
			b.CurrentSchoolID is not null --currently only active students; will update aftor manual student refactor
GO

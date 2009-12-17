IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Match_Students]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Match_Students]
GO

CREATE VIEW [EXCENTO].[Match_Students]
AS
	SELECT a.GStudentID, b.ID [DestID]
	from
		EXCENTO.Student a join
		dbo.Student b on
			isnull(a.Del_Flag, 0) = 0 and
			a.SCDOE = b.x_SunsNumber
	union
	SELECT a.GStudentID, b.ID
	from
		EXCENTO.Student a join
		dbo.Student b on
			isnull(a.Del_Flag, 0) = 0 and
			a.SCDOE <> b.x_SunsNumber and
			a.StudentID = b.Number
	union
	SELECT a.GStudentID, b.ID
	from
		EXCENTO.Student a join
		dbo.Student b on
			isnull(a.Del_Flag, 0) = 0 and
			a.SCDOE <> b.x_SunsNumber and
			a.StudentID <> b.Number and
			a.Firstname = b.FirstName and
			a.Lastname = b.LastName and
			a.Birthdate = b.DOB join
		dbo.EnumValue e on
			b.GenderID = e.ID and
			e.DisplayValue = a.Sex
GO
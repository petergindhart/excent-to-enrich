IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Student_Clean]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[Student_Clean]
GO

CREATE VIEW Student_Clean AS
SELECT
	*
FROM
	Student
WHERE
	IsNumeric(Number) = 1
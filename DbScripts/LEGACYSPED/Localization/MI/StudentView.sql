IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.StudentView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.StudentView
GO
CREATE VIEW LEGACYSPED.StudentView
as
SELECT *, StudentStateID = x_UicNumber
FROM dbo.Student
GO
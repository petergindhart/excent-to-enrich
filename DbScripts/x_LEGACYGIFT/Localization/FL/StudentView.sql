IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.StudentView') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.StudentView
GO
CREATE VIEW x_LEGACYGIFT.StudentView
as
SELECT *, StudentStateID = cast(NULL as varchar(20))
FROM dbo.Student s
GO



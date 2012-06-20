

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.StudentwithSSID') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.StudentwithSSID
GO
CREATE VIEW LEGACYSPED.StudentwithSSID
as
SELECT *, StudentStateID = cast(NULL as varchar(50))
FROM dbo.Student
GO

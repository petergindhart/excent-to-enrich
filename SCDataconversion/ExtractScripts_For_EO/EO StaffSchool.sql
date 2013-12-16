IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.StaffSchool_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.StaffSchool_EO
GO

CREATE VIEW dbo.StaffSchool_EO
AS
SELECT Line_No=Row_Number() OVER (ORDER BY (SELECT 1)),s.Email as StaffEmail ,SchoolID as SchoolCode
FROM dbo.StaffSchool ss JOIN dbo.Staff s ON s.StaffGID = ss.StaffGID 
WHERE ss.DeleteID is NULL 


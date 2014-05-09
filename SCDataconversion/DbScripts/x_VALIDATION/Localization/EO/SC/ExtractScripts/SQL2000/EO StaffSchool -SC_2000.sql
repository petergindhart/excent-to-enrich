IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vw_StaffSchool') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.vw_StaffSchool
GO

CREATE VIEW dbo.vw_StaffSchool
AS
SELECT 
--Line_No=Row_Number() OVER (ORDER BY (SELECT 1)),
s.Email as StaffEmail ,
SchoolID as SchoolCode
FROM dbo.StaffSchool ss JOIN dbo.Staff s ON s.StaffGID = ss.StaffGID 
WHERE ss.DeleteID IS NULL 
GO

IF  EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.StaffSchool_src') AND type in (N'U'))
DROP TABLE dbo.StaffSchool_src
GO
SELECT  
Line_No = IDENTITY(INT,1,1),
StaffEmail ,
SchoolCode
INTO dbo.StaffSchool_src
FROM dbo.vw_StaffSchool

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.StaffSchool_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.StaffSchool_EO
GO

CREATE VIEW dbo.StaffSchool_EO
AS
SELECT  
Line_No,
StaffEmail ,
SchoolCode
FROM dbo.StaffSchool_src
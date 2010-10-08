IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[ReportStudentSchools]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[ReportStudentSchools]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[ReportStudentSchools_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[ReportStudentSchools_LOCAL]
GO

CREATE TABLE [EXCENTO].[ReportStudentSchools_LOCAL](
GStudentID	uniqueidentifier NOT NULL,
ServiceSchCode	nvarchar(10),
ServiceSchName	nvarchar(50),
ServiceSchRegion	nvarchar(80),
ServiceSchoolType	nvarchar(80),
ServiceDistCode	nvarchar(10),
ServiceDistName	nvarchar(50),
ResidSchCode	nvarchar(10),
ResidSchName	nvarchar(50),
ResidSchRegion	nvarchar(80),
ResidSchoolType	nvarchar(80),
ResidDistCode	nvarchar(10),
ResidDistName	nvarchar(50)
) ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[ReportStudentSchools]
AS
	SELECT * FROM [EXCENTO].[ReportStudentSchools_LOCAL]
GO

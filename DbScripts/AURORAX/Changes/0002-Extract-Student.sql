IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Student]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Student]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Student_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [AURORAX].[Student_LOCAL]
GO

CREATE TABLE AURORAX.Student_LOCAL (
SASID  varchar(20) not null,
StudentID  varchar(20) not null
)
GO

CREATE VIEW [AURORAX].[Student]
AS
	SELECT * FROM [AURORAX].[Student_LOCAL]
GO

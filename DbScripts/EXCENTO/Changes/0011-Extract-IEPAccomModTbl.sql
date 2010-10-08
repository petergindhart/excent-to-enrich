IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[IEPAccomModTbl]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[IEPAccomModTbl]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[IEPAccomModTbl_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[IEPAccomModTbl_LOCAL]
GO

CREATE TABLE [EXCENTO].[IEPAccomModTbl_LOCAL](
GStudentID	uniqueidentifier NOT NULL,
IEPAccomSeq	bigint NOT NULL,
CreateID	nvarchar(20),
CreateDate	datetime,
ModifyID	nvarchar(20),
ModifyDate	datetime,
DeleteID	nvarchar(20),
DeleteDate	datetime,
Del_Flag	bit
) ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[IEPAccomModTbl]
AS
	SELECT * FROM [EXCENTO].[IEPAccomModTbl_LOCAL]
GO

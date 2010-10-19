CREATE TABLE dbo.IepTestAccomCategory
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTestAccomCategory ADD CONSTRAINT
	PK_IepTestAccomCategory PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTestAccomDef ADD
	CategoryID uniqueidentifier NULL,
	MinGradeID uniqueidentifier NULL,
	MaxGradeID uniqueidentifier NULL,
	IsStandard bit NULL
GO
ALTER TABLE dbo.IepTestAccomDef ADD CONSTRAINT
	FK_IepTestAccomDef#Category#AccomDefs FOREIGN KEY
	(
	CategoryID
	) REFERENCES dbo.IepTestAccomCategory
	(
	ID
	)  
GO
ALTER TABLE dbo.IepTestAccomDef ADD CONSTRAINT
	FK_IepTestAccomDef#MinGradeLevel# FOREIGN KEY
	(
	MinGradeID
	) REFERENCES dbo.GradeLevel
	(
	ID
	)  
GO
ALTER TABLE dbo.IepTestAccomDef ADD CONSTRAINT
	FK_IepTestAccomDef#MaxGradeLevel# FOREIGN KEY
	(
	MaxGradeID
	) REFERENCES dbo.GradeLevel
	(
	ID
	)  
GO

--##############################################################################

insert IepTestAccomCategory values ('8425409C-5195-4070-B56F-E491CE20CC45', 'Refactored')
update IepTestAccomDef set CategoryID = '8425409C-5195-4070-B56F-E491CE20CC45' where CategoryID is null
update IepTestAccomDef set IsStandard = 1 where IsStandard is null
 
--##############################################################################

ALTER TABLE dbo.IepTestAccomDef
	DROP CONSTRAINT FK_IepTestAccomDef#MinGradeLevel#
GO
ALTER TABLE dbo.IepTestAccomDef
	DROP CONSTRAINT FK_IepTestAccomDef#MaxGradeLevel#
GO
ALTER TABLE dbo.IepTestAccomDef
	DROP CONSTRAINT FK_IepTestAccomDef#Category#AccomDefs
GO
CREATE TABLE dbo.Tmp_IepTestAccomDef
	(
	ID uniqueidentifier NOT NULL,
	Text varchar(200) NOT NULL,
	CategoryID uniqueidentifier NOT NULL,
	MinGradeID uniqueidentifier NULL,
	MaxGradeID uniqueidentifier NULL,
	IsStandard bit NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.IepTestAccomDef)
	 EXEC('INSERT INTO dbo.Tmp_IepTestAccomDef (ID, Text, CategoryID, MinGradeID, MaxGradeID, IsStandard)
		SELECT ID, Text, CategoryID, MinGradeID, MaxGradeID, IsStandard FROM dbo.IepTestAccomDef WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.IepAllowedTestAccom
	DROP CONSTRAINT FK_IepTestAccomDef#AllowedTestDefs
GO
ALTER TABLE dbo.IepTestAccom
	DROP CONSTRAINT FK_IepTestAccomDef#Participations
GO
DROP TABLE dbo.IepTestAccomDef
GO
EXECUTE sp_rename N'dbo.Tmp_IepTestAccomDef', N'IepTestAccomDef', 'OBJECT' 
GO
ALTER TABLE dbo.IepTestAccomDef ADD CONSTRAINT
	PK_IepTestAccomDef PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTestAccomDef ADD CONSTRAINT
	FK_IepTestAccomDef#Category#AccomDefs FOREIGN KEY
	(
	CategoryID
	) REFERENCES dbo.IepTestAccomCategory
	(
	ID
	)  
GO
ALTER TABLE dbo.IepTestAccomDef ADD CONSTRAINT
	FK_IepTestAccomDef#MinGradeLevel# FOREIGN KEY
	(
	MinGradeID
	) REFERENCES dbo.GradeLevel
	(
	ID
	)  
GO
ALTER TABLE dbo.IepTestAccomDef ADD CONSTRAINT
	FK_IepTestAccomDef#MaxGradeLevel# FOREIGN KEY
	(
	MaxGradeID
	) REFERENCES dbo.GradeLevel
	(
	ID
	)  
GO
ALTER TABLE dbo.IepTestAccom ADD CONSTRAINT
	FK_IepTestAccomDef#Participations FOREIGN KEY
	(
	DefID
	) REFERENCES dbo.IepTestAccomDef
	(
	ID
	) ON DELETE  CASCADE 
GO


GO
ALTER TABLE dbo.IepAllowedTestAccom ADD CONSTRAINT
	FK_IepTestAccomDef#AllowedTestDefs FOREIGN KEY
	(
	AccomDefID
	) REFERENCES dbo.IepTestAccomDef
	(
	ID
	)  
GO


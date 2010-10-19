IF  EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[dbo].[PrgItemDef]') AND name = N'UN_PrgItemDef_Name')
	ALTER TABLE [dbo].[PrgItemDef] DROP CONSTRAINT [UN_PrgItemDef_Name]
GO

ALTER TABLE PrgItemDef
ADD CONSTRAINT UN_PrgItemDef_Name UNIQUE
(
	ProgramID, Name, DeletedDate
)
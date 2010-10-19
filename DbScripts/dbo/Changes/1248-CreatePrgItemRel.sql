CREATE TABLE dbo.PrgItemRelDef
	(
	ID uniqueidentifier NOT NULL,
	InitiatingItemDefID uniqueidentifier NOT NULL,
	ResultingItemDefID uniqueidentifier,
	Name text,
	DeletedDate datetime
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgItemRelDef ADD CONSTRAINT
	PK_PrgItemRelDef PRIMARY KEY CLUSTERED 
	(
	ID
	)
GO
ALTER TABLE dbo.PrgItemRelDef ADD CONSTRAINT
	FK_PrgItemRelDef#InitiatingItemDef#ResultingItemDefs FOREIGN KEY
	(
	InitiatingItemDefID
	) REFERENCES dbo.PrgItemDef
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION
	
GO
ALTER TABLE dbo.PrgItemRelDef ADD CONSTRAINT
	FK_PrgItemRelDef#ResultingItemDef#InitiatingItemDefs FOREIGN KEY
	(
	ResultingItemDefID
	) REFERENCES dbo.PrgItemDef
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO


CREATE TABLE dbo.PrgItemRel
	(
	ID uniqueidentifier NOT NULL,
	PrgItemRelDefID uniqueidentifier NOT NULL,
	InitiatingItemID uniqueidentifier NOT NULL,
	ResultingItemID uniqueidentifier
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgItemRel ADD CONSTRAINT
	PK_PrgItemRel PRIMARY KEY CLUSTERED 
	(
	ID
	)
GO
ALTER TABLE dbo.PrgItemRel ADD CONSTRAINT
	FK_PrgItemRel#ResultingItem#InitiatingItemRels FOREIGN KEY
	(
	ResultingItemID
	) REFERENCES dbo.PrgItem
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION
	
GO
ALTER TABLE dbo.PrgItemRel ADD CONSTRAINT
	FK_PrgItemRel#InitiatingItem#ResultingItemRels FOREIGN KEY
	(
	InitiatingItemID
	) REFERENCES dbo.PrgItem
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
GO
ALTER TABLE dbo.PrgItemRel ADD CONSTRAINT
	FK_PrgItemRel#RelDef#ItemRels FOREIGN KEY
	(
	PrgItemRelDefID
	) REFERENCES dbo.PrgItemRelDef
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
GO

DROP TABLE PrgMeetingItem
GO
CREATE TABLE dbo.PrgInvolvementTeamMember
	(
	ID uniqueidentifier NOT NULL,
	PersonID uniqueidentifier NOT NULL,
	InvolvementID uniqueidentifier NOT NULL,
	ResponsibilityID uniqueidentifier NULL,
	IsPrimary bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgInvolvementTeamMember ADD CONSTRAINT
	DF_PrgInvolvementTeamMember_IsPrimary DEFAULT 0 FOR IsPrimary
GO
ALTER TABLE dbo.PrgInvolvementTeamMember ADD CONSTRAINT
	PK_PrgInvolvementTeamMember PRIMARY KEY CLUSTERED 
	(
	ID
	) 
GO

ALTER TABLE dbo.Program ADD
	AllowProgramLevelTeams bit NOT NULL CONSTRAINT DF_Program_AllowProgramLevelTeams DEFAULT 0
GO

ALTER TABLE dbo.PrgInvolvementTeamMember ADD CONSTRAINT
	FK_PrgInvolvementTeamMember#Involvement#Members FOREIGN KEY
	(
	InvolvementID
	) REFERENCES dbo.PrgInvolvement
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PrgInvolvementTeamMember ADD CONSTRAINT
	FK_PrgInvolvementTeamMember#Responsibility#InvolvementTeamMembers FOREIGN KEY
	(
	ResponsibilityID
	) REFERENCES dbo.PrgResponsibility
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PrgInvolvementTeamMember ADD CONSTRAINT
	FK_PrgInvolvementTeamMember#Person#InvolvementTeamMemberships FOREIGN KEY
	(
	PersonID
	) REFERENCES dbo.Person
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO

EXECUTE sp_rename N'dbo.PrgItemTeamMember.MtgAttendee', N'Tmp_MtgAbsent', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.PrgItemTeamMember.Tmp_MtgAbsent', N'MtgAbsent', 'COLUMN' 
GO
ALTER TABLE dbo.PrgItemTeamMember ADD CONSTRAINT
	DF_PrgItemTeamMember_MtgAttended DEFAULT 0 FOR MtgAbsent
GO
ALTER TABLE dbo.PrgItemTeamMember
	DROP COLUMN MtgInvitee
GO

ALTER TABLE dbo.PrgItemRelDef ADD
	ExcusalFormTemplateID uniqueidentifier NULL,
	ExcusalDocumentDefID uniqueidentifier NULL
GO

CREATE TABLE dbo.PrgMeetingExcusal
	(
	ID uniqueidentifier NOT NULL,
	RelID uniqueidentifier NOT NULL,
	TeamMemberID uniqueidentifier NOT NULL,
	FormID uniqueidentifier NULL,
	DocumentID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgMeetingExcusal ADD CONSTRAINT
	PK_PrgMeetingExcusal PRIMARY KEY CLUSTERED 
	(
	ID
	)

GO
ALTER TABLE dbo.PrgMeetingExcusal ADD CONSTRAINT
	FK_PrgMeetingExcusal#Rel#Excusals FOREIGN KEY
	(
	RelID
	) REFERENCES dbo.PrgItemRel
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PrgMeetingExcusal ADD CONSTRAINT
	FK_PrgMeetingExcusal#TeamMember#Excusals FOREIGN KEY
	(
	TeamMemberID
	) REFERENCES dbo.PrgItemTeamMember
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE   NO ACTION  
	
GO
ALTER TABLE dbo.PrgMeetingExcusal ADD CONSTRAINT
	FK_PrgMeetingExcusal#Document# FOREIGN KEY
	(
	DocumentID
	) REFERENCES dbo.PrgDocument
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.PrgMeetingExcusal ADD CONSTRAINT
	FK_PrgMeetingExcusal#Form# FOREIGN KEY
	(
	FormID
	) REFERENCES dbo.PrgItemForm
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

ALTER TABLE dbo.PrgItemRelDef ADD CONSTRAINT
	FK_PrgItemRelDef#ExcusalDocumentDef# FOREIGN KEY
	(
	ExcusalDocumentDefID
	) REFERENCES dbo.PrgDocumentDef
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.PrgItemRelDef ADD CONSTRAINT
	FK_PrgItemRelDef#ExcusalFormTemplate# FOREIGN KEY
	(
	ExcusalFormTemplateID
	) REFERENCES dbo.FormTemplate
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
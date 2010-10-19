ALTER TABLE dbo.IepSpecialFactor
	DROP CONSTRAINT FK_IepSpecialFactor#Document#
GO
ALTER TABLE dbo.PrgMeetingExcusal
	DROP CONSTRAINT FK_PrgMeetingExcusal#Document#
GO
ALTER TABLE dbo.PrgMeetingExcusal ADD CONSTRAINT
	FK_PrgMeetingExcusal#Document# FOREIGN KEY
	(
	DocumentID
	) REFERENCES dbo.PrgDocument
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepSpecialFactor ADD CONSTRAINT
	FK_IepSpecialFactor#Document# FOREIGN KEY
	(
	DocumentId
	) REFERENCES dbo.PrgDocument
	(
	ID
	) ON DELETE  CASCADE
GO

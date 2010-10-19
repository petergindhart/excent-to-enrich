ALTER TABLE PrgMilestone
DROP CONSTRAINT FK_PrgMilestone#Instance#Milestones
GO
ALTER TABLE PrgMilestone
DROP COLUMN InstanceID
GO
ALTER TABLE PrgMilestone
ADD InvolvementID uniqueidentifier
GO
ALTER TABLE PrgMilestone
ALTER COLUMN InvolvementID uniqueidentifier NOT NULL
GO
ALTER TABLE dbo.PrgMilestone ADD CONSTRAINT
	FK_PrgMilestone#Involvement#Milestones FOREIGN KEY
	(
	InvolvementID
	) REFERENCES dbo.PrgInvolvement
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
GO
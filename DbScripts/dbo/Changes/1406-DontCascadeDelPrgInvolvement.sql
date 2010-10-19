-- remove cascade delete from PrgItem.Involvement
-- currently no 'delete involvement' in the UI.
ALTER TABLE dbo.PrgItem
	DROP CONSTRAINT FK_PrgItem#Involvement#Items
GO
ALTER TABLE dbo.PrgItem ADD CONSTRAINT
	FK_PrgItem#Involvement#Items FOREIGN KEY
	(
	InvolvementID
	) REFERENCES dbo.PrgInvolvement
	(
	ID
	)
GO

-- NOTE: a check has been added to the object script PrgInvolvement_RecalculateStatuses
-- to raise awareness if this is changed in the future
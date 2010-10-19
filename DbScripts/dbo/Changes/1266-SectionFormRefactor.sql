/*	
	PrgItemForm no longer references section, but PrgSection now references PrgItemForm.
	Added PrgItemForm.AssociationTypeID to cache whether a form was added through a user action, or mandated
	through the definition of a section or related item.
 */
 
ALTER TABLE dbo.PrgItemForm
	DROP CONSTRAINT FK_PrgItemForm#Section#SectionForms
GO
ALTER TABLE dbo.PrgItemForm
	DROP COLUMN SectionID
GO

ALTER TABLE dbo.PrgItemForm ADD
	AssociationTypeID uniqueidentifier NULL
GO
ALTER TABLE dbo.PrgItemForm ADD CONSTRAINT
	FK_PrgItemForm#AssociationType# FOREIGN KEY
	(
	AssociationTypeID
	) REFERENCES dbo.EnumValue
	(
	ID
	)  
GO

ALTER TABLE dbo.PrgSection ADD
	FormInstanceID uniqueidentifier NULL
GO
ALTER TABLE dbo.PrgSection ADD CONSTRAINT
	FK_PrgSection#FormInstance# FOREIGN KEY
	(
	FormInstanceID
	) REFERENCES dbo.PrgItemForm
	(
	ID
	)  
GO


-- define Association Types
INSERT EnumType VALUES ( '36106D66-0F28-42DF-A57A-F39CF2528D04', 'PrgItemForm.AssociationType', 0, 0, 'Association Type' )
INSERT EnumValue VALUES ( 'E6A1AC11-3F22-4ED6-ABA9-813FA919D1D1', '36106D66-0F28-42DF-A57A-F39CF2528D04', 'Item', 'I', 1, 0 )
INSERT EnumValue VALUES ( 'CEE1D2AC-DA5B-406F-AFBD-C568A3E8C382', '36106D66-0F28-42DF-A57A-F39CF2528D04', 'Section', 'S', 1, 1 )
INSERT EnumValue VALUES ( '65CC32F2-8D67-47C6-92F3-527D98D6990C', '36106D66-0F28-42DF-A57A-F39CF2528D04', 'Special Factor', 'F', 1, 2 )

-- set Associatoin Types
UPDATE i
SET AssociationTypeID = '65CC32F2-8D67-47C6-92F3-527D98D6990C' -- Special Factor
FROM
	PrgItemForm i JOIN
	IepSpecialFactor f ON f.FormInstanceId = i.ID

UPDATE PrgItemForm
SET AssociationTypeID = 'E6A1AC11-3F22-4ED6-ABA9-813FA919D1D1' -- Item
WHERE AssociationTypeID IS NULL

-- Make AssociationTypeID required
ALTER TABLE PrgItemForm
ALTER COLUMN AssociationTypeID uniqueidentifier NOT NULL
GO

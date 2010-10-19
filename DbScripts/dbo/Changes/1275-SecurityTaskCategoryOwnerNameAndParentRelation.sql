DELETE FROM SecurityTaskCategory
WHERE OwnerID IS NOT NULL AND
OwnerID NOT IN (SELECT ID FROM Program) AND
OwnerID NOT IN (SELECT ID FROM PrgItemDef) AND
OwnerID NOT IN (SELECT ID FROM PrgSectionDef)

ALTER TABLE SecurityTaskCategory
ADD OwnerClassName varchar(100)
GO

UPDATE SecurityTaskCategory
SET OwnerClassName = 'Program'
WHERE OwnerID IS NOT NULL AND 
OwnerID IN (SELECT ID FROM Program)

UPDATE SecurityTaskCategory
SET OwnerClassName = 'PrgItemDef'
WHERE OwnerID IS NOT NULL AND 
OwnerID IN (SELECT ID FROM PrgItemDef)

UPDATE SecurityTaskCategory
SET OwnerClassName = 'PrgSectionDef'
WHERE OwnerID IS NOT NULL AND 
OwnerID IN (SELECT ID FROM PrgSectionDef)

ALTER TABLE SecurityTaskCategory 
ADD CONSTRAINT FK_SecurityTaskCategory#Parent#Children FOREIGN KEY
(
ParentID
) 
REFERENCES SecurityTaskCategory 
(
ID
) NOT FOR REPLICATION
GO

ALTER TABLE SecurityTaskCategory
ADD CONSTRAINT UN_SecurityTaskCategory_Name UNIQUE
(
	Name, ParentID
)
GO
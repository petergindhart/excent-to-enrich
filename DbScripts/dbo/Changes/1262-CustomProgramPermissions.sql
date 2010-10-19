DECLARE @rootProgramCategoryID AS uniqueidentifier
SET @rootProgramCategoryID = '07D4ED6A-0CFF-4FD0-B03F-E22D51940CDD' --Programs
DECLARE @contextTypeID as uniqueidentifier
SET @contextTypeID = 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4' --Student

----START Program-------------------------------------------------------------------------
CREATE TABLE #program
(
	programID uniqueidentifier,
	programCategoryID uniqueidentifier,
	actionsCategoryID uniqueidentifier,
	plansCategoryID uniqueidentifier,
	meetingsCategoryID uniqueidentifier
)

----Program: Custom Programs
INSERT INTO #program
SELECT ID, NEWID(),
NEWID(), NEWID(), NEWID()
FROM Program
WHERE ID NOT IN ('D3AB11A2-96C0-4BA5-914A-C250EDDEA995','7DE3B3D7-B60F-48AC-9681-78D46A5E74D4','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C')

----Program: Category
INSERT INTO SecurityTaskCategory
SELECT c.programCategoryID, p.Abbreviation, @rootProgramCategoryID, NULL, 0, NULL, c.programID
FROM #program c JOIN
Program p ON p.ID = c.programID 
ORDER BY p.Abbreviation ASC

----Program: Actions Category
INSERT INTO SecurityTaskCategory
SELECT c.actionsCategoryID, 'Actions', c.programCategoryID, NULL, 0, NULL, c.programID
FROM #program c

----Program: Meetings Category
INSERT INTO SecurityTaskCategory
SELECT c.meetingsCategoryID, 'Meetings', c.programCategoryID, NULL, 1, NULL, c.programID
FROM #program c

----Program: Plans Category
INSERT INTO SecurityTaskCategory
SELECT c.plansCategoryID, 'Plans', c.programCategoryID, NULL, 2, NULL, c.programID
FROM #program c

----END Program-------------------------------------------------------------------------

----START PrgItemDef--------------------------------------------------------------------
CREATE TABLE #item
(
	itemID uniqueidentifier,
	programID uniqueidentifier,
	
	itemCategoryID uniqueidentifier DEFAULT NEWID()
)

INSERT INTO #item (itemID, programID)
SELECT d.ID, d.ProgramID
FROM PrgItemDef d JOIN
#program p on p.programID = d.ProgramID --Resolves original disconnect between programs and items
WHERE d.TypeID <> '6002D022-4D8F-48A9-A0B7-918863631B13' --Tool Action (No permissions)
ORDER BY d.Description

----Item: Category
--Actions Type
INSERT INTO SecurityTaskCategory
SELECT i.itemCategoryID, d.Name, p.actionsCategoryID, NULL, 0, NULL, i.itemID
FROM #item i JOIN
PrgItemDef d ON d.ID = i.itemID JOIN
#program p ON p.programID = i.programID
WHERE d.TypeID IN ('2A37FB49-1977-48C7-9031-56148AEE8328','1511F713-B210-40BB-ACCA-624212BB38F4')

--Meetings Type
INSERT INTO SecurityTaskCategory
SELECT i.itemCategoryID, d.Name, p.meetingsCategoryID, NULL, 0, NULL, i.itemID
FROM #item i JOIN
PrgItemDef d ON d.ID = i.itemID JOIN
#program p ON p.programID = i.programID
WHERE d.TypeID IN ('B1B9173E-C987-4752-82DE-D7237A2BC060') 

--Plan Type
INSERT INTO SecurityTaskCategory
SELECT i.itemCategoryID, d.Name, p.plansCategoryID, NULL, 0, NULL, i.itemID
FROM #item i JOIN
PrgItemDef d ON d.ID = i.itemID JOIN
#program p ON p.programID = i.programID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870') 

----Item: Connect child categories to item category
UPDATE c
SET c.ParentID = i.itemCategoryID
FROM SecurityTaskCategory c JOIN
#item i ON i.itemID = c.OwnerID
WHERE NOT EXISTS (SELECT * FROM SecurityTaskCategory p WHERE p.ID = c.ParentID)

----Item: Connect child section categories to item category
UPDATE c
SET c.ParentID = i.itemCategoryID
FROM SecurityTaskCategory c JOIN
PrgSectionDef d ON d.ID = c.OwnerID JOIN
#item i ON i.itemID = d.ItemDefID
WHERE NOT EXISTS (SELECT * FROM SecurityTaskCategory p WHERE p.ID = c.ParentID)

DROP TABLE #program
DROP TABLE #item
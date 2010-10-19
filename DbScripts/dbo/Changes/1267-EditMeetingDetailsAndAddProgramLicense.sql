DECLARE @contextTypeID as uniqueidentifier
SET @contextTypeID = 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4' --Student

DECLARE @viewItemDetailsTaskTypeID uniqueidentifier
SET @viewItemDetailsTaskTypeID = 'A34EA01F-7406-4357-9214-D4EE60FB2DA3'

DECLARE @editItemDetailsTaskTypeID uniqueidentifier
SET @editItemDetailsTaskTypeID = 'AFFA7C5F-67A3-4004-8D89-4348E3F527B5'

--Make View and Edit Details Task Generic
UPDATE SecurityTaskType
SET Name='View Program Item Details', DisplayName='View Program Item Details'
WHERE ID=@viewItemDetailsTaskTypeID

UPDATE SecurityTaskType
SET Name='Edit Program Item Details', DisplayName='Edit Program Item Details'
WHERE ID=@editItemDetailsTaskTypeID

--Meetings-------------------------------------------------------------------
CREATE TABLE #Meeting
(
	ID uniqueidentifier,
	ItemCategoryID uniqueidentifier,
	DetailsCategoryID uniqueidentifier DEFAULT NEWID(),
	ViewDetailsCategoryID uniqueidentifier DEFAULT NEWID(),
	ViewDetailsTaskID uniqueidentifier DEFAULT NEWID(),
	EditDetailsCategoryID uniqueidentifier DEFAULT NEWID(),
	EditDetailsTaskID uniqueidentifier DEFAULT NEWID()
)

INSERT #Meeting (ID, ItemCategoryID)
SELECT d.ID, c.ID
FROM SecurityTaskCategory c JOIN --Item's Category
SecurityTaskCategory m ON c.ParentID = m.ID JOIN --Plan Category
SecurityTaskCategory p on m.ParentID = p.ID JOIN --Specific Program Category
PrgItemDef d ON c.OwnerID = d.ID
WHERE d.TypeID = 'B1B9173E-C987-4752-82DE-D7237A2BC060' AND --Meetings plan type
p.ParentID = '07D4ED6A-0CFF-4FD0-B03F-E22D51940CDD' --Programs category under student

--Details Category
INSERT INTO SecurityTaskCategory
SELECT m.DetailsCategoryID, 'Details', m.ItemCategoryID, NULL, 4, NULL, m.ID
FROM #Meeting m 

--View Details Permissions
INSERT INTO SecurityTaskCategory
SELECT m.ViewDetailsCategoryID, 'View', m.DetailsCategoryID, NULL, 0, NULL, m.ID
FROM #Meeting m 

INSERT INTO SecurityTask
SELECT @viewItemDetailsTaskTypeID, m.ViewDetailsCategoryID, 0, @contextTypeID, m.ID, m.ViewDetailsTaskID
FROM #Meeting m

INSERT INTO SecurityRoleSecurityTask
SELECT DISTINCT rt.RoleID, m.ViewDetailsTaskID
FROM #Meeting m JOIN
SecurityTask et ON et.TargetID = m.ID JOIN
SecurityRoleSecurityTask rt ON rt.TaskID = et.ID 
WHERE et.SecurityTaskTypeID = '28F0D77A-813E-466E-945E-BDB77F5A33DC' --View Program Item

--Edit Details Permissions
INSERT INTO SecurityTaskCategory
SELECT m.EditDetailsCategoryID, 'Edit', m.DetailsCategoryID, NULL, 1, NULL, m.ID
FROM #Meeting m 

INSERT INTO SecurityTask
SELECT @editItemDetailsTaskTypeID, m.EditDetailsCategoryID, 0, @contextTypeID, m.ID, m.EditDetailsTaskID
FROM #Meeting m

INSERT INTO SecurityRoleSecurityTask
SELECT DISTINCT rt.RoleID, m.EditDetailsTaskID
FROM #Meeting m JOIN
SecurityTask t ON t.TargetID = m.ID AND 
t.SecurityTaskTypeID = '2825A4E0-E342-48B1-BFCB-6A037C93C7BA' JOIN -- Edit start and end date task type
SecurityRoleSecurityTask rt ON rt.TaskID = t.ID

DROP TABLE #Meeting

--Create Custom Programs License
INSERT INTO Feature
VALUES ('38863934-0048-4a2e-8363-3558731a24c9','District.CreateCustomPrograms')

UPDATE SecurityTaskCategory
SET FeatureID = '38863934-0048-4a2e-8363-3558731a24c9'
WHERE ID IN 
('636F3E9D-267C-4881-9FC5-14D924059EDE', --ADD PROGRAM
'EC095A79-690F-44D9-88FA-203A2FE06E59', --EDIT PROGRAM
'2E71C940-EBBE-4621-B805-C13526E3DB2F') -- DELETE PROGRAM
DECLARE @contextTypeID as uniqueidentifier
SET @contextTypeID = 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4' --Student

--Change schedule category name to Start and End Date
UPDATE s
SET Name = 'Start and End Date'
FROM SecurityTaskCategory s JOIN --Schedule Category
SecurityTaskCategory c ON s.ParentID = c.ID JOIN --Item's Category
SecurityTaskCategory m ON c.ParentID = m.ID JOIN --Plan Category
SecurityTaskCategory p ON m.ParentID = p.ID --Specific Program Category
WHERE s.Name = 'Schedule' AND
p.ParentID = '07D4ED6A-0CFF-4FD0-B03F-E22D51940CDD' --Programs category under student

--Change schedule task description
UPDATE SecurityTaskType
SET Name = 'View Program Item Start and End Date', DisplayName = 'View Program Item Start and End Date'
WHERE ID = '2B3A2BDB-435F-472E-AC68-9F248C477331'

UPDATE SecurityTaskType
SET Name = 'Edit Program Item Start and End Date', DisplayName = 'Edit Program Item Start and End Date'
WHERE ID = '2825A4E0-E342-48B1-BFCB-6A037C93C7BA'

--Custom Plans-------------------------------------------------------------
CREATE TABLE #CustomPlan
(
	ID uniqueidentifier,
	ItemCategoryID uniqueidentifier,
	ActionScheduleCategoryID uniqueidentifier DEFAULT NEWID(),
	ViewActionScheduleCategoryID uniqueidentifier DEFAULT NEWID(),
	ViewActionScheduleTaskID uniqueidentifier DEFAULT NEWID(),
	EditActionScheduleCategoryID uniqueidentifier DEFAULT NEWID(),
	EditActionScheduleTaskID uniqueidentifier DEFAULT NEWID(),
	StartAndEndDateCategoryID uniqueidentifier DEFAULT NEWID(),
	ViewStartAndEndDateCategoryID uniqueidentifier DEFAULT NEWID(),
	ViewStartAndEndDateTaskID uniqueidentifier DEFAULT NEWID(),
	EditStartAndEndDateCategoryID uniqueidentifier DEFAULT NEWID(),
	EditStartAndEndDateTaskID uniqueidentifier DEFAULT NEWID(),
	DetailsCategoryID uniqueidentifier DEFAULT NEWID(),
	ViewDetailsCategoryID uniqueidentifier DEFAULT NEWID(),
	ViewDetailsTaskID uniqueidentifier DEFAULT NEWID(),
	EditDetailsCategoryID uniqueidentifier DEFAULT NEWID(),
	EditDetailsTaskID uniqueidentifier DEFAULT NEWID(),
)

INSERT #CustomPlan (ID, ItemCategoryID)
SELECT d.ID, c.ID
FROM SecurityTaskCategory c JOIN --Item's Category
SecurityTaskCategory m ON c.ParentID = m.ID JOIN --Plan Category
SecurityTaskCategory p on m.ParentID = p.ID JOIN --Specific Program Category
PrgItemDef d ON c.OwnerID = d.ID
WHERE d.TypeID = 'D7B183D8-5BBD-4471-8829-3C8D82A92478' AND --Custom plan type
p.ParentID = '07D4ED6A-0CFF-4FD0-B03F-E22D51940CDD' --Programs category under student

--Action Schedules Category
INSERT INTO SecurityTaskCategory
SELECT p.ActionScheduleCategoryID, 'Action Schedules', p.ItemCategoryID, NULL, 4, NULL, p.ID
FROM #CustomPlan p 

--View Action Schedule Permissions
INSERT INTO SecurityTaskCategory
SELECT p.ViewActionScheduleCategoryID, 'View', P.ActionScheduleCategoryID, NULL, 0, NULL, p.ID
FROM #CustomPlan p

INSERT INTO SecurityTask
SELECT '4216EEA6-D9F1-42EA-966A-3F414F1410AE', p.ViewActionScheduleCategoryID, 0, @contextTypeID, p.ID, p.ViewActionScheduleTaskID
FROM #CustomPlan p

INSERT INTO SecurityRoleSecurityTask
SELECT DISTINCT rt.RoleID, nt.ID
FROM #CustomPlan p JOIN
SecurityTask nt ON nt.ID = p.ViewActionScheduleTaskID JOIN
SecurityTask et ON et.SecurityTaskTypeID = nt.SecurityTaskTypeID JOIN
SecurityRoleSecurityTask rt ON rt.TaskID = et.ID 

--Edit Action Schedule Permissions
INSERT INTO SecurityTaskCategory
SELECT p.EditActionScheduleCategoryID, 'Edit', p.ActionScheduleCategoryID, NULL, 1, NULL, p.ID
FROM #CustomPlan p

INSERT INTO SecurityTask
SELECT '2C991BF6-9BF2-4B43-ACE8-307EE9D5C0AE', p.EditActionScheduleCategoryID, 0, @contextTypeID, p.ID, p.EditActionScheduleTaskID
FROM #CustomPlan p

INSERT INTO SecurityRoleSecurityTask
SELECT DISTINCT rt.RoleID, nt.ID
FROM #CustomPlan p JOIN
SecurityTask nt ON nt.ID = p.EditActionScheduleTaskID JOIN
SecurityTask et ON et.SecurityTaskTypeID = nt.SecurityTaskTypeID JOIN
SecurityRoleSecurityTask rt ON rt.TaskID = et.ID 

--Start and End Date Category
INSERT INTO SecurityTaskCategory
SELECT p.StartAndEndDateCategoryID, 'Start and End Date', p.ItemCategoryID, NULL, 4, NULL, p.ID
FROM #CustomPlan p 

--View Start and End Date Permissions
INSERT INTO SecurityTaskCategory
SELECT p.ViewStartAndEndDateCategoryID, 'View', p.StartAndEndDateCategoryID, NULL, 0, NULL, p.ID
FROM #CustomPlan p 

INSERT INTO SecurityTask
SELECT '2B3A2BDB-435F-472E-AC68-9F248C477331', p.ViewStartAndEndDateCategoryID, 0, @contextTypeID, p.ID, p.ViewStartAndEndDateTaskID
FROM #CustomPlan p 

INSERT INTO SecurityRoleSecurityTask
SELECT DISTINCT rt.RoleID, nt.ID
FROM #CustomPlan p JOIN
SecurityTask nt ON nt.ID = p.ViewStartAndEndDateTaskID JOIN
SecurityTask et ON et.SecurityTaskTypeID = nt.SecurityTaskTypeID JOIN
SecurityRoleSecurityTask rt ON rt.TaskID = et.ID 

--Edit Start and End Date Permissions
INSERT INTO SecurityTaskCategory
SELECT p.EditStartAndEndDateCategoryID, 'Edit', p.StartAndEndDateCategoryID, NULL, 1, NULL, p.ID
FROM #CustomPlan p 

INSERT INTO SecurityTask
SELECT '2825A4E0-E342-48B1-BFCB-6A037C93C7BA', p.EditStartAndEndDateCategoryID, 0, @contextTypeID, p.ID, p.EditStartAndEndDateTaskID
FROM #CustomPlan p

INSERT INTO SecurityRoleSecurityTask
SELECT DISTINCT rt.RoleID, nt.ID
FROM #CustomPlan p JOIN
SecurityTask nt ON nt.ID = p.EditStartAndEndDateTaskID JOIN
SecurityTask et ON et.SecurityTaskTypeID = nt.SecurityTaskTypeID JOIN
SecurityRoleSecurityTask rt ON rt.TaskID = et.ID 

--Details Category
INSERT INTO SecurityTaskCategory
SELECT p.DetailsCategoryID, 'Details', p.ItemCategoryID, NULL, 4, NULL, p.ID
FROM #CustomPlan p 

--View Details Permissions
INSERT INTO SecurityTaskCategory
SELECT p.ViewDetailsCategoryID, 'View', p.DetailsCategoryID, NULL, 0, NULL, p.ID
FROM #CustomPlan p 

INSERT INTO SecurityTaskType
VALUES ('A34EA01F-7406-4357-9214-D4EE60FB2DA3', 'View Custom Plan Details', 'View Custom Plan Details')

INSERT INTO SecurityTask
SELECT 'A34EA01F-7406-4357-9214-D4EE60FB2DA3', p.ViewDetailsCategoryID, 0, @contextTypeID, p.ID, p.ViewDetailsTaskID
FROM #CustomPlan p

INSERT INTO SecurityRoleSecurityTask
SELECT DISTINCT rt.RoleID, p.ViewDetailsTaskID
FROM #CustomPlan p JOIN
SecurityTask et ON et.TargetID = p.ID JOIN
SecurityRoleSecurityTask rt ON rt.TaskID = et.ID 
WHERE et.SecurityTaskTypeID = '28F0D77A-813E-466E-945E-BDB77F5A33DC' --View Program Item

--Edit Details Permissions
INSERT INTO SecurityTaskCategory
SELECT p.EditDetailsCategoryID, 'Edit', p.DetailsCategoryID, NULL, 1, NULL, p.ID
FROM #CustomPlan p 

INSERT INTO SecurityTaskType
VALUES ('AFFA7C5F-67A3-4004-8D89-4348E3F527B5', 'Edit Custom Plan Details', 'Edit Custom Plan Details')

INSERT INTO SecurityTask
SELECT 'AFFA7C5F-67A3-4004-8D89-4348E3F527B5', p.EditDetailsCategoryID, 0, @contextTypeID, p.ID, p.EditDetailsTaskID
FROM #CustomPlan p

INSERT INTO SecurityRoleSecurityTask
SELECT DISTINCT r.ID, p.EditDetailsTaskID
FROM #CustomPlan p JOIN
SecurityTask eas ON eas.ID = p.EditActionScheduleTaskID JOIN
SecurityRoleSecurityTask asrt ON asrt.TaskID = eas.ID JOIN 
SecurityTask esd ON esd.ID = p.EditStartAndEndDateTaskID JOIN
SecurityRoleSecurityTask sdrt ON sdrt.TaskID = esd.ID JOIN 
SecurityRole r ON (r.ID = asrt.RoleID AND r.ID = sdrt.RoleID)

DROP TABLE #CustomPlan

--Meetings-------------------------------------------------------------------
CREATE TABLE #Meeting
(
	ID uniqueidentifier,
	ItemCategoryID uniqueidentifier,
	StartAndEndDateCategoryID uniqueidentifier DEFAULT NEWID(),
	ViewStartAndEndDateCategoryID uniqueidentifier DEFAULT NEWID(),
	ViewStartAndEndDateTaskID uniqueidentifier DEFAULT NEWID(),
	EditStartAndEndDateCategoryID uniqueidentifier DEFAULT NEWID(),
	EditStartAndEndDateTaskID uniqueidentifier DEFAULT NEWID()
)

INSERT #Meeting (ID, ItemCategoryID)
SELECT d.ID, c.ID
FROM SecurityTaskCategory c JOIN --Item's Category
SecurityTaskCategory m ON c.ParentID = m.ID JOIN --Plan Category
SecurityTaskCategory p on m.ParentID = p.ID JOIN --Specific Program Category
PrgItemDef d ON c.OwnerID = d.ID
WHERE d.TypeID = 'B1B9173E-C987-4752-82DE-D7237A2BC060' AND --Meetings plan type
p.ParentID = '07D4ED6A-0CFF-4FD0-B03F-E22D51940CDD' --Programs category under student

--Start and End Date Category
INSERT INTO SecurityTaskCategory
SELECT m.StartAndEndDateCategoryID, 'Start and End Date', m.ItemCategoryID, NULL, 4, NULL, m.ID
FROM #Meeting m 

--View Start and End Date Permissions
INSERT INTO SecurityTaskCategory
SELECT m.ViewStartAndEndDateCategoryID, 'View', m.StartAndEndDateCategoryID, NULL, 0, NULL, m.ID
FROM #Meeting m 

INSERT INTO SecurityTask
SELECT '2B3A2BDB-435F-472E-AC68-9F248C477331', m.ViewStartAndEndDateCategoryID, 0, @contextTypeID, m.ID, m.ViewStartAndEndDateTaskID
FROM #Meeting m 

INSERT INTO SecurityRoleSecurityTask
SELECT DISTINCT rt.RoleID, nt.ID
FROM #Meeting m JOIN
SecurityTask nt ON nt.ID = m.ViewStartAndEndDateTaskID JOIN
SecurityTask et ON et.SecurityTaskTypeID = nt.SecurityTaskTypeID JOIN
SecurityRoleSecurityTask rt ON rt.TaskID = et.ID 

--Edit Start and End Date Permissions
INSERT INTO SecurityTaskCategory
SELECT m.EditStartAndEndDateCategoryID, 'Edit', m.StartAndEndDateCategoryID, NULL, 1, NULL, m.ID
FROM #Meeting m 

INSERT INTO SecurityTask
SELECT '2825A4E0-E342-48B1-BFCB-6A037C93C7BA', m.EditStartAndEndDateCategoryID, 0, @contextTypeID, m.ID, m.EditStartAndEndDateTaskID
FROM #Meeting m

INSERT INTO SecurityRoleSecurityTask
SELECT DISTINCT rt.RoleID, nt.ID
FROM #Meeting m JOIN
SecurityTask nt ON nt.ID = m.EditStartAndEndDateTaskID JOIN
SecurityTask et ON et.SecurityTaskTypeID = nt.SecurityTaskTypeID JOIN
SecurityRoleSecurityTask rt ON rt.TaskID = et.ID 

DROP TABLE #Meeting
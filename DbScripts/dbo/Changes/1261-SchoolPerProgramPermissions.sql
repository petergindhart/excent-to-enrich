DECLARE @rootProgramCategoryID uniqueidentifier
SET @rootProgramCategoryID = '4380ACF5-3ABE-40C2-B724-2A43970BC81E'

DECLARE @viewSummaryTaskTypeID uniqueidentifier
SET @viewSummaryTaskTypeID = 'FB89727E-3289-4DA6-A386-CB02E791FF5C'

DECLARE @configureSchoolTeamTaskTypeID uniqueidentifier
SET @configureSchoolTeamTaskTypeID = '022E578E-79AC-407C-B5F9-C9403CC45698'

----Tasks: UpdateNames
UPDATE SecurityTaskType
SET Name = 'View School Program Summary', DisplayName = 'View School Program Summary'
WHERE ID = @viewSummaryTaskTypeID

UPDATE SecurityTaskType
SET Name = 'Configure School Program Team', DisplayName = 'Configure School Program Team'
WHERE ID = @configureSchoolTeamTaskTypeID

----Root: Root Programs Category
INSERT INTO SecurityTaskCategory
VALUES (@rootProgramCategoryID, 'Programs', 'D2AA105F-F536-4E0F-8E7A-4FA4CAB02344', NULL, 3, NULL, NULL)

CREATE TABLE #program
(
	programID uniqueidentifier,
	programCategoryID uniqueidentifier,
	viewSummaryCategoryID uniqueidentifier,
	viewSummaryTaskID uniqueidentifier,
	configureSchoolTeamCategoryID uniqueidentifier,
	configureSchoolTeamTaskID uniqueidentifier
)

----Program: ILP Program
INSERT INTO #program
VALUES('D3AB11A2-96C0-4BA5-914A-C250EDDEA995','BA2FBCF0-E755-4F1D-9BFA-CF2DFBE57341',
'066B9DC6-D15A-4F66-9473-E6366A4AEE9B','88AF1CBB-B86D-403A-9B4C-723B3853D5FA',
'66258FAC-49A3-4686-A2F7-F6D030E0ACEA','BB5E6860-D5DE-4B31-BADF-D4E933D13CC5')

----Program: RTI Program
INSERT INTO #program
VALUES('7DE3B3D7-B60F-48AC-9681-78D46A5E74D4','423CE5C2-53AD-4BCD-973F-5F4612F90268',
'7F9C6882-E65F-44BD-9167-D36E0F016979','05FA3A13-79BA-48E2-8A42-3B4B78755AF6',
'7AA6C660-770B-45C8-B2F3-A5D6B6950F92','F7831458-2CD5-4DC2-8531-D88CD146A7BD')

----Program: SpEd Program
INSERT INTO #program
VALUES('F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C','F30A9520-E52D-41EE-83AD-0D2CBE5ADB05',
'2DCE1641-9D4D-4950-930F-C0DE505507FB','2542FCE0-62F8-4C59-B370-22DFD7549F94',
'CE2F2853-F3A9-4729-9D1B-D3B2968AE39C','3507DC2C-77F8-41BD-AD3E-6D0A4D234894')

----Programs: Custom Programs
INSERT INTO #program
SELECT ID, NEWID(), 
NEWID(), NEWID(),
NEWID(), NEWID()
FROM Program p
WHERE p.ID NOT IN (SELECT programID FROM #program)

----Program: Category
INSERT INTO SecurityTaskCategory
SELECT c.programCategoryID, p.Abbreviation, @rootProgramCategoryID, NULL, 0, NULL, c.programID
FROM #program c JOIN
Program p ON p.ID = c.programID 
ORDER BY p.Abbreviation ASC

----Program: View Summary Permissions
INSERT INTO SecurityTaskCategory
SELECT c.viewSummaryCategoryID, 'View Summary', c.programCategoryID, NULL, 0, NULL, c.programID
FROM #program c

INSERT INTO SecurityTask
SELECT @viewSummaryTaskTypeID, c.viewSummaryCategoryID, 0, NULL, c.programID, c.viewSummaryTaskID
FROM #program c

----Program: Configure Settings Permissions
INSERT INTO SecurityTaskCategory
SELECT c.configureSchoolTeamCategoryID, 'Setup Team', c.programCategoryID, NULL, 1, NULL, c.programID
FROM #program c

INSERT INTO SecurityTask
SELECT @configureSchoolTeamTaskTypeID, c.configureSchoolTeamCategoryID, 0, NULL, c.programID, c.configureSchoolTeamTaskID
FROM #program c

----Old Categories
DECLARE @oldRtiCategoryID uniqueidentifier
SET @oldRtiCategoryID = 'C53D85A0-EE8D-4A39-8778-46757FD41704'

DECLARE @oldViewSummaryCategoryID uniqueidentifier
SET @oldViewSummaryCategoryID = '61CF08B3-6B55-4D69-8EE1-035C732F5E9A'

DECLARE @manageTeamCategoryID uniqueidentifier
SET @manageTeamCategoryID = 'E7F20445-A57E-4518-9EF9-FDC1C48206A1'

----Permission Conversion : View Summary
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @oldViewSummaryCategoryID,
#program p JOIN 
SecurityTask newTask ON newTask.ID = p.viewSummaryTaskID

----Permission Conversion : Configure Settings
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @manageTeamCategoryID,
#program p JOIN 
SecurityTask newTask ON newTask.ID = p.configureSchoolTeamTaskID

----Clean up
DELETE FROM SecurityTaskCategory
WHERE ID IN (@oldRtiCategoryID, @oldViewSummaryCategoryID, @manageTeamCategoryID)

DROP TABLE #program
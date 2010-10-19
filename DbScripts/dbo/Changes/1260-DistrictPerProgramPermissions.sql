DECLARE @rootProgramCategoryID uniqueidentifier
SET @rootProgramCategoryID = '64EC7291-1B71-4268-AB01-14410587F727'

DECLARE @viewSummaryTaskTypeID uniqueidentifier
SET @viewSummaryTaskTypeID = '729EBF19-BB78-4139-BEA2-67C4FB28B38C'

DECLARE @manageDistrictTaskTypeID uniqueidentifier
SET @manageDistrictTaskTypeID = '9B496F36-FAC5-4957-817D-D6AC684860D5'

----Tasks: UpdateNames
UPDATE SecurityTaskType
SET Name = 'View District Summary', DisplayName = 'View District Summary'
WHERE ID = @viewSummaryTaskTypeID

UPDATE SecurityTaskType
SET Name = 'Configure District Setup', DisplayName = 'Configure District Setup'
WHERE ID = @manageDistrictTaskTypeID

----Root: Root Programs Category
INSERT INTO SecurityTaskCategory
VALUES (@rootProgramCategoryID, 'Programs', 'DA685604-DB23-490A-9552-7D6BF9B98CD7', NULL, 5, NULL, NULL)

CREATE TABLE #program
(
	programID uniqueidentifier,
	programCategoryID uniqueidentifier,
	viewSummaryCategoryID uniqueidentifier,
	viewSummaryTaskID uniqueidentifier,
	configureSettingsCategoryID uniqueidentifier,
	configureSettingsTaskID uniqueidentifier
)

----Program: ILP Program
INSERT INTO #program
VALUES('D3AB11A2-96C0-4BA5-914A-C250EDDEA995','331A5CF1-51FA-42E8-BC6E-735FB187521B',
'46BF9789-1D2D-4533-B5BF-CB5E642DD6D9','7688AFFC-C7F3-4761-80F0-DA6A6BB04BF4',
'E8E32A56-92DE-496B-A55D-B57290820170','67E1A3DB-F570-4178-99FA-A1A70EA882D6')

----Program: RTI Program
INSERT INTO #program
VALUES('7DE3B3D7-B60F-48AC-9681-78D46A5E74D4','9672CE1A-162E-4070-B3A3-F0FCB57DBFE6',
'25AB99AE-A9A7-49E5-8D4C-68ECB7F52937','E1C316D3-D17B-40A5-A1D9-D6FA96722576',
'BCB5D956-3ADA-409F-B0A4-A7A1B870E5C9','D71D0092-DEA2-4725-B2B0-6DCD05B5AFB9')

----Program: SpEd Program
INSERT INTO #program
VALUES('F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C','9E7B2FF5-D245-486F-96C4-20CAC65FF27B',
'BB6E4E85-2F4B-48A0-B9D6-E461AD7674CD','156E7E50-84EA-4FB9-83D4-74BD38577374',
'B6706C20-9574-4262-B111-254C01C96818','44F031A7-A614-46B2-9728-1E1C41CCBFA4')

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
SELECT c.configureSettingsCategoryID, 'Configure Setup', c.programCategoryID, NULL, 1, NULL, c.programID
FROM #program c

INSERT INTO SecurityTask
SELECT @manageDistrictTaskTypeID, c.configureSettingsCategoryID, 0, NULL, c.programID, c.configureSettingsTaskID
FROM #program c

----Old Categories
DECLARE @oldRtiCategoryID uniqueidentifier
SET @oldRtiCategoryID = '7D9E4B68-DA43-4578-9FB7-854350E5D90B'

DECLARE @oldViewSummaryCategoryID uniqueidentifier
SET @oldViewSummaryCategoryID = '5DE6E8CA-257B-4B48-A877-F24F5A8560F8'

DECLARE @oldConfigureSettingsCategoryID uniqueidentifier
SET @oldConfigureSettingsCategoryID = '0A517A48-1C4E-4202-9317-0E3D8A2005D6'

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
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @oldConfigureSettingsCategoryID,
#program p JOIN 
SecurityTask newTask ON newTask.ID = p.configureSettingsTaskID

----Clean up
DELETE FROM SecurityTaskCategory
WHERE ID IN (@oldRtiCategoryID, @oldViewSummaryCategoryID, @oldConfigureSettingsCategoryID)

DROP TABLE #program
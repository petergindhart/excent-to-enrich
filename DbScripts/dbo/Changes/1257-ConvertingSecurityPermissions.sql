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

----Program: ILP Program
INSERT INTO #program
VALUES('D3AB11A2-96C0-4BA5-914A-C250EDDEA995','D21E247E-2D36-4265-B7C4-A0F776A50CDC',
'0089858A-7737-4C1C-A238-61B12F5E0E26', 'BB54F53F-E915-44AF-AE22-7912A4B06BFC','F26E0011-8A20-40D5-9DC2-DD97570CD34E')

----Program: RTI Program
INSERT INTO #program
VALUES('7DE3B3D7-B60F-48AC-9681-78D46A5E74D4','93DC2CA4-5400-408D-BC3D-31F167FE4DCC',
'507C0DFE-A473-48C9-BAE6-60D70DE1B150','3ABE494F-197A-429E-BF98-F279635B37EE','3BAE357E-F2B3-4BA3-B383-DE8B0341C9C7')

----Program: SpEd Program
INSERT INTO #program
VALUES('F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C','6038585D-7B34-4C64-937A-F67DB51C03CE',
'2142AD1F-30C0-4210-9615-111C2EBCC99B','EDE13A46-53AE-4485-8BA8-9CD45F8F2755','F8380496-DDC8-45EE-82AF-616702E3E2D6')

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
	
	itemCategoryID uniqueidentifier DEFAULT NEWID(),
	viewCategoryID uniqueidentifier DEFAULT NEWID(),
	createCategoryID uniqueidentifier DEFAULT NEWID(), 
	deleteCategoryID uniqueidentifier DEFAULT NEWID(), 
	enterOutcomeCategoryID uniqueidentifier DEFAULT NEWID(), 
	
	commentsCategoryID uniqueidentifier DEFAULT NEWID(),
	viewCommentsCategoryID uniqueidentifier DEFAULT NEWID(),
	addCommentsCategoryID uniqueidentifier DEFAULT NEWID(),
	editCommentsCategoryID uniqueidentifier DEFAULT NEWID(),
	editMyCommentsCategoryID uniqueidentifier DEFAULT NEWID(),
	editOthersCommentsCategoryID uniqueidentifier DEFAULT NEWID(),
	deleteCommentsCategoryID uniqueidentifier DEFAULT NEWID(),
	deleteMyCommentsCategoryID uniqueidentifier DEFAULT NEWID(),
	deleteOthersCommentsCategoryID uniqueidentifier DEFAULT NEWID(),
	
	----Intervention Specific
	actionScheduleCategoryID uniqueidentifier,
	viewActionScheduleCategoryID uniqueidentifier,
	editActionScheduleCategoryID uniqueidentifier,
	
	scheduleCategoryID uniqueidentifier,
	viewScheduleCategoryID uniqueidentifier,
	editScheduleCategoryID uniqueidentifier,
	
	toolsCategoryID uniqueidentifier,
	viewToolsCategoryID uniqueidentifier,
	editToolsCategoryID uniqueidentifier,
	
	----Intervention and IEP Specific
	goalsCategoryID uniqueidentifier,
	viewGoalsCategoryID uniqueidentifier,
	editGoalsCategoryID uniqueidentifier,
	
	----Action Specific
	formsCategoryID uniqueidentifier,
	attachFormsCategoryID uniqueidentifier,
	editFormsCategoryID uniqueidentifier,
	deleteFormsCategoryID uniqueidentifier,
	
	----Team Configuration Specific
	teamCategoryID uniqueidentifier,
	viewTeamCategoryID uniqueidentifier,
	editTeamCategoryID uniqueidentifier
)

INSERT INTO #item (itemID, programID)
SELECT d.ID, d.ProgramID
FROM PrgItemDef d
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

----Item: View Permissions
INSERT INTO SecurityTaskCategory
SELECT i.viewCategoryID, 'View', i.itemCategoryID, NULL, 0, NULL, i.itemID
FROM #item i

INSERT INTO SecurityTask
SELECT '28F0D77A-813E-466E-945E-BDB77F5A33DC', i.viewCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i

----Item: Create Permissions
INSERT INTO SecurityTaskCategory
SELECT i.createCategoryID, 'Create', i.itemCategoryID, NULL, 1, NULL, i.itemID
FROM #item i 

INSERT INTO SecurityTask
SELECT 'FB18BADF-9535-4211-BB09-C71901936149', i.createCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i

----Item: Delete Permissions
INSERT INTO SecurityTaskCategory
SELECT i.deleteCategoryID, 'Delete', i.itemCategoryID, NULL, 2, NULL, i.itemID
FROM #item i 

INSERT INTO SecurityTask
SELECT '3819B923-B58A-486B-B01E-3F7DA369C771', i.deleteCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i

----Item: Enter Outcome Permissions
INSERT INTO SecurityTaskCategory
SELECT i.enterOutcomeCategoryID, 'Enter Outcome', i.itemCategoryID, NULL, 3, NULL, i.itemID
FROM #item i 

INSERT INTO SecurityTask
SELECT 'ED3250FA-00A2-47AF-9CA7-6CF84EC3E252', i.enterOutcomeCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i

----Comments: Category
INSERT INTO SecurityTaskCategory
SELECT i.commentsCategoryID, 'Comments', i.itemCategoryID, NULL, 4, NULL, i.itemID
FROM #item i 

----Comments: View Permissions
INSERT INTO SecurityTaskCategory
SELECT i.viewCommentsCategoryID, 'View', i.commentsCategoryID, NULL, 0, NULL, i.itemID
FROM #item i 

INSERT INTO SecurityTask
SELECT 'BE5BF034-03E8-4CA8-AB36-16C34AEE287C', i.viewCommentsCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i

----Comments: Add Permissions
INSERT INTO SecurityTaskCategory
SELECT i.addCommentsCategoryID, 'Add', i.commentsCategoryID, NULL, 1, NULL, i.itemID
FROM #item i 

INSERT INTO SecurityTask
SELECT '4026B7A0-FE59-4F46-8681-425C23921F34', i.addCommentsCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i

----Comments: Edit Category
INSERT INTO SecurityTaskCategory
SELECT i.editCommentsCategoryID, 'Edit', i.commentsCategoryID, NULL, 2, NULL, i.itemID
FROM #item i 

----Comments: Edit My Comments Permissions
INSERT INTO SecurityTaskCategory
SELECT i.editMyCommentsCategoryID, 'My Comments', i.editCommentsCategoryID, NULL, 0, NULL, i.itemID
FROM #item i 

INSERT INTO SecurityTask
SELECT 'CC4A43A5-F5FB-48D9-9B25-2501100E0CD6', i.editMyCommentsCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i

----Comments: Edit Others Comments Permissions
INSERT INTO SecurityTaskCategory
SELECT i.editOthersCommentsCategoryID, 'Others Comments', i.editCommentsCategoryID, NULL, 1, NULL, i.itemID
FROM #item i 

INSERT INTO SecurityTask
SELECT '6E1BC5E5-ADAF-4C92-942C-422D662B8F4F', i.editOthersCommentsCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i

----Comments: Delete Category
INSERT INTO SecurityTaskCategory
SELECT i.deleteCommentsCategoryID, 'Delete', i.commentsCategoryID, NULL, 3, NULL, i.itemID
FROM #item i 

----Comments: Delete My Comments Permissions
INSERT INTO SecurityTaskCategory
SELECT i.deleteMyCommentsCategoryID, 'My Comments', i.deleteCommentsCategoryID, NULL, 0, NULL, i.itemID
FROM #item i 

INSERT INTO SecurityTask
SELECT 'D1FC52A2-88F3-4AE1-ADDF-D0045BF1A893', i.deleteMyCommentsCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i

----Comments: Delete Others Comments Permissions
INSERT INTO SecurityTaskCategory
SELECT i.deleteOthersCommentsCategoryID, 'Others Comments', i.deleteCommentsCategoryID, NULL, 1, NULL, i.itemID
FROM #item i 

INSERT INTO SecurityTask
SELECT 'D840E0E6-5D69-4CEA-9D87-9D24239ACCAB', i.deleteOthersCommentsCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i

----Intervention: Specific Categories
UPDATE i
SET actionScheduleCategoryID = NEWID(), viewActionScheduleCategoryID = NEWID(), editActionScheduleCategoryID = NEWID(),
scheduleCategoryID = NEWID(), viewScheduleCategoryID = NEWID(), editScheduleCategoryID = NEWID(),
toolsCategoryID = NEWID(), viewToolsCategoryID = NEWID(), editToolsCategoryID = NEWID()
FROM #item i JOIN 
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID = '03670605-58B2-40B2-99D5-4A1A70156C73'

----Intervention: Action Schedules Category
INSERT INTO SecurityTaskCategory
SELECT i.actionScheduleCategoryID, 'Action Schedules', i.itemCategoryID, NULL, 4, NULL, i.itemID
FROM #item i 
WHERE i.actionScheduleCategoryID IS NOT NULL

----Intervention: View Action Schedule Permissions
INSERT INTO SecurityTaskCategory
SELECT i.viewActionScheduleCategoryID, 'View', i.actionScheduleCategoryID, NULL, 0, NULL, i.itemID
FROM #item i 
WHERE i.viewActionScheduleCategoryID IS NOT NULL

INSERT INTO SecurityTask
SELECT '4216EEA6-D9F1-42EA-966A-3F414F1410AE', i.viewActionScheduleCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.viewActionScheduleCategoryID IS NOT NULL

----Intervention: Edit Action Schedule Permissions
INSERT INTO SecurityTaskCategory
SELECT i.editActionScheduleCategoryID, 'Edit', i.actionScheduleCategoryID, NULL, 1, NULL, i.itemID
FROM #item i 
WHERE i.editActionScheduleCategoryID IS NOT NULL

INSERT INTO SecurityTask
SELECT '2C991BF6-9BF2-4B43-ACE8-307EE9D5C0AE', i.editActionScheduleCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.editActionScheduleCategoryID IS NOT NULL

----Intervention: Schedule Category
INSERT INTO SecurityTaskCategory
SELECT i.scheduleCategoryID, 'Schedule', i.itemCategoryID, NULL, 4, NULL, i.itemID
FROM #item i 
WHERE i.scheduleCategoryID IS NOT NULL

----Intervention: View Schedule Permissions
INSERT INTO SecurityTaskCategory
SELECT i.viewScheduleCategoryID, 'View', i.scheduleCategoryID, NULL, 0, NULL, i.itemID
FROM #item i 
WHERE i.viewScheduleCategoryID IS NOT NULL

INSERT INTO SecurityTask
SELECT '2B3A2BDB-435F-472E-AC68-9F248C477331', i.viewScheduleCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.viewScheduleCategoryID IS NOT NULL

----Intervention: Edit Schedule Permissions
INSERT INTO SecurityTaskCategory
SELECT i.editScheduleCategoryID, 'Edit', i.scheduleCategoryID, NULL, 1, NULL, i.itemID
FROM #item i 
WHERE i.editScheduleCategoryID IS NOT NULL

INSERT INTO SecurityTask
SELECT '2825A4E0-E342-48B1-BFCB-6A037C93C7BA', i.editScheduleCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.editScheduleCategoryID IS NOT NULL

----Intervention: Tools Category
INSERT INTO SecurityTaskCategory
SELECT i.toolsCategoryID, 'Tools', i.itemCategoryID, NULL, 4, NULL, i.itemID
FROM #item i 
WHERE i.toolsCategoryID IS NOT NULL

----Intervention: View Tools Permissions
INSERT INTO SecurityTaskCategory
SELECT i.viewToolsCategoryID, 'View', i.toolsCategoryID, NULL, 0, NULL, i.itemID
FROM #item i 
WHERE i.viewToolsCategoryID IS NOT NULL

INSERT INTO SecurityTask
SELECT 'DD14F929-54BC-4739-93B4-A44AB60EB8C5', i.viewToolsCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.viewToolsCategoryID IS NOT NULL

----Intervention: Edit Tools Permissions
INSERT INTO SecurityTaskCategory
SELECT i.editToolsCategoryID, 'Edit', i.toolsCategoryID, NULL, 1, NULL, i.itemID
FROM #item i 
WHERE i.editToolsCategoryID IS NOT NULL

INSERT INTO SecurityTask
SELECT '75397555-AC0A-4470-AD7B-50BF0BEF5D17', i.editToolsCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.editToolsCategoryID IS NOT NULL

----Intervention and IEP: Specific Categories
UPDATE i
SET goalsCategoryID = NEWID(), viewGoalsCategoryID = NEWID(), 
editGoalsCategoryID = NEWID()
FROM #item i JOIN 
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('03670605-58B2-40B2-99D5-4A1A70156C73', 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

----Intervention and IEP: Goals Category
INSERT INTO SecurityTaskCategory
SELECT i.goalsCategoryID, 'Goals', i.itemCategoryID, NULL, 4, NULL, i.itemID
FROM #item i 
WHERE i.goalsCategoryID IS NOT NULL

----Intervention and IEP: View Goals Permissions
INSERT INTO SecurityTaskCategory
SELECT i.viewGoalsCategoryID, 'View', i.goalsCategoryID, NULL, 0, NULL, i.itemID
FROM #item i 
WHERE i.viewGoalsCategoryID IS NOT NULL

INSERT INTO SecurityTask
SELECT '5CE42A14-7DEE-464C-B9B0-D21C8BD6AE00', i.viewGoalsCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.viewGoalsCategoryID IS NOT NULL

----Intervention and IEP: Edit Goals Permissions
INSERT INTO SecurityTaskCategory
SELECT i.editGoalsCategoryID, 'Edit', i.goalsCategoryID, NULL, 1, NULL, i.itemID
FROM #item i 
WHERE i.editGoalsCategoryID IS NOT NULL

INSERT INTO SecurityTask
SELECT '0550E034-636D-4C97-8F6E-81435F279CC3', i.editGoalsCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.editGoalsCategoryID IS NOT NULL

----Action: Specific Categories
UPDATE i
SET formsCategoryID = NEWID(), attachFormsCategoryID = NEWID(), 
editFormsCategoryID = NEWID(), deleteFormsCategoryID = NEWID()
FROM #item i JOIN 
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('2A37FB49-1977-48C7-9031-56148AEE8328','1511F713-B210-40BB-ACCA-624212BB38F4')

----Action: Forms Category
INSERT INTO SecurityTaskCategory
SELECT i.formsCategoryID, 'Forms', i.itemCategoryID, NULL, 4, NULL, i.itemID
FROM #item i 
WHERE i.formsCategoryID IS NOT NULL

----Action: View Form Permissions (Task Only)
INSERT INTO SecurityTask
SELECT 'E44D45F8-25F3-4950-9D27-8ACC692FBE7B', i.viewCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.formsCategoryID IS NOT NULL

----Action: Attach Form Permissions
INSERT INTO SecurityTaskCategory
SELECT i.attachFormsCategoryID, 'Attach', i.formsCategoryID, NULL, 1, NULL, i.itemID
FROM #item i 
WHERE i.attachFormsCategoryID IS NOT NULL

INSERT INTO SecurityTask
SELECT 'C899A55F-C697-4A9A-968A-F48957615334', i.attachFormsCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.attachFormsCategoryID IS NOT NULL

----Action: Edit Form Permissions
INSERT INTO SecurityTaskCategory
SELECT i.editFormsCategoryID, 'Edit', i.formsCategoryID, NULL, 2, NULL, i.itemID
FROM #item i 
WHERE i.editFormsCategoryID IS NOT NULL

INSERT INTO SecurityTask
SELECT 'EFEF0864-D69C-413A-8ABC-C48273934B72', i.editFormsCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.editFormsCategoryID IS NOT NULL

----Action: Delete Form Permissions
INSERT INTO SecurityTaskCategory
SELECT i.deleteFormsCategoryID, 'Delete', i.formsCategoryID, NULL, 3, NULL, i.itemID
FROM #item i 
WHERE i.deleteFormsCategoryID IS NOT NULL

INSERT INTO SecurityTask
SELECT '5CBAE974-903C-42AD-96ED-65BA2D3D1864', i.deleteFormsCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.deleteFormsCategoryID IS NOT NULL

----Team Configuration Specific Categories
UPDATE i
SET teamCategoryID = NEWID(), viewTeamCategoryID = NEWID(), editTeamCategoryID = NEWID()
FROM #item i JOIN 
PrgItemDef d ON d.ID = i.itemID
WHERE d.UseTeam = 1

----Team: Category
INSERT INTO SecurityTaskCategory
SELECT i.teamCategoryID, 'Team', i.itemCategoryID, NULL, 4, NULL, i.itemID
FROM #item i 
WHERE i.teamCategoryID IS NOT NULL

----Team: View Team Permissions
INSERT INTO SecurityTaskCategory
SELECT i.viewTeamCategoryID, 'View', i.teamCategoryID, NULL, 0, NULL, i.itemID
FROM #item i 
WHERE i.viewTeamCategoryID IS NOT NULL

INSERT INTO SecurityTask
SELECT 'CBDE8B3B-909F-4874-842D-480A7AD36B97', i.viewTeamCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.viewTeamCategoryID IS NOT NULL

----Team: Edit Team Permissions
INSERT INTO SecurityTaskCategory
SELECT i.editTeamCategoryID, 'Edit', i.teamCategoryID, NULL, 1, NULL, i.itemID
FROM #item i 
WHERE i.editTeamCategoryID IS NOT NULL

INSERT INTO SecurityTask
SELECT '38DD9A3A-36AC-4E47-8258-2F2654C4426F', i.editTeamCategoryID, 0, @contextTypeID, i.itemID, NEWID()
FROM #item i
WHERE i.editTeamCategoryID IS NOT NULL

----Section
CREATE TABLE #section
(
	sectionID uniqueidentifier,
	sectionCategoryID uniqueidentifier DEFAULT NEWID(),
	viewSectionCategoryID uniqueidentifier DEFAULT NEWID(),
	editSectionCategoryID uniqueidentifier DEFAULT NEWID()
)

INSERT INTO #section (sectionID)
SELECT ID
FROM PrgSectionDef

----Section: Category
INSERT INTO SecurityTaskCategory
SELECT s.sectionCategoryID, t.Name, i.itemCategoryID, NULL, 4, NULL, s.sectionID
FROM #section s JOIN
PrgSectionDef d ON d.ID = s.sectionID JOIN
PrgSectionType t ON t.ID = d.TypeID JOIN
#item i ON i.itemID = d.ItemDefID

----Section: View Section Permissions
INSERT INTO SecurityTaskCategory
SELECT s.viewSectionCategoryID, 'View', s.sectionCategoryID, NULL, 0, NULL, s.sectionID
FROM #section s

INSERT INTO SecurityTask
SELECT '19028B08-C7AB-4B67-91AF-C448B093559D', s.viewSectionCategoryID, 0, @contextTypeID, s.sectionID, NEWID()
FROM #section s

----Section: Edit Section Permissions
INSERT INTO SecurityTaskCategory
SELECT s.editSectionCategoryID, 'Edit', s.sectionCategoryID, NULL, 1, NULL, s.sectionID
FROM #section s

INSERT INTO SecurityTask
SELECT '4CA7B7A8-F906-4CCC-8673-711BD8364F95', s.editSectionCategoryID, 0, @contextTypeID, s.sectionID, NEWID()
FROM #section s
----END PrgItemDef--------------------------------------------------------------------

----START Conversion------------------------------------------------------------------
----Old Category ID's
DECLARE @viewComment uniqueidentifier
SET @viewComment = '89B9C344-A804-4E47-B5E5-F8C7B4FDE744'

DECLARE @addComment uniqueidentifier
SET @addComment = '67A1B905-2015-495C-86CB-8B9EA8007284'

DECLARE @editMyComment uniqueidentifier
SET @editMyComment = '0FF85E2C-3740-400B-BAA0-F0DE99D29435'

DECLARE @editOthersComment uniqueidentifier
SET @editOthersComment = 'CC160E25-6BE4-49CA-BCB6-05707F350C60'

DECLARE @deleteMyComment uniqueidentifier
SET @deleteMyComment = 'F7E33DB7-093D-4116-9119-610E0AE3D9E5'

DECLARE @deleteOthersComment uniqueidentifier
SET @deleteOthersComment = '2EA4A821-98F0-4405-9CB5-01EABCE4D0A3'

DECLARE @viewPreIntervention uniqueidentifier
SET @viewPreIntervention = '45D2B9C9-B43E-49A9-B972-F640C4247C95'

DECLARE @viewPreInterventionTaskType uniqueidentifier
SET @viewPreInterventionTaskType = 'CDDEF9D1-18F7-4933-BD86-740F9C273AFB'

DECLARE @viewPreInterventionFormTaskType uniqueidentifier
SET @viewPreInterventionFormTaskType = '4EEAB717-1301-481B-84F1-B7BFA1B9645E'

DECLARE @createPreIntervention uniqueidentifier
SET @createPreIntervention = '8308213E-336E-48E0-B842-0A950DFE09F1'

DECLARE @finalizePreIntervention uniqueidentifier
SET @finalizePreIntervention = '78B26A6C-77BE-4F0C-8498-726ECDFCD822'

DECLARE @deletePreIntervention uniqueidentifier
SET @deletePreIntervention = '7827483C-F77A-406E-A363-4C4636370BDA'

DECLARE @attachFormPreIntervention uniqueidentifier
SET @attachFormPreIntervention = 'F4F08FCB-AD78-4F33-9578-E2DECD207AD4'

DECLARE @editFormPreIntervention uniqueidentifier
SET @editFormPreIntervention = 'F444891D-83BB-44BF-B561-EEE06CACDED0'

DECLARE @deleteFormPreIntervention uniqueidentifier
SET @deleteFormPreIntervention = '83B9B593-71AF-419C-B37A-AC9221D212D4'

DECLARE @createPlan uniqueidentifier
SET @createPlan = '08F88C66-EC11-4DF1-9A36-B7F591DBD743'

DECLARE @viewPlan uniqueidentifier
SET @viewPlan = '05C0726B-8D26-4AC5-AAFE-E5DD48C75C9E'

DECLARE @viewPlanActionTaskType uniqueidentifier
SET @viewPlanActionTaskType = '4506843E-4A76-4D28-A71A-CD0B10CB152B'

DECLARE @viewPlanTaskType uniqueidentifier
SET @viewPlanTaskType = 'EF8EE870-E492-40B1-84F4-00335D9787C4'

DECLARE @viewPlanActionFormTaskType uniqueidentifier
SET @viewPlanActionFormTaskType = '3DA250D4-8BB1-4153-A761-945E435991B5'

DECLARE @editPlanSchedule uniqueidentifier
SET @editPlanSchedule = '006C6E8C-17E5-43EB-ADF5-DDD2F3459AA3'

DECLARE @editPlanTeam uniqueidentifier
SET @editPlanTeam = 'E468A2D4-BEE1-4B5F-B16D-C43F8DF6E5C3'

DECLARE @editPlanTools uniqueidentifier
SET @editPlanTools = '702E9DC3-8D36-415A-BAC8-2A9773B11110'

DECLARE @editPlanGoals uniqueidentifier
SET @editPlanGoals = '6FF9E2E6-1042-43A7-968F-6E81BB94B3BD'

DECLARE @editPlanActionSchedules uniqueidentifier
SET @editPlanActionSchedules = 'DDAC9AA7-DC9D-44C3-B8B8-2364CD062FC5'

DECLARE @deletePlan uniqueidentifier
SET @deletePlan = '554F9CBA-F20C-4A74-86B4-372894511AB9'

DECLARE @enterOutcome uniqueidentifier
SET @enterOutcome = '86EB045E-A91F-479B-A8ED-CAECC860E295'

DECLARE @actionsCreate uniqueidentifier
SET @actionsCreate = '74A5DC6B-F250-4531-88B4-198B992EF51C'

DECLARE @actionsFinalize uniqueidentifier
SET @actionsFinalize = 'AD4E5DD3-1661-49BB-8696-70296E70271C'

DECLARE @actionsDelete uniqueidentifier
SET @actionsDelete = '5586F06A-554E-4169-A111-70F200784EDC'

DECLARE @actionFormsAttach uniqueidentifier
SET @actionFormsAttach = '37C2D7DF-896C-40F4-87BE-14F2B2FC7474'

DECLARE @actionFormsEdit uniqueidentifier
SET @actionFormsEdit = '3421A103-8822-46D7-9F52-BAD6961E2626'

DECLARE @actionFormsDelete uniqueidentifier
SET @actionFormsDelete = 'EF574752-3F30-4094-9DF4-4CC2AC7F9AF1'

DECLARE @manageProbeScores uniqueidentifier
SET @manageProbeScores = '01A1F74A-45CB-4B7E-89A9-8FEE78D70874'

DECLARE @viewProbeScoreTaskType uniqueidentifier
SET @viewProbeScoreTaskType = 'E1C8E47C-43F4-43AB-A11C-08CC72F4BD01'

DECLARE @editProbeScoresTaskType uniqueidentifier
SET @editProbeScoresTaskType = '75AF87DA-F725-4DC5-9614-EF95099B7CCD'

DECLARE @addProbeScoresTaskType uniqueidentifier
SET @addProbeScoresTaskType = '7DFFA6B9-8622-4405-9244-0A0A3B809DB1'

DECLARE @deleteProbeScoresTaskType uniqueidentifier
SET @deleteProbeScoresTaskType = '5FEE837B-9BDD-4ECC-A48E-97B6D983CFFD'

----Permission Conversion : View Comments
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @viewComment,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.viewCommentsCategoryID

----Permission Conversion : Add Comments
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @addComment,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.addCommentsCategoryID

----Permission Conversion : Edit My Comments
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @editMyComment,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.editMyCommentsCategoryID

----Permission Conversion : Edit Others Comments
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @editOthersComment,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.editOthersCommentsCategoryID

----Permission Conversion : Delete My Comments
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @deleteMyComment,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.deleteMyCommentsCategoryID

----Permission Conversion : Delete Others Comments
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @deleteOthersComment,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.deleteOthersCommentsCategoryID

----Permission Conversion : View Pre-Intervention Activities
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND 
oldTask.CategoryID = @viewPreIntervention AND
oldTask.SecurityTaskTypeID = @viewPreInterventionTaskType,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.viewCategoryID AND
newTask.SecurityTaskTypeID = '28F0D77A-813E-466E-945E-BDB77F5A33DC' JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('2A37FB49-1977-48C7-9031-56148AEE8328')

----Permission Conversion : View Pre-Intervention Form Activities
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND 
oldTask.CategoryID = @viewPreIntervention AND
oldTask.SecurityTaskTypeID = @viewPreInterventionFormTaskType,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.viewCategoryID AND
newTask.SecurityTaskTypeID = 'E44D45F8-25F3-4950-9D27-8ACC692FBE7B' JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('2A37FB49-1977-48C7-9031-56148AEE8328')

----Permission Conversion : Create Pre-Intervention Activities
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @createPreIntervention,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.createCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('2A37FB49-1977-48C7-9031-56148AEE8328')

----Permission Conversion : Finalize Pre-Intervention Activities
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @finalizePreIntervention,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.enterOutcomeCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('2A37FB49-1977-48C7-9031-56148AEE8328')

----Permission Conversion : Delete Pre-Intervention Activities
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @deletePreIntervention,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.deleteCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('2A37FB49-1977-48C7-9031-56148AEE8328')

----Permission Conversion : Attach Form Pre-Intervention Activities
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @attachFormPreIntervention,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.attachFormsCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('2A37FB49-1977-48C7-9031-56148AEE8328')

----Permission Conversion : Edit Form Pre-Intervention Activities
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @editFormPreIntervention,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.editFormsCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('2A37FB49-1977-48C7-9031-56148AEE8328')

----Permission Conversion : Delete Form Pre-Intervention Activities
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @deleteFormPreIntervention,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.deleteFormsCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('2A37FB49-1977-48C7-9031-56148AEE8328')

----Permission Conversion : Create Plan
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @createPlan,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.createCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

----Permission Conversion : View Plan Actions
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND 
oldTask.CategoryID = @viewPlan AND
oldTask.SecurityTaskTypeID = @viewPlanActionTaskType,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.viewCategoryID AND 
newTask.SecurityTaskTypeID = '28F0D77A-813E-466E-945E-BDB77F5A33DC' JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('1511F713-B210-40BB-ACCA-624212BB38F4')

----Permission Conversion : View Plan
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND 
oldTask.CategoryID = @viewPlan AND
oldTask.SecurityTaskTypeID = @viewPlanTaskType,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.viewCategoryID AND 
newTask.SecurityTaskTypeID = '28F0D77A-813E-466E-945E-BDB77F5A33DC' JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

----Permission Conversion : View Plan Action Forms
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND 
oldTask.CategoryID = @viewPlan AND
oldTask.SecurityTaskTypeID = @viewPlanActionFormTaskType,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.viewCategoryID AND 
newTask.SecurityTaskTypeID = 'E44D45F8-25F3-4950-9D27-8ACC692FBE7B' JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('1511F713-B210-40BB-ACCA-624212BB38F4')

----Permission Conversion : View Plan Converted Sections
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND 
oldTask.CategoryID = @viewPlan AND
oldTask.SecurityTaskTypeID = @viewPlanTaskType,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.viewScheduleCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND 
oldTask.CategoryID = @viewPlan AND
oldTask.SecurityTaskTypeID = @viewPlanTaskType,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.viewTeamCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND 
oldTask.CategoryID = @viewPlan AND
oldTask.SecurityTaskTypeID = @viewPlanTaskType,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.viewToolsCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND 
oldTask.CategoryID = @viewPlan AND
oldTask.SecurityTaskTypeID = @viewPlanTaskType,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.viewGoalsCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND 
oldTask.CategoryID = @viewPlan AND
oldTask.SecurityTaskTypeID = @viewPlanTaskType,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.viewActionScheduleCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

----Permission Conversion : Edit Plan Schedule
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @editPlanSchedule,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.editScheduleCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

----Permission Conversion : Edit Plan Team
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @editPlanTeam,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.editTeamCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

----Permission Conversion : Edit Plan Tools
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @editPlanTools,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.editToolsCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

----Permission Conversion : Edit Plan Goals
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @editPlanGoals,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.editGoalsCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

----Permission Conversion : Edit Plan Action Schedules
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @editPlanActionSchedules,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.editActionScheduleCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

----Permission Conversion : Delete Plan
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @deletePlan,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.deleteCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

----Permission Conversion : Enter Plan Outcome
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @enterOutcome,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.enterOutcomeCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478','03670605-58B2-40B2-99D5-4A1A70156C73','A5990B5E-AFAD-4EF0-9CCA-DC3685296870')

----Permission Conversion : Action Create
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @actionsCreate,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.createCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('1511F713-B210-40BB-ACCA-624212BB38F4')

----Permission Conversion : Action Finalize
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @actionsFinalize,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.enterOutcomeCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('1511F713-B210-40BB-ACCA-624212BB38F4')

----Permission Conversion : Action Delete
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @actionsDelete,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.deleteCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('1511F713-B210-40BB-ACCA-624212BB38F4')

----Permission Conversion : Action Form Attach
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @actionFormsAttach,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.attachFormsCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('1511F713-B210-40BB-ACCA-624212BB38F4')

----Permission Conversion : Action Form Edit
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @actionFormsEdit,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.editFormsCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('1511F713-B210-40BB-ACCA-624212BB38F4')

----Permission Conversion : Action Form Delete
INSERT INTO SecurityRoleSecurityTask
SELECT rt.RoleID, newTask.ID
FROM SecurityRoleSecurityTask rt JOIN
SecurityTask oldTask ON oldTask.ID = rt.TaskID AND oldTask.CategoryID = @actionFormsDelete,
#item i JOIN 
SecurityTask newTask ON newTask.CategoryID = i.deleteFormsCategoryID JOIN
PrgItemDef d ON d.ID = i.itemID
WHERE d.TypeID IN ('1511F713-B210-40BB-ACCA-624212BB38F4')

----Permission Conversion : Probe Scores Category
DECLARE @probeScoreCategoryID uniqueidentifier
SET @probeScoreCategoryID = 'EF43FCEC-9334-413F-A89D-E25BB1F279F1'

INSERT INTO SecurityTaskCategory
VALUES(@probeScoreCategoryID, 'Probe Scores', '70085690-B6CC-4D6E-B825-C705B10B0680', NULL, 12, NULL, NULL)

----Permission Conversion : View Plan Probe Scores
DECLARE @viewProbeScoreCategoryID uniqueidentifier
SET @viewProbeScoreCategoryID = 'CBFE4869-703D-4B7D-BFDE-C54562F8CF27'

INSERT INTO SecurityTaskCategory
VALUES(@viewProbeScoreCategoryID, 'View', @probeScoreCategoryID, NULL, 0, NULL, NULL)

UPDATE SecurityTask
SET CategoryID = @viewProbeScoreCategoryID
WHERE SecurityTaskTypeID = @viewProbeScoreTaskType

----Permission Conversion : Add Probe Scores
DECLARE @addProbeScoreCategoryID uniqueidentifier
SET @addProbeScoreCategoryID = '2CF9E7CD-8C0D-4642-BC29-C763FB9B92C5'

INSERT INTO SecurityTaskCategory
VALUES(@addProbeScoreCategoryID, 'Add', @probeScoreCategoryID, NULL, 1, NULL, NULL)

UPDATE SecurityTask
SET CategoryID = @addProbeScoreCategoryID
WHERE SecurityTaskTypeID = @addProbeScoresTaskType

----Permission Conversion : Edit Probe Scores
DECLARE @editProbeScoreCategoryID uniqueidentifier
SET @editProbeScoreCategoryID = 'B79821AB-CF79-4512-A0F4-B29D33FEE79E'

INSERT INTO SecurityTaskCategory
VALUES(@editProbeScoreCategoryID, 'Edit', @probeScoreCategoryID, NULL, 2, NULL, NULL)

UPDATE SecurityTask
SET CategoryID = @editProbeScoreCategoryID
WHERE SecurityTaskTypeID = @editProbeScoresTaskType

----Permission Conversion : Delete Probe Scores
DECLARE @deleteProbeScoreCategoryID uniqueidentifier
SET @deleteProbeScoreCategoryID = 'B5AC615C-FB52-4824-A2A3-A645A4F092EE'

INSERT INTO SecurityTaskCategory
VALUES(@deleteProbeScoreCategoryID, 'Delete', @probeScoreCategoryID, NULL, 3, NULL, NULL)

UPDATE SecurityTask
SET CategoryID = @deleteProbeScoreCategoryID
WHERE SecurityTaskTypeID = @deleteProbeScoresTaskType

----END Conversion--------------------------------------------------------------

----Old Permission CleanUp
CREATE TABLE #toBeDeleted
(
	taskTypeID uniqueidentifier,
	categoryID uniqueidentifier
)

INSERT INTO #toBeDeleted
SELECT t.SecurityTaskTypeID, c.ID
FROM SecurityTaskCategory c LEFT JOIN
SecurityTask t on t.CategoryID = c.ID
WHERE c.ID IN
(
	@viewComment,
	@addComment,
	@editMyComment,
	@editOthersComment,
	@deleteMyComment,
	@deleteOthersComment,
	@viewPreIntervention,
	@createPreIntervention, 
	@finalizePreIntervention,
	@deletePreIntervention, 
	@attachFormPreIntervention,
	@editFormPreIntervention,
	@deleteFormPreIntervention,
	@createPlan,
	@viewPlan,
	@editPlanSchedule,
	@editPlanTeam,
	@editPlanTools,
	@editPlanGoals,
	@editPlanActionSchedules,
	@deletePlan,
	@enterOutcome,
	@actionsCreate,
	@actionsFinalize,
	@actionsDelete,
	@actionFormsAttach,
	@actionFormsEdit,
	@actionFormsDelete
) 
OR c.ID IN
(
	'FF0DE31E-A187-46DA-AEEE-5FE844799AF3', --Comments Category
	'E0ED96C4-DAB5-4B36-8B66-989AEEFC034C', --Edit Comments	
	'BA5EC32A-7560-4343-8231-24FEACC46ABA', --Delete Comments
	'1C3892D7-B62E-4898-A369-D2394C9E204D', --RTI
	'CC6E4841-179B-4D56-AD05-E76691019853', --Pre-Intervention Activities	
	'CBFB3C77-C91F-4CD6-B39B-9A2D31CBD4E6', --Pre-Intervention Forms
	'D4574DAE-E1A6-4511-BB2B-C3E3E13E76ED', --Interventions
	'A21972A9-26A4-416F-825F-AE8A368A2A78', --Edit Plan
	'687CF40F-EE52-4250-B57C-0B1A894D19C3', --Actions
	'830FDDC1-88E9-436D-9998-DEB04E09D858'  --Action Forms
)
OR t.SecurityTaskTypeID IN
(
	@viewPreInterventionTaskType,
	@viewPreInterventionFormTaskType,
	@viewPlanActionTaskType,
	@viewPlanTaskType,
	@viewPlanActionFormTaskType
)

DELETE FROM SecurityTaskType
WHERE ID IN (SELECT DISTINCT taskTypeID FROM #toBeDeleted)

DELETE FROM SecurityTaskCategory
WHERE ID IN (SELECT DISTINCT categoryID FROM #toBeDeleted)

DELETE FROM SecurityTaskCategory
WHERE ID = @manageProbeScores

DROP TABLE #program
DROP TABLE #item
DROP TABLE #section
DROP TABLE #toBeDeleted
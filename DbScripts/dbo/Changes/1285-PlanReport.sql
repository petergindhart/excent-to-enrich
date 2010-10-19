--Delete Planned End Date From Item
DELETE FROM VC3Reporting.ReportSchemaColumn
WHERE Id = '52478A33-6A2A-4E0E-A172-11AB1F927142'

--Update Definition On Item To Be Select Only
UPDATE VC3Reporting.ReportSchemaColumn
SET IsSelectColumn = 0
WHERE Id = 'D3DF497E-E9BB-4860-A6D2-D19049BCECC6'

DECLARE @studentContextID uniqueidentifier
SET @studentContextID = 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4'

--Update ReportType Sequence
UPDATE ReportType
SET Sequence = 2
WHERE Id IN ('I','M','T')

--Plan ReportType
DECLARE @reportTypeID varchar
SET @reportTypeID = 'P'

INSERT INTO VC3Reporting.ReportType
VALUES (@reportTypeID, 'Plan', 1)

INSERT INTO ReportType
VALUES (@reportTypeID, @studentContextID, 'View Plans', NULL, 'ReportIcon_Student.gif', 0, 2, NULL)

INSERT INTO VC3Reporting.ReportTypeFormat
VALUES (@reportTypeID, 'X', 0)

----PrgItemDef------------------------------------------------------------------------------------------
DECLARE @prgItemDefSchemaTableID uniqueidentifier
SET @prgItemDefSchemaTableID = '7CC0036F-BEDA-4FE4-B133-77167E7E8B09'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@prgItemDefSchemaTableID, 'Prg Item Def',
		'(SELECT *
		FROM PrgItemDef)',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@prgItemDefSchemaTableID, NULL)

--DeletedDate
DECLARE @pidDeletedDateColumnID uniqueidentifier
SET @pidDeletedDateColumnID = '3AC0A144-D3E6-4BEF-9D42-E5D82C9B9C60'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pidDeletedDateColumnID, 'Deleted Date', @prgItemDefSchemaTableID, 'D', NULL, 'DeletedDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pidDeletedDateColumnID, NULL)

--Description
DECLARE @pidDescriptionColumnID uniqueidentifier
SET @pidDescriptionColumnID = 'D32D8FB5-DA87-4280-8009-AF6916362E86'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pidDescriptionColumnID, 'Description', @prgItemDefSchemaTableID, 'T', NULL, 'Description', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pidDescriptionColumnID, NULL)

--Name
DECLARE @pidNameColumnID uniqueidentifier
SET @pidNameColumnID = 'D4D0E748-AB22-4DA7-8E33-A124064033AE'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pidNameColumnID, 'Name', @prgItemDefSchemaTableID, 'T', NULL, 'Name', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pidNameColumnID, NULL)

--ProgramID
DECLARE @pidProgramIdColumnID uniqueidentifier
SET @pidProgramIdColumnID = 'F71532E6-17C2-4C35-BA89-D813A148220C'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pidProgramIdColumnID, 'Program', @prgItemDefSchemaTableID, 'G', '(SELECT Name FROM Program WHERE ID={this}.ProgramID)', 'ProgramID', '(SELECT Name FROM Program WHERE ID={this}.ProgramID)', NULL, NULL, 0, 1, 1, 1, 1, 0, 'SELECT ID, Name AS Name FROM Program ORDER BY Name', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pidProgramIdColumnID, NULL)

--StatusID
DECLARE @pidStatusIdColumnID uniqueidentifier
SET @pidStatusIdColumnID = '3384BC9D-6CCD-48D5-AB80-67E7EA10E1B2'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pidStatusIdColumnID, 'Status', @prgItemDefSchemaTableID, 'G', '(SELECT Name FROM PrgStatus WHERE ID={this}.StatusID)', 'StatusID', '(SELECT Sequence FROM PrgStatus WHERE ID={this}.StatusID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Name AS Name FROM PrgStatus ORDER BY Sequence', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pidStatusIdColumnID, NULL)

--TeamLabel
DECLARE @pidTeamLabelColumnID uniqueidentifier
SET @pidTeamLabelColumnID = '5F765C5B-2FA0-439F-9A9D-8562ABF2218D'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pidTeamLabelColumnID, 'Team Label', @prgItemDefSchemaTableID, 'T', NULL, 'TeamLabel', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pidTeamLabelColumnID, NULL)

--TypeID
DECLARE @pidTypeIdColumnID uniqueidentifier
SET @pidTypeIdColumnID = '0BB7B38A-0909-4FEC-A80A-43FA550CBF4A'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pidTypeIdColumnID, 'Type', @prgItemDefSchemaTableID, 'G', '(SELECT Name FROM PrgItemType WHERE ID={this}.TypeID)', 'TypeID', '(SELECT Name FROM PrgItemType WHERE ID={this}.TypeID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Name AS Name FROM PrgItemType ORDER BY Name', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pidTypeIdColumnID, NULL)

--UsePlannedEndDate
DECLARE @pidUsePlannedEndDateColumnID uniqueidentifier
SET @pidUsePlannedEndDateColumnID = '3DCAA16D-608D-4582-A8B3-5DD73ECB346F'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pidUsePlannedEndDateColumnID, 'Use Planned End Date', @prgItemDefSchemaTableID, 'B', '(CASE WHEN {this}.UsePlannedEndDate= 1 THEN ''Yes'' ELSE ''No'' END)', 'UsePlannedEndDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT 1 Id, ''Yes'' Name UNION SELECT 0, ''No'' ORDER BY 1 DESC', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pidUsePlannedEndDateColumnID, NULL)

--UseTeam
DECLARE @pidUseTeamColumnID uniqueidentifier
SET @pidUseTeamColumnID = '17BE5850-AC80-4AEE-B8E5-00C9E678248A'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pidUseTeamColumnID, 'Use Team', @prgItemDefSchemaTableID, 'B', '(CASE WHEN {this}.UseTeam= 1 THEN ''Yes'' ELSE ''No'' END)', 'UseTeam', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT 1 Id, ''Yes'' Name UNION SELECT 0, ''No'' ORDER BY 1 DESC', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pidUseTeamColumnID, NULL)

----Program---------------------------------------------------------------------------------------------
DECLARE @programSchemaTableID uniqueidentifier
SET @programSchemaTableID = '6D04F20C-484A-4C7C-B41F-85940DF2BC88'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@programSchemaTableID, 'Program',
		'(SELECT *
		FROM Program)',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@programSchemaTableID, NULL)

--Abbreviation
DECLARE @pAbbreviationColumnID uniqueidentifier
SET @pAbbreviationColumnID = 'E1948D03-3747-4F46-BE2E-C3EFC91E46CF'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pAbbreviationColumnID, 'Abbreviation', @programSchemaTableID, 'T', NULL, 'Abbreviation', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pAbbreviationColumnID, NULL)

--DeletedDate
DECLARE @pDeletedDateColumnID uniqueidentifier
SET @pDeletedDateColumnID = '76B7617F-445A-46EC-AC43-E34D7D86DC0B'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pDeletedDateColumnID, 'Deleted Date', @programSchemaTableID, 'D', NULL, 'DeletedDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pDeletedDateColumnID, NULL)

--Description
DECLARE @pDescriptionColumnID uniqueidentifier
SET @pDescriptionColumnID = '0D1B892C-5F70-4FAD-AB58-BF6966C9548A'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pDescriptionColumnID, 'Description', @programSchemaTableID, 'T', NULL, 'Description', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pDescriptionColumnID, NULL)

--Name
DECLARE @pNameColumnID uniqueidentifier
SET @pNameColumnID = '71F0E7A3-C84A-4A57-9714-5452178BD6F5'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pNameColumnID, 'Name', @programSchemaTableID, 'T', NULL, 'Name', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pNameColumnID, NULL)

--SubVariantLabel
DECLARE @pSubVariantLabelColumnID uniqueidentifier
SET @pSubVariantLabelColumnID = '69C5E30A-4A6E-46DB-B26E-BC2A177DC791'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pSubVariantLabelColumnID, 'Sub Variant Label', @programSchemaTableID, 'T', NULL, 'SubVariantLabel', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pSubVariantLabelColumnID, NULL)

--UserDefined
DECLARE @pUserDefinedColumnID uniqueidentifier
SET @pUserDefinedColumnID = 'FB88CB5C-0519-4B54-A9AE-A2E789798C5D'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pUserDefinedColumnID, 'User Defined', @programSchemaTableID, 'B', '(CASE WHEN {this}.UserDefined= 1 THEN ''Yes'' ELSE ''No'' END)', 'UserDefined', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT 1 Id, ''Yes'' Name UNION SELECT 0, ''No'' ORDER BY 1 DESC', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pUserDefinedColumnID, NULL)

--VariantLabel
DECLARE @pVariantLabelColumnID uniqueidentifier
SET @pVariantLabelColumnID = '926BF285-F5B7-48EC-862A-5CA01EFEAEF3'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pVariantLabelColumnID, 'Variant Label', @programSchemaTableID, 'T', NULL, 'VariantLabel', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pVariantLabelColumnID, NULL)

----Plan-------------------------------------------------------------------------------
DECLARE @planSchemaTableID uniqueidentifier
SET @planSchemaTableID = 'B1AA13A5-75E1-402A-8170-20B8E18FDF3F'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@planSchemaTableID, 'Plan',
		'(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
		FROM
			(SELECT i.ID, i.PlannedEndDate,
				CASE
					WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
					ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
				END AS DaysUntilPlannedEnd,
				
				(SELECT TOP 1 bi.ID
				FROM PrgItem bi JOIN
					PrgItemDef bd on bd.ID = bi.DefID
				WHERE bi.StudentID = i.StudentID AND
					bi.ID <> i.ID AND
					NOT(bi.StartDate = i.StartDate AND bi.EndDate = i.EndDate) AND
					bd.TypeID IN (''D7B183D8-5BBD-4471-8829-3C8D82A92478'',''03670605-58B2-40B2-99D5-4A1A70156C73'',''A5990B5E-AFAD-4EF0-9CCA-DC3685296870'') AND
					bi.EndDate IS NOT NULL AND
					bi.EndDate <= i.StartDate
				ORDER BY bi.EndDate DESC,
					CASE
						WHEN bi.DefID = i.DefID THEN 1
						WHEN bd.ProgramID = d.ProgramID THEN 2
						ELSE 3
					END ASC) AS PlanBeforeID,
				
				(SELECT TOP 1 ai.ID
				FROM PrgItem ai JOIN
					PrgItemDef ad on ad.ID = ai.DefID
				WHERE ai.StudentID = i.StudentID AND
					ai.ID <> i.ID AND
					NOT(ai.StartDate = i.StartDate AND ai.EndDate = i.EndDate) AND
					ad.TypeID IN (''D7B183D8-5BBD-4471-8829-3C8D82A92478'',''03670605-58B2-40B2-99D5-4A1A70156C73'',''A5990B5E-AFAD-4EF0-9CCA-DC3685296870'') AND
					i.EndDate IS NOT NULL AND
					ai.StartDate >= i.EndDate
				ORDER BY ai.StartDate ASC,
					CASE
						WHEN ai.DefID = i.DefID THEN 1
						WHEN ad.ProgramID = d.ProgramID THEN 2
						ELSE 3
					END ASC) AS PlanAfterID	
			FROM PrgItem i JOIN
				PrgItemDef d ON d.ID = i.DefID
			WHERE d.TypeID IN (''D7B183D8-5BBD-4471-8829-3C8D82A92478'',''03670605-58B2-40B2-99D5-4A1A70156C73'',''A5990B5E-AFAD-4EF0-9CCA-DC3685296870'') ) p
		)',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@planSchemaTableID, NULL)

--DaysUntilPlannedEnd
DECLARE @pDaysUntilPlannedEndColumnID uniqueidentifier
SET @pDaysUntilPlannedEndColumnID = '2C2CC7FF-F5E3-481F-8AD6-4C34A08DA7E2'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pDaysUntilPlannedEndColumnID, 'Days Until Planned End', @planSchemaTableID, 'N', NULL, 'DaysUntilPlannedEnd', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pDaysUntilPlannedEndColumnID, NULL)

--PlannedEndDate
DECLARE @pPlannedEndDateColumnID uniqueidentifier
SET @pPlannedEndDateColumnID = '7AD2107D-5256-4EFE-ACDC-52A128A1685F'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pPlannedEndDateColumnID, 'Planned End Date', @planSchemaTableID, 'D', NULL, 'PlannedEndDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pPlannedEndDateColumnID, NULL)

--WeeksUntilPlannedEnd
DECLARE @pWeeksUntilPlannedEndColumnID uniqueidentifier
SET @pWeeksUntilPlannedEndColumnID = '3666EFAF-5B1B-441D-A7FC-902DB6D7EAD7'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pWeeksUntilPlannedEndColumnID, 'Weeks Until Planned End', @planSchemaTableID, 'N', NULL, 'WeeksUntilPlannedEnd', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pWeeksUntilPlannedEndColumnID, NULL)

--Report Type
INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('DEFA9577-3303-41D9-B2BB-6534C26FF6F1', 'Plan', @reportTypeID, 0, @planSchemaTableID, NULL, NULL, NULL, NULL)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('21824B3E-EE9A-4AF4-BA43-276CF7AABD4D', 'Item', @reportTypeID, 0, 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'DEFA9577-3303-41D9-B2BB-6534C26FF6F1', 'I', '{left}.ID = {right}.ID', NULL)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('32428BD8-171E-469F-BE69-681207279C33', 'Student', @reportTypeID, 0, 'F210EF27-1FBA-4518-B3F3-41DD8AFB4615', '21824B3E-EE9A-4AF4-BA43-276CF7AABD4D', 'I' ,'{left}.StudentID = {right}.ID', 'Student >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('E8DBCA0D-CBF7-44F8-A5B4-8962ECB04260', 'Item Definition', @reportTypeID, 0, @prgItemDefSchemaTableID, '21824B3E-EE9A-4AF4-BA43-276CF7AABD4D', 'I' ,'{left}.DefID = {right}.ID', 'Definition >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('AC078FB3-2783-45BF-8453-81676B23BF4D', 'Program', @reportTypeID, 0, @programSchemaTableID, 'E8DBCA0D-CBF7-44F8-A5B4-8962ECB04260', 'I' ,'{left}.ProgramID = {right}.ID', 'Program >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('A9E1482D-37F8-4859-BB9C-E4965120DFD7', 'Probe Score Change', @reportTypeID, 0, 'DAA40B4B-9CCD-4497-9DCF-79BD72154151', 'DEFA9577-3303-41D9-B2BB-6534C26FF6F1', 'R' ,'{left}.ID = {right}.ItemID', 'Probe Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('D5CB9F35-884D-408B-AEC8-7BBEDA38D2BB', 'Discipline Referral Change', @reportTypeID, 0, '939E4566-F622-4999-BDBB-734A87527675', 'DEFA9577-3303-41D9-B2BB-6534C26FF6F1', 'R' ,'{left}.ID = {right}.ItemID', 'Referral Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('77EBA24F-FC3C-42E7-A1C1-843B28F47F9E', 'Attendance Change', @reportTypeID, 0, '9FEF182E-4B86-4F42-AB94-D4D646D79B32', 'DEFA9577-3303-41D9-B2BB-6534C26FF6F1', 'R' ,'{left}.ID = {right}.ItemID', 'Attendance Change >')

--Report Type : Plan Before
INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('E955233C-6495-440C-BCBB-8272DB1C4397', 'Plan Before', @reportTypeID, 0, @planSchemaTableID, 'DEFA9577-3303-41D9-B2BB-6534C26FF6F1', 'L', '{left}.PlanBeforeID = {right}.ID', 'Plan Before >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('5314B645-B0B3-482D-8115-E46D1C0CAEA3', 'Plan Before - Item', @reportTypeID, 0, 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'E955233C-6495-440C-BCBB-8272DB1C4397', 'I', '{left}.ID = {right}.ID', 'Plan Before >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('64FD94EC-26DD-407E-9A06-A4973BE1906D', 'Plan Before - Item Definition', @reportTypeID, 0, @prgItemDefSchemaTableID, '5314B645-B0B3-482D-8115-E46D1C0CAEA3', 'I' ,'{left}.DefID = {right}.ID', 'Plan Before Defintion >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('B223B1DD-FDBA-48BF-A99E-C8A1243C13EC', 'Plan Before - Program', @reportTypeID, 0, @programSchemaTableID, 'B223B1DD-FDBA-48BF-A99E-C8A1243C13EC', 'I' ,'{left}.ProgramID = {right}.ID', 'Plan Before Program >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('F94B5F13-970E-4693-A19E-30C4DFD8BEA0', 'Plan Before - Probe Score Change', @reportTypeID, 0, 'DAA40B4B-9CCD-4497-9DCF-79BD72154151', 'E955233C-6495-440C-BCBB-8272DB1C4397', 'R' ,'{left}.ID = {right}.ItemID', 'Plan Before Probe Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('3BF196E0-5B15-498D-AC00-732F1660D3C6', 'Plan Before - Discipline Referral Change', @reportTypeID, 0, '939E4566-F622-4999-BDBB-734A87527675', 'E955233C-6495-440C-BCBB-8272DB1C4397', 'R' ,'{left}.ID = {right}.ItemID', 'Plan Before Referral Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('5F390A7C-3F89-41C1-897C-74531947A318', 'Plan Before - Attendance Change', @reportTypeID, 0, '9FEF182E-4B86-4F42-AB94-D4D646D79B32', 'E955233C-6495-440C-BCBB-8272DB1C4397', 'R' ,'{left}.ID = {right}.ItemID', 'Plan Before Attendance Change >')

--Report Type : Plan After
INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('DD40AF6A-6EBE-4034-B251-E0CA7B2D7911', 'Plan After', @reportTypeID, 0, @planSchemaTableID, 'DEFA9577-3303-41D9-B2BB-6534C26FF6F1', 'L', '{left}.PlanAfterID = {right}.ID', 'Plan After >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('E5002A8D-B530-4890-A382-E44F81780F8C', 'Plan After - Item', @reportTypeID, 0, 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'DD40AF6A-6EBE-4034-B251-E0CA7B2D7911', 'I', '{left}.ID = {right}.ID', 'Plan After >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('DEDEC257-D19B-4BDC-8834-4AFC1BDB3679', 'Plan After - Item Definition', @reportTypeID, 0, @prgItemDefSchemaTableID, 'E5002A8D-B530-4890-A382-E44F81780F8C', 'I' ,'{left}.DefID = {right}.ID', 'Plan After Defintion >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('D1A764AA-808B-4E4C-9685-16F41B2ACC9D', 'Plan After - Program', @reportTypeID, 0, @programSchemaTableID, 'DEDEC257-D19B-4BDC-8834-4AFC1BDB3679', 'I' ,'{left}.ProgramID = {right}.ID', 'Plan After Program >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('C4A4BAC5-9782-44FB-89DD-D8C3EA109F0D', 'Plan After - Probe Score Change', @reportTypeID, 0, 'DAA40B4B-9CCD-4497-9DCF-79BD72154151', 'DD40AF6A-6EBE-4034-B251-E0CA7B2D7911', 'R' ,'{left}.ID = {right}.ItemID', 'Plan After Probe Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('710459B8-16CD-43F6-9755-F2DEA31BC301', 'Plan After - Discipline Referral Change', @reportTypeID, 0, '939E4566-F622-4999-BDBB-734A87527675', 'DD40AF6A-6EBE-4034-B251-E0CA7B2D7911', 'R' ,'{left}.ID = {right}.ItemID', 'Plan After Referral Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('393F6B63-AD8C-4261-BB7E-4818E6F6B146', 'Plan After - Attendance Change', @reportTypeID, 0, '9FEF182E-4B86-4F42-AB94-D4D646D79B32', 'DD40AF6A-6EBE-4034-B251-E0CA7B2D7911', 'R' ,'{left}.ID = {right}.ItemID', 'Plan After Attendance Change >')

--Update Meeting To Include Meeting Before And After---------------------------------------------------------------------------------
UPDATE VC3Reporting.ReportSchemaTable
SET TableExpression =
'(SELECT m.*, i.StartDate AS StartTime, i.EndDate AS EndTime,
	(SELECT TOP 1 bi.ID
	FROM PrgMeeting bm JOIN
		PrgItem bi ON bi.ID = bm.ID JOIN
		PrgItemDef bd ON bd.ID = bi.DefID
	WHERE bi.StudentID = i.StudentID AND
		bi.ID <> i.ID AND
		NOT(bi.StartDate = i.StartDate AND bi.EndDate = i.EndDate) AND
		bi.EndDate IS NOT NULL AND
		bi.EndDate <= i.StartDate
	ORDER BY bi.EndDate DESC,
		CASE
			WHEN bi.DefID = i.DefID THEN 1
			WHEN bd.ProgramID = d.ProgramID THEN 2
			ELSE 3
		END ASC) AS MeetingBeforeID,

	(SELECT TOP 1 ai.ID
	FROM PrgMeeting am JOIN
		PrgItem ai ON ai.ID = am.ID JOIN
		PrgItemDef ad ON ad.ID = ai.DefID
	WHERE ai.StudentID = i.StudentID AND
		ai.ID <> i.ID AND
		NOT(ai.StartDate = i.StartDate AND ai.EndDate = i.EndDate) AND
		i.EndDate IS NOT NULL AND
		ai.StartDate >= i.EndDate
	ORDER BY ai.StartDate ASC,
		CASE
			WHEN ai.DefID = i.DefID THEN 1
			WHEN ad.ProgramID = d.ProgramID THEN 2
			ELSE 3
		END ASC) AS MeetingAfterID	
FROM PrgMeeting m JOIN 
	PrgItem i ON i.ID = m.ID JOIN
	PrgItemDef d ON d.ID = i.DefID)'
WHERE Id = '9E90D4AB-464F-45C6-BBEF-F46B254EF882'

--Report Type : Meeting Before
INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('C0A2EBDF-F3C2-422B-B8DF-EF18A30F2AEC', 'Meeting Before', 'M', 0, '9E90D4AB-464F-45C6-BBEF-F46B254EF882', 'B42FF3DD-BAAF-40D0-B604-700FF1E17C5D', 'L', '{left}.MeetingBeforeID = {right}.ID', 'Meeting Before >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('3C3CA980-F52E-487E-B63D-5F30A94E8228', 'Meeting Before - Item', 'M', 0, 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'C0A2EBDF-F3C2-422B-B8DF-EF18A30F2AEC', 'I', '{left}.ID = {right}.ID', 'Meeting Before >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('1955C898-2FBB-49A5-9CC7-16F02A0F3B02', 'Meeting Before - Item Definition', 'M', 0, @prgItemDefSchemaTableID, '3C3CA980-F52E-487E-B63D-5F30A94E8228', 'I' ,'{left}.DefID = {right}.ID', 'Meeting Before Defintion >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('F22A6B94-742D-49AB-9504-1C8C091B2DA7', 'Meeting Before - Program', 'M', 0, @programSchemaTableID, '1955C898-2FBB-49A5-9CC7-16F02A0F3B02', 'I' ,'{left}.ProgramID = {right}.ID', 'Meeting Before Program >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('5E280416-F24F-4CDF-AFE0-495F1FCA812E', 'Meeting Before - Probe Score Change', 'M', 0, 'DAA40B4B-9CCD-4497-9DCF-79BD72154151', 'C0A2EBDF-F3C2-422B-B8DF-EF18A30F2AEC', 'R' ,'{left}.ID = {right}.ItemID', 'Meeting Before Probe Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('BE42510D-BA6D-4F38-881F-6D8D512C71E9', 'Meeting Before - Discipline Referral Change', 'M', 0, '939E4566-F622-4999-BDBB-734A87527675', 'C0A2EBDF-F3C2-422B-B8DF-EF18A30F2AEC', 'R' ,'{left}.ID = {right}.ItemID', 'Meeting Before Referral Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('587D3B6E-A85C-4759-9F81-6B513BE4641B', 'Meeting Before - Attendance Change', 'M', 0, '9FEF182E-4B86-4F42-AB94-D4D646D79B32', 'C0A2EBDF-F3C2-422B-B8DF-EF18A30F2AEC', 'R' ,'{left}.ID = {right}.ItemID', 'Meeting Before Attendance Change >')

--Report Type : Meeting After
INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('EB34AB3F-1C4F-44EF-A95F-34C75899ED94', 'Meeting After', 'M', 0, '9E90D4AB-464F-45C6-BBEF-F46B254EF882', 'B42FF3DD-BAAF-40D0-B604-700FF1E17C5D', 'L', '{left}.MeetingAfterID = {right}.ID', 'Meeting After >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('CEE6D738-4815-45C5-A008-29B1600CD86C', 'Meeting After - Item', 'M', 0, 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'EB34AB3F-1C4F-44EF-A95F-34C75899ED94', 'I', '{left}.ID = {right}.ID', 'Meeting After >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('F5714518-9821-4261-BFCF-F7A6E004E188', 'Meeting After - Item Definition', 'M', 0, @prgItemDefSchemaTableID, 'CEE6D738-4815-45C5-A008-29B1600CD86C', 'I' ,'{left}.DefID = {right}.ID', 'Meeting After Defintion >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('B16AE45D-AECC-426F-8C6E-067538E1E336', 'Meeting After - Program', 'M', 0, @programSchemaTableID, 'F5714518-9821-4261-BFCF-F7A6E004E188', 'I' ,'{left}.ProgramID = {right}.ID', 'Meeting After Program >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('A5896DE9-ACF1-46BA-876C-4FCAD9607F48', 'Meeting After - Probe Score Change', 'M', 0, 'DAA40B4B-9CCD-4497-9DCF-79BD72154151', 'EB34AB3F-1C4F-44EF-A95F-34C75899ED94', 'R' ,'{left}.ID = {right}.ItemID', 'Meeting After Probe Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('A18B3747-A228-4553-ACEC-F1BA7A2D7B01', 'Meeting After - Discipline Referral Change', 'M', 0, '939E4566-F622-4999-BDBB-734A87527675', 'EB34AB3F-1C4F-44EF-A95F-34C75899ED94', 'R' ,'{left}.ID = {right}.ItemID', 'Meeting After Referral Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('F63B8A29-A205-4ECA-AA7D-A3240DB60B4A', 'Meeting After - Attendance Change', 'M', 0, '9FEF182E-4B86-4F42-AB94-D4D646D79B32', 'EB34AB3F-1C4F-44EF-A95F-34C75899ED94', 'R' ,'{left}.ID = {right}.ItemID', 'Meeting After Attendance Change >')

--Update Action To Include Action Before And After------------------------------------------------------------------------------------
UPDATE VC3Reporting.ReportSchemaTable
SET TableExpression =
'(SELECT a.*,
	(SELECT TOP 1 bi.ID
	FROM PrgActivity ba JOIN
		PrgItem bi ON bi.ID = ba.ID JOIN
		PrgItemDef bd ON bd.ID = bi.DefID
	WHERE bi.StudentID = i.StudentID AND
		bi.ID <> i.ID AND
		NOT(bi.StartDate = i.StartDate AND bi.EndDate = i.EndDate) AND
		bi.EndDate IS NOT NULL AND
		bi.EndDate <= i.StartDate
	ORDER BY bi.EndDate DESC,
		CASE
			WHEN bi.DefID = i.DefID THEN 1
			WHEN bd.ProgramID = d.ProgramID THEN 2
			ELSE 3
		END ASC) AS ActionBeforeID,

	(SELECT TOP 1 ai.ID
	FROM PrgActivity aa JOIN
		PrgItem ai ON ai.ID = aa.ID JOIN
		PrgItemDef ad ON ad.ID = ai.DefID
	WHERE ai.StudentID = i.StudentID AND
		ai.ID <> i.ID AND
		NOT(ai.StartDate = i.StartDate AND ai.EndDate = i.EndDate) AND
		i.EndDate IS NOT NULL AND
		ai.StartDate >= i.EndDate
	ORDER BY ai.StartDate ASC,
		CASE
			WHEN ai.DefID = i.DefID THEN 1
			WHEN ad.ProgramID = d.ProgramID THEN 2
			ELSE 3
		END ASC) AS ActionAfterID	
FROM PrgActivity a JOIN 
	PrgItem i ON i.ID = a.ID JOIN
	PrgItemDef d ON d.ID = i.DefID)'
WHERE Id = '03F77763-4633-426B-972F-E10400EE9702'

--Report Type : Action Before
INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('F111DD58-6A93-475B-8595-6A47757B4EB1', 'Action Before', 'T', 0, '03F77763-4633-426B-972F-E10400EE9702', '7B0CA412-6D83-4110-80B4-C08F3738E8A5', 'L', '{left}.ActionBeforeID = {right}.ID', 'Action Before >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('DF2B6906-FEAD-4C46-94AA-C8D2975EA14D', 'Action Before - Item', 'T', 0, 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'F111DD58-6A93-475B-8595-6A47757B4EB1', 'I', '{left}.ID = {right}.ID', 'Action Before >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('28B518EF-E365-4F88-9184-E311E469FD92', 'Action Before - Item Definition', 'T', 0, @prgItemDefSchemaTableID, 'DF2B6906-FEAD-4C46-94AA-C8D2975EA14D', 'I' ,'{left}.DefID = {right}.ID', 'Action Before Defintion >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('D4B664B1-EA11-4B59-965F-E8B8025F736C', 'Action Before - Program', 'T', 0, @programSchemaTableID, '28B518EF-E365-4F88-9184-E311E469FD92', 'I' ,'{left}.ProgramID = {right}.ID', 'Action Before Program >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('426A75E4-E5F9-4A8A-B32C-99799D087AD0', 'Action Before - Probe Score Change', 'T', 0, 'DAA40B4B-9CCD-4497-9DCF-79BD72154151', 'F111DD58-6A93-475B-8595-6A47757B4EB1', 'R' ,'{left}.ID = {right}.ItemID', 'Action Before Probe Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('E170FA71-9C75-4653-B44E-BFB290AEE3FE', 'Action Before - Discipline Referral Change', 'T', 0, '939E4566-F622-4999-BDBB-734A87527675', 'F111DD58-6A93-475B-8595-6A47757B4EB1', 'R' ,'{left}.ID = {right}.ItemID', 'Action Before Referral Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('390E2E7C-CAA7-4F54-B9C3-9FEECFA324FE', 'Action Before - Attendance Change', 'T', 0, '9FEF182E-4B86-4F42-AB94-D4D646D79B32', 'F111DD58-6A93-475B-8595-6A47757B4EB1', 'R' ,'{left}.ID = {right}.ItemID', 'Action Before Attendance Change >')

--Report Type : Action After
INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('C064AAB7-0499-4CCD-8097-076BFE170B57', 'Action After', 'T', 0, '03F77763-4633-426B-972F-E10400EE9702', '7B0CA412-6D83-4110-80B4-C08F3738E8A5', 'L', '{left}.ActionAfterID = {right}.ID', 'Action After >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('5AEDD5F6-B6CC-48F1-ACE1-18E2A6F17379', 'Action After - Item', 'T', 0, 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'C064AAB7-0499-4CCD-8097-076BFE170B57', 'I', '{left}.ID = {right}.ID', 'Action After >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('8790BE99-A6CD-4D9C-BFB1-3626381FD9E4', 'Action After - Item Definition', 'T', 0, @prgItemDefSchemaTableID, '5AEDD5F6-B6CC-48F1-ACE1-18E2A6F17379', 'I' ,'{left}.DefID = {right}.ID', 'Action After Defintion >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('FE22B11D-C0E5-47E9-A676-22A023B616E9', 'Action After - Program', 'T', 0, @programSchemaTableID, '8790BE99-A6CD-4D9C-BFB1-3626381FD9E4', 'I' ,'{left}.ProgramID = {right}.ID', 'Action After Program >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('0FD8A13E-D379-48A8-AF91-C26DAD6EA0B8', 'Action After - Probe Score Change', 'T', 0, 'DAA40B4B-9CCD-4497-9DCF-79BD72154151', 'C064AAB7-0499-4CCD-8097-076BFE170B57', 'R' ,'{left}.ID = {right}.ItemID', 'Action After Probe Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('5E958E75-9D3C-4844-BEEF-902376A7C168', 'Action After - Discipline Referral Change', 'T', 0, '939E4566-F622-4999-BDBB-734A87527675', 'C064AAB7-0499-4CCD-8097-076BFE170B57', 'R' ,'{left}.ID = {right}.ItemID', 'Action After Referral Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('8C8D4080-9A13-4721-BEE6-F6D5CA516C5F', 'Action After - Attendance Change', 'T', 0, '9FEF182E-4B86-4F42-AB94-D4D646D79B32', 'C064AAB7-0499-4CCD-8097-076BFE170B57', 'R' ,'{left}.ID = {right}.ItemID', 'Action After Attendance Change >')
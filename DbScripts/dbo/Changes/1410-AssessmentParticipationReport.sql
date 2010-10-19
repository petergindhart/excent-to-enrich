----IepTestParticipation--------------------------------------------------------------------------------
DECLARE @iepTestParticipationSchemaTableID uniqueidentifier
SET @iepTestParticipationSchemaTableID = '103A026D-248B-4544-973B-2DE904699194'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@iepTestParticipationSchemaTableID, 'Iep Test Participation',
		'(SELECT *
		FROM IepTestParticipation)',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@iepTestParticipationSchemaTableID, NULL)

--Participation
DECLARE @itpParticipationDefIdColumnID uniqueidentifier
SET @itpParticipationDefIdColumnID = 'D92BFFB8-3865-434F-8AFB-704E2015572C'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@itpParticipationDefIdColumnID, 'Participation', @iepTestParticipationSchemaTableID, 'G', '(SELECT Text FROM IepTestParticipationDef WHERE ID={this}.ParticipationDefID)', '{this}.ParticipationDefID', '(SELECT Sequence FROM IepTestParticipationDef WHERE ID={this}.ParticipationDefID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Text AS Name FROM IepTestParticipationDef ORDER BY Sequence, Text', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@itpParticipationDefIdColumnID, NULL)

----IepTestDef------------------------------------------------------------------------------------------
DECLARE @iepTestDefSchemaTableID uniqueidentifier
SET @iepTestDefSchemaTableID = '8F92FD8E-BA4E-42B6-835C-07797A0014B2'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@iepTestDefSchemaTableID, 'Iep Test Def',
		'(SELECT *
		FROM IepTestDef)',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@iepTestDefSchemaTableID, NULL)


--Is State
DECLARE @itdIsStateColumnID uniqueidentifier
SET @itdIsStateColumnID = '493ED64D-808F-4F15-90F8-CA4F8339C80E'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@itdIsStateColumnID, 'State Test?', @iepTestDefSchemaTableID, 'B', '(CASE WHEN {this}.IsState= 1 THEN ''Yes'' ELSE ''No'' END)', '{this}.IsState', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT 1 Id, ''Yes'' Name UNION SELECT 0, ''No'' ORDER BY 1 DESC', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@itdIsStateColumnID, NULL)

--Test Name
DECLARE @itdNameColumnID uniqueidentifier
SET @itdNameColumnID = '5B78855C-66B4-4911-8E1F-F0E87C4A750A'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@itdNameColumnID, 'Test Name', @iepTestDefSchemaTableID, 'T', NULL, '{this}.Name', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@itdNameColumnID, NULL)

----IepTestAccom----------------------------------------------------------------------------------------
DECLARE @iepTestAccomSchemaTableID uniqueidentifier
SET @iepTestAccomSchemaTableID = '1826750F-6182-4F36-92C6-F0F39025798B'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@iepTestAccomSchemaTableID, 'Iep Test Accom',
		'(SELECT *
		FROM IepTestAccom)',
		'ParticipationID, DefID')

INSERT INTO ReportSchemaTable
VALUES (@iepTestAccomSchemaTableID, NULL)

----IepTestAccomDef-------------------------------------------------------------------------------------
DECLARE @iepTestAccomDefSchemaTableID uniqueidentifier
SET @iepTestAccomDefSchemaTableID = '38743A79-EAB4-4665-884C-70207AE1E639'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@iepTestAccomDefSchemaTableID, 'Iep Test Accom Def',
		'(SELECT *
		FROM IepTestAccomDef)',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@iepTestAccomDefSchemaTableID, NULL)


--Category
DECLARE @itadCategoryIdColumnID uniqueidentifier
SET @itadCategoryIdColumnID = '07F42F7A-FFCC-48AE-865E-714B15800B4C'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@itadCategoryIdColumnID, 'Category', @iepTestAccomDefSchemaTableID, 'G', '(SELECT Name FROM IepTestAccomCategory WHERE ID={this}.CategoryID)', '{this}.CategoryID', '(SELECT Name FROM IepTestAccomCategory WHERE ID={this}.CategoryID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Name AS Name FROM IepTestAccomCategory ORDER BY Name', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@itadCategoryIdColumnID, NULL)

--Is Standard
DECLARE @itadIsStandardColumnID uniqueidentifier
SET @itadIsStandardColumnID = '81166ED1-C353-47BD-92B6-B4B4214C22DC'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@itadIsStandardColumnID, 'Standard?', @iepTestAccomDefSchemaTableID, 'B', '(CASE WHEN {this}.IsStandard= 1 THEN ''Yes'' ELSE ''No'' END)', '{this}.IsStandard', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT 1 Id, ''Yes'' Name UNION SELECT 0, ''No'' ORDER BY 1 DESC', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@itadIsStandardColumnID, NULL)

--Text
DECLARE @itadTextColumnID uniqueidentifier
SET @itadTextColumnID = '6C2AEFDA-A626-48FC-95C0-8874EC027CB5'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@itadTextColumnID, 'Description', @iepTestAccomDefSchemaTableID, 'T', NULL, '{this}.Text', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@itadTextColumnID, NULL)

--Assessment Participation ReportType
DECLARE @reportTypeID varchar
SET @reportTypeID = 'I'

INSERT INTO VC3Reporting.ReportType
VALUES (@reportTypeId,'Assessment Participation', 1, 'List of students and accommodations for an assessment as specified in the Assessments Participantion section.')

INSERT INTO ReportType
VALUES (@reportTypeId, 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4', 'Assessment Participation', 'ReportIcon_Student.gif', 0, 6, NULL, '426D5613-B398-4556-BF3F-765040E5617F') --SpecEd Only

INSERT INTO VC3Reporting.ReportTypeFormat
VALUES (@reportTypeID, 'X', 0)

INSERT INTO ReportAreaReportType
VALUES ('808D7789-2B13-4A82-992B-C949D68EB1D1', @reportTypeId) --Special Education

--Report Type Tables
DECLARE @itemSchemaTableID uniqueidentifier
SET @itemSchemaTableID = 'CA58AA53-C0AB-4326-AA35-6D74695596A7'

DECLARE @studentSchemaTableID uniqueidentifier
SET @studentSchemaTableID = 'F210EF27-1FBA-4518-B3F3-41DD8AFB4615'

DECLARE @prgSectionSchemaTableID uniqueidentifier
SET @prgSectionSchemaTableID = 'B348B796-FE8A-45B8-99EC-6F1D8F4034E6'

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('A0253EB7-3165-4CD9-910B-68338A935759', 'Assessment Participation', @reportTypeID, 0, @iepTestParticipationSchemaTableID, NULL, NULL, NULL, 'Assessment Participation >', 0)

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('0F5D0002-5D9F-4074-9B06-89A020C7F9C1', 'Assessment Participation Section', @reportTypeID, 0, @prgSectionSchemaTableID, 'A0253EB7-3165-4CD9-910B-68338A935759', 'I' ,'{left}.InstanceID = {right}.ID', 'Assessment Participation >', 1)

		INSERT INTO VC3Reporting.ReportTypeTable
		VALUES ('DCF1802E-3157-424E-B419-7E6C7CB8826C', 'Associated Item', @reportTypeID, 0, @itemSchemaTableID, '0F5D0002-5D9F-4074-9B06-89A020C7F9C1', 'I' ,'{left}.ItemID = {right}.ID', 'Associated Item >', 0)

			INSERT INTO VC3Reporting.ReportTypeTable
			VALUES ('98A98CBB-616C-4D78-B702-172375990AC6', 'Student', @reportTypeID, 0, @studentSchemaTableID, 'DCF1802E-3157-424E-B419-7E6C7CB8826C', 'I', '{left}.StudentID = {right}.ID', 'Student >', 0)

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('7B73CC53-9AEA-44E4-9A37-DC0848A1F119', 'Test', @reportTypeID, 0, @iepTestDefSchemaTableID, 'A0253EB7-3165-4CD9-910B-68338A935759', 'I' ,'{left}.TestDefID = {right}.ID', 'Test >', 1)

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('39C8E218-32D7-4EC7-9D88-25EDAD6F2365', 'Accomodation', @reportTypeID, 0, @iepTestAccomSchemaTableID, 'A0253EB7-3165-4CD9-910B-68338A935759', 'Z' ,'{left}.ID = {right}.ParticipationID', 'Accomodation >', 0)

		--NOTE: If the parent is a Zero to Many or just allows Zero then child relations must also allow for zero per standard SQL convention
		INSERT INTO VC3Reporting.ReportTypeTable
		VALUES ('48AFE5CC-A983-4858-AC83-9A244026637E', 'Accomodation', @reportTypeID, 0, @iepTestAccomDefSchemaTableID, '39C8E218-32D7-4EC7-9D88-25EDAD6F2365', 'L' ,'{left}.DefID = {right}.ID', 'Accomodation >', 1)
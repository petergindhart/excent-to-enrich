--ReportTimePoint
CREATE TABLE dbo.ReportTimePoint
(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL,
	Value int
)
GO
ALTER TABLE dbo.ReportTimePoint ADD CONSTRAINT
	PK_ReportTimePeriod PRIMARY KEY CLUSTERED
	(
	ID
	)
GO

INSERT INTO ReportTimePoint VALUES ('E5BF3494-3A29-4C56-96A9-C2EA81BCBB70', 'Item Start', 0)
INSERT INTO ReportTimePoint VALUES ('0DE15C03-E6F7-46C1-AFED-9BD9276EEBB1', 'Day 7 After Item Start', 7)
INSERT INTO ReportTimePoint VALUES ('8BDF1376-D2CE-456B-917F-57D1419224A3', 'Day 14 After Item Start', 14)
INSERT INTO ReportTimePoint VALUES ('06BC39F9-2F04-4740-BEAE-3AADF43156DB', 'Day 30 After Item Start', 30)
INSERT INTO ReportTimePoint VALUES ('66989CF7-A6D6-481F-85DB-AEE903FBCC76', 'Day 45 After Item Start', 45)
INSERT INTO ReportTimePoint VALUES ('A607AFEE-F500-4E8A-BF71-C35003A39781', 'Day 60 After Item Start', 60)
INSERT INTO ReportTimePoint VALUES ('9961B55E-56D4-448C-A18C-C381F6EDF387', 'Day 90 After Item Start', 90)
INSERT INTO ReportTimePoint VALUES ('E9EF6AC7-E839-464E-9044-A658E9B2D12B', 'Item End', NULL)

--Context
DECLARE @studentContextID uniqueidentifier
SET @studentContextID = 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4'

--Student ReportType
DECLARE @reportTypeID varchar
SET @reportTypeID = 'I'

INSERT INTO VC3Reporting.ReportType
VALUES (@reportTypeID, 'Item Summary', 1)

INSERT INTO ReportType
VALUES (@reportTypeID, @studentContextID, 'Item Summary', NULL, NULL, 0, 4, NULL)

INSERT INTO VC3Reporting.ReportTypeFormat
VALUES (@reportTypeID, 'X', 0)

----PrgItem_ProbeScoreChange----------------------------------------------------------------------------
DECLARE @prgItem_ProbeScoreChangeSchemaTableID uniqueidentifier
SET @prgItem_ProbeScoreChangeSchemaTableID = 'DAA40B4B-9CCD-4497-9DCF-79BD72154151'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@prgItem_ProbeScoreChangeSchemaTableID, 'Probe Score Change',
		'(SELECT *
		FROM PrgItem_ProbeScoreChange({Start Point}, {End Point}, {Probe Type}))',
		NULL)

INSERT INTO ReportSchemaTable
VALUES (@prgItem_ProbeScoreChangeSchemaTableID, NULL)

--Change
DECLARE @pscChangeColumnID uniqueidentifier
SET @pscChangeColumnID = '02ED4330-904E-413E-8A34-69A5D3DC8DC2'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscChangeColumnID, 'Change', @prgItem_ProbeScoreChangeSchemaTableID, 'N', NULL, 'Change', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscChangeColumnID, NULL)

--ChangePercent
DECLARE @pscChangePercentColumnID uniqueidentifier
SET @pscChangePercentColumnID = '18175243-AE95-468A-9460-31BA1826E8E6'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscChangePercentColumnID, 'Change (%)', @prgItem_ProbeScoreChangeSchemaTableID, 'N', NULL, 'ChangePercent', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscChangePercentColumnID, NULL)

--ChangePerDay
DECLARE @pscChangePerDayColumnID uniqueidentifier
SET @pscChangePerDayColumnID = '1B53D3CC-7CD8-459F-87C2-3BC829327C9D'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscChangePerDayColumnID, 'Change Per Day', @prgItem_ProbeScoreChangeSchemaTableID, 'N', NULL, 'ChangePerDay', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscChangePerDayColumnID, NULL)

--ChangePerDayPercent
DECLARE @pscChangePerDayPercentColumnID uniqueidentifier
SET @pscChangePerDayPercentColumnID = '1386A8FE-A69E-4AA0-960E-05F1F49564D0'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscChangePerDayPercentColumnID, 'Change Per Day (%)', @prgItem_ProbeScoreChangeSchemaTableID, 'N', NULL, 'ChangePerDayPercent', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscChangePerDayPercentColumnID, NULL)

--ChangePerWeek
DECLARE @pscChangePerWeekColumnID uniqueidentifier
SET @pscChangePerWeekColumnID = '3F4560C5-5F7D-4B1E-9921-BC11999E5FF4'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscChangePerWeekColumnID, 'Change Per Week', @prgItem_ProbeScoreChangeSchemaTableID, 'N', NULL, 'ChangePerWeek', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscChangePerWeekColumnID, NULL)

--ChangePerWeekPercent
DECLARE @pscChangePerWeekPercentColumnID uniqueidentifier
SET @pscChangePerWeekPercentColumnID = '472337EE-9CA5-4D6E-A7F5-1166DBB3072E'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscChangePerWeekPercentColumnID, 'Change Per Week (%)', @prgItem_ProbeScoreChangeSchemaTableID, 'N', NULL, 'ChangePerWeekPercent', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscChangePerWeekPercentColumnID, NULL)

--DaysBetweenEndPointAndScore
DECLARE @pscDaysBetweenEndPointAndScoreColumnID uniqueidentifier
SET @pscDaysBetweenEndPointAndScoreColumnID = 'F0EB62D3-353B-4913-9915-075E16A173A0'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscDaysBetweenEndPointAndScoreColumnID, 'Days Between End Point And Score', @prgItem_ProbeScoreChangeSchemaTableID, 'I', NULL, 'DaysBetweenEndPointAndScore', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscDaysBetweenEndPointAndScoreColumnID, NULL)

--DaysBetweenScores
DECLARE @pscDaysBetweenScoresColumnID uniqueidentifier
SET @pscDaysBetweenScoresColumnID = '273E1851-DDD8-418B-8546-75B64A188F6A'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscDaysBetweenScoresColumnID, 'Days Between Scores', @prgItem_ProbeScoreChangeSchemaTableID, 'I', NULL, 'DaysBetweenScores', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscDaysBetweenScoresColumnID, NULL)

--DaysBetweenStartPointAndScore
DECLARE @pscDaysBetweenStartPointAndScoreColumnID uniqueidentifier
SET @pscDaysBetweenStartPointAndScoreColumnID = 'FCFEB781-C10A-4B74-984F-DEF7DA2C6958'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscDaysBetweenStartPointAndScoreColumnID, 'Days Between Start Point And Score', @prgItem_ProbeScoreChangeSchemaTableID, 'I', NULL, 'DaysBetweenStartPointAndScore', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscDaysBetweenStartPointAndScoreColumnID, NULL)

--EndDateOfTimeRange
DECLARE @pscEndDateOfTimeRangeColumnID uniqueidentifier
SET @pscEndDateOfTimeRangeColumnID = '2D53A9AF-FD6C-43F0-8A0B-2E22483AB551'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscEndDateOfTimeRangeColumnID, 'End Date Of Time Range', @prgItem_ProbeScoreChangeSchemaTableID, 'D', NULL, 'EndDateOfTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscEndDateOfTimeRangeColumnID, NULL)

--EndPointID
DECLARE @pscEndPointIdColumnID uniqueidentifier
SET @pscEndPointIdColumnID = 'E501CC06-C914-4F04-A101-57D464F51A61'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscEndPointIdColumnID, 'End Point', @prgItem_ProbeScoreChangeSchemaTableID, 'G', '(SELECT Name FROM ReportTimePoint WHERE ID={this}.EndPointId)', 'EndPointId', NULL, NULL, NULL, 0, 1, 1, 1, 1, 0, 'SELECT ID, Name FROM ReportTimePoint ORDER BY CASE WHEN Value IS NULL THEN (SELECT MAX(VALUE) FROM ReportTimePoint) ELSE Value END', 0, NULL)

INSERT INTO VC3Reporting.ReportSchemaTableParameter
VALUES ('7907EE07-B089-4D56-B5FB-365AC0C6BD3F', 'End Point', @prgItem_ProbeScoreChangeSchemaTableID, @pscEndPointIdColumnID, '41BA0544-6400-4E61-B1DD-378743A7D145', 1,2)

INSERT INTO ReportSchemaColumn
VALUES (@pscEndPointIdColumnID, NULL)

--EndScore
DECLARE @pscEndScoreColumnID uniqueidentifier
SET @pscEndScoreColumnID = '0A672180-8E1D-40F9-9BC2-7AC74BA005E7'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscEndScoreColumnID, 'End Score', @prgItem_ProbeScoreChangeSchemaTableID, 'T', NULL, 'EndScore', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscEndScoreColumnID, NULL)

--EndScoreDate
DECLARE @pscEndScoreDateColumnID uniqueidentifier
SET @pscEndScoreDateColumnID = '23AB9CA7-0FA1-43E4-9C0B-C7BA54A5ACFA'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscEndScoreDateColumnID, 'End Score Date', @prgItem_ProbeScoreChangeSchemaTableID, 'D', NULL, 'EndScoreDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscEndScoreDateColumnID, NULL)

--EndScoreValue
DECLARE @pscEndScoreValueColumnID uniqueidentifier
SET @pscEndScoreValueColumnID = '0005FB5C-53F4-4B8B-9B50-3028006202EE'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscEndScoreValueColumnID, 'End Score Value', @prgItem_ProbeScoreChangeSchemaTableID, 'N', NULL, 'EndScoreValue', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscEndScoreValueColumnID, NULL)

--ProbeTypeID
DECLARE @pscProbeTypeIdColumnID uniqueidentifier
SET @pscProbeTypeIdColumnID = '3830983D-42A3-4729-8463-55A608895A55'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscProbeTypeIdColumnID, 'Probe Type', @prgItem_ProbeScoreChangeSchemaTableID, 'G', '(SELECT Name FROM ProbeType WHERE ID={this}.ProbeTypeID)', 'ProbeTypeID', NULL, NULL, NULL, 0, 1, 1, 1, 1, 0, 'SELECT ID, Name FROM ProbeType ORDER BY Name', 0, NULL)

INSERT INTO VC3Reporting.ReportSchemaTableParameter
VALUES ('73048B89-0AA2-47A7-97D4-3CA86D87AC33', 'Probe Type', @prgItem_ProbeScoreChangeSchemaTableID, @pscProbeTypeIdColumnID, '41BA0544-6400-4E61-B1DD-378743A7D145', 1,3)

INSERT INTO ReportSchemaColumn
VALUES (@pscProbeTypeIdColumnID, NULL)

--ScoreIncreaseIsBetter
DECLARE @pscScoreIncreaseIsBetterColumnID uniqueidentifier
SET @pscScoreIncreaseIsBetterColumnID = 'DF9ABDBB-41F3-474F-9652-89DCAAA91068'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscScoreIncreaseIsBetterColumnID, 'Score Increase Is Better', @prgItem_ProbeScoreChangeSchemaTableID, 'B', '(CASE WHEN {this}.ScoreIncreaseIsBetter= 1 THEN ''Yes'' ELSE ''No'' END)', 'ScoreIncreaseIsBetter', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT 1 Id, ''Yes'' Name UNION SELECT 0, ''No'' ORDER BY 1 DESC', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscScoreIncreaseIsBetterColumnID, NULL)

--StartDateOfTimeRange
DECLARE @pscStartDateOfTimeRangeColumnID uniqueidentifier
SET @pscStartDateOfTimeRangeColumnID = '5B0A1902-6010-43F5-8FAC-BE511614EE17'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscStartDateOfTimeRangeColumnID, 'Start Date Of Time Range', @prgItem_ProbeScoreChangeSchemaTableID, 'D', NULL, 'StartDateOfTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscStartDateOfTimeRangeColumnID, NULL)

--StartPointID
DECLARE @pscStartPointIdColumnID uniqueidentifier
SET @pscStartPointIdColumnID = '7812270E-6B96-43F6-B758-D7F2AA00E35B'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscStartPointIdColumnID, 'Start Point', @prgItem_ProbeScoreChangeSchemaTableID, 'G', '(SELECT Name FROM ReportTimePoint WHERE ID={this}.StartPointID)', 'StartPointID', NULL, NULL, NULL, 0, 1, 1, 1, 1, 0, 'SELECT ID, Name FROM ReportTimePoint ORDER BY CASE WHEN Value IS NULL THEN (SELECT MAX(VALUE) FROM ReportTimePoint) ELSE Value END', 0, NULL)

INSERT INTO VC3Reporting.ReportSchemaTableParameter
VALUES ('CBC3487A-5092-461C-AB62-DEB6033BA0E4', 'Start Point', @prgItem_ProbeScoreChangeSchemaTableID, @pscStartPointIdColumnID, '41BA0544-6400-4E61-B1DD-378743A7D145', 1,1)

INSERT INTO ReportSchemaColumn
VALUES (@pscStartPointIdColumnID, NULL)

--StartScore
DECLARE @pscStartScoreColumnID uniqueidentifier
SET @pscStartScoreColumnID = '35685CE7-ED5C-4A1E-A086-1654CA83DE65'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscStartScoreColumnID, 'Start Score', @prgItem_ProbeScoreChangeSchemaTableID, 'T', NULL, 'StartScore', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscStartScoreColumnID, NULL)

--StartScoreDate
DECLARE @pscStartScoreDateColumnID uniqueidentifier
SET @pscStartScoreDateColumnID = '3F0A5AF8-B245-4951-8F39-C57617F6FBC0'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscStartScoreDateColumnID, 'Start Score Date', @prgItem_ProbeScoreChangeSchemaTableID, 'D', NULL, 'StartScoreDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscStartScoreDateColumnID, NULL)

--StartScoreValue
DECLARE @pscStartScoreValueColumnID uniqueidentifier
SET @pscStartScoreValueColumnID = '9C0EEE48-F570-42E2-8F6A-1D9AB4433296'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscStartScoreValueColumnID, 'Start Score Value', @prgItem_ProbeScoreChangeSchemaTableID, 'N', NULL, 'StartScoreValue', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscStartScoreValueColumnID, NULL)

--WeeksBetweenScores
DECLARE @pscWeeksBetweenScoresColumnID uniqueidentifier
SET @pscWeeksBetweenScoresColumnID = 'F4DC3BD2-461F-4C53-9410-8C18880B6385'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pscWeeksBetweenScoresColumnID, 'Weeks Between Scores', @prgItem_ProbeScoreChangeSchemaTableID, 'N', NULL, 'WeeksBetweenScores', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pscWeeksBetweenScoresColumnID, NULL)

----PrgItem--------------------------------------------
DECLARE @prgItemSchemaTableID uniqueidentifier
SET @prgItemSchemaTableID = 'CA58AA53-C0AB-4326-AA35-6D74695596A7'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES ('CA58AA53-C0AB-4326-AA35-6D74695596A7', 'Program Item', 
	'(SELECT *
	FROM PrgItem i)', 
	'ID')

INSERT INTO ReportSchemaTable
VALUES ('CA58AA53-C0AB-4326-AA35-6D74695596A7', NULL)

--DefID
INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('D3DF497E-E9BB-4860-A6D2-D19049BCECC6', 'Definition', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'G', '(SELECT Name FROM PrgItemDef WHERE ID={this}.DefID)', 'DefID', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Name AS Name FROM PrgItemDef ORDER BY Name', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES ('D3DF497E-E9BB-4860-A6D2-D19049BCECC6', NULL)

--StartDate
INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('6DB3E68B-ECD0-4102-9782-52F5267A8E51', 'Start Date', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'D', NULL, 'StartDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES ('6DB3E68B-ECD0-4102-9782-52F5267A8E51', NULL)

--EndDate
INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('92FD154C-93A0-497B-BA69-2822AD9AE051', 'End Date', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'D', NULL, 'EndDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES ('92FD154C-93A0-497B-BA69-2822AD9AE051', NULL)

--ItemOutcomeID
INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('8D007416-D37C-4F07-9893-154C31ADE2E4', 'Item Outcome', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'G', '(SELECT Text FROM PrgItemOutcome WHERE ID = {this}.ItemOutcomeID)', 'ItemOutcomeID', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Text AS Name FROM PrgItemOutcome ORDER BY Text', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES ('8D007416-D37C-4F07-9893-154C31ADE2E4', NULL)

--CreatedDate
INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('3970AC88-FFC7-45F7-9E41-F6344870C346', 'Created Date', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'D', NULL, 'CreatedDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES ('3970AC88-FFC7-45F7-9E41-F6344870C346', NULL)

--CreatedBy
INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('92046546-8A7F-4AB0-8FF8-1FA060BAB2BD', 'Created By', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'G', '(SELECT p.LastName + '', '' + p.FirstName FROM UserProfile u JOIN Person p ON u.ID = p.ID WHERE u.ID = {this}.CreatedBy)', 'CreatedBy', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT DISTINCT u.ID, p.LastName + '', '' + p.FirstName AS Name FROM PrgItem i JOIN UserProfile u ON u.ID = i.CreatedBy JOIN Person p ON u.ID = p.ID ORDER BY Name', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES ('92046546-8A7F-4AB0-8FF8-1FA060BAB2BD', NULL)

--EndedDate
INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('BAF46F47-9BF5-4565-831C-A70A7517D386', 'Ended Date', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'D', NULL, 'EndedDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES ('BAF46F47-9BF5-4565-831C-A70A7517D386', NULL)

--EndedBy
INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('F726A485-B97B-402C-9868-1DF19D05BAAC', 'Ended By', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'G', '(SELECT p.LastName + '', '' + p.FirstName FROM UserProfile u JOIN Person p ON u.ID = p.ID WHERE u.ID = {this}.EndedBy)', 'EndedBy', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT DISTINCT u.ID, p.LastName + '', '' + p.FirstName AS Name FROM PrgItem i JOIN UserProfile u ON u.ID = i.EndedBy JOIN Person p ON u.ID = p.ID ORDER BY Name', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES ('F726A485-B97B-402C-9868-1DF19D05BAAC', NULL)

--SchoolID
INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('0F35373C-3561-49B5-A0D9-EA5C9A1B1218', 'School', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'G', '(SELECT Name FROM School WHERE ID={this}.SchoolID)', 'SchoolID', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '(SELECT ID, Name AS Name FROM School)', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES ('0F35373C-3561-49B5-A0D9-EA5C9A1B1218', NULL)

--GradeLevelID
INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('B8B29473-8A6D-4BEB-95AE-0EA1309725B2', 'Grade Level', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'G', '(SELECT ''Grade '' + Name FROM GradeLevel WHERE ID={this}.GradeLevelID)', 'GradeLevelID', '(SELECT Sequence FROM GradeLevel WHERE ID={this}.GradeLevelID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, ''Grade '' + Name AS Name FROM GradeLevel ORDER BY Name', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES ('B8B29473-8A6D-4BEB-95AE-0EA1309725B2', NULL)

--StartStatusID
INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('D86E1C6F-18D5-43BB-89FA-5E1628478A56', 'Start Status', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'G', '(SELECT Name FROM PrgStatus WHERE ID={this}.StartStatusID)', 'StartStatusID', '(SELECT Sequence FROM PrgStatus WHERE ID={this}.StartStatusID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Name AS Name FROM PrgStatus ORDER BY Name', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES ('D86E1C6F-18D5-43BB-89FA-5E1628478A56', NULL)

--EndStatusID
INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('B514752C-8B92-4813-854B-061D812CF1C7', 'End Status', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'G', '(SELECT Name FROM PrgStatus WHERE ID={this}.EndStatusID)', 'EndStatusID', '(SELECT Sequence FROM PrgStatus WHERE ID={this}.EndStatusID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Name AS Name FROM PrgStatus ORDER BY Name', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES ('B514752C-8B92-4813-854B-061D812CF1C7', NULL)

--PlannedEndDate
INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('52478A33-6A2A-4E0E-A172-11AB1F927142', 'Planned End Date', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'D', NULL, 'PlannedEndDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES ('52478A33-6A2A-4E0E-A172-11AB1F927142', NULL)

----PrgItem_DisciplineReferralChange--------------------------------------------------------------------
DECLARE @prgItem_DisciplineReferralChangeSchemaTableID uniqueidentifier
SET @prgItem_DisciplineReferralChangeSchemaTableID = '939E4566-F622-4999-BDBB-734A87527675'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@prgItem_DisciplineReferralChangeSchemaTableID, 'Discipline Referral Change',
		'(SELECT *
		FROM PrgItem_DisciplineReferralChange({Start Point}, {End Point}, {Days Surrounding Time Range}, {Disposition}))',
		NULL)

INSERT INTO ReportSchemaTable
VALUES (@prgItem_DisciplineReferralChangeSchemaTableID, NULL)

--Change
DECLARE @drcChangeColumnID uniqueidentifier
SET @drcChangeColumnID = 'DA8B78FE-C3D4-4AD0-8090-C4CC647F1F29'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcChangeColumnID, 'Change', @prgItem_DisciplineReferralChangeSchemaTableID, 'I', NULL, 'Change', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcChangeColumnID, NULL)

--ChangePercent
DECLARE @drcChangePercentColumnID uniqueidentifier
SET @drcChangePercentColumnID = '0092C898-9275-48A8-B9E6-428F24DB6F36'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcChangePercentColumnID, 'Change (%)', @prgItem_DisciplineReferralChangeSchemaTableID, 'N', NULL, 'ChangePercent', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcChangePercentColumnID, NULL)

--ChangePerDay
DECLARE @drcChangePerDayColumnID uniqueidentifier
SET @drcChangePerDayColumnID = '9D914A56-E11E-4A9A-872A-E469B37E98D3'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcChangePerDayColumnID, 'Change Per Day', @prgItem_DisciplineReferralChangeSchemaTableID, 'N', NULL, 'ChangePerDay', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcChangePerDayColumnID, NULL)

--ChangePerDayPercent
DECLARE @drcChangePerDayPercentColumnID uniqueidentifier
SET @drcChangePerDayPercentColumnID = '956F2918-ED5A-46F6-B533-F80AA64083AC'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcChangePerDayPercentColumnID, 'Change Per Day (%)', @prgItem_DisciplineReferralChangeSchemaTableID, 'N', NULL, 'ChangePerDayPercent', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcChangePerDayPercentColumnID, NULL)

--ChangePerWeek
DECLARE @drcChangePerWeekColumnID uniqueidentifier
SET @drcChangePerWeekColumnID = '25505AC6-2779-4788-B7D0-691EC271BFDA'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcChangePerWeekColumnID, 'Change Per Week', @prgItem_DisciplineReferralChangeSchemaTableID, 'N', NULL, 'ChangePerWeek', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcChangePerWeekColumnID, NULL)

--ChangePerWeekPercent
DECLARE @drcChangePerWeekPercentColumnID uniqueidentifier
SET @drcChangePerWeekPercentColumnID = 'C9BDF5D0-A316-4DF0-91C4-9ED61DD9429D'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcChangePerWeekPercentColumnID, 'Change Per Week (%)', @prgItem_DisciplineReferralChangeSchemaTableID, 'N', NULL, 'ChangePerWeekPercent', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcChangePerWeekPercentColumnID, NULL)

--DaysInTimeRange
DECLARE @drcDaysInTimeRangeColumnID uniqueidentifier
SET @drcDaysInTimeRangeColumnID = 'A73CB7DB-30FF-4C46-BCC9-098388D08482'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcDaysInTimeRangeColumnID, 'Days In Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'N', NULL, 'DaysInTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcDaysInTimeRangeColumnID, NULL)

--DaysSurroundingTimeRange
DECLARE @drcDaysSurroundingTimeRangeColumnID uniqueidentifier
SET @drcDaysSurroundingTimeRangeColumnID = 'D75CCAA2-F75E-4B84-A393-46586D7BF564'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcDaysSurroundingTimeRangeColumnID, 'Days Surrounding Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'I', NULL, 'DaysSurroundingTimeRange', NULL, NULL, NULL, 0, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO VC3Reporting.ReportSchemaTableParameter
VALUES ('79AFC59A-C42D-489A-9664-FFE4BB08854B', 'Days Surrounding Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, @drcDaysSurroundingTimeRangeColumnID, '41BA0544-6400-4E61-B1DD-378743A7D145', 1,3)

INSERT INTO ReportSchemaColumn
VALUES (@drcDaysSurroundingTimeRangeColumnID, NULL)

--DispositionID
DECLARE @drcDispositionIdColumnID uniqueidentifier
SET @drcDispositionIdColumnID = '472298AD-3468-4465-BF0C-4E4B3E72C528'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcDispositionIdColumnID, 'Disposition', @prgItem_DisciplineReferralChangeSchemaTableID, 'G', '(SELECT DisplayValue FROM EnumValue WHERE ID={this}.DispositionID)', 'DispositionID', NULL, NULL, NULL, 0, 1, 1, 1, 1, 0, 'SELECT ID, DisplayValue AS Name FROM EnumValue WHERE Type = ''0870E284-3909-4817-BE7E-9D9C98DC6F07'' ORDER BY Name', 0, NULL)

INSERT INTO VC3Reporting.ReportSchemaTableParameter
VALUES ('B735D516-111D-4180-9919-9A9458FA4A5E', 'Disposition', @prgItem_DisciplineReferralChangeSchemaTableID, @drcDispositionIdColumnID, '41BA0544-6400-4E61-B1DD-378743A7D145', 0,4)

INSERT INTO ReportSchemaColumn
VALUES (@drcDispositionIdColumnID, NULL)

--EndDateOfTimeRange
DECLARE @drcEndDateOfTimeRangeColumnID uniqueidentifier
SET @drcEndDateOfTimeRangeColumnID = '0EA44D3D-D8B8-41F1-8694-7654BCA7F5C3'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcEndDateOfTimeRangeColumnID, 'End Date Of Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'D', NULL, 'EndDateOfTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcEndDateOfTimeRangeColumnID, NULL)

--EndPointId
DECLARE @drcEndPointIdColumnID uniqueidentifier
SET @drcEndPointIdColumnID = 'A705019D-AAF1-4801-BEF0-92591739CD21'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcEndPointIdColumnID, 'End Point', @prgItem_DisciplineReferralChangeSchemaTableID, 'G', '(SELECT Name FROM ReportTimePoint WHERE ID={this}.EndPointId)', 'EndPointId', NULL, NULL, NULL, 0, 1, 1, 1, 1, 0, 'SELECT ID, Name FROM ReportTimePoint ORDER BY CASE WHEN Value IS NULL THEN (SELECT MAX(VALUE) FROM ReportTimePoint) ELSE Value END', 0, NULL)

INSERT INTO VC3Reporting.ReportSchemaTableParameter
VALUES ('062F2742-5E3A-49AE-A1E6-04600A622BC7', 'End Point', @prgItem_DisciplineReferralChangeSchemaTableID, @drcEndPointIdColumnID, '41BA0544-6400-4E61-B1DD-378743A7D145', 1,2)

INSERT INTO ReportSchemaColumn
VALUES (@drcEndPointIdColumnID, NULL)

--ReferralsAfterTimeRange
DECLARE @drcReferralsAfterTimeRangeColumnID uniqueidentifier
SET @drcReferralsAfterTimeRangeColumnID = 'EEBD9651-2555-46FD-B4D6-55197DAC975E'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcReferralsAfterTimeRangeColumnID, 'Referrals After Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'I', NULL, 'ReferralsAfterTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcReferralsAfterTimeRangeColumnID, NULL)

--ReferralsBeforeTimeRange
DECLARE @drcReferralsBeforeTimeRangeColumnID uniqueidentifier
SET @drcReferralsBeforeTimeRangeColumnID = 'A4773CE4-3AC2-4BBA-94E5-021B46F33C9B'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcReferralsBeforeTimeRangeColumnID, 'Referrals Before Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'I', NULL, 'ReferralsBeforeTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcReferralsBeforeTimeRangeColumnID, NULL)

--ReferralsInTimeRange
DECLARE @drcReferralsInTimeRangeColumnID uniqueidentifier
SET @drcReferralsInTimeRangeColumnID = '57EB4E06-0284-406E-AF9B-14A6085B7599'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcReferralsInTimeRangeColumnID, 'Referrals In Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'I', NULL, 'ReferralsInTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcReferralsInTimeRangeColumnID, NULL)

--ReferralsPerDayAfterTimeRange
DECLARE @drcReferralsPerDayAfterTimeRangeColumnID uniqueidentifier
SET @drcReferralsPerDayAfterTimeRangeColumnID = 'F8D6F23B-A31D-429D-A192-0090C9294315'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcReferralsPerDayAfterTimeRangeColumnID, 'Referrals Per Day After Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'N', NULL, 'ReferralsPerDayAfterTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcReferralsPerDayAfterTimeRangeColumnID, NULL)

--ReferralsPerDayBeforeTimeRange
DECLARE @drcReferralsPerDayBeforeTimeRangeColumnID uniqueidentifier
SET @drcReferralsPerDayBeforeTimeRangeColumnID = '0F2C0787-7A02-4B25-B9BE-CC7B86EF9936'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcReferralsPerDayBeforeTimeRangeColumnID, 'Referrals Per Day Before Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'N', NULL, 'ReferralsPerDayBeforeTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcReferralsPerDayBeforeTimeRangeColumnID, NULL)

--ReferralsPerDayInTimeRange
DECLARE @drcReferralsPerDayInTimeRangeColumnID uniqueidentifier
SET @drcReferralsPerDayInTimeRangeColumnID = 'F53D5570-0164-47DA-A9ED-1F5302FD16FB'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcReferralsPerDayInTimeRangeColumnID, 'Referrals Per Day In Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'N', NULL, 'ReferralsPerDayInTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcReferralsPerDayInTimeRangeColumnID, NULL)

--ReferralsPerWeekAfterTimeRange
DECLARE @drcReferralsPerWeekAfterTimeRangeColumnID uniqueidentifier
SET @drcReferralsPerWeekAfterTimeRangeColumnID = 'F9FD966E-4D63-417E-B81B-70703FB79B0A'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcReferralsPerWeekAfterTimeRangeColumnID, 'Referrals Per Week After Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'N', NULL, 'ReferralsPerWeekAfterTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcReferralsPerWeekAfterTimeRangeColumnID, NULL)

--ReferralsPerWeekBeforeTimeRange
DECLARE @drcReferralsPerWeekBeforeTimeRangeColumnID uniqueidentifier
SET @drcReferralsPerWeekBeforeTimeRangeColumnID = 'B81487DD-BB5B-49BB-9832-3DA46C8F7007'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcReferralsPerWeekBeforeTimeRangeColumnID, 'Referrals Per Week Before Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'N', NULL, 'ReferralsPerWeekBeforeTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcReferralsPerWeekBeforeTimeRangeColumnID, NULL)

--ReferralsPerWeekInTimeRange
DECLARE @drcReferralsPerWeekInTimeRangeColumnID uniqueidentifier
SET @drcReferralsPerWeekInTimeRangeColumnID = '6D4D6418-54A2-41C4-B3C7-A6206D63549C'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcReferralsPerWeekInTimeRangeColumnID, 'Referrals Per Week In Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'N', NULL, 'ReferralsPerWeekInTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcReferralsPerWeekInTimeRangeColumnID, NULL)

--StartDateOfTimeRange
DECLARE @drcStartDateOfTimeRangeColumnID uniqueidentifier
SET @drcStartDateOfTimeRangeColumnID = '4A0D740C-E02D-42D9-B68F-DD65D2574781'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcStartDateOfTimeRangeColumnID, 'Start Date Of Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'D', NULL, 'StartDateOfTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcStartDateOfTimeRangeColumnID, NULL)

--StartPointID
DECLARE @drcStartPointIdColumnID uniqueidentifier
SET @drcStartPointIdColumnID = 'C2093218-9389-4441-A569-717DE294EC50'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcStartPointIdColumnID, 'Start Point', @prgItem_DisciplineReferralChangeSchemaTableID, 'G', '(SELECT Name FROM ReportTimePoint WHERE ID={this}.StartPointID)', 'StartPointID', NULL, NULL, NULL, 0, 1, 1, 1, 1, 0, 'SELECT ID, Name FROM ReportTimePoint ORDER BY CASE WHEN Value IS NULL THEN (SELECT MAX(VALUE) FROM ReportTimePoint) ELSE Value END', 0, NULL)

INSERT INTO VC3Reporting.ReportSchemaTableParameter
VALUES ('590A45E8-E3FA-422E-AD71-B043E9992EDC', 'Start Point', @prgItem_DisciplineReferralChangeSchemaTableID, @drcStartPointIdColumnID, '41BA0544-6400-4E61-B1DD-378743A7D145', 1,1)

INSERT INTO ReportSchemaColumn
VALUES (@drcStartPointIdColumnID, NULL)

--WeeksInTimeRange
DECLARE @drcWeeksInTimeRangeColumnID uniqueidentifier
SET @drcWeeksInTimeRangeColumnID = 'CCDB2B13-D32C-45F8-AB11-414FC42B830A'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@drcWeeksInTimeRangeColumnID, 'Weeks In Time Range', @prgItem_DisciplineReferralChangeSchemaTableID, 'N', NULL, 'WeeksInTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@drcWeeksInTimeRangeColumnID, NULL)

----PrgItem_AttendanceChange----------------------------------------------------------------------------
DECLARE @prgItem_AttendanceChangeSchemaTableID uniqueidentifier
SET @prgItem_AttendanceChangeSchemaTableID = '9FEF182E-4B86-4F42-AB94-D4D646D79B32'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@prgItem_AttendanceChangeSchemaTableID, 'Attendance Change',
		'(SELECT *
		FROM PrgItem_AttendanceChange({Start Point}, {End Point}, {Days Surrounding Time Range}, {Absence Reason}))',
		NULL)

INSERT INTO ReportSchemaTable
VALUES (@prgItem_AttendanceChangeSchemaTableID, NULL)

--AbsenceReasonID
DECLARE @acAbsenceReasonIdColumnID uniqueidentifier
SET @acAbsenceReasonIdColumnID = '43F663D6-46E4-4F01-95E6-77A5CC68EF0C'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acAbsenceReasonIdColumnID, 'Absence Reason', @prgItem_AttendanceChangeSchemaTableID, 'G', '(SELECT Name FROM AbsenceReason WHERE ID={this}.AbsenceReasonID)', 'AbsenceReasonID', NULL, NULL, NULL, 0, 1, 1, 1, 1, 0, 'SELECT ID, Name FROM AbsenceReason ORDER BY Name', 0, NULL)

INSERT INTO VC3Reporting.ReportSchemaTableParameter
VALUES ('EEE21943-CA97-41F0-8EE0-D8B6AF9E4819', 'Absence Reason', @prgItem_AttendanceChangeSchemaTableID, @acAbsenceReasonIdColumnID, '41BA0544-6400-4E61-B1DD-378743A7D145', 0,4)

INSERT INTO ReportSchemaColumn
VALUES (@acAbsenceReasonIdColumnID, NULL)

--AbsencesAfterTimeRange
DECLARE @acAbsencesAfterTimeRangeColumnID uniqueidentifier
SET @acAbsencesAfterTimeRangeColumnID = '925EDA26-1BCA-4633-8492-7F63F8C48A18'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acAbsencesAfterTimeRangeColumnID, 'Absences After Time Range', @prgItem_AttendanceChangeSchemaTableID, 'I', NULL, 'AbsencesAfterTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acAbsencesAfterTimeRangeColumnID, NULL)

--AbsencesBeforeTimeRange
DECLARE @acAbsencesBeforeTimeRangeColumnID uniqueidentifier
SET @acAbsencesBeforeTimeRangeColumnID = '5939D6B1-6096-47EA-B749-7CDA6852F6DD'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acAbsencesBeforeTimeRangeColumnID, 'Absences Before Time Range', @prgItem_AttendanceChangeSchemaTableID, 'I', NULL, 'AbsencesBeforeTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acAbsencesBeforeTimeRangeColumnID, NULL)

--AbsencesInTimeRange
DECLARE @acAbsencesInTimeRangeColumnID uniqueidentifier
SET @acAbsencesInTimeRangeColumnID = 'F11EA8B7-9D98-4698-A8EA-376055918206'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acAbsencesInTimeRangeColumnID, 'Absences In Time Range', @prgItem_AttendanceChangeSchemaTableID, 'I', NULL, 'AbsencesInTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acAbsencesInTimeRangeColumnID, NULL)

--AbsencesPerDayAfterTimeRange
DECLARE @acAbsencesPerDayAfterTimeRangeColumnID uniqueidentifier
SET @acAbsencesPerDayAfterTimeRangeColumnID = 'BCB1C6F4-4C40-49F4-92AA-DEAAED2D00E8'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acAbsencesPerDayAfterTimeRangeColumnID, 'Absences Per Day After Time Range', @prgItem_AttendanceChangeSchemaTableID, 'N', NULL, 'AbsencesPerDayAfterTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acAbsencesPerDayAfterTimeRangeColumnID, NULL)

--AbsencesPerDayBeforeTimeRange
DECLARE @acAbsencesPerDayBeforeTimeRangeColumnID uniqueidentifier
SET @acAbsencesPerDayBeforeTimeRangeColumnID = 'C7688A80-9797-4AD1-9928-C038538B61F9'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acAbsencesPerDayBeforeTimeRangeColumnID, 'Absences Per Day Before Time Range', @prgItem_AttendanceChangeSchemaTableID, 'N', NULL, 'AbsencesPerDayBeforeTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acAbsencesPerDayBeforeTimeRangeColumnID, NULL)

--AbsencesPerDayInTimeRange
DECLARE @acAbsencesPerDayInTimeRangeColumnID uniqueidentifier
SET @acAbsencesPerDayInTimeRangeColumnID = '0F56F850-518E-493D-8BF5-F0FF6A72A319'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acAbsencesPerDayInTimeRangeColumnID, 'Absences Per Day In Time Range', @prgItem_AttendanceChangeSchemaTableID, 'N', NULL, 'AbsencesPerDayInTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acAbsencesPerDayInTimeRangeColumnID, NULL)

--AbsencesPerWeekAfterTimeRange
DECLARE @acAbsencesPerWeekAfterTimeRangeColumnID uniqueidentifier
SET @acAbsencesPerWeekAfterTimeRangeColumnID = '1EA0CC37-37EE-4E6F-ADB6-772F7C3E92E6'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acAbsencesPerWeekAfterTimeRangeColumnID, 'Absences Per Week After Time Range', @prgItem_AttendanceChangeSchemaTableID, 'N', NULL, 'AbsencesPerWeekAfterTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acAbsencesPerWeekAfterTimeRangeColumnID, NULL)

--AbsencesPerWeekBeforeTimeRange
DECLARE @acAbsencesPerWeekBeforeTimeRangeColumnID uniqueidentifier
SET @acAbsencesPerWeekBeforeTimeRangeColumnID = '1175801E-D2CF-4068-BD85-2C88C80DC280'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acAbsencesPerWeekBeforeTimeRangeColumnID, 'Absences Per Week Before Time Range', @prgItem_AttendanceChangeSchemaTableID, 'N', NULL, 'AbsencesPerWeekBeforeTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acAbsencesPerWeekBeforeTimeRangeColumnID, NULL)

--AbsencesPerWeekInTimeRange
DECLARE @acAbsencesPerWeekInTimeRangeColumnID uniqueidentifier
SET @acAbsencesPerWeekInTimeRangeColumnID = 'E9E1D08A-0440-43CD-8A99-82349FC05613'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acAbsencesPerWeekInTimeRangeColumnID, 'Absences Per Week In Time Range', @prgItem_AttendanceChangeSchemaTableID, 'N', NULL, 'AbsencesPerWeekInTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acAbsencesPerWeekInTimeRangeColumnID, NULL)

--Change
DECLARE @acChangeColumnID uniqueidentifier
SET @acChangeColumnID = 'B314AF4D-785E-4A7F-878E-4D803A1F8A1B'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acChangeColumnID, 'Change', @prgItem_AttendanceChangeSchemaTableID, 'I', NULL, 'Change', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acChangeColumnID, NULL)

--ChangePercent
DECLARE @acChangePercentColumnID uniqueidentifier
SET @acChangePercentColumnID = '185951FC-2268-4678-A6D8-4A7699E9AD59'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acChangePercentColumnID, 'Change (%)', @prgItem_AttendanceChangeSchemaTableID, 'N', NULL, 'ChangePercent', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acChangePercentColumnID, NULL)

--ChangePerDay
DECLARE @acChangePerDayColumnID uniqueidentifier
SET @acChangePerDayColumnID = '80524C36-EFFA-44C2-8AEB-63BBC4BB79A9'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acChangePerDayColumnID, 'Change Per Day', @prgItem_AttendanceChangeSchemaTableID, 'N', NULL, 'ChangePerDay', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acChangePerDayColumnID, NULL)

--ChangePerDayPercent
DECLARE @acChangePerDayPercentColumnID uniqueidentifier
SET @acChangePerDayPercentColumnID = 'C80534D0-13C0-4E60-B5D8-48E37EAC31E8'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acChangePerDayPercentColumnID, 'Change Per Day (%)', @prgItem_AttendanceChangeSchemaTableID, 'N', NULL, 'ChangePerDayPercent', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acChangePerDayPercentColumnID, NULL)

--ChangePerWeek
DECLARE @acChangePerWeekColumnID uniqueidentifier
SET @acChangePerWeekColumnID = '7CED040D-205D-49F8-994D-2660BB80F183'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acChangePerWeekColumnID, 'Change Per Week', @prgItem_AttendanceChangeSchemaTableID, 'N', NULL, 'ChangePerWeek', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acChangePerWeekColumnID, NULL)

--ChangePerWeekPercent
DECLARE @acChangePerWeekPercentColumnID uniqueidentifier
SET @acChangePerWeekPercentColumnID = '0F5AC445-1F79-436B-B211-747E76B6C7CD'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acChangePerWeekPercentColumnID, 'Change Per Week (%)', @prgItem_AttendanceChangeSchemaTableID, 'N', NULL, 'ChangePerWeekPercent', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acChangePerWeekPercentColumnID, NULL)

--DaysInTimeRange
DECLARE @acDaysInTimeRangeColumnID uniqueidentifier
SET @acDaysInTimeRangeColumnID = 'EF898E28-A49B-4CF6-8613-BCC366DFB979'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acDaysInTimeRangeColumnID, 'Days In Time Range', @prgItem_AttendanceChangeSchemaTableID, 'N', NULL, 'DaysInTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acDaysInTimeRangeColumnID, NULL)

--DaysSurroundingTimeRange
DECLARE @acDaysSurroundingTimeRangeColumnID uniqueidentifier
SET @acDaysSurroundingTimeRangeColumnID = '1FE50540-6CF7-4A04-9B37-03CC2702B60D'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acDaysSurroundingTimeRangeColumnID, 'Days Surrounding Time Range', @prgItem_AttendanceChangeSchemaTableID, 'I', NULL, 'DaysSurroundingTimeRange', NULL, NULL, NULL, 0, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO VC3Reporting.ReportSchemaTableParameter
VALUES ('34FBE3ED-8EDB-4A7C-BEDC-CCF3C8590D50', 'Days Surrounding Time Range', @prgItem_AttendanceChangeSchemaTableID, @acDaysSurroundingTimeRangeColumnID, '41BA0544-6400-4E61-B1DD-378743A7D145', 1,3)

INSERT INTO ReportSchemaColumn
VALUES (@acDaysSurroundingTimeRangeColumnID, NULL)

--EndDateOfTimeRange
DECLARE @acEndDateOfTimeRangeColumnID uniqueidentifier
SET @acEndDateOfTimeRangeColumnID = '1BC676DB-FD67-4D4C-9C00-780E5112E2BA'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acEndDateOfTimeRangeColumnID, 'End Date Of Time Range', @prgItem_AttendanceChangeSchemaTableID, 'D', NULL, 'EndDateOfTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acEndDateOfTimeRangeColumnID, NULL)

--EndPointId
DECLARE @acEndPointIdColumnID uniqueidentifier
SET @acEndPointIdColumnID = '33B096A9-396E-4E50-A9C9-713F17C4A049'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acEndPointIdColumnID, 'End Point', @prgItem_AttendanceChangeSchemaTableID, 'G', '(SELECT Name FROM ReportTimePoint WHERE ID={this}.EndPointId)', 'EndPointId', NULL, NULL, NULL, 0, 1, 1, 1, 1, 0, 'SELECT ID, Name FROM ReportTimePoint ORDER BY CASE WHEN Value IS NULL THEN (SELECT MAX(VALUE) FROM ReportTimePoint) ELSE Value END', 0, NULL)

INSERT INTO VC3Reporting.ReportSchemaTableParameter
VALUES ('5783DA6B-01CE-481F-9A91-854E56C936B1', 'End Point', @prgItem_AttendanceChangeSchemaTableID, @acEndPointIdColumnID, '41BA0544-6400-4E61-B1DD-378743A7D145', 1,2)

INSERT INTO ReportSchemaColumn
VALUES (@acEndPointIdColumnID, NULL)

--StartDateOfTimeRange
DECLARE @acStartDateOfTimeRangeColumnID uniqueidentifier
SET @acStartDateOfTimeRangeColumnID = 'CE58C55C-7E5D-4237-893D-C2B28D0BB6EA'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acStartDateOfTimeRangeColumnID, 'Start Date Of Time Range', @prgItem_AttendanceChangeSchemaTableID, 'D', NULL, 'StartDateOfTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acStartDateOfTimeRangeColumnID, NULL)

--StartPointID
DECLARE @acStartPointIdColumnID uniqueidentifier
SET @acStartPointIdColumnID = '4C1B6EE9-4D1D-41D8-A060-C908588785E7'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acStartPointIdColumnID, 'Start Point', @prgItem_AttendanceChangeSchemaTableID, 'G', '(SELECT Name FROM ReportTimePoint WHERE ID={this}.StartPointID)', 'StartPointID', NULL, NULL, NULL, 0, 1, 1, 1, 1, 0, 'SELECT ID, Name FROM ReportTimePoint ORDER BY CASE WHEN Value IS NULL THEN (SELECT MAX(VALUE) FROM ReportTimePoint) ELSE Value END', 0, NULL)

INSERT INTO VC3Reporting.ReportSchemaTableParameter
VALUES ('72978757-055D-457E-84E2-CA1EF93C618B', 'Start Point', @prgItem_AttendanceChangeSchemaTableID, @acStartPointIdColumnID, '41BA0544-6400-4E61-B1DD-378743A7D145', 1,1)

INSERT INTO ReportSchemaColumn
VALUES (@acStartPointIdColumnID, NULL)

--WeeksInTimeRange
DECLARE @acWeeksInTimeRangeColumnID uniqueidentifier
SET @acWeeksInTimeRangeColumnID = '165BE4E5-54CF-4ADE-A435-C3D97E345A5E'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@acWeeksInTimeRangeColumnID, 'Weeks In Time Range', @prgItem_AttendanceChangeSchemaTableID, 'N', NULL, 'WeeksInTimeRange', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@acWeeksInTimeRangeColumnID, NULL)

----Report Type Table Inserts--------------------------------------------------------------------------
INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('BFF68206-59AF-4C43-A983-11CAD8881847', 'Item', @reportTypeID, 0, @prgItemSchemaTableID, NULL, NULL, NULL, NULL)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('BB495DAB-3023-495B-A4D9-AD3424E5064B', 'Student', @reportTypeID, 0, 'F210EF27-1FBA-4518-B3F3-41DD8AFB4615', 'BFF68206-59AF-4C43-A983-11CAD8881847', 'I' ,'{left}.StudentID = {right}.ID', NULL) --Student Table

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('486D8523-BB74-4535-8566-5181A4AE43A2', 'Probe Score Change', @reportTypeID, 0, @prgItem_ProbeScoreChangeSchemaTableID, 'BFF68206-59AF-4C43-A983-11CAD8881847', 'R' ,'{left}.ID = {right}.ItemID', 'Probe Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('4EBF78F3-F27E-4855-B1C1-7F8D944444AB', 'Discipline Referral Change', @reportTypeID, 0, @prgItem_DisciplineReferralChangeSchemaTableID, 'BFF68206-59AF-4C43-A983-11CAD8881847', 'R' ,'{left}.ID = {right}.ItemID', 'Referral Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('71ABD577-C91A-4145-96E0-35CC9B7E6B0B', 'Attendance Change', @reportTypeID, 0, @prgItem_AttendanceChangeSchemaTableID, 'BFF68206-59AF-4C43-A983-11CAD8881847', 'R' ,'{left}.ID = {right}.ItemID', 'Attendance Change >')
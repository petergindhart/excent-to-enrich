--Context
DECLARE @studentContextID uniqueidentifier
SET @studentContextID = 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4'

--Student ReportType
DECLARE @reportTypeID varchar
SET @reportTypeID = 'T'

INSERT INTO VC3Reporting.ReportType
VALUES (@reportTypeID, 'Action', 1)

INSERT INTO ReportType
VALUES (@reportTypeID, @studentContextID, 'View Actions', NULL, 'ReportIcon_Student.gif', 0, 6, NULL)

INSERT INTO VC3Reporting.ReportTypeFormat
VALUES (@reportTypeID, 'X', 0)

----PrgActivity-----------------------------------------------------------------------------------------
DECLARE @prgActivitySchemaTableID uniqueidentifier
SET @prgActivitySchemaTableID = '03F77763-4633-426B-972F-E10400EE9702'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@prgActivitySchemaTableID, 'Action',
		'(SELECT *
		FROM PrgActivity)',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@prgActivitySchemaTableID, NULL)

--ReasonID
DECLARE @paReasonIdColumnID uniqueidentifier
SET @paReasonIdColumnID = '806508A9-3387-49B5-94A5-44AF7A718627'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@paReasonIdColumnID, 'Reason', @prgActivitySchemaTableID, 'G', '(SELECT Text FROM PrgActivityReason WHERE ID={this}.ReasonID)', 'ReasonID', '(SELECT Sequence FROM PrgActivityReason WHERE ID={this}.ReasonID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Text AS Name FROM PrgActivityReason ORDER BY Sequence', 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@paReasonIdColumnID, NULL)

--Report Type
INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('7B0CA412-6D83-4110-80B4-C08F3738E8A5', 'Action', @reportTypeID, 0, @prgActivitySchemaTableID, NULL, NULL, NULL, NULL)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('7A7AEC95-3CFA-4401-9A59-6599D4D4B108', 'Item', @reportTypeID, 0, 'CA58AA53-C0AB-4326-AA35-6D74695596A7', '7B0CA412-6D83-4110-80B4-C08F3738E8A5', 'I', '{left}.ID = {right}.ID', NULL)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('EB0FDCA4-36DF-481A-A205-CFB0043A40E0', 'Student', @reportTypeID, 0, 'F210EF27-1FBA-4518-B3F3-41DD8AFB4615', '7A7AEC95-3CFA-4401-9A59-6599D4D4B108', 'I' ,'{left}.StudentID = {right}.ID', NULL) --Student Table

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('DF867A6C-0E5E-4F1C-93D2-2C32B8B701E8', 'Probe Score Change', @reportTypeID, 0, 'DAA40B4B-9CCD-4497-9DCF-79BD72154151', '7B0CA412-6D83-4110-80B4-C08F3738E8A5', 'R' ,'{left}.ID = {right}.ItemID', 'Probe Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('E432CFA5-7DE0-4E25-96A3-E4BA1D9F1F28', 'Discipline Referral Change', @reportTypeID, 0, '939E4566-F622-4999-BDBB-734A87527675', '7B0CA412-6D83-4110-80B4-C08F3738E8A5', 'R' ,'{left}.ID = {right}.ItemID', 'Referral Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('9007DFBB-7B4D-49B8-8FE9-D4A6D92D9084', 'Attendance Change', @reportTypeID, 0, '9FEF182E-4B86-4F42-AB94-D4D646D79B32', '7B0CA412-6D83-4110-80B4-C08F3738E8A5', 'R' ,'{left}.ID = {right}.ItemID', 'Attendance Change >')
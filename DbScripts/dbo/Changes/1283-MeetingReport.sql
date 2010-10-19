--Context
DECLARE @studentContextID uniqueidentifier
SET @studentContextID = 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4'

--Student ReportType
DECLARE @reportTypeID varchar
SET @reportTypeID = 'M'

INSERT INTO VC3Reporting.ReportType
VALUES (@reportTypeID, 'Meeting', 1)

INSERT INTO ReportType
VALUES (@reportTypeID, @studentContextID, 'View Meetings', NULL, 'ReportIcon_Student.gif', 0, 5, NULL)

INSERT INTO VC3Reporting.ReportTypeFormat
VALUES (@reportTypeID, 'X', 0)

--Rename Item Report
UPDATE ReportType
SET Summary = 'View Items', PreviewImg = 'ReportIcon_Student.gif'
WHERE Id = 'I'

UPDATE VC3Reporting.ReportType
SET Name = 'Item'
WHERE Id = 'I'

----PrgMeeting------------------------------------------------------------------------------------------
DECLARE @prgMeetingSchemaTableID uniqueidentifier
SET @prgMeetingSchemaTableID = '9E90D4AB-464F-45C6-BBEF-F46B254EF882'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@prgMeetingSchemaTableID, 'Meeting',
		'(SELECT m.*, i.StartDate AS StartTime, i.EndDate AS EndTime
		FROM PrgMeeting m JOIN 
			PrgItem i on i.ID = m.ID)',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@prgMeetingSchemaTableID, NULL)

--AgendaText
DECLARE @pmAgendaTextColumnID uniqueidentifier
SET @pmAgendaTextColumnID = '899486FF-220C-4AF6-BC1B-D21E18F53647'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pmAgendaTextColumnID, 'Agenda', @prgMeetingSchemaTableID, 'T', NULL, 'AgendaText', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pmAgendaTextColumnID, NULL)

--EndTime
DECLARE @pmEndTimeColumnID uniqueidentifier
SET @pmEndTimeColumnID = '7C0A4CF0-78AB-416D-8061-B6F16F12F02A'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pmEndTimeColumnID, 'End Time', @prgMeetingSchemaTableID, 'M', NULL, 'EndTime', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pmEndTimeColumnID, NULL)

--Location
DECLARE @pmLocationColumnID uniqueidentifier
SET @pmLocationColumnID = '11A4F26D-9272-4B4C-8CF7-B8A19DED6364'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pmLocationColumnID, 'Location', @prgMeetingSchemaTableID, 'T', NULL, 'Location', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pmLocationColumnID, NULL)

--MinutesText
DECLARE @pmMinutesTextColumnID uniqueidentifier
SET @pmMinutesTextColumnID = '9E437BBA-8A3F-431C-8A6C-8CCBFB66FE3E'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pmMinutesTextColumnID, 'Minutes', @prgMeetingSchemaTableID, 'T', NULL, 'MinutesText', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pmMinutesTextColumnID, NULL)

--StartTime
DECLARE @pmStartTimeColumnID uniqueidentifier
SET @pmStartTimeColumnID = '68BAB34B-1EFB-4B7F-B86A-B857D2BC7582'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pmStartTimeColumnID, 'Start Time', @prgMeetingSchemaTableID, 'M', NULL, 'StartTime', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pmStartTimeColumnID, NULL)

----Report Type Table Inserts--------------------------------------------------------------------------
INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('B42FF3DD-BAAF-40D0-B604-700FF1E17C5D', 'Meeting', @reportTypeID, 0, @prgMeetingSchemaTableID, NULL, NULL, NULL, NULL)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('7551BE83-F8C5-4849-B8CB-7A1D56E2EFFF', 'Item', @reportTypeID, 0, 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'B42FF3DD-BAAF-40D0-B604-700FF1E17C5D', 'I', '{left}.ID = {right}.ID', NULL)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('9DCA7DF2-09CF-4F95-9F08-13BB381609BB', 'Student', @reportTypeID, 0, 'F210EF27-1FBA-4518-B3F3-41DD8AFB4615', '7551BE83-F8C5-4849-B8CB-7A1D56E2EFFF', 'I' ,'{left}.StudentID = {right}.ID', NULL) --Student Table

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('13B2CCDD-507C-468C-B54F-B563360F88BD', 'Probe Score Change', @reportTypeID, 0, 'DAA40B4B-9CCD-4497-9DCF-79BD72154151', 'B42FF3DD-BAAF-40D0-B604-700FF1E17C5D', 'R' ,'{left}.ID = {right}.ItemID', 'Probe Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('6D749BFD-A55F-4DB3-B616-DABF880D8567', 'Discipline Referral Change', @reportTypeID, 0, '939E4566-F622-4999-BDBB-734A87527675', 'B42FF3DD-BAAF-40D0-B604-700FF1E17C5D', 'R' ,'{left}.ID = {right}.ItemID', 'Referral Change >')

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('AB1E5252-D6B3-4071-A0D4-E419D97F66C9', 'Attendance Change', @reportTypeID, 0, '9FEF182E-4B86-4F42-AB94-D4D646D79B32', 'B42FF3DD-BAAF-40D0-B604-700FF1E17C5D', 'R' ,'{left}.ID = {right}.ItemID', 'Attendance Change >')
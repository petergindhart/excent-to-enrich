--Report Type Record
DECLARE @reportTypeId varchar
SET @reportTypeId = 'U'

INSERT INTO VC3Reporting.ReportType
VALUES (@reportTypeId,'Program Involvement', 1, 'General information on the involvement of a student within a program.')

INSERT INTO ReportType
VALUES (@reportTypeId, 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4', 'Program Involvement', 'ReportIcon_Student.gif', 0, 4, NULL, '375CA1CA-D0E1-4768-A84E-680BBBC2D7E5')

INSERT INTO VC3Reporting.ReportTypeFormat
VALUES (@reportTypeID, 'X', 0)

----PrgInvolvement--------------------------------------------------------------------------------------
DECLARE @prgInvolvementSchemaTableID uniqueidentifier
SET @prgInvolvementSchemaTableID = 'AAEF6DC4-845B-4E1F-B551-09AC8EE22CC2'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@prgInvolvementSchemaTableID, 'Program Involvement',
		'(SELECT i.*,
			CAST(
				CASE
					WHEN 
						(SELECT TOP 1 mr.ID
						FROM PrgInvolvement mr
						WHERE mr.StudentID = i.StudentID AND
							mr.ProgramID = i.ProgramID AND 
							((mr.VariantID IS NULL AND i.VariantID IS NULL) OR mr.VariantID = i.VariantID)
						ORDER BY 
							CASE 
								WHEN EndDate IS NULL THEN ''12/30/9999''
								ELSE EndDate
							END DESC,
							StartDate DESC) = i.ID THEN 1
					ELSE 0
				END 
			AS bit) AS IsMostRecent,
			(SELECT TOP 1 s.StatusID
			FROM PrgInvolvementStatus s
			WHERE s.InvolvementID = i.ID
			ORDER BY 
				CASE 
					WHEN EndDate IS NULL THEN ''12/30/9999''
					ELSE EndDate
				END DESC,
				StartDate DESC) AS MostRecentStatusID
		FROM PrgInvolvement i
		)',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@prgInvolvementSchemaTableID, NULL)

--End Date
DECLARE @piEndDateColumnID uniqueidentifier
SET @piEndDateColumnID = 'DEA1EA8D-5B1F-471E-9772-2A15CF042325'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piEndDateColumnID, 'End Date', @prgInvolvementSchemaTableID, 'D', NULL, 'EndDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piEndDateColumnID, NULL)

--Is Most Recent
DECLARE @piIsMostRecentColumnID uniqueidentifier
SET @piIsMostRecentColumnID = '03DB0BA4-35A6-4619-9CCA-889BF28B5E65'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piIsMostRecentColumnID, 'Is Most Recent', @prgInvolvementSchemaTableID, 'B', '(CASE WHEN {this}.IsMostRecent= 1 THEN ''Yes'' ELSE ''No'' END)', 'IsMostRecent', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT 1 Id, ''Yes'' Name UNION SELECT 0, ''No'' ORDER BY 1 DESC', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piIsMostRecentColumnID, NULL)

--Most Recent Status
DECLARE @piMostRecentStatusIdColumnID uniqueidentifier
SET @piMostRecentStatusIdColumnID = 'B6FA0D28-89FB-437C-BE17-86900230C4B2'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piMostRecentStatusIdColumnID, 'Most Recent Status', @prgInvolvementSchemaTableID, 'G', '(SELECT Name FROM PrgStatus WHERE ID={this}.MostRecentStatusID)', 'MostRecentStatusID', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT s.ID, s.Name AS Name, p.Name AS Program FROM PrgStatus s JOIN Program p ON s.ProgramID = p.ID ORDER BY p.Name, s.Name', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piMostRecentStatusIdColumnID, NULL)

--Program
DECLARE @piProgramIdColumnID uniqueidentifier
SET @piProgramIdColumnID = '17C61742-8638-4CA0-A5CB-9235B5ACCAD7'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piProgramIdColumnID, 'Program', @prgInvolvementSchemaTableID, 'G', '(SELECT Name FROM Program WHERE ID={this}.ProgramID)', 'ProgramID', '(SELECT Name FROM Program WHERE ID={this}.ProgramID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Name AS Name FROM Program ORDER BY Name', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piProgramIdColumnID, NULL)

--Start Date
DECLARE @piStartDateColumnID uniqueidentifier
SET @piStartDateColumnID = '837ECA3D-2018-4C4A-AE36-BDDAFF64D06B'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piStartDateColumnID, 'Start Date', @prgInvolvementSchemaTableID, 'D', NULL, 'StartDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piStartDateColumnID, NULL)

--Variant
DECLARE @piVariantIdColumnID uniqueidentifier
SET @piVariantIdColumnID = '600B1352-1976-4AF7-A7BC-A9E351934777'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piVariantIdColumnID, 'Domain', @prgInvolvementSchemaTableID, 'G', '(SELECT Name FROM PrgVariant WHERE ID={this}.VariantID)', 'VariantID', '(SELECT Name FROM PrgVariant WHERE ID={this}.VariantID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT v.ID, v.Name AS Name, p.Name AS Program FROM PrgVariant v JOIN Program p ON v.ProgramID = p.ID ORDER BY p.Name, v.Name', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piVariantIdColumnID, NULL)

--Report Type Tables
INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('E00523E7-64EA-4C05-8B0F-9F9FA7FF890C', 'Program Involvement', @reportTypeID, 0, @prgInvolvementSchemaTableID, NULL, NULL, NULL, NULL, 0)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('F24B5F6A-3548-48B5-A0C7-CA984D5D6A39', 'Student', @reportTypeID, 0, 'F210EF27-1FBA-4518-B3F3-41DD8AFB4615', 'E00523E7-64EA-4C05-8B0F-9F9FA7FF890C', 'I' ,'{left}.StudentID = {right}.ID', 'Student >', 0)

--Report Areas
INSERT INTO ReportAreaReportType
VALUES ('1A5E2B3E-D3E3-4C1B-B502-81120CE5F878', @reportTypeId) --RTI Scheduling and Mgmt

INSERT INTO ReportAreaReportType
VALUES ('808D7789-2B13-4A82-992B-C949D68EB1D1', @reportTypeId) --Special Education
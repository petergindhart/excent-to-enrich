----IepDisabilityEligibility--------------------------------------------------------------------------
DECLARE @iepDisabilityEligibilitySchemaTableID uniqueidentifier
SET @iepDisabilityEligibilitySchemaTableID = 'F34E963A-ADC6-4B88-8CDC-889AF57D7FE2'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@iepDisabilityEligibilitySchemaTableID, 'Iep Disability Eligibility',
		'(SELECT de.*,
			Sequence + 1 AS DisabilityNumber,
			CAST(
			CASE
				WHEN de.Sequence = 0 THEN 1
				ELSE 0
			END 
			AS BIT) AS IsPrimary		
		FROM IepDisabilityEligibility de
		WHERE IsEligibileID = ''B76DDCD6-B261-4D46-A98E-857B0A814A0C'')',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@iepDisabilityEligibilitySchemaTableID, NULL)


--Disability
DECLARE @ideDisabilityIdColumnID uniqueidentifier
SET @ideDisabilityIdColumnID = '6E69ADC1-81C8-4080-A17C-AC4A639AA5ED'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@ideDisabilityIdColumnID, 'Disability', @iepDisabilityEligibilitySchemaTableID, 'G', '(SELECT Name FROM IepDisability WHERE ID={this}.DisabilityID)', '{this}.DisabilityID', '(SELECT Name FROM IepDisability WHERE ID={this}.DisabilityID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Name AS Name FROM IepDisability ORDER BY Name', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@ideDisabilityIdColumnID, NULL)

--Disability Number
DECLARE @ideDisabilityNumberColumnID uniqueidentifier
SET @ideDisabilityNumberColumnID = '89F19B1E-C953-44B0-AA26-D4C4ABCD04F7'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@ideDisabilityNumberColumnID, 'Disability Number', @iepDisabilityEligibilitySchemaTableID, 'I', NULL, '{this}.DisabilityNumber', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@ideDisabilityNumberColumnID, NULL)

--Is Primary
DECLARE @ideIsPrimaryColumnID uniqueidentifier
SET @ideIsPrimaryColumnID = '3741773E-1B83-4BAC-A2D9-A6DADC31A514'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@ideIsPrimaryColumnID, 'Primary?', @iepDisabilityEligibilitySchemaTableID, 'B', '(CASE WHEN {this}.IsPrimary= 1 THEN ''Yes'' ELSE ''No'' END)', '{this}.IsPrimary', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT 1 Id, ''Yes'' Name UNION SELECT 0, ''No'' ORDER BY 1 DESC', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@ideIsPrimaryColumnID, NULL)

----PrgSection--------------------------------------------------------------------------
DECLARE @prgSectionSchemaTableID uniqueidentifier
SET @prgSectionSchemaTableID = 'B348B796-FE8A-45B8-99EC-6F1D8F4034E6'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@prgSectionSchemaTableID, 'Prg Section',
		'(select 
			sv.*
		from PrgSectionView sv JOIN
			PrgItem i on i.ID = sv.ItemID
		WHERE sv.IsActive = 1 AND
			(SELECT MAX(ls.SectionFinalizedDate)
			FROM PrgSectionView ls JOIN
				PrgItem li ON li.ID = ls.ItemID
			WHERE ls.IsActive = 1 AND 
				li.StudentID = i.StudentID AND
				ls.DefID = sv.DefID) = sv.SectionFinalizedDate)',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@prgSectionSchemaTableID, NULL)

--Disability ReportType
DECLARE @reportTypeID varchar
SET @reportTypeID = 'D'

INSERT INTO VC3Reporting.ReportType
VALUES (@reportTypeId,'Disabilities', 1, 'List of current eligible disabilities for students.')

INSERT INTO ReportType
VALUES (@reportTypeId, 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4', 'Disabilities', 'ReportIcon_Student.gif', 0, 5, NULL, '426D5613-B398-4556-BF3F-765040E5617F') --SpecEd Only

INSERT INTO VC3Reporting.ReportTypeFormat
VALUES (@reportTypeID, 'X', 0)

INSERT INTO ReportAreaReportType
VALUES ('808D7789-2B13-4A82-992B-C949D68EB1D1', @reportTypeId) --Special Education

--Report Type Tables
DECLARE @itemSchemaTableID uniqueidentifier
SET @itemSchemaTableID = 'CA58AA53-C0AB-4326-AA35-6D74695596A7'

DECLARE @studentSchemaTableID uniqueidentifier
SET @studentSchemaTableID = 'F210EF27-1FBA-4518-B3F3-41DD8AFB4615'

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('24B9BEB7-7245-4803-8838-E7CB4BD3B7B6', 'Disability', @reportTypeID, 0, @iepDisabilityEligibilitySchemaTableID, NULL, NULL, NULL, NULL, 0)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('9BD537D4-1C78-4204-A197-749F59096CAC', 'Disability Section', @reportTypeID, 0, @prgSectionSchemaTableID, '24B9BEB7-7245-4803-8838-E7CB4BD3B7B6', 'I' ,'{left}.InstanceID = {right}.ID', 'Disability Section >', 1)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('C32432AA-46B0-40CB-BC8F-B366B2EE4E96', 'Associated Item', @reportTypeID, 0, @itemSchemaTableID, '9BD537D4-1C78-4204-A197-749F59096CAC', 'I' ,'{left}.ItemID = {right}.ID', 'Associated Item >', 0)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('0D7B54DC-4328-403E-B317-31510DBE1E68', 'Student', @reportTypeID, 0, @studentSchemaTableID, 'C32432AA-46B0-40CB-BC8F-B366B2EE4E96', 'I' ,'{left}.StudentID = {right}.ID', 'Student >', 0)
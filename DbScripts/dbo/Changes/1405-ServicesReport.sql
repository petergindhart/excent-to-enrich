----IepService--------------------------------------------------------------------------
DECLARE @iepServiceSchemaTableID uniqueidentifier
SET @iepServiceSchemaTableID = 'D5869422-41B4-4039-BCDC-58587BE555AC'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@iepServiceSchemaTableID, 'Iep Service',
		'(
		SELECT s.*,
			MinutesPerWeek * CAST(ABS(DATEDIFF(WEEK,s.StartDate,s.EndDate)) AS FLOAT) AS MinutesTotal
		FROM
		(select s.*,
			s.Amount * u.MinuteFactor AS MinutesPerSession,
			s.Amount * u.MinuteFactor * f.WeekFactor AS MinutesPerWeek
		from IepService s JOIN
		IepServiceUnit u ON u.ID = s.UnitID JOIN
		IepServiceFrequency f ON f.ID = s.FrequencyID) s)',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@iepServiceSchemaTableID, NULL)


--Amount
DECLARE @isAmountColumnID uniqueidentifier
SET @isAmountColumnID = '8755B7ED-2644-4444-B649-BC02165D09E8'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isAmountColumnID, 'Amount', @iepServiceSchemaTableID, 'I', NULL, '{this}.Amount', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isAmountColumnID, NULL)

--Amount (Average)
DECLARE @isAmountAverageColumnID uniqueidentifier
SET @isAmountAverageColumnID = '0915EBF8-B7AA-49B9-BF63-FCFEE044420D'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isAmountAverageColumnID, 'Amount (Average)', @iepServiceSchemaTableID, 'N', NULL, 'AVG(CAST({this}.Amount AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @isAmountColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@isAmountAverageColumnID, NULL)

--Amount (Max)
DECLARE @isAmountMaxColumnID uniqueidentifier
SET @isAmountMaxColumnID = 'F6EDEEF9-681C-4EDD-93A4-764472EB422D'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isAmountMaxColumnID, 'Amount (Max)', @iepServiceSchemaTableID, 'I', NULL, 'MAX({this}.Amount)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @isAmountColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@isAmountMaxColumnID, NULL)

--Amount (Min)
DECLARE @isAmountMinColumnID uniqueidentifier
SET @isAmountMinColumnID = 'CF7AE040-5258-4014-966C-47DB0F42684A'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isAmountMinColumnID, 'Amount (Min)', @iepServiceSchemaTableID, 'I', NULL, 'MIN({this}.Amount)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @isAmountColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@isAmountMinColumnID, NULL)

--Name (Def)
DECLARE @isDefIdColumnID uniqueidentifier
SET @isDefIdColumnID = '67AD3C7C-BD7D-4AE8-904D-276811B3B59E'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isDefIdColumnID, 'Name', @iepServiceSchemaTableID, 'G', '(SELECT Name FROM IepServiceDef WHERE ID={this}.DefID)', '{this}.DefID', '(SELECT Name FROM IepServiceDef WHERE ID={this}.DefID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Name AS Name FROM IepServiceDef ORDER BY Name', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isDefIdColumnID, NULL)

--Delivery Statement
DECLARE @isDeliveryStatementColumnID uniqueidentifier
SET @isDeliveryStatementColumnID = '09098494-9376-4F65-9594-B6C7DAC5C026'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isDeliveryStatementColumnID, 'Delivery Statement', @iepServiceSchemaTableID, 'T', NULL, 'CAST({this}.DeliveryStatement AS VARCHAR(4000))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isDeliveryStatementColumnID, NULL)

--Direct
DECLARE @isDirectIdColumnID uniqueidentifier
SET @isDirectIdColumnID = 'E3C302BB-6D24-4D46-B572-B7B5F80FBACE'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isDirectIdColumnID, 'Direct', @iepServiceSchemaTableID, 'G', '(SELECT DisplayValue FROM EnumValue WHERE ID={this}.DirectID)', '{this}.DirectID', '(SELECT Sequence FROM EnumValue WHERE ID={this}.DirectID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, DisplayValue AS Name FROM EnumValue ORDER BY Sequence, DisplayValue', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isDirectIdColumnID, NULL)

--End Date
DECLARE @isEndDateColumnID uniqueidentifier
SET @isEndDateColumnID = '731A79D7-C2F2-40BC-9358-D73104D52191'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isEndDateColumnID, 'End Date', @iepServiceSchemaTableID, 'D', NULL, '{this}.EndDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isEndDateColumnID, NULL)

--Esy
DECLARE @isEsyIdColumnID uniqueidentifier
SET @isEsyIdColumnID = '0C7B716A-16FE-4134-A066-8885B2C09869'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isEsyIdColumnID, 'ESY', @iepServiceSchemaTableID, 'G', '(SELECT DisplayValue FROM EnumValue WHERE ID={this}.EsyID)', '{this}.EsyID', '(SELECT Sequence FROM EnumValue WHERE ID={this}.EsyID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, DisplayValue AS Name FROM EnumValue ORDER BY Sequence, DisplayValue', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isEsyIdColumnID, NULL)

--Excludes
DECLARE @isExcludesIdColumnID uniqueidentifier
SET @isExcludesIdColumnID = 'B7E6D94B-4D57-4195-B99C-26ED1F2A7C16'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isExcludesIdColumnID, 'Excludes', @iepServiceSchemaTableID, 'G', '(SELECT DisplayValue FROM EnumValue WHERE ID={this}.ExcludesID)', '{this}.ExcludesID', '(SELECT Sequence FROM EnumValue WHERE ID={this}.ExcludesID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, DisplayValue AS Name FROM EnumValue ORDER BY Sequence, DisplayValue', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isExcludesIdColumnID, NULL)

--Frequency
DECLARE @isFrequencyIdColumnID uniqueidentifier
SET @isFrequencyIdColumnID = '956E7276-947F-4C2E-9DA7-6ED7DAF13DB8'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isFrequencyIdColumnID, 'Frequency', @iepServiceSchemaTableID, 'G', '(SELECT Name FROM IepServiceFrequency WHERE ID={this}.FrequencyID)', '{this}.FrequencyID', '(SELECT Sequence FROM IepServiceFrequency WHERE ID={this}.FrequencyID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Name AS Name FROM IepServiceFrequency ORDER BY Sequence, Name', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isFrequencyIdColumnID, NULL)

--Location
DECLARE @isLocationColumnID uniqueidentifier
SET @isLocationColumnID = '8A61F843-6D1D-4A8D-9336-B6968305E994'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isLocationColumnID, 'Location', @iepServiceSchemaTableID, 'T', NULL, '{this}.Location', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isLocationColumnID, NULL)

--Minutes Per Session
DECLARE @isMinutesPerSessionColumnID uniqueidentifier
SET @isMinutesPerSessionColumnID = 'A32C1BE4-0625-4EFF-BEBD-DC8E32D5A0AB'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isMinutesPerSessionColumnID, 'Minutes Per Session', @iepServiceSchemaTableID, 'N', NULL, '{this}.MinutesPerSession', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isMinutesPerSessionColumnID, NULL)

--Minutes Per Session (Average)
DECLARE @isMinutesPerSessionAverageColumnID uniqueidentifier
SET @isMinutesPerSessionAverageColumnID = '97E97CF1-4802-4913-905D-A585E39B767A'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isMinutesPerSessionAverageColumnID, 'Minutes Per Session (Average)', @iepServiceSchemaTableID, 'N', NULL, 'AVG(CAST({this}.MinutesPerSession AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @isMinutesPerSessionColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@isMinutesPerSessionAverageColumnID, NULL)

--Minutes Per Session (Max)
DECLARE @isMinutesPerSessionMaxColumnID uniqueidentifier
SET @isMinutesPerSessionMaxColumnID = '97E170BE-4637-4438-98AB-E6330A367955'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isMinutesPerSessionMaxColumnID, 'Minutes Per Session (Max)', @iepServiceSchemaTableID, 'N', NULL, 'MAX({this}.MinutesPerSession)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @isMinutesPerSessionColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@isMinutesPerSessionMaxColumnID, NULL)

--Minutes Per Session (Min)
DECLARE @isMinutesPerSessionMinColumnID uniqueidentifier
SET @isMinutesPerSessionMinColumnID = '4B419B44-1D3D-4AF9-8F6C-67BF96219BE0'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isMinutesPerSessionMinColumnID, 'Minutes Per Session (Min)', @iepServiceSchemaTableID, 'N', NULL, 'MIN({this}.MinutesPerSession)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @isMinutesPerSessionColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@isMinutesPerSessionMinColumnID, NULL)

--Minutes Per Week
DECLARE @isMinutesPerWeekColumnID uniqueidentifier
SET @isMinutesPerWeekColumnID = '52C465E9-3F29-4BF2-8286-16DEE455BD58'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isMinutesPerWeekColumnID, 'Minutes Per Week', @iepServiceSchemaTableID, 'N', NULL, '{this}.MinutesPerWeek', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isMinutesPerWeekColumnID, NULL)

--Minutes Per Week (Average)
DECLARE @isMinutesPerWeekAverageColumnID uniqueidentifier
SET @isMinutesPerWeekAverageColumnID = '4404A0D3-B5D9-4B41-9F8A-0E22AAC7C8B0'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isMinutesPerWeekAverageColumnID, 'Minutes Per Week (Average)', @iepServiceSchemaTableID, 'N', NULL, 'AVG(CAST({this}.MinutesPerWeek AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @isMinutesPerWeekColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@isMinutesPerWeekAverageColumnID, NULL)

--Minutes Per Week (Max)
DECLARE @isMinutesPerWeekMaxColumnID uniqueidentifier
SET @isMinutesPerWeekMaxColumnID = '40AD80AC-B943-48FC-82C8-E130E075C7BF'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isMinutesPerWeekMaxColumnID, 'Minutes Per Week (Max)', @iepServiceSchemaTableID, 'N', NULL, 'MAX({this}.MinutesPerWeek)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @isMinutesPerWeekColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@isMinutesPerWeekMaxColumnID, NULL)

--Minutes Per Week (Min)
DECLARE @isMinutesPerWeekMinColumnID uniqueidentifier
SET @isMinutesPerWeekMinColumnID = '7A8DFDD0-8A58-4AA8-BCE1-246FF3281D82'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isMinutesPerWeekMinColumnID, 'Minutes Per Week (Min)', @iepServiceSchemaTableID, 'N', NULL, 'MIN({this}.MinutesPerWeek)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @isMinutesPerWeekColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@isMinutesPerWeekMinColumnID, NULL)

--Minutes Total
DECLARE @isMinutesTotalColumnID uniqueidentifier
SET @isMinutesTotalColumnID = '22F91CD1-7AA7-4AF3-9ACC-589231B25E27'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isMinutesTotalColumnID, 'Minutes Total', @iepServiceSchemaTableID, 'N', NULL, '{this}.MinutesTotal', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isMinutesTotalColumnID, NULL)

--Minutes Total (Average)
DECLARE @isMinutesTotalAverageColumnID uniqueidentifier
SET @isMinutesTotalAverageColumnID = 'FEE42503-BE5B-4BF7-B38C-0F2E9576E998'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isMinutesTotalAverageColumnID, 'Minutes Total (Average)', @iepServiceSchemaTableID, 'N', NULL, 'AVG(CAST({this}.MinutesTotal AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @isMinutesTotalColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@isMinutesTotalAverageColumnID, NULL)

--Minutes Total (Max)
DECLARE @isMinutesTotalMaxColumnID uniqueidentifier
SET @isMinutesTotalMaxColumnID = 'F37552E8-0F35-41B7-9EC8-A92E0C91008B'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isMinutesTotalMaxColumnID, 'Minutes Total (Max)', @iepServiceSchemaTableID, 'N', NULL, 'MAX({this}.MinutesTotal)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @isMinutesTotalColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@isMinutesTotalMaxColumnID, NULL)

--Minutes Total (Min)
DECLARE @isMinutesTotalMinColumnID uniqueidentifier
SET @isMinutesTotalMinColumnID = '44431EEC-173B-4293-99FB-F484EF0528E8'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isMinutesTotalMinColumnID, 'Minutes Total (Min)', @iepServiceSchemaTableID, 'N', NULL, 'MIN({this}.MinutesTotal)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @isMinutesTotalColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@isMinutesTotalMinColumnID, NULL)

--Provider Title
DECLARE @isProviderTitleColumnID uniqueidentifier
SET @isProviderTitleColumnID = '9E422453-9BDF-4861-B02C-DD3CE821AB7B'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isProviderTitleColumnID, 'Prover Title', @iepServiceSchemaTableID, 'T', NULL, '{this}.ProviderTitle', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isProviderTitleColumnID, NULL)

--Related
DECLARE @isRelatedIdColumnID uniqueidentifier
SET @isRelatedIdColumnID = 'C3926F1C-8FE2-4D26-B142-C4681178F52F'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isRelatedIdColumnID, 'Related', @iepServiceSchemaTableID, 'G', '(SELECT DisplayValue FROM EnumValue WHERE ID={this}.RelatedID)', '{this}.RelatedID', '(SELECT Sequence FROM EnumValue WHERE ID={this}.RelatedID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, DisplayValue AS Name FROM EnumValue ORDER BY Sequence, DisplayValue', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isRelatedIdColumnID, NULL)

--Sequence
DECLARE @isSequenceColumnID uniqueidentifier
SET @isSequenceColumnID = '47BB3D87-A603-4CE1-B85E-25776073CA30'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isSequenceColumnID, 'Sequence', @iepServiceSchemaTableID, 'I', NULL, '{this}.Sequence', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isSequenceColumnID, NULL)

--Start Date
DECLARE @isStartDateColumnID uniqueidentifier
SET @isStartDateColumnID = 'D1B1BB33-0593-4C0B-8AB0-63EEC5EAF760'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isStartDateColumnID, 'Start Date', @iepServiceSchemaTableID, 'D', NULL, '{this}.StartDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isStartDateColumnID, NULL)

--Unit
DECLARE @isUnitIdColumnID uniqueidentifier
SET @isUnitIdColumnID = 'ABF79AA5-5AFF-463E-8488-77FE46FB337C'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@isUnitIdColumnID, 'Unit', @iepServiceSchemaTableID, 'G', '(SELECT Name FROM IepServiceUnit WHERE ID={this}.UnitID)', '{this}.UnitID', '(SELECT Sequence FROM IepServiceUnit WHERE ID={this}.UnitID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Name AS Name FROM IepServiceUnit ORDER BY Sequence, Name', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@isUnitIdColumnID, NULL)

--Services ReportType
DECLARE @reportTypeID varchar
SET @reportTypeID = 'R'

INSERT INTO VC3Reporting.ReportType
VALUES (@reportTypeId,'Services', 1, 'List of current services for students.')

INSERT INTO ReportType
VALUES (@reportTypeId, 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4', 'Services', 'ReportIcon_Student.gif', 0, 5, NULL, '426D5613-B398-4556-BF3F-765040E5617F') --SpecEd Only

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
VALUES ('546B7DD0-F8FE-44FB-9FBF-DBE6AA7675E9', 'Service', @reportTypeID, 0, @iepServiceSchemaTableID, NULL, NULL, NULL, NULL, 0)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('4F0EB58E-2712-46E2-918B-68360EC66B60', 'Service Section', @reportTypeID, 0, @prgSectionSchemaTableID, '546B7DD0-F8FE-44FB-9FBF-DBE6AA7675E9', 'I' ,'{left}.InstanceID = {right}.ID', 'Service Section >', 1)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('05635793-9FFE-45CD-B31A-A34FE15709FE', 'Associated Item', @reportTypeID, 0, @itemSchemaTableID, '4F0EB58E-2712-46E2-918B-68360EC66B60', 'I' ,'{left}.ItemID = {right}.ID', 'Associated Item >', 0)

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('45E30AA0-0CED-4D37-817B-152BF72C85C4', 'Student', @reportTypeID, 0, @studentSchemaTableID, '05635793-9FFE-45CD-B31A-A34FE15709FE', 'I' ,'{left}.StudentID = {right}.ID', 'Student >', 0)
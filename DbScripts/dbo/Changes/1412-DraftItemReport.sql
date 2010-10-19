----PrgVersion--------------------------------------------------------------------------
DECLARE @prgVersionSchemaTableID uniqueidentifier
SET @prgVersionSchemaTableID = 'B9C2231D-7FA3-43B7-AB08-1EDF50F2DB5E'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@prgVersionSchemaTableID, 'Prg Version',
		'(SELECT *,
			CAST(TimeOpenDays AS FLOAT) / 7 AS TimeOpenWeeks
		FROM
			(select *, DATEDIFF(DAY,DateCreated,GETDATE()) AS TimeOpenDays
			from PrgVersion
			where DateFinalized is null) v)',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@prgVersionSchemaTableID, NULL)


--Date Created
DECLARE @pvDateCreatedColumnID uniqueidentifier
SET @pvDateCreatedColumnID = 'F69768C1-B3C5-462A-BA84-56CC04171AA7'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pvDateCreatedColumnID, 'Date Created', @prgVersionSchemaTableID, 'D', NULL, '{this}.DateCreated', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pvDateCreatedColumnID, NULL)

--Time Open in Days
DECLARE @pvTimeOpenDaysColumnID uniqueidentifier
SET @pvTimeOpenDaysColumnID = '6C9B209A-EE4E-4598-BEFC-7694450D78B9'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pvTimeOpenDaysColumnID, 'Time Open in Days', @prgVersionSchemaTableID, 'I', NULL, '{this}.TimeOpenDays', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pvTimeOpenDaysColumnID, NULL)

--Time Open in Days (Average)
DECLARE @pvTimeOpenDaysAverageColumnID uniqueidentifier
SET @pvTimeOpenDaysAverageColumnID = '8CE17684-F120-468A-8C86-59F700A2FAD4'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pvTimeOpenDaysAverageColumnID, 'Time Open in Days (Average)', @prgVersionSchemaTableID, 'N', NULL, 'AVG(CAST({this}.TimeOpenDays AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @pvTimeOpenDaysColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@pvTimeOpenDaysAverageColumnID, NULL)

--Time Open in Days (Max)
DECLARE @pvTimeOpenDaysMaxColumnID uniqueidentifier
SET @pvTimeOpenDaysMaxColumnID = '29F1CBDF-5863-4463-A174-9B443CA9A345'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pvTimeOpenDaysMaxColumnID, 'Time Open in Days (Max)', @prgVersionSchemaTableID, 'I', NULL, 'MAX({this}.TimeOpenDays)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @pvTimeOpenDaysColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@pvTimeOpenDaysMaxColumnID, NULL)

--Time Open in Days (Min)
DECLARE @pvTimeOpenDaysMinColumnID uniqueidentifier
SET @pvTimeOpenDaysMinColumnID = '1A341220-6A13-47EB-8D68-27183A515368'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pvTimeOpenDaysMinColumnID, 'Time Open in Days (Min)', @prgVersionSchemaTableID, 'I', NULL, 'MIN({this}.TimeOpenDays)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @pvTimeOpenDaysColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@pvTimeOpenDaysMinColumnID, NULL)

--Time Open in Weeks
DECLARE @pvTimeOpenWeeksColumnID uniqueidentifier
SET @pvTimeOpenWeeksColumnID = '4B53C127-3C9B-4979-950D-C3E6FBCCCEC1'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pvTimeOpenWeeksColumnID, 'Time Open in Weeks', @prgVersionSchemaTableID, 'N', NULL, '{this}.TimeOpenWeeks', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pvTimeOpenWeeksColumnID, NULL)

--Time Open in Weeks (Average)
DECLARE @pvTimeOpenWeeksAverageColumnID uniqueidentifier
SET @pvTimeOpenWeeksAverageColumnID = '49967139-A010-4558-B9C9-99B4A034BEDD'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pvTimeOpenWeeksAverageColumnID, 'Time Open in Weeks (Average)', @prgVersionSchemaTableID, 'N', NULL, 'AVG(CAST({this}.TimeOpenWeeks AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @pvTimeOpenWeeksColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@pvTimeOpenWeeksAverageColumnID, NULL)

--Time Open in Weeks (Max)
DECLARE @pvTimeOpenWeeksMaxColumnID uniqueidentifier
SET @pvTimeOpenWeeksMaxColumnID = 'FC227F06-302B-480A-A0B4-AFE167AB74AE'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pvTimeOpenWeeksMaxColumnID, 'Time Open in Weeks (Max)', @prgVersionSchemaTableID, 'N', NULL, 'MAX({this}.TimeOpenWeeks)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @pvTimeOpenWeeksColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@pvTimeOpenWeeksMaxColumnID, NULL)

--Time Open in Weeks (Min)
DECLARE @pvTimeOpenWeeksMinColumnID uniqueidentifier
SET @pvTimeOpenWeeksMinColumnID = '6D70AE8B-B8B6-450A-9004-50910787246E'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pvTimeOpenWeeksMinColumnID, 'Time Open in Weeks (Min)', @prgVersionSchemaTableID, 'N', NULL, 'MIN({this}.TimeOpenWeeks)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @pvTimeOpenWeeksColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@pvTimeOpenWeeksMinColumnID, NULL)

--Draft Plans ReportType
DECLARE @reportTypeID varchar
SET @reportTypeID = 'F'

INSERT INTO VC3Reporting.ReportType
VALUES (@reportTypeId,'Draft Plans', 1, 'List of plans with a pending draft.')

INSERT INTO ReportType
VALUES (@reportTypeId, 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4', 'Draft Plans', 'ReportIcon_Student.gif', 0, 7, NULL, '426D5613-B398-4556-BF3F-765040E5617F') --SpecEd Only

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

DECLARE @planSchemaTableID uniqueidentifier
SET @planSchemaTableID = 'B1AA13A5-75E1-402A-8170-20B8E18FDF3F'

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('DE2387D3-9697-46FF-969E-AC5573C1E80D', 'Draft', @reportTypeID, 0, @prgVersionSchemaTableID, NULL, NULL, NULL, 'Draft >', 0)

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('759217AD-454A-423C-BA08-D759178197C9', 'Plan', @reportTypeID, 0, @planSchemaTableID, 'DE2387D3-9697-46FF-969E-AC5573C1E80D', 'I' ,'{left}.ItemID = {right}.ID', 'Plan >', 0)

		INSERT INTO VC3Reporting.ReportTypeTable
		VALUES ('BB092D4B-2162-4B2D-8207-BE9FE5CC0DC4', 'Item', @reportTypeID, 0, @itemSchemaTableID, '759217AD-454A-423C-BA08-D759178197C9', 'I' ,'{left}.ID = {right}.ID', 'Plan >', 1)
			
			INSERT INTO VC3Reporting.ReportTypeTable
			VALUES ('1EB5FC03-73DD-4F6D-936C-E07ED0F925A0', 'Student', @reportTypeID, 0, @studentSchemaTableID, 'BB092D4B-2162-4B2D-8207-BE9FE5CC0DC4', 'I', '{left}.StudentID = {right}.ID', 'Student >', 0)
			
	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('6C69CB02-BDD5-408B-8577-EB435B1D855D', 'Plan Before', @reportTypeID, 0, @planSchemaTableID, '759217AD-454A-423C-BA08-D759178197C9', 'L', '{left}.PlanBeforeID = {right}.ID', 'Plan Before >', 0)

		INSERT INTO VC3Reporting.ReportTypeTable
		VALUES ('26A54055-45A4-46A0-B198-DA682F93B702', 'Item', @reportTypeID, 0, @itemSchemaTableID, '6C69CB02-BDD5-408B-8577-EB435B1D855D', 'L' ,'{left}.ID = {right}.ID', 'Plan Before >', 1)
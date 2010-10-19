----PendingItem--------------------------------------------------------------------------
DECLARE @pendingItemSchemaTableID uniqueidentifier
SET @pendingItemSchemaTableID = '4B99A925-A839-410C-BFC9-67986737CA89'

INSERT INTO VC3Reporting.ReportSchemaTable
VALUES (@pendingItemSchemaTableID, 'Pending Item',
		'(
		SELECT *, 
			CAST(TimePendingDays AS FLOAT) / 7 AS TimePendingWeeks
		FROM
		(
			SELECT r.*, d.ResultingItemDefID, rd.ProgramID,
				DATEDIFF(DAY,
					CASE
						WHEN d.TriggerID = ''E91110EC-78E2-4E42-90B5-5206D3AA735D'' THEN ii.StartDate
						WHEN d.TriggerID = ''3EAAE600-86AB-4CF8-8866-E7D70BCB0497'' THEN ii.EndDate
						ELSE GETDATE()
					END,
					GETDATE()) AS TimePendingDays
			FROM PrgItemRel r JOIN
				PrgItemRelDef d on r.PrgItemRelDefID = d.ID JOIN
				PrgItemDef rd on d.ResultingItemDefID = rd.ID JOIN
				PrgItem ii on r.InitiatingItemID = ii.ID
			WHERE r.ResultingItemID IS NULL
		) p)',
		'ID')

INSERT INTO ReportSchemaTable
VALUES (@pendingItemSchemaTableID, NULL)

--Name
DECLARE @piResultingItemDefIdColumnID uniqueidentifier
SET @piResultingItemDefIdColumnID = '4583303E-91DD-4616-A88E-D626ED3DEC75'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piResultingItemDefIdColumnID, 'Name', @pendingItemSchemaTableID, 'G', '(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(100),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID={this}.ResultingItemDefID)', '{this}.ResultingItemDefID', '(SELECT Name FROM PrgItemDef WHERE ID={this}.ResultingItemDefID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT d.ID, ISNULL(d.Name + '' (Inactive as of '' + CONVERT(VARCHAR(100),d.DeletedDate,101) + '')'', d.Name) AS Name, ISNULL(p.Name + '' (Inactive as of '' + CONVERT(VARCHAR(100),p.DeletedDate,101) + '')'', p.Name) AS Program FROM PrgItemDef d JOIN Program p ON p.ID = d.ProgramID WHERE p.FeatureID is null or p.FeatureID in (select id from GetUniqueIdentifiers(<%=FeatureIds%>)) ORDER BY Program, Name', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piResultingItemDefIdColumnID, NULL)

--Program
DECLARE @piProgramIdColumnID uniqueidentifier
SET @piProgramIdColumnID = '0F4524D1-790E-43DF-AA68-1CC817BE7588'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piProgramIdColumnID, 'Program', @pendingItemSchemaTableID, 'G', '(SELECT Name FROM Program WHERE ID={this}.ProgramID)', '{this}.ProgramID', '(SELECT Name FROM Program WHERE ID={this}.ProgramID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, Name AS Name FROM Program ORDER BY Name', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piProgramIdColumnID, NULL)

--Time Pending in Days
DECLARE @piTimePendingDaysColumnID uniqueidentifier
SET @piTimePendingDaysColumnID = 'FA2BD6B4-2E04-4243-9929-F20128334021'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimePendingDaysColumnID, 'Time Pending in Days', @pendingItemSchemaTableID, 'I', NULL, '{this}.TimePendingDays', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimePendingDaysColumnID, NULL)

--Time Pending in Days (Average)
DECLARE @piTimePendingDaysAverageColumnID uniqueidentifier
SET @piTimePendingDaysAverageColumnID = 'F1782D3B-0130-4F8C-B755-3B22891A7E60'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimePendingDaysAverageColumnID, 'Time Pending in Days (Average)', @pendingItemSchemaTableID, 'N', NULL, 'AVG(CAST({this}.TimePendingDays AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @piTimePendingDaysColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@piTimePendingDaysAverageColumnID, NULL)

--Time Pending in Days (Max)
DECLARE @piTimePendingDaysMaxColumnID uniqueidentifier
SET @piTimePendingDaysMaxColumnID = '74529D1B-3559-4035-9AD8-F3C1D378FC0F'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimePendingDaysMaxColumnID, 'Time Pending in Days (Max)', @pendingItemSchemaTableID, 'I', NULL, 'MAX({this}.TimePendingDays)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @piTimePendingDaysColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@piTimePendingDaysMaxColumnID, NULL)

--Time Pending in Days (Min)
DECLARE @piTimePendingDaysMinColumnID uniqueidentifier
SET @piTimePendingDaysMinColumnID = '053FBC44-D24B-4FD8-937F-D0CA6593FC74'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimePendingDaysMinColumnID, 'Time Pending in Days (Min)', @pendingItemSchemaTableID, 'I', NULL, 'MIN({this}.TimePendingDays)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @piTimePendingDaysColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@piTimePendingDaysMinColumnID, NULL)

--Time Pending in Weeks
DECLARE @piTimePendingWeeksColumnID uniqueidentifier
SET @piTimePendingWeeksColumnID = 'CA74B4A6-1F6D-411B-910D-3F69F59030B7'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimePendingWeeksColumnID, 'Time Pending in Weeks', @pendingItemSchemaTableID, 'N', NULL, '{this}.TimePendingWeeks', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimePendingWeeksColumnID, NULL)

--Time Pending in Weeks (Average)
DECLARE @piTimePendingWeeksAverageColumnID uniqueidentifier
SET @piTimePendingWeeksAverageColumnID = '4EB525CC-B84D-4D73-A295-C0477D770C18'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimePendingWeeksAverageColumnID, 'Time Pending in Weeks (Average)', @pendingItemSchemaTableID, 'N', NULL, 'AVG(CAST({this}.TimePendingWeeks AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @piTimePendingWeeksColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@piTimePendingWeeksAverageColumnID, NULL)

--Time Pending in Weeks (Max)
DECLARE @piTimePendingWeeksMaxColumnID uniqueidentifier
SET @piTimePendingWeeksMaxColumnID = '3CE4123C-EA66-4AF6-8C54-33A3520ED493'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimePendingWeeksMaxColumnID, 'Time Pending in Weeks (Max)', @pendingItemSchemaTableID, 'N', NULL, 'MAX({this}.TimePendingWeeks)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @piTimePendingWeeksColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@piTimePendingWeeksMaxColumnID, NULL)

--Time Pending in Weeks (Min)
DECLARE @piTimePendingWeeksMinColumnID uniqueidentifier
SET @piTimePendingWeeksMinColumnID = 'E5FAA264-C8A7-43F6-B809-270EE9F2EAD0'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimePendingWeeksMinColumnID, 'Time Pending in Weeks (Min)', @pendingItemSchemaTableID, 'N', NULL, 'MIN({this}.TimePendingWeeks)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL, @piTimePendingWeeksColumnID)

INSERT INTO ReportSchemaColumn
VALUES (@piTimePendingWeeksMinColumnID, NULL)

--Pending Item ReportType
DECLARE @reportTypeID varchar
SET @reportTypeID = 'G'

INSERT INTO VC3Reporting.ReportType
VALUES (@reportTypeId,'Pending Items', 1, 'List of plans, actions, etc that are pending as a result of another item.')

	--Features
	DECLARE @generalFeatureID uniqueidentifier
	SET @generalFeatureID = '375CA1CA-D0E1-4768-A84E-680BBBC2D7E5'

	DECLARE @rtiFeatureID uniqueidentifier
	SET @rtiFeatureID = '2A516452-E8D4-43CA-880F-C8CF0006E47E'

	DECLARE @specEdFeatureID uniqueidentifier
	SET @specEdFeatureID = '426D5613-B398-4556-BF3F-765040E5617F'

INSERT INTO ReportType
VALUES (@reportTypeId, 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4', 'Pending Items', 'ReportIcon_Student.gif', 0, 6, NULL, @generalFeatureID)

INSERT INTO VC3Reporting.ReportTypeFormat
VALUES (@reportTypeID, 'X', 0)

	--Report Areas
	DECLARE @specEdArea uniqueidentifier
	SET @specEdArea = '808D7789-2B13-4A82-992B-C949D68EB1D1'
	
	DECLARE @rtiSchedulingAndMgmtArea uniqueidentifier
	SET @rtiSchedulingAndMgmtArea = '1A5E2B3E-D3E3-4C1B-B502-81120CE5F878'

INSERT INTO ReportAreaReportType
VALUES (@specEdArea, @reportTypeId)

INSERT INTO ReportAreaReportType
VALUES (@rtiSchedulingAndMgmtArea, @reportTypeId)

--Report Type Tables
DECLARE @itemSchemaTableID uniqueidentifier
SET @itemSchemaTableID = 'CA58AA53-C0AB-4326-AA35-6D74695596A7'

DECLARE @studentSchemaTableID uniqueidentifier
SET @studentSchemaTableID = 'F210EF27-1FBA-4518-B3F3-41DD8AFB4615'

DECLARE @prgSectionSchemaTableID uniqueidentifier
SET @prgSectionSchemaTableID = 'B348B796-FE8A-45B8-99EC-6F1D8F4034E6'

INSERT INTO VC3Reporting.ReportTypeTable
VALUES ('C478A55C-C5D8-4C52-AE7E-434E7C7E3A81', 'Pending Item', @reportTypeID, 0, @pendingItemSchemaTableID, NULL, NULL, NULL, 'Pending Item >', 0)

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('313F5766-B7A7-4096-AAA3-4CB9C8945BB6', 'Initiating Item', @reportTypeID, 0, @itemSchemaTableID, 'C478A55C-C5D8-4C52-AE7E-434E7C7E3A81', 'I' ,'{left}.InitiatingItemID = {right}.ID', 'Initiating Item >', 0)
	
		INSERT INTO VC3Reporting.ReportTypeTable
		VALUES ('16CA90D0-628F-4CA3-9DDF-82F317094751', 'Student', @reportTypeID, 0, @studentSchemaTableID, '313F5766-B7A7-4096-AAA3-4CB9C8945BB6', 'I', '{left}.StudentID = {right}.ID', 'Student >', 0)

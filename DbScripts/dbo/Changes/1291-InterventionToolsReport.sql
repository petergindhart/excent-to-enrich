DECLARE @studentContextID uniqueidentifier
SET @studentContextID = 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4'

--Intervention Tools ReportType
DECLARE @reportTypeID varchar
SET @reportTypeID = 'N'

IF NOT EXISTS(SELECT * FROM VC3Reporting.ReportType WHERE ID = @reportTypeID)
BEGIN

	INSERT INTO VC3Reporting.ReportType
	VALUES (@reportTypeID, 'Intervention Tool', 1)

	INSERT INTO ReportType
	VALUES (@reportTypeID, @studentContextID, 'View Intervention Tools', NULL, 'ReportIcon_Student.gif', 0, 3, NULL)

	INSERT INTO VC3Reporting.ReportTypeFormat
	VALUES (@reportTypeID, 'X', 0)

	----IntvTool--------------------------------------------------------------------------------------------
	DECLARE @intvToolSchemaTableID uniqueidentifier
	SET @intvToolSchemaTableID = 'BA112066-0473-4F89-864A-BAE635E30EF4'

	INSERT INTO VC3Reporting.ReportSchemaTable
	VALUES (@intvToolSchemaTableID, 'Intervention Tool',
			'(SELECT *
			FROM IntvTool)',
			'ID')

	INSERT INTO ReportSchemaTable
	VALUES (@intvToolSchemaTableID, NULL)

	--MinutesPerSession
	DECLARE @itMinutesPerSessionColumnID uniqueidentifier
	SET @itMinutesPerSessionColumnID = '2048FEBB-1661-4E0A-96D1-0B404154BC5E'

	INSERT INTO VC3Reporting.ReportSchemaColumn
	VALUES (@itMinutesPerSessionColumnID, 'Minutes Per Session', @intvToolSchemaTableID, 'I', NULL, 'MinutesPerSession', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

	INSERT INTO ReportSchemaColumn
	VALUES (@itMinutesPerSessionColumnID, NULL)

	--NumWeeks
	DECLARE @itNumWeeksColumnID uniqueidentifier
	SET @itNumWeeksColumnID = '342EED29-4C30-4633-995F-3F222EC51B3C'

	INSERT INTO VC3Reporting.ReportSchemaColumn
	VALUES (@itNumWeeksColumnID, 'Number Of Weeks', @intvToolSchemaTableID, 'I', NULL, 'NumWeeks', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

	INSERT INTO ReportSchemaColumn
	VALUES (@itNumWeeksColumnID, NULL)

	--SessionsPerWeek
	DECLARE @itSessionsPerWeekColumnID uniqueidentifier
	SET @itSessionsPerWeekColumnID = '8F100ED6-8E7B-4DDD-83BE-A7B36D19631D'

	INSERT INTO VC3Reporting.ReportSchemaColumn
	VALUES (@itSessionsPerWeekColumnID, 'Sessions Per Week', @intvToolSchemaTableID, 'I', NULL, 'SessionsPerWeek', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

	INSERT INTO ReportSchemaColumn
	VALUES (@itSessionsPerWeekColumnID, NULL)

	----IntvToolDef-----------------------------------------------------------------------------------------
	DECLARE @intvToolDefSchemaTableID uniqueidentifier
	SET @intvToolDefSchemaTableID = '7C5EAA5E-8ED4-4102-BB40-1D1F981C2906'

	INSERT INTO VC3Reporting.ReportSchemaTable
	VALUES (@intvToolDefSchemaTableID, 'Intv Tool Def',
			'(SELECT *
			FROM IntvToolDef)',
			'ID')

	INSERT INTO ReportSchemaTable
	VALUES (@intvToolDefSchemaTableID, NULL)

	--DeletedDate
	DECLARE @itdDeletedDateColumnID uniqueidentifier
	SET @itdDeletedDateColumnID = '2F2EE458-0F27-46AD-9F11-B6E5F1107714'

	INSERT INTO VC3Reporting.ReportSchemaColumn
	VALUES (@itdDeletedDateColumnID, 'Deleted Date', @intvToolDefSchemaTableID, 'D', NULL, 'DeletedDate', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

	INSERT INTO ReportSchemaColumn
	VALUES (@itdDeletedDateColumnID, NULL)

	--Name
	DECLARE @itdNameColumnID uniqueidentifier
	SET @itdNameColumnID = 'D8EC709E-94A8-452E-991A-58E8A9D42234'

	INSERT INTO VC3Reporting.ReportSchemaColumn
	VALUES (@itdNameColumnID, 'Name', @intvToolDefSchemaTableID, 'T', NULL, 'Name', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL)

	INSERT INTO ReportSchemaColumn
	VALUES (@itdNameColumnID, NULL)

	--ReferenceTypeID
	DECLARE @itdReferenceTypeIdColumnID uniqueidentifier
	SET @itdReferenceTypeIdColumnID = '6F84BC35-AC06-4BA7-B8EF-C1714FCFF09C'

	INSERT INTO VC3Reporting.ReportSchemaColumn
	VALUES (@itdReferenceTypeIdColumnID, 'Reference Type', @intvToolDefSchemaTableID, 'G', '(SELECT DisplayValue FROM EnumValue WHERE ID={this}.ReferenceTypeID)', 'ReferenceTypeID', '(SELECT Sequence FROM EnumValue WHERE ID={this}.ReferenceTypeID)', NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT ID, DisplayValue AS Name FROM EnumValue ORDER BY Sequence, DisplayValue', 0, NULL)

	INSERT INTO ReportSchemaColumn
	VALUES (@itdReferenceTypeIdColumnID, NULL)

	--Report Type : Intervention Tool
	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('A5C4AE91-7D16-478D-9CA3-90800C456E96', 'Intervention Tool', @reportTypeID, 0, @intvToolSchemaTableID, NULL, NULL, NULL, NULL)

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('4B177532-38DF-4F83-9FA8-6154B632624B', 'Tool Defintion', @reportTypeID, 0, @intvToolDefSchemaTableID, 'A5C4AE91-7D16-478D-9CA3-90800C456E96', 'I', '{left}.DefinitionID = {right}.ID', NULL)

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('1062D59A-FE7F-467A-B0D2-6D41DC6A2FA9', 'Intervention', @reportTypeID, 0, 'B1AA13A5-75E1-402A-8170-20B8E18FDF3F', 'A5C4AE91-7D16-478D-9CA3-90800C456E96', 'I', '{left}.InterventionID = {right}.ID', 'Intervention >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('1586D5FF-0292-4CD1-B1BF-67987E83170F', 'Intervention - Item', @reportTypeID, 0, 'CA58AA53-C0AB-4326-AA35-6D74695596A7', '1062D59A-FE7F-467A-B0D2-6D41DC6A2FA9', 'I', '{left}.ID = {right}.ID', 'Intervention >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('DF168178-E245-4B62-9C0E-F2152CCB60A7', 'Student', @reportTypeID, 0, 'F210EF27-1FBA-4518-B3F3-41DD8AFB4615', '1586D5FF-0292-4CD1-B1BF-67987E83170F', 'I' ,'{left}.StudentID = {right}.ID', 'Student >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('A2D7289A-908C-4FA1-A078-B2DBC7A1908C', 'Intervention - Item Definition', @reportTypeID, 0, '7CC0036F-BEDA-4FE4-B133-77167E7E8B09', '1586D5FF-0292-4CD1-B1BF-67987E83170F', 'I' ,'{left}.DefID = {right}.ID', 'Intervention Definition >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('EA54EE0D-4895-4F51-856C-B47A34FD8D30', 'Intervention - Program', @reportTypeID, 0, '6D04F20C-484A-4C7C-B41F-85940DF2BC88', 'A2D7289A-908C-4FA1-A078-B2DBC7A1908C', 'I' ,'{left}.ProgramID = {right}.ID', 'Intervention Program >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('B538B557-8896-41B4-8451-04E046C0F4A2', 'Probe Score Change', @reportTypeID, 0, 'DAA40B4B-9CCD-4497-9DCF-79BD72154151', '1062D59A-FE7F-467A-B0D2-6D41DC6A2FA9', 'R' ,'{left}.ID = {right}.ItemID', 'Probe Change >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('1B3A53F5-54D7-4FBF-B514-A15C3943F357', 'Discipline Referral Change', @reportTypeID, 0, '939E4566-F622-4999-BDBB-734A87527675', '1062D59A-FE7F-467A-B0D2-6D41DC6A2FA9', 'R' ,'{left}.ID = {right}.ItemID', 'Referral Change >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('C4FD789A-DDEA-4154-9168-62F979399CDE', 'Attendance Change', @reportTypeID, 0, '9FEF182E-4B86-4F42-AB94-D4D646D79B32', '1062D59A-FE7F-467A-B0D2-6D41DC6A2FA9', 'R' ,'{left}.ID = {right}.ItemID', 'Attendance Change >')

	--Report Type : Plan Before
	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('264B96B6-D3DB-478E-A202-31FDF06DBB07', 'Plan Before', @reportTypeID, 0, 'B1AA13A5-75E1-402A-8170-20B8E18FDF3F', '1062D59A-FE7F-467A-B0D2-6D41DC6A2FA9', 'L', '{left}.PlanBeforeID = {right}.ID', 'Plan Before >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('B9192116-22AD-4E88-B028-91A9541DC860', 'Plan Before - Item', @reportTypeID, 0, 'CA58AA53-C0AB-4326-AA35-6D74695596A7', '264B96B6-D3DB-478E-A202-31FDF06DBB07', 'I', '{left}.ID = {right}.ID', 'Plan Before >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('C4F0CB1C-FE03-4A25-8B39-AD46139BA7D8', 'Plan Before - Item Definition', @reportTypeID, 0, '7CC0036F-BEDA-4FE4-B133-77167E7E8B09', 'B9192116-22AD-4E88-B028-91A9541DC860', 'I' ,'{left}.DefID = {right}.ID', 'Plan Before Defintion >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('FAE7302A-0DC3-4D84-ACEB-8EF56244F8A1', 'Plan Before - Program', @reportTypeID, 0, '6D04F20C-484A-4C7C-B41F-85940DF2BC88', 'C4F0CB1C-FE03-4A25-8B39-AD46139BA7D8', 'I' ,'{left}.ProgramID = {right}.ID', 'Plan Before Program >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('1C8F2A63-EC00-4FAA-BFDA-A745CE3B201A', 'Plan Before - Probe Score Change', @reportTypeID, 0, 'DAA40B4B-9CCD-4497-9DCF-79BD72154151', '264B96B6-D3DB-478E-A202-31FDF06DBB07', 'R' ,'{left}.ID = {right}.ItemID', 'Plan Before Probe Change >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('1A7F4639-24FE-4D0C-BD7C-0CFD39D3E9B4', 'Plan Before - Discipline Referral Change', @reportTypeID, 0, '939E4566-F622-4999-BDBB-734A87527675', '264B96B6-D3DB-478E-A202-31FDF06DBB07', 'R' ,'{left}.ID = {right}.ItemID', 'Plan Before Referral Change >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('188FB125-E4E3-4122-A0CE-0CD5C21F4803', 'Plan Before - Attendance Change', @reportTypeID, 0, '9FEF182E-4B86-4F42-AB94-D4D646D79B32', '264B96B6-D3DB-478E-A202-31FDF06DBB07', 'R' ,'{left}.ID = {right}.ItemID', 'Plan Before Attendance Change >')

	--Report Type : Plan After
	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('350585C7-8E9C-42A8-ABFD-2D10441195BF', 'Plan After', @reportTypeID, 0, 'B1AA13A5-75E1-402A-8170-20B8E18FDF3F', '1062D59A-FE7F-467A-B0D2-6D41DC6A2FA9', 'L', '{left}.PlanAfterID = {right}.ID', 'Plan After >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('A16E6FB8-8780-4E2B-95F6-BCEEAF111D85', 'Plan After - Item', @reportTypeID, 0, 'CA58AA53-C0AB-4326-AA35-6D74695596A7', '350585C7-8E9C-42A8-ABFD-2D10441195BF', 'I', '{left}.ID = {right}.ID', 'Plan After >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('6457B616-B37C-46C6-883E-1D129A91C40D', 'Plan After - Item Definition', @reportTypeID, 0, '7CC0036F-BEDA-4FE4-B133-77167E7E8B09', 'A16E6FB8-8780-4E2B-95F6-BCEEAF111D85', 'I' ,'{left}.DefID = {right}.ID', 'Plan After Defintion >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('B64C3362-B08E-440C-AA15-1FECC5A2EDA8', 'Plan After - Program', @reportTypeID, 0, '6D04F20C-484A-4C7C-B41F-85940DF2BC88', '6457B616-B37C-46C6-883E-1D129A91C40D', 'I' ,'{left}.ProgramID = {right}.ID', 'Plan After Program >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('7C7A4751-8275-45A3-9371-AEFC64E9737D', 'Plan After - Probe Score Change', @reportTypeID, 0, 'DAA40B4B-9CCD-4497-9DCF-79BD72154151', '350585C7-8E9C-42A8-ABFD-2D10441195BF', 'R' ,'{left}.ID = {right}.ItemID', 'Plan After Probe Change >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('656746A7-14C6-4402-A30B-EC2048C73844', 'Plan After - Discipline Referral Change', @reportTypeID, 0, '939E4566-F622-4999-BDBB-734A87527675', '350585C7-8E9C-42A8-ABFD-2D10441195BF', 'R' ,'{left}.ID = {right}.ItemID', 'Plan After Referral Change >')

	INSERT INTO VC3Reporting.ReportTypeTable
	VALUES ('8A3D7E6A-58E5-4DA0-B053-55FFFDD410E1', 'Plan After - Attendance Change', @reportTypeID, 0, '9FEF182E-4B86-4F42-AB94-D4D646D79B32', '350585C7-8E9C-42A8-ABFD-2D10441195BF', 'R' ,'{left}.ID = {right}.ItemID', 'Plan After Attendance Change >')
	
END
--#include ..\objects\TestScoreDefinition_InsertRecord.sql
--#include ..\objects\TestSectionDefinition_InsertRecord.sql
--#include ..\objects\TestDefinitionFamily_InsertRecord.sql
--#include ..\objects\TestDefinition_InsertRecord.sql
--#include ..\objects\EnumType_InsertRecord.sql
--#include ..\objects\EnumValue_InsertRecord.sql
--#include ..\objects\TestScoreDefinition_UpdateRecord.sql
--#include ..\objects\TestSectionDefinition_UpdateRecord.sql
--#include ..\objects\TestDefinitionFamily_UpdateRecord.sql
--#include ..\objects\TestDefinition_UpdateRecord.sql
--#include ..\objects\EnumType_UpdateRecord.sql
--#include ..\objects\EnumValue_UpdateRecord.sql
create table T_LLI (
	ID uniqueidentifier not null constraint PK_T_LLI primary key,
	StudentID uniqueidentifier not null constraint FK_T_LLI_StudentID foreign key references Student(ID),
	ImportID uniqueidentifier null constraint FK_T_LLI_ImportID foreign key references TestImport(ID) on delete cascade,
	DateTaken datetime not null,
	SchoolID uniqueidentifier null constraint FK_T_LLI_SchoolID foreign key references School(ID),
	AdministrationID uniqueidentifier not null constraint FK_T_LLI_AdministrationID foreign key references TestAdministration(ID) on delete cascade,
	GradeLevelID uniqueidentifier null constraint FK_T_LLI_GradeLevelID foreign key references GradeLevel(ID),
	GeneralTextLevel uniqueidentifier null constraint FK_T_LLI_GeneralTextLevel foreign key references EnumValue(ID),
    NumericTextLevel real null,
	GeneralAccuracy real null,
	GeneralSelfCorrection real null,
	GeneralComprehension real null,
	GeneralFluency real null
)
GO

exec dbo.TestDefinitionFamily_InsertRecord @id='2bdc6395-1e50-4344-8c4f-06caa51f32d8', @name='LLI', @status='U', @helpText=NULL, @importUploadText=NULL, @serviceUserName=NULL, @servicePassword=NULL, @serviceTypeName=NULL
exec dbo.TestDefinition_InsertRecord @id='9afe80ba-730f-4099-b126-9c6a9aafadfe', @name='LLI', @tableName='T_LLI', @reportTableId=NULL, @familyId='2bdc6395-1e50-4344-8c4f-06caa51f32d8'
exec TestSectionDefinition_InsertRecord @testDefinitionId='9afe80ba-730f-4099-b126-9c6a9aafadfe', @parent=NULL, @subjectId=NULL, @sequence=0, @name='General', @id='edc22f0c-fd19-422f-a321-adb184e4c179'
exec EnumType_InsertRecord @id='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @type='UCAlphabet', @isCustom=0, @isEditable=0, @displayName=NULL
exec TestScoreDefinition_InsertRecord @testSectionDefinitionId='edc22f0c-fd19-422f-a321-adb184e4c179', @resultReportColumnId=NULL, @dataTypeId='f415d55d-d901-46f5-8f64-b86a4dfa3a23', @sequence=0, @columnName='GeneralTextLevel', @name='Text Level', @minValue=0, @maxValue=0, @enumType='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @importanceId=3, @Id='00a265b4-9e79-462b-ad3f-cc9b2a0f1063'
exec dbo.EnumValue_InsertRecord @id='b1e8d14e-2af1-48a4-a479-55dea9850066', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='1', @code='A', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='06ec6a81-5247-4bb1-a1ab-6b814e711941', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='2', @code='B', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='862e320c-91f4-4e81-9a7e-7a42611aaf39', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='3', @code='C', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='4258874b-db60-406b-938e-2086fa92639b', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='4', @code='D', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='6e617d9d-250e-4e27-9307-284d887df5dc', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='5', @code='E', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='9ce6eee9-ea9c-4180-8c1c-4db026a8ecad', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='6', @code='F', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='5aedfa98-6920-40b3-a314-22a995c59227', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='7', @code='G', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='a6c867f0-383d-4677-b30b-cf08a3da24a6', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='8', @code='H', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='75a50ecf-36a7-4d87-9c37-0e6ed790258c', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='9', @code='I', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='2f76ddea-7bd4-4619-90e0-39eff68dbe02', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='10', @code='J', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='ae99e23c-5abf-41da-a7d0-8048efc52b74', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='11', @code='K', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='297a4907-75b1-4a8e-9155-0ac9b1ebee05', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='12', @code='L', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='a28ede43-4a76-4e50-8f96-4434a05f2be9', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='13', @code='M', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='952bc278-e9e0-4e0b-84ba-b1f0e4920c5f', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='14', @code='N', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='fb5eea10-f452-4025-ad67-6d9a121626bb', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='15', @code='O', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='069e5e5b-f99c-4086-8db9-fddfeca435da', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='16', @code='P', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='a2ca418d-dc75-4ecd-a360-c5944ce5ffa6', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='17', @code='Q', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='4c5c4399-6ca8-4768-aa57-3dd0c007792c', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='18', @code='R', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='19d5448f-036a-452d-a747-ec8b4f4f2ba6', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='19', @code='S', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='2fddf298-d212-4c38-a31d-1430d10e87d4', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='20', @code='T', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='0891e695-ec39-46e3-8b8f-9903ce8c52b5', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='21', @code='U', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='42232c85-6564-4484-85de-e670a3a8077c', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='22', @code='V', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='6602de65-62f9-4bfd-b5d5-dc008c925648', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='23', @code='W', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='299c29a7-227c-4898-90ca-da8cb5130db4', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='24', @code='X', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='112f7831-5daa-4fba-9597-9531ea1742d8', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='25', @code='Y', @isActive=1, @sequence=0
exec dbo.EnumValue_InsertRecord @id='e5e6520e-c901-424d-969a-1e207ad34008', @type='7779482b-3a45-45d2-b7e8-f2ae78289bc1', @displayValue='26', @code='Z', @isActive=1, @sequence=0
exec TestScoreDefinition_InsertRecord @testSectionDefinitionId='edc22f0c-fd19-422f-a321-adb184e4c179', @resultReportColumnId=NULL, @dataTypeId='35dd056b-e9dd-4df7-b9c8-21b289d5588d', @sequence=1, @columnName='NumericTextLevel', @name='Numeric Text Level', @minValue=NULL, @maxValue=NULL, @enumType=NULL, @importanceId=3, @Id='b9938f77-cab3-487b-98c9-70856fb894cf'
exec TestScoreDefinition_InsertRecord @testSectionDefinitionId='edc22f0c-fd19-422f-a321-adb184e4c179', @resultReportColumnId=NULL, @dataTypeId='35dd056b-e9dd-4df7-b9c8-21b289d5588d', @sequence=1, @columnName='GeneralAccuracy', @name='Accuracy', @minValue=0, @maxValue=100, @enumType=NULL, @importanceId=3, @Id='908fab8b-e831-439d-b7fb-711260a2d7c6'
exec TestScoreDefinition_InsertRecord @testSectionDefinitionId='edc22f0c-fd19-422f-a321-adb184e4c179', @resultReportColumnId=NULL, @dataTypeId='35dd056b-e9dd-4df7-b9c8-21b289d5588d', @sequence=2, @columnName='GeneralSelfCorrection', @name='Self Correction', @minValue=0, @maxValue=20, @enumType=NULL, @importanceId=3, @Id='0ef1e905-60b4-42bc-98a8-f635ef6530a1'
exec TestScoreDefinition_InsertRecord @testSectionDefinitionId='edc22f0c-fd19-422f-a321-adb184e4c179', @resultReportColumnId=NULL, @dataTypeId='35dd056b-e9dd-4df7-b9c8-21b289d5588d', @sequence=3, @columnName='GeneralComprehension', @name='Comprehension', @minValue=0, @maxValue=3, @enumType=NULL, @importanceId=3, @Id='47866c9f-481d-43d7-b0ce-aaa9362d658e'
exec TestScoreDefinition_InsertRecord @testSectionDefinitionId='edc22f0c-fd19-422f-a321-adb184e4c179', @resultReportColumnId=NULL, @dataTypeId='35dd056b-e9dd-4df7-b9c8-21b289d5588d', @sequence=4, @columnName='GeneralFluency', @name='Fluency', @minValue=0, @maxValue=3, @enumType=NULL, @importanceId=3, @Id='05532be2-0d36-4d14-a02e-98e20efa6999'
GO
--LLI

-- Report stuff
insert into VC3Reporting.ReportSchemaTable values ('5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'LLI', '(select * from T_LLI where (AdministrationID={Administration} or {Administration} is null))', 'ID'); insert into ReportSchemaTable values('5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', NULL)
insert into VC3Reporting.ReportSchemaColumn (Id,Name,SchemaTable,SchemaDataType,DisplayExpression,ValueExpression,OrderExpression,LinkExpression,LinkFormat,IsSelectColumn,IsFilterColumn,IsParameterColumn,IsGroupColumn,IsOrderColumn,IsAggregated,AllowedValuesExpression,Sequence,Width,Description) values ('C2E13F04-7960-4380-AC10-0425AB550DF8', 'Administration', '5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'G', '(select Name from TestAdministration where ID={this}.AdministrationID)', 'AdministrationID', '(select StartDate from TestAdministration where ID={this}.AdministrationID)', null, null, 1, 1, 1, 1, 1, 0, 'select Id, Name from TestAdministration where TestDefinitionID=''9AFE80BA-730F-4099-B126-9C6A9AAFADFE'' order by StartDate desc', 0, null, NULL ); insert into ReportSchemaColumn values('C2E13F04-7960-4380-AC10-0425AB550DF8', NULL)
insert into VC3Reporting.ReportSchemaColumn (Id,Name,SchemaTable,SchemaDataType,DisplayExpression,ValueExpression,OrderExpression,LinkExpression,LinkFormat,IsSelectColumn,IsFilterColumn,IsParameterColumn,IsGroupColumn,IsOrderColumn,IsAggregated,AllowedValuesExpression,Sequence,Width,Description) values ('97B1F02B-DC53-4790-80DC-A2C3E2D392D9', 'Grade Level (when tested)', '5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'G', '(select ''Grade '' + Name from GradeLevel where ID = {this}.GradeLevelID)', 'GradeLevelID', null, null, null, 1, 1, 1, 1, 1, 0, 'select Id, ''Grade '' + Name from GradeLevel where Active=1 order by Name', 1, null, NULL ); insert into ReportSchemaColumn values('97B1F02B-DC53-4790-80DC-A2C3E2D392D9', NULL)
insert into VC3Reporting.ReportSchemaColumn (Id,Name,SchemaTable,SchemaDataType,DisplayExpression,ValueExpression,OrderExpression,LinkExpression,LinkFormat,IsSelectColumn,IsFilterColumn,IsParameterColumn,IsGroupColumn,IsOrderColumn,IsAggregated,AllowedValuesExpression,Sequence,Width,Description)values ('82B4EF8E-B9CD-4089-BAF7-9CBD73B22345', 'School (when tested)', '5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'G', '(select Name from School where ID={this}.SchoolID)', 'SchoolID', null, null, null, 1, 1, 1, 1, 1, 0, 'select Id, Name from School order by Name', 2, null, NULL ); insert into ReportSchemaColumn values('82B4EF8E-B9CD-4089-BAF7-9CBD73B22345', NULL)
insert into VC3Reporting.ReportSchemaColumn (Id,Name,SchemaTable,SchemaDataType,DisplayExpression,ValueExpression,OrderExpression,LinkExpression,LinkFormat,IsSelectColumn,IsFilterColumn,IsParameterColumn,IsGroupColumn,IsOrderColumn,IsAggregated,AllowedValuesExpression,Sequence,Width,Description)values ('3B5EDE8D-6EB9-45EC-8F23-C5013FF61569', 'Date Taken', '5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'D', null, 'DateTaken', null, null, null, 1, 1, 1, 1, 1, 0, null, 3, null, NULL ); insert into ReportSchemaColumn values('3B5EDE8D-6EB9-45EC-8F23-C5013FF61569', NULL)
insert into VC3Reporting.ReportSchemaColumn (Id,Name,SchemaTable,SchemaDataType,DisplayExpression,ValueExpression,OrderExpression,LinkExpression,LinkFormat,IsSelectColumn,IsFilterColumn,IsParameterColumn,IsGroupColumn,IsOrderColumn,IsAggregated,AllowedValuesExpression,Sequence,Width,Description)values ('234DD008-A24A-4175-B7BD-DDDF61A916E1', 'General > Accuracy', '5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'N', null, 'GeneralAccuracy', null, null, null, 1, 1, 1, 1, 1, 0, null, 100, null, NULL); insert into ReportSchemaColumn values('234DD008-A24A-4175-B7BD-DDDF61A916E1', NULL)
insert into VC3Reporting.ReportSchemaColumn (Id,Name,SchemaTable,SchemaDataType,DisplayExpression,ValueExpression,OrderExpression,LinkExpression,LinkFormat,IsSelectColumn,IsFilterColumn,IsParameterColumn,IsGroupColumn,IsOrderColumn,IsAggregated,AllowedValuesExpression,Sequence,Width,Description)values ('49DA7203-CE9B-4501-862C-B4DA7FD9B145', 'General > Comprehension', '5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'N', null, 'GeneralComprehension', null, null, null, 1, 1, 1, 1, 1, 0, null, 100, null, NULL); insert into ReportSchemaColumn values('49DA7203-CE9B-4501-862C-B4DA7FD9B145', NULL)
insert into VC3Reporting.ReportSchemaColumn (Id,Name,SchemaTable,SchemaDataType,DisplayExpression,ValueExpression,OrderExpression,LinkExpression,LinkFormat,IsSelectColumn,IsFilterColumn,IsParameterColumn,IsGroupColumn,IsOrderColumn,IsAggregated,AllowedValuesExpression,Sequence,Width,Description)values ('31CC909B-478E-487C-9258-04CC13EB7D3A', 'General > Fluency', '5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'N', null, 'GeneralFluency', null, null, null, 1, 1, 1, 1, 1, 0, null, 100, null, NULL); insert into ReportSchemaColumn values('31CC909B-478E-487C-9258-04CC13EB7D3A', NULL)
insert into VC3Reporting.ReportSchemaColumn (Id,Name,SchemaTable,SchemaDataType,DisplayExpression,ValueExpression,OrderExpression,LinkExpression,LinkFormat,IsSelectColumn,IsFilterColumn,IsParameterColumn,IsGroupColumn,IsOrderColumn,IsAggregated,AllowedValuesExpression,Sequence,Width,Description)values ('3C5EC6F5-ECCD-44DA-A714-98751F4B55BB', 'General > Self Correction', '5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'N', null, 'GeneralSelfCorrection', null, null, null, 1, 1, 1, 1, 1, 0, null, 100, null, NULL); insert into ReportSchemaColumn values('3C5EC6F5-ECCD-44DA-A714-98751F4B55BB', NULL)
insert into VC3Reporting.ReportSchemaColumn  
(Id,Name,SchemaTable,SchemaDataType,DisplayExpression,ValueExpression,OrderExpression,LinkExpression,LinkFormat,IsSelectColumn,IsFilterColumn,IsParameterColumn,IsGroupColumn,IsOrderColumn,IsAggregated,AllowedValuesExpression,Sequence,Width,Description)
values
('E88B780E-B1B5-4D5E-8B1F-25DE57502A7E', 'General > Text Level', '5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'G', '(select DisplayValue from EnumValue where Id={this}.GeneralTextLevel)', 'GeneralTextLevel', '(select Code from EnumValue where Id={this}.GeneralTextLevel)', null, null, 1, 1, 1, 1, 1, 0, 'select Id, DisplayValue from EnumValue where Type=''7779482B-3A45-45D2-B7E8-F2AE78289BC1'' order by Code', 100, null, NULL ); insert into ReportSchemaColumn values('E88B780E-B1B5-4D5E-8B1F-25DE57502A7E', NULL)
insert into VC3Reporting.ReportSchemaColumn  
(Id,Name,SchemaTable,SchemaDataType,DisplayExpression,ValueExpression,OrderExpression,LinkExpression,LinkFormat,IsSelectColumn,IsFilterColumn,IsParameterColumn,IsGroupColumn,IsOrderColumn,IsAggregated,AllowedValuesExpression,Sequence,Width,Description)
values
('F2490E80-DD41-4DA7-BD46-6411C46CDE5A', 'Language Arts Teacher (when tested)','5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'G', '(select  LastName + '', '' + FirstName from Teacher where ID = dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken, ''DF2274C7-1714-44C1-A8FC-61F29D5504AC''))', 'dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken, ''DF2274C7-1714-44C1-A8FC-61F29D5504AC'')', null, null, null, 1, 1, 1, 1, 1, 0, 'select TeacherID AS ID, LastName + '', '' + FirstName from dbo.GetAllTeachersBySubject(''DF2274C7-1714-44C1-A8FC-61F29D5504AC'') ORDER BY LastName, FirstName', 3, null, NULL ); insert into ReportSchemaColumn values('F2490E80-DD41-4DA7-BD46-6411C46CDE5A', NULL)
insert into VC3Reporting.ReportSchemaColumn  
(Id,Name,SchemaTable,SchemaDataType,DisplayExpression,ValueExpression,OrderExpression,LinkExpression,LinkFormat,IsSelectColumn,IsFilterColumn,IsParameterColumn,IsGroupColumn,IsOrderColumn,IsAggregated,AllowedValuesExpression,Sequence,Width,Description)
values
('B1FFAF13-5F03-47C4-B2FD-7F5AD8787B25', 'Mathematics Teacher (when tested)','5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'G', '(select  LastName + '', '' + FirstName from Teacher where ID = dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken, ''7BC1F354-2787-4C88-83F1-888D93F0E71E''))', 'dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken, ''7BC1F354-2787-4C88-83F1-888D93F0E71E'')', null, null, null, 1, 1, 1, 1, 1, 0, 'select TeacherID AS ID, LastName + '', '' + FirstName from dbo.GetAllTeachersBySubject(''7BC1F354-2787-4C88-83F1-888D93F0E71E'') ORDER BY LastName, FirstName', 4, null, NULL ); insert into ReportSchemaColumn values('B1FFAF13-5F03-47C4-B2FD-7F5AD8787B25', NULL)
insert into VC3Reporting.ReportSchemaColumn  
(Id,Name,SchemaTable,SchemaDataType,DisplayExpression,ValueExpression,OrderExpression,LinkExpression,LinkFormat,IsSelectColumn,IsFilterColumn,IsParameterColumn,IsGroupColumn,IsOrderColumn,IsAggregated,AllowedValuesExpression,Sequence,Width,Description)
values
('DAF79C7D-F078-4245-B331-DC066FCB3162', 'Science Teacher (when tested)','5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'G', '(select  LastName + '', '' + FirstName from Teacher where ID = dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken, ''0351CAC6-40EE-479C-A506-DC84E77C6665''))', 'dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken, ''0351CAC6-40EE-479C-A506-DC84E77C6665'')', null, null, null, 1, 1, 1, 1, 1, 0, 'select TeacherID AS ID, LastName + '', '' + FirstName from dbo.GetAllTeachersBySubject(''0351CAC6-40EE-479C-A506-DC84E77C6665'') ORDER BY LastName, FirstName', 5, null, NULL ); insert into ReportSchemaColumn values('DAF79C7D-F078-4245-B331-DC066FCB3162', NULL)
insert into VC3Reporting.ReportSchemaColumn  
(Id,Name,SchemaTable,SchemaDataType,DisplayExpression,ValueExpression,OrderExpression,LinkExpression,LinkFormat,IsSelectColumn,IsFilterColumn,IsParameterColumn,IsGroupColumn,IsOrderColumn,IsAggregated,AllowedValuesExpression,Sequence,Width,Description)
values
('01C03A5A-EC97-4816-BCE4-9D7B998A31E2', 'Social Studies Teacher (when tested)','5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'G', '(select  LastName + '', '' + FirstName from Teacher where ID = dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken, ''C90E81B1-30CB-4D2D-B301-F4AB6A1F5E75''))', 'dbo.GetTeacherBySubject({this}.StudentID,{this}.DateTaken, ''C90E81B1-30CB-4D2D-B301-F4AB6A1F5E75'')', null, null, null, 1, 1, 1, 1, 1, 0, 'select TeacherID AS ID, LastName + '', '' + FirstName from dbo.GetAllTeachersBySubject(''C90E81B1-30CB-4D2D-B301-F4AB6A1F5E75'') ORDER BY LastName, FirstName', 6, null, NULL ); insert into ReportSchemaColumn values('01C03A5A-EC97-4816-BCE4-9D7B998A31E2', NULL)
insert into VC3Reporting.ReportSchemaTableParameter values ('28E7ED50-B3B5-41A6-94DE-AB1DCE8ED80D', 'Administration', '5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'C2E13F04-7960-4380-AC10-0425AB550DF8', '41BA0544-6400-4E61-B1DD-378743A7D145', 0, 0)
insert into VC3Reporting.ReportTypeTable values('4CF92C46-F4F4-4847-BABC-A8039AB5F29C', 'LLI', 'S', 10, '5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'C0619F4E-EDB7-4152-BF25-7BD3845C1700', 'Z', '{left}.ID = {right}.StudentID', 'LLI',0)
insert into VC3Reporting.ReportTypeTable values('998E5028-1E9A-48E7-9BE3-93F18A340AAB', 'LLI', 'Y', 10, '5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB', 'BA314C08-7D2C-456F-AFBD-AD1E67911618', 'L', '{left}.StudentID = {right}.StudentID and {left}.AdministrationID = {right}.AdministrationID', 'LLI',0)
update TestDefinition set ReportTableID='5EBA74A5-ED94-4EBF-8047-ECAE2FDA07CB' where Id='9AFE80BA-730F-4099-B126-9C6A9AAFADFE'
update TestScoreDefinition set ResultReportColumnID='234DD008-A24A-4175-B7BD-DDDF61A916E1' where Id='908FAB8B-E831-439D-B7FB-711260A2D7C6'
update TestScoreDefinition set ResultReportColumnID='49DA7203-CE9B-4501-862C-B4DA7FD9B145' where Id='47866C9F-481D-43D7-B0CE-AAA9362D658E'
update TestScoreDefinition set ResultReportColumnID='31CC909B-478E-487C-9258-04CC13EB7D3A' where Id='05532BE2-0D36-4D14-A02E-98E20EFA6999'
update TestScoreDefinition set ResultReportColumnID='3C5EC6F5-ECCD-44DA-A714-98751F4B55BB' where Id='0EF1E905-60B4-42BC-98A8-F635EF6530A1'
update TestScoreDefinition set ResultReportColumnID='E88B780E-B1B5-4D5E-8B1F-25DE57502A7E' where Id='00A265B4-9E79-462B-AD3F-CC9B2A0F1063'
GO

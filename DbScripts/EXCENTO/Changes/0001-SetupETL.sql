--#assume VC3ETL:20

INSERT INTO VC3TaskScheduler.ScheduledTaskType VALUES ( 'BDFBC128-AFA3-4215-8A36-88D4BFD21CDC', 'Data Import', 'VC3.TestView.ScheduledTasks.DataImportTask,VC3.TestView' )
INSERT INTO VC3ETL.ExtractType values ('ACBEF25A-A8EB-465B-97D8-9738F07C3023', 'Data Import')

-- extract
INSERT INTO VC3ETL.ExtractDatabase VALUES ( '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 'ACBEF25A-A8EB-465B-97D8-9738F07C3023', 'CBE6E716-95F0-44BC-837C-BBC4FD59506C', NULL, NULL, 'Richland1_ExcentOnline', 'username', 'password', NULL, 0, NULL, NULL, NULL, '[{BrandName}] {SisDatabase} import completed', 'Successfully imported {SisDatabase} data into {BrandName}.  {SisDatabase} data in {BrandName} is now current as of {SnapshotDate}.', NULL, '[{BrandName}] {SisDatabase} import failed', 'There was a problem importing {SisDatabase} data into {BrandName}:  {ErrorMessage}', 1, '_NEW', '_LOCAL', NULL, NULL, 'Excent Online', 0)
INSERT VC3ETL.ExtractTable VALUES ( '6C95DA07-0A04-4666-AE1E-051E009790ED', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 'Student', 'EXCENTO', 'Student', 'GStudentID', NULL, NULL, NULL, NULL, 1, 0, NULL)
INSERT VC3ETL.ExtractTable VALUES ( '5AC3D359-539A-4886-9FB9-8ECC39F625C1', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 'IEPTbl', 'EXCENTO', 'IEPTbl', 'IEPSeqNum', NULL, NULL, NULL, NULL, 1, 0, NULL)
INSERT VC3ETL.ExtractTable VALUES ( 'F45BFFFF-6A74-4DC6-A8C0-B298A91674A1', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 'IEPTbl_SC', 'EXCENTO', 'IEPTbl_SC', 'IEPSeqNum', NULL, NULL, NULL, NULL, 1, 0, NULL)

-- load
-- Student #####################################################################
CREATE TABLE [EXCENTO].[MAP_StudentID]
	(
	GStudentID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE [EXCENTO].[MAP_StudentID] ADD CONSTRAINT
	[PK_MAP_StudentID] PRIMARY KEY CLUSTERED 
	(
	GStudentID
	) ON [PRIMARY]
GO
INSERT VC3ETL.LoadTable VALUES ( '95CC88A7-C5B6-4BA7-A55C-CCA42473746F', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 0, 'EXCENTO.Match_Students', 'EXCENTO.MAP_StudentID', 0, NULL, NULL, NULL, 2, 1, 0, 1, 1, NULL, NULL, NULL, 0, 0, NULL )
INSERT VC3ETL.LoadColumn VALUES ( '75FF5F31-8380-43E1-9180-197254A6AD4D', '95CC88A7-C5B6-4BA7-A55C-CCA42473746F', 'GStudentID', 'GStudentID', 'K', 0, NULL, NULL)
INSERT VC3ETL.LoadColumn VALUES ( '7DB16D92-6A3C-4995-8074-6027DADEC32A', '95CC88A7-C5B6-4BA7-A55C-CCA42473746F', 'DestID', 'DestID', 'C', 0, NULL, NULL)
GO
-- PrgInvolvement ##############################################################
CREATE TABLE EXCENTO.Map_InvolvementID
(
	GStudentID uniqueidentifier NOT NULL ,
	DestID uniqueidentifier NOT NULL
)
GO
ALTER TABLE EXCENTO.Map_InvolvementID ADD CONSTRAINT
PK_Map_InvolvementID PRIMARY KEY CLUSTERED 
(
	GStudentID
)
GO
INSERT VC3ETL.LoadTable VALUES ( 'DEBAB94B-62F1-41E4-A744-EEA796F4B01C', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 1, 'EXCENTO.Transform_Involvement', 'PrgInvolvement', 1, 'EXCENTO.Map_InvolvementID', 'GStudentID', 'DestID', 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, NULL )
INSERT VC3ETL.LoadColumn VALUES ( 'DC11354F-94DF-4D51-97B9-F3F5DDA286E5', 'DEBAB94B-62F1-41E4-A744-EEA796F4B01C', 'DestID', 'ID', 'K', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( '4D9E7609-5D67-4957-AF88-86C8DBCAF800', 'DEBAB94B-62F1-41E4-A744-EEA796F4B01C', 'StudentID', 'StudentID', 'C', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( '92199F26-03EF-45DD-84ED-A750929C0F53', 'DEBAB94B-62F1-41E4-A744-EEA796F4B01C', 'ProgramID', 'ProgramID', 'C', 0, NULL, NULL )
--INSERT VC3ETL.LoadColumn VALUES ( '4A1E73FC-E739-4AE2-B55C-96D57221B34B', 'DEBAB94B-62F1-41E4-A744-EEA796F4B01C', 'VariantID', 'VariantID', 'C', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( '26FA413B-C946-4A71-B1F7-41B9721F92BC', 'DEBAB94B-62F1-41E4-A744-EEA796F4B01C', 'StartDate', 'StartDate', 'C', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( '78FABAF2-F072-4614-B9C8-CC0F53EBCEC2', 'DEBAB94B-62F1-41E4-A744-EEA796F4B01C', 'EndDate', 'EndDate', 'C', 0, NULL, NULL )
GO

-- PrgItem #####################################################################
CREATE TABLE EXCENTO.Map_IepID
(
	IEPSeqNum int NOT NULL ,
	DestID uniqueidentifier NOT NULL
)
GO
ALTER TABLE EXCENTO.Map_IepID ADD CONSTRAINT
PK_Map_IepID PRIMARY KEY CLUSTERED 
(
	IEPSeqNum
)
GO
INSERT VC3ETL.LoadTable VALUES ( 'EEA7F1E3-93B5-41BE-9471-DA167991B5B5', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 2, 'EXCENTO.Transform_Iep', 'PrgItem', 1, 'EXCENTO.Map_IepID', 'IEPSeqNum', 'DestID', 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, NULL )
INSERT VC3ETL.LoadColumn VALUES ( '1BEAE02D-D280-473E-A72A-944F166B1EB3', 'EEA7F1E3-93B5-41BE-9471-DA167991B5B5', 'DestID', 'ID', 'K', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( '766413FC-B07D-4A4E-B11E-DC3741BF4881', 'EEA7F1E3-93B5-41BE-9471-DA167991B5B5', 'DefID', 'DefID', 'C', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( 'F8915D34-FB52-4E80-99D1-40616B5711F2', 'EEA7F1E3-93B5-41BE-9471-DA167991B5B5', 'StudentID', 'StudentID', 'C', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( 'D73E86CE-DE71-4E68-AE81-FA79F8582DBF', 'EEA7F1E3-93B5-41BE-9471-DA167991B5B5', 'StartDate', 'StartDate', 'C', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( '0DA7AADC-81C8-4AC8-94CA-5096FD5F08C1', 'EEA7F1E3-93B5-41BE-9471-DA167991B5B5', 'EndDate', 'EndDate', 'C', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( '6F3EBE4C-6F21-4BAA-939B-264F4052EEBD', 'EEA7F1E3-93B5-41BE-9471-DA167991B5B5', 'CreatedDate', 'CreatedDate', 'C', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( 'D9674A77-D3CE-4618-933F-639EF234ED7B', 'EEA7F1E3-93B5-41BE-9471-DA167991B5B5', 'CreatedBy', 'CreatedBy', 'C', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( 'AB0DB1F5-BB80-423F-9A3D-46D7D28ABC55', 'EEA7F1E3-93B5-41BE-9471-DA167991B5B5', 'SchoolID', 'SchoolID', 'C', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( 'DB497285-0832-4988-B501-B88F4A433990', 'EEA7F1E3-93B5-41BE-9471-DA167991B5B5', 'GradeLevelID', 'GradeLevelID', 'C', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( '9A6E904F-E738-4423-812C-0C9B0D8B82A9', 'EEA7F1E3-93B5-41BE-9471-DA167991B5B5', 'InvolvementID', 'InvolvementID', 'C', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( '38AE354F-5624-4EF3-9C01-7BD5A76A4C9A', 'EEA7F1E3-93B5-41BE-9471-DA167991B5B5', 'StartStatus', 'StartStatusID', 'C', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( '829FBEBF-A12A-4D22-9F33-C408AE1F5566', 'EEA7F1E3-93B5-41BE-9471-DA167991B5B5', 'PlannedEndDate', 'PlannedEndDate', 'C', 0, NULL, NULL )
GO

-- PrgIep ######################################################################
INSERT VC3ETL.LoadTable VALUES ( 'A7E6277B-2556-4AF3-ABBE-E22D42EF5946', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 3, 'EXCENTO.Transform_Iep', 'PrgIep', 0, NULL, NULL, NULL, 1, 0, 1, 1, 1, NULL, NULL, NULL, 0, 0, NULL )
INSERT VC3ETL.LoadColumn VALUES ( 'BCFC7D2F-550B-404A-9FDC-BD59A3998A3B', 'A7E6277B-2556-4AF3-ABBE-E22D42EF5946', 'DestID', 'ID', 'K', 0, NULL, NULL )
INSERT VC3ETL.LoadColumn VALUES ( '466F9D8C-36B7-4769-B1B4-45B74AFCBA36', 'A7E6277B-2556-4AF3-ABBE-E22D42EF5946', 'IsTransitional', 'IsTransitional', 'C', 0, NULL, NULL )
GO

-- Recalculate involvement status
INSERT VC3ETL.LoadTable VALUES ( '298F4A09-C64D-46A7-B446-803D90E8C6A0', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 99, 'PrgInvolvement_RecalculateStatuses', '', 0, NULL, NULL, NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, 0, NULL )
GO
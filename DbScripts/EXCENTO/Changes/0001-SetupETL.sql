BEGIN TRAN

-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_ExtractDatabase TABLE (ID uniqueidentifier, Type uniqueidentifier, DatabaseType uniqueidentifier, Server varchar(64), DatabaseOwner varchar(64), DatabaseName varchar(128), Username varchar(32), Password varchar(32), LinkedServer varchar(100), IsLinkedServerManaged bit, LastExtractDate datetime, LastLoadDate datetime, SucceededEmail varchar(500), SucceededSubject text, SucceededMessage text, FailedEmail varchar(500), FailedSubject text, FailedMessage text, RetainSnapshot bit, DestTableTempSuffix varchar(30), DestTableFinalSuffix varchar(30), FileGroup varchar(64), Schedule uniqueidentifier, Name varchar(100), Enabled bit)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_ExtractDatabase VALUES ( '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 'ACBEF25A-A8EB-465B-97D8-9738F07C3023', 
'CBE6E716-95F0-44BC-837C-BBC4FD59506C', NULL, NULL, 'ExcentOnlineFL', 'DCB1_FL_LEE', 'vc3go!!', NULL, 0, NULL, NULL, NULL, 
'[{BrandName}] {SisDatabase} import completed', 'Successfully imported {SisDatabase} data into {BrandName}.  {SisDatabase} data in {BrandName} is now current as of {SnapshotDate}.', NULL, '[{BrandName}] {SisDatabase} import failed', 'There was a problem importing {SisDatabase} data into {BrandName}:  {ErrorMessage}', 1, '_NEW', '_LOCAL', NULL, NULL, 'Excent Online', 0)


-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_ExtractTable TABLE (ID uniqueidentifier, ExtractDatabase uniqueidentifier, SourceTable varchar(100), DestSchema varchar(50), DestTable varchar(50), PrimaryKey varchar(100), Indexes varchar(200), LastSuccessfulCount int, CurrentCount int, Filter varchar(1000), Enabled bit, IgnoreMissing bit, Columns varchar(4000), Comments varchar(1000))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_ExtractTable VALUES ('707E8324-343A-4588-A311-A25292CC9C3D', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 'IEPArchiveDocTbl', 'dbo', 'FileData', 'ID', NULL, 0, 0, NULL, 1, 1, NULL, NULL)


-- Declare a temporary table to hold the data to be synchronized
DECLARE @VC3ETL_LoadTable TABLE (ID uniqueidentifier, ExtractDatabase uniqueidentifier, Sequence int, SourceTable varchar(100), DestTable varchar(100), HasMapTable bit, MapTable varchar(100), KeyField varchar(250), DeleteKey varchar(50), ImportType int, DeleteTrans bit, UpdateTrans bit, InsertTrans bit, Enabled bit, SourceTableFilter varchar(1000), DestTableFilter varchar(1000), PurgeCondition varchar(1000), KeepMappingAfterDelete bit, StartNewTransaction bit, LastLoadDate datetime, MapTableMapID varchar(250), Comments varchar(1000))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @VC3ETL_LoadTable VALUES ('3C48A2E0-DB9B-4D74-83FD-BD1272D78B81', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 0, 'EXCENTO.Transform_FileData', 'FileData', 1, 'EXCENTO.MAP_FileDataID', 'IepRefID', NULL, 1, 0, 1, 1, 1, null, 's.DestID in (select DestID from EXCENTO.MAP_FileDataID)', NULL, 0, 0, '2012-05-04 12:17:45.093', NULL, NULL)

INSERT INTO @VC3ETL_LoadTable VALUES ('9D044143-DC30-4F5D-BB56-43116DD2F2D2', '9756E9BB-8B6B-44E4-9C4E-B3F8E6A6CD16', 0, 'EXCENTO.Transform_Attachment', 'Attachment', 1, 'EXCENTO.MAP_AttachmentID', 'IepRefID,FileDataID', NULL, 1, 0, 1, 1, 1, null, 's.DestID in (select DestID from EXCENTO.MAP_AttachmentID)', NULL, 0, 0, '2012-05-04 12:17:45.093', NULL, NULL)

/** Need to complete the insert queries for LoadColumn table.  Also need to complete the SQL Statements to update the VC3 Destination tables. **/

-- Declare a temporary table to hold the data to be synchronized    
DECLARE @VC3ETL_LoadColumn TABLE (ID uniqueidentifier, LoadTable uniqueidentifier, SourceColumn varchar(500), DestColumn varchar(500), ColumnType char(1), UpdateOnDelete bit, DeletedValue varchar(500), NullValue varchar(500), Comments varchar(1000))

-- Insert the data to be synchronized into the temporary table

--Insert the records represent each column in FileData Table
INSERT INTO @VC3ETL_LoadColumn VALUES ('7935E441-4DAD-4C72-8E75-5D8F7414F928', '3C48A2E0-DB9B-4D74-83FD-BD1272D78B81', 'DestID', 'ID', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('7E943201-DB4D-4564-9196-1CE796C2A202', '3C48A2E0-DB9B-4D74-83FD-BD1272D78B81', 'OriginalName', 'OriginalName', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('67A6267D-705F-4D66-8714-81E5A727C09E', '3C48A2E0-DB9B-4D74-83FD-BD1272D78B81', 'ReceivedDate', 'ReceivedDate', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('1777F73F-868A-4A95-9B66-A5BBE37B4BF8', '3C48A2E0-DB9B-4D74-83FD-BD1272D78B81', 'MimeType', 'MimeType', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('9788C924-837C-4B72-89D0-70E21BE42562', '3C48A2E0-DB9B-4D74-83FD-BD1272D78B81', 'Content', 'Content', 'C', 0, NULL, NULL, NULL)
INSERT INTO @VC3ETL_LoadColumn VALUES ('A3426A15-853C-4BAB-BBD5-2B5813A17CB1', '3C48A2E0-DB9B-4D74-83FD-BD1272D78B81', 'isTemporary', 'isTemporary', 'C', 0, NULL, NULL, NULL)









set nocount off;

COMMIT TRAN
